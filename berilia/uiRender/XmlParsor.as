package com.ankamagames.berilia.uiRender
{
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.InputComboBox;
   import com.ankamagames.berilia.components.Tree;
   import com.ankamagames.berilia.enums.EventEnums;
   import com.ankamagames.berilia.enums.LocationTypeEnum;
   import com.ankamagames.berilia.enums.StatesEnum;
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.enums.XmlAttributesEnum;
   import com.ankamagames.berilia.enums.XmlTagsEnum;
   import com.ankamagames.berilia.managers.BindsManager;
   import com.ankamagames.berilia.types.event.ParsingErrorEvent;
   import com.ankamagames.berilia.types.event.ParsorEvent;
   import com.ankamagames.berilia.types.event.PreProcessEndEvent;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.graphic.GraphicLocation;
   import com.ankamagames.berilia.types.graphic.GraphicSize;
   import com.ankamagames.berilia.types.graphic.ScrollContainer;
   import com.ankamagames.berilia.types.graphic.StateContainer;
   import com.ankamagames.berilia.types.uiDefinition.BasicElement;
   import com.ankamagames.berilia.types.uiDefinition.ButtonElement;
   import com.ankamagames.berilia.types.uiDefinition.ComponentElement;
   import com.ankamagames.berilia.types.uiDefinition.ContainerElement;
   import com.ankamagames.berilia.types.uiDefinition.GridElement;
   import com.ankamagames.berilia.types.uiDefinition.ScrollContainerElement;
   import com.ankamagames.berilia.types.uiDefinition.StateContainerElement;
   import com.ankamagames.berilia.types.uiDefinition.UiDefinition;
   import com.ankamagames.berilia.utils.ComponentList;
   import com.ankamagames.berilia.utils.GridItemList;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   import com.ankamagames.jerakine.utils.misc.Levenshtein;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.system.ApplicationDomain;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   
   public class XmlParsor extends EventDispatcher
   {
      
      private static var _classDescCache:Object = new Object();
       
      
      protected const _componentList:ComponentList = null;
      
      protected const _GridItemList:GridItemList = null;
      
      protected const _log:Logger = Log.getLogger(getQualifiedClassName(XmlParsor));
      
      private var _xmlDoc:XMLDocument;
      
      private var _sUrl:String;
      
      protected var _aName:Array;
      
      private var _loader:IResourceLoader;
      
      private var _describeType:Function;
      
      public var rootPath:String;
      
      public function XmlParsor()
      {
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._describeType = DescribeTypeCache.typeDescription;
         super();
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onXmlLoadComplete);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onXmlLoadError);
      }
      
      public function get url() : String
      {
         return this._sUrl;
      }
      
      public function get xmlDocString() : String
      {
         return !!this._xmlDoc?this._xmlDoc.toString():null;
      }
      
      public function processFile(param1:String) : void
      {
         this._sUrl = param1;
         this._loader.load(new Uri(this._sUrl));
      }
      
      public function processXml(param1:String) : void
      {
         var errorLog:String = null;
         var i:uint = 0;
         var regOpenTagAdv:RegExp = null;
         var regOpenTag:RegExp = null;
         var tmp:Array = null;
         var openTag:Array = null;
         var tag:String = null;
         var regCloseTag:RegExp = null;
         var closeTag:Array = null;
         var sXml:String = param1;
         this._xmlDoc = new XMLDocument();
         this._xmlDoc.ignoreWhite = true;
         try
         {
            this._xmlDoc.parseXML(sXml.toString());
         }
         catch(e:Error)
         {
            if(sXml)
            {
               regOpenTagAdv = /<\w+[^>]*/g;
               regOpenTag = /<\w+/g;
               tmp = sXml.match(regOpenTagAdv);
               openTag = new Array();
               i = 0;
               while(i < tmp.length)
               {
                  if(tmp[i].substr(tmp[i].length - 1) != "/")
                  {
                     tag = tmp[i].match(regOpenTag)[0];
                     if(!openTag[tag])
                     {
                        openTag[tag] = 0;
                     }
                     ++openTag[tag];
                  }
                  i++;
               }
               regCloseTag = /<\/\w+/g;
               tmp = sXml.match(regCloseTag);
               closeTag = new Array();
               i = 0;
               while(i < tmp.length)
               {
                  tag = "<" + tmp[i].substr(2);
                  if(!closeTag[tag])
                  {
                     closeTag[tag] = 0;
                  }
                  ++closeTag[tag];
                  i++;
               }
            }
            errorLog = "";
            for(tag in openTag)
            {
               if(!closeTag[tag] || closeTag[tag] != openTag[tag])
               {
                  errorLog = errorLog + ("\n - " + tag + " have no closing tag");
               }
            }
            for(tag in closeTag)
            {
               if(!openTag[tag] || openTag[tag] != closeTag[tag])
               {
                  errorLog = errorLog + ("\n - </" + tag.substr(1) + "> is lonely closing tag");
               }
            }
            _log.error("Error when parsing " + _sUrl + ", misformatted xml" + (!!errorLog.length?" : " + errorLog:""));
            dispatchEvent(new ParsorEvent(null,true));
         }
         this._aName = new Array();
         this.preProccessXml();
      }
      
      private function preProccessXml() : void
      {
         var _loc1_:XmlPreProcessor = new XmlPreProcessor(this._xmlDoc);
         _loc1_.addEventListener(PreProcessEndEvent.PRE_PROCESS_END,this.onPreProcessCompleted);
         _loc1_.processTemplate();
      }
      
      private function mainProcess() : void
      {
         if(this._xmlDoc && this._xmlDoc.firstChild)
         {
            dispatchEvent(new ParsorEvent(this.parseMainNode(this._xmlDoc.firstChild),false));
         }
         else
         {
            dispatchEvent(new ParsorEvent(null,true));
         }
      }
      
      protected function parseMainNode(param1:XMLNode) : UiDefinition
      {
         var _loc2_:XMLNode = null;
         var _loc3_:int = 0;
         var _loc4_:UiDefinition = new UiDefinition();
         var _loc5_:Array;
         if(!(_loc5_ = param1.childNodes).length)
         {
            return null;
         }
         var _loc6_:Object;
         var _loc7_:String = (_loc6_ = param1.attributes)[XmlAttributesEnum.ATTRIBUTE_DEBUG];
         var _loc8_:String = _loc6_[XmlAttributesEnum.ATTRIBUTE_USECACHE];
         var _loc9_:String = _loc6_[XmlAttributesEnum.ATTRIBUTE_USEPROPERTIESCACHE];
         var _loc10_:String = _loc6_[XmlAttributesEnum.ATTRIBUTE_MODAL];
         var _loc11_:String = _loc6_[XmlAttributesEnum.ATTRIBUTE_SCALABLE];
         var _loc12_:String = _loc6_[XmlAttributesEnum.ATTRIBUTE_FOCUS];
         var _loc13_:String = _loc6_[XmlAttributesEnum.ATTRIBUTE_TRANSMITFOCUS];
         var _loc14_:String = _loc6_[XmlAttributesEnum.ATTRIBUTE_LABEL_DEBUG];
         if(_loc7_)
         {
            _loc4_.debug = _loc7_ == "true";
         }
         if(_loc8_)
         {
            _loc4_.useCache = _loc8_ == "true";
         }
         if(_loc9_)
         {
            _loc4_.usePropertiesCache = _loc9_ == "true";
         }
         if(_loc10_)
         {
            _loc4_.modal = _loc10_ == "true";
         }
         if(_loc11_)
         {
            _loc4_.scalable = _loc11_ == "true";
         }
         if(_loc12_)
         {
            _loc4_.giveFocus = _loc12_ == "true";
         }
         if(_loc13_)
         {
            _loc4_.transmitFocus = _loc13_ == "true";
         }
         if(_loc14_)
         {
            _loc4_.labelDebug = _loc14_ == "true";
         }
         var _loc15_:int = _loc5_.length;
         _loc3_ = 0;
         for(; _loc3_ < _loc15_; _loc3_ = _loc3_ + 1)
         {
            _loc2_ = _loc5_[_loc3_];
            switch(_loc2_.nodeName)
            {
               case XmlTagsEnum.TAG_CONSTANTS:
                  this.parseConstants(_loc2_,_loc4_.constants);
                  continue;
               case XmlTagsEnum.TAG_CONTAINER:
               case XmlTagsEnum.TAG_SCROLLCONTAINER:
               case XmlTagsEnum.TAG_STATECONTAINER:
               case XmlTagsEnum.TAG_BUTTON:
                  _loc4_.graphicTree.push(this.parseGraphicElement(_loc2_));
                  continue;
               case XmlTagsEnum.TAG_SHORTCUTS:
                  _loc4_.shortcutsEvents = this.parseShortcutsEvent(_loc2_);
                  continue;
               default:
                  this._log.warn("[" + this._sUrl + "] " + _loc2_.nodeName + " is not allowed or unknown. " + this.suggest(_loc2_.nodeName,[XmlTagsEnum.TAG_CONTAINER,XmlTagsEnum.TAG_STATECONTAINER,XmlTagsEnum.TAG_BUTTON,XmlTagsEnum.TAG_SHORTCUTS]));
                  continue;
            }
         }
         this.cleanLocalConstants(_loc4_.constants);
         return _loc4_;
      }
      
      private function cleanLocalConstants(param1:Array) : void
      {
         var _loc2_:* = null;
         for(_loc2_ in param1)
         {
            LangManager.getInstance().deleteEntry("local." + _loc2_);
         }
      }
      
      protected function parseConstants(param1:XMLNode, param2:Array) : void
      {
         var _loc3_:XMLNode = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Array;
         var _loc10_:int = (_loc9_ = param1.childNodes).length;
         _loc4_ = 0;
         while(_loc4_ < _loc10_)
         {
            _loc3_ = _loc9_[_loc4_];
            if((_loc6_ = _loc3_.nodeName) != XmlTagsEnum.TAG_CONSTANT)
            {
               this._log.error(_loc6_ + " found, wrong node name, waiting for " + XmlTagsEnum.TAG_CONSTANT + " in " + this._sUrl);
            }
            else if(!(_loc7_ = _loc3_.attributes["name"]))
            {
               this._log.error("Constant name\'s not found in " + this._sUrl);
            }
            else
            {
               _loc5_ = LangManager.getInstance().replaceKey(_loc3_.attributes["value"]);
               if(_loc8_ = _loc3_.attributes["type"])
               {
                  if((_loc8_ = _loc8_.toUpperCase()) == "STRING")
                  {
                     param2[_loc7_] = _loc5_;
                  }
                  else if(_loc8_ == "NUMBER")
                  {
                     param2[_loc7_] = Number(_loc5_);
                  }
                  else if(_loc8_ == "UINT" || _loc8_ == "INT")
                  {
                     param2[_loc7_] = int(_loc5_);
                  }
                  else if(_loc8_ == "BOOLEAN")
                  {
                     param2[_loc7_] = _loc5_ == "true";
                  }
                  else if(_loc8_ == "ARRAY")
                  {
                     param2[_loc7_] = _loc5_.split(",");
                  }
               }
               else
               {
                  param2[_loc7_] = _loc5_;
               }
               LangManager.getInstance().setEntry("local." + _loc7_,_loc5_);
            }
            _loc4_ = _loc4_ + 1;
         }
      }
      
      protected function parseGraphicElement(param1:XMLNode, param2:XMLNode = null, param3:BasicElement = null) : BasicElement
      {
         var _loc4_:XMLNode = null;
         var _loc5_:int = 0;
         var _loc6_:* = null;
         var _loc7_:Class = null;
         var _loc8_:* = undefined;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:Class = null;
         var _loc13_:String = null;
         var _loc14_:Array;
         var _loc15_:int = (_loc14_ = param1.childNodes).length;
         if(!param2)
         {
            param2 = param1;
         }
         if(!param3)
         {
            switch(param2.nodeName)
            {
               case XmlTagsEnum.TAG_CONTAINER:
                  param3 = new ContainerElement();
                  param3.className = getQualifiedClassName(GraphicContainer);
                  break;
               case XmlTagsEnum.TAG_SCROLLCONTAINER:
                  param3 = new ScrollContainerElement();
                  param3.className = getQualifiedClassName(ScrollContainer);
                  break;
               case XmlTagsEnum.TAG_GRID:
                  param3 = new GridElement();
                  param3.className = getQualifiedClassName(Grid);
                  break;
               case XmlTagsEnum.TAG_COMBOBOX:
                  param3 = new GridElement();
                  param3.className = getQualifiedClassName(ComboBox);
                  break;
               case XmlTagsEnum.TAG_INPUTCOMBOBOX:
                  param3 = new GridElement();
                  param3.className = getQualifiedClassName(InputComboBox);
                  break;
               case XmlTagsEnum.TAG_TREE:
                  param3 = new GridElement();
                  param3.className = getQualifiedClassName(Tree);
                  break;
               case XmlTagsEnum.TAG_STATECONTAINER:
                  param3 = new StateContainerElement();
                  param3.className = getQualifiedClassName(StateContainer);
                  break;
               case XmlTagsEnum.TAG_BUTTON:
                  param3 = new ButtonElement();
                  param3.className = getQualifiedClassName(ButtonContainer);
                  break;
               default:
                  param3 = new ComponentElement();
                  ComponentElement(param3).className = "com.ankamagames.berilia.components::" + param2.nodeName;
            }
         }
         for(_loc6_ in param2.attributes)
         {
            switch(_loc6_)
            {
               case XmlAttributesEnum.ATTRIBUTE_NAME:
                  param3.setName(param2.attributes[_loc6_]);
                  this._aName[param2.attributes[_loc6_]] = param3;
                  continue;
               case XmlAttributesEnum.ATTRIBUTE_VISIBLE:
                  param3.properties["visible"] = Boolean(param2.attributes[_loc6_]);
                  continue;
               case XmlAttributesEnum.ATTRIBUTE_STRATA:
                  param3.strata = this.getStrataNum(param2.attributes[_loc6_]);
                  continue;
               default:
                  this._log.warn("[" + this._sUrl + "] Unknown attribute \'" + _loc6_ + "\' in " + XmlTagsEnum.TAG_CONTAINER + " tag");
                  continue;
            }
         }
         _loc5_ = 0;
         for(; _loc5_ < _loc15_; _loc5_ = _loc5_ + 1)
         {
            _loc4_ = _loc14_[_loc5_];
            switch(_loc4_.nodeName)
            {
               case XmlTagsEnum.TAG_ANCHORS:
                  param3.anchors = this.parseAnchors(_loc4_);
                  continue;
               case XmlTagsEnum.TAG_SIZE:
                  param3.size = this.parseSize(_loc4_,true).toSizeElement();
                  continue;
               case XmlTagsEnum.TAG_EVENTS:
                  param3.event = this.parseEvent(_loc4_);
                  continue;
               case XmlTagsEnum.TAG_MINIMALSIZE:
                  param3.minSize = this.parseSize(_loc4_,false).toSizeElement();
                  continue;
               case XmlTagsEnum.TAG_MAXIMALSIZE:
                  param3.maxSize = this.parseSize(_loc4_,false).toSizeElement();
                  continue;
               case XmlTagsEnum.TAG_SCROLLCONTAINER:
               case XmlTagsEnum.TAG_CONTAINER:
               case XmlTagsEnum.TAG_GRID:
               case XmlTagsEnum.TAG_COMBOBOX:
               case XmlTagsEnum.TAG_INPUTCOMBOBOX:
               case XmlTagsEnum.TAG_TREE:
                  switch(param2.nodeName)
                  {
                     case XmlTagsEnum.TAG_CONTAINER:
                     case XmlTagsEnum.TAG_BUTTON:
                     case XmlTagsEnum.TAG_STATECONTAINER:
                     case XmlTagsEnum.TAG_SCROLLCONTAINER:
                     case XmlTagsEnum.TAG_COMBOBOX:
                     case XmlTagsEnum.TAG_INPUTCOMBOBOX:
                     case XmlTagsEnum.TAG_TREE:
                     case XmlTagsEnum.TAG_GRID:
                        ContainerElement(param3).childs.push(this.parseGraphicElement(_loc4_));
                        break;
                     default:
                        this._log.warn("[" + this._sUrl + "] " + param2.nodeName + " cannot contains " + _loc4_.nodeName);
                  }
                  continue;
               case XmlTagsEnum.TAG_STATECONTAINER:
               case XmlTagsEnum.TAG_BUTTON:
                  switch(param2.nodeName)
                  {
                     case XmlTagsEnum.TAG_CONTAINER:
                     case XmlTagsEnum.TAG_STATECONTAINER:
                     case XmlTagsEnum.TAG_SCROLLCONTAINER:
                     case XmlTagsEnum.TAG_GRID:
                     case XmlTagsEnum.TAG_COMBOBOX:
                     case XmlTagsEnum.TAG_INPUTCOMBOBOX:
                     case XmlTagsEnum.TAG_TREE:
                        ContainerElement(param3).childs.push(this.parseStateContainer(_loc4_,_loc4_.nodeName));
                        break;
                     default:
                        this._log.warn("[" + this._sUrl + "] " + param2.nodeName + " cannot contains Button");
                  }
                  continue;
               default:
                  switch(param2.nodeName)
                  {
                     case XmlTagsEnum.TAG_CONTAINER:
                        _loc7_ = GraphicContainer;
                        break;
                     case XmlTagsEnum.TAG_BUTTON:
                        _loc7_ = ButtonContainer;
                        break;
                     case XmlTagsEnum.TAG_STATECONTAINER:
                        _loc7_ = StateContainer;
                        break;
                     case XmlTagsEnum.TAG_SCROLLCONTAINER:
                        _loc7_ = ScrollContainer;
                        break;
                     case XmlTagsEnum.TAG_GRID:
                        _loc7_ = Grid;
                        break;
                     case XmlTagsEnum.TAG_COMBOBOX:
                        _loc7_ = ComboBox;
                        break;
                     case XmlTagsEnum.TAG_INPUTCOMBOBOX:
                        _loc7_ = InputComboBox;
                        break;
                     case XmlTagsEnum.TAG_TREE:
                        _loc7_ = Tree;
                  }
                  if((_loc9_ = this.getClassDesc(_loc7_))[_loc4_.nodeName])
                  {
                     if(_loc4_.firstChild)
                     {
                        _loc11_ = (_loc10_ = _loc4_.toString()).substr(_loc4_.nodeName.length + 2,_loc10_.length - _loc4_.nodeName.length * 2 - 5);
                        _loc8_ = LangManager.getInstance().replaceKey(_loc11_);
                        switch(_loc9_[_loc4_.nodeName])
                        {
                           case "Boolean":
                              _loc8_ = _loc8_ != "false";
                              break;
                           default:
                              if(_loc8_.charAt(0) == "[" && _loc8_.charAt(_loc8_.length - 1) == "]")
                              {
                                 break;
                              }
                              _loc8_ = new (_loc12_ = getDefinitionByName(_loc9_[_loc4_.nodeName]) as Class)(_loc8_);
                              break;
                        }
                        ContainerElement(param3).properties[_loc4_.nodeName] = _loc8_;
                     }
                  }
                  else
                  {
                     switch(param2.nodeName)
                     {
                        case XmlTagsEnum.TAG_CONTAINER:
                        case XmlTagsEnum.TAG_BUTTON:
                        case XmlTagsEnum.TAG_STATECONTAINER:
                        case XmlTagsEnum.TAG_SCROLLCONTAINER:
                        case XmlTagsEnum.TAG_GRID:
                        case XmlTagsEnum.TAG_COMBOBOX:
                        case XmlTagsEnum.TAG_INPUTCOMBOBOX:
                        case XmlTagsEnum.TAG_TREE:
                           if(ApplicationDomain.currentDomain.hasDefinition("com.ankamagames.berilia.components." + _loc4_.nodeName))
                           {
                              ContainerElement(param3).childs.push(this.parseGraphicElement(_loc4_));
                           }
                           else
                           {
                              this._log.warn("[" + this._sUrl + "] " + _loc4_.nodeName + " is unknown component / property on " + param2.nodeName);
                           }
                           break;
                        default:
                           if(_loc4_.firstChild != null)
                           {
                              _loc13_ = _loc4_.toString();
                              param3.properties[_loc4_.nodeName] = _loc13_.substr(_loc4_.nodeName.length + 2,_loc13_.length - _loc4_.nodeName.length * 2 - 5);
                           }
                     }
                  }
                  continue;
            }
         }
         if(param3 is ComponentElement)
         {
            this.cleanComponentProperty(ComponentElement(param3));
         }
         return param3;
      }
      
      protected function parseStateContainer(param1:XMLNode, param2:String) : *
      {
         var _loc3_:XMLNode = null;
         var _loc4_:int = 0;
         var _loc5_:StateContainerElement = null;
         var _loc6_:* = undefined;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:Array;
         var _loc10_:int = (_loc9_ = param1.childNodes).length;
         if(param2 == XmlTagsEnum.TAG_BUTTON)
         {
            _loc5_ = new ButtonElement();
         }
         if(param2 == XmlTagsEnum.TAG_STATECONTAINER)
         {
            _loc5_ = new StateContainerElement();
         }
         _loc5_.className = getQualifiedClassName(ButtonContainer);
         _loc4_ = 0;
         for(; _loc4_ < _loc10_; _loc4_ = _loc4_ + 1)
         {
            _loc3_ = _loc9_[_loc4_];
            switch(_loc3_.nodeName)
            {
               case XmlTagsEnum.TAG_COMMON:
                  this.parseGraphicElement(_loc3_,param1,_loc5_);
                  continue;
               case XmlTagsEnum.TAG_STATE:
                  if(_loc7_ = _loc3_.attributes[XmlAttributesEnum.ATTRIBUTE_TYPE])
                  {
                     if(param2 == XmlTagsEnum.TAG_STATECONTAINER)
                     {
                        _loc6_ = _loc7_;
                     }
                     else
                     {
                        _loc6_ = 9999;
                        switch(_loc7_)
                        {
                           case StatesEnum.STATE_CLICKED_STRING:
                              _loc6_ = StatesEnum.STATE_CLICKED;
                              break;
                           case StatesEnum.STATE_OVER_STRING:
                              _loc6_ = StatesEnum.STATE_OVER;
                              break;
                           case StatesEnum.STATE_DISABLED_STRING:
                              _loc6_ = StatesEnum.STATE_DISABLED;
                              break;
                           case StatesEnum.STATE_SELECTED_STRING:
                              _loc6_ = StatesEnum.STATE_SELECTED;
                              break;
                           case StatesEnum.STATE_SELECTED_OVER_STRING:
                              _loc6_ = StatesEnum.STATE_SELECTED_OVER;
                              break;
                           case StatesEnum.STATE_SELECTED_CLICKED_STRING:
                              _loc6_ = StatesEnum.STATE_SELECTED_CLICKED;
                              break;
                           default:
                              _loc8_ = new Array(StatesEnum.STATE_CLICKED_STRING,StatesEnum.STATE_OVER_STRING,StatesEnum.STATE_SELECTED_STRING,StatesEnum.STATE_SELECTED_OVER_STRING,StatesEnum.STATE_SELECTED_CLICKED_STRING,StatesEnum.STATE_DISABLED_STRING);
                              this._log.warn(_loc7_ + " is not a valid state" + this.suggest(_loc7_,_loc8_));
                        }
                     }
                     if(_loc6_ != 9999)
                     {
                        if(!_loc5_.stateChangingProperties[_loc6_])
                        {
                           _loc5_.stateChangingProperties[_loc6_] = new Array();
                        }
                        this.parseSetProperties(_loc3_,_loc5_.stateChangingProperties[_loc6_]);
                     }
                  }
                  else
                  {
                     this._log.warn(XmlTagsEnum.TAG_STATE + " must have attribute [" + XmlAttributesEnum.ATTRIBUTE_TYPE + "]");
                  }
                  continue;
               default:
                  this._log.warn(param2 + " does not allow " + _loc3_.nodeName + this.suggest(_loc3_.nodeName,[XmlTagsEnum.TAG_COMMON,XmlTagsEnum.TAG_STATE]));
                  continue;
            }
         }
         return _loc5_;
      }
      
      protected function parseSetProperties(param1:XMLNode, param2:Object) : void
      {
         var _loc3_:XMLNode = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:XMLNode = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Array;
         var _loc12_:int = (_loc11_ = param1.childNodes).length;
         _loc4_ = 0;
         while(_loc4_ < _loc12_)
         {
            _loc3_ = _loc11_[_loc4_];
            if(_loc3_.nodeName == XmlTagsEnum.TAG_SETPROPERTY)
            {
               if(_loc5_ = _loc3_.attributes[XmlAttributesEnum.ATTRIBUTE_TARGET])
               {
                  if(this._aName[_loc5_])
                  {
                     if(!param2[_loc5_])
                     {
                        param2[_loc5_] = new Array();
                     }
                     _loc6_ = param2[_loc5_];
                     _loc9_ = (_loc8_ = _loc3_.childNodes).length;
                     _loc10_ = 0;
                     while(_loc10_ < _loc9_)
                     {
                        _loc7_ = _loc8_[_loc10_];
                        _loc6_[_loc7_.nodeName] = LangManager.getInstance().replaceKey(_loc7_.firstChild.toString());
                        _loc10_ = _loc10_ + 1;
                     }
                     this.cleanComponentProperty(this._aName[_loc5_],_loc6_);
                  }
                  else
                  {
                     this._log.warn("Unknown reference to \"" + _loc5_ + "\" in " + XmlTagsEnum.TAG_SETPROPERTY);
                  }
               }
               else
               {
                  this._log.warn("Cannot set button properties, not yet implemented");
               }
            }
            else
            {
               this._log.warn("Only " + XmlTagsEnum.TAG_SETPROPERTY + " tags are authorized in " + XmlTagsEnum.TAG_STATE + " tags (found " + _loc3_.nodeName + ")");
            }
            _loc4_ = _loc4_ + 1;
         }
      }
      
      private function cleanComponentProperty(param1:BasicElement, param2:Array = null) : Boolean
      {
         var _loc3_:* = undefined;
         var _loc4_:Class = null;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:Array = null;
         var _loc8_:* = null;
         if(!param2)
         {
            param2 = param1.properties;
         }
         var _loc9_:Class = getDefinitionByName(param1.className) as Class;
         var _loc10_:Object = this.getClassDesc(_loc9_);
         var _loc11_:Array = new Array();
         for(_loc5_ in param2)
         {
            if(_loc10_[_loc5_])
            {
               _loc3_ = LangManager.getInstance().replaceKey(param2[_loc5_]);
               switch(_loc10_[_loc5_])
               {
                  case "Boolean":
                     _loc3_ = _loc3_ != "false";
                     break;
                  case getQualifiedClassName(Uri):
                     _loc3_ = new (_loc4_ = getDefinitionByName(_loc10_[_loc5_]) as Class)(_loc3_);
                     break;
                  case "*":
                     break;
                  default:
                     if(_loc3_.charAt(0) == "[" && _loc3_.charAt(_loc3_.length - 1) == "]")
                     {
                        break;
                     }
                     _loc3_ = new (_loc4_ = getDefinitionByName(_loc10_[_loc5_]) as Class)(_loc3_);
                     break;
               }
               _loc11_[_loc5_] = _loc3_;
            }
            else
            {
               _loc7_ = new Array();
               for(_loc8_ in _loc10_)
               {
                  _loc7_.push(_loc8_);
               }
               this._log.warn("[" + this._sUrl + "]" + _loc5_ + " is unknown for " + param1.className + " component" + this.suggest(_loc5_,_loc7_));
            }
         }
         for(_loc6_ in _loc11_)
         {
            param2[_loc6_] = _loc11_[_loc6_];
         }
         return true;
      }
      
      protected function getClassDesc(param1:Object) : Object
      {
         var _loc2_:XML = null;
         var _loc3_:XML = null;
         var _loc4_:String = getQualifiedClassName(param1);
         if(_classDescCache[_loc4_])
         {
            return _classDescCache[_loc4_];
         }
         var _loc5_:XML = this._describeType(param1);
         var _loc6_:Object = new Object();
         for each(_loc2_ in _loc5_..accessor)
         {
            _loc6_[_loc2_.@name.toString()] = _loc2_.@type.toString();
         }
         for each(_loc3_ in _loc5_..variable)
         {
            _loc6_[_loc3_.@name.toString()] = _loc3_.@type.toString();
         }
         return _loc6_;
      }
      
      protected function parseSize(param1:XMLNode, param2:Boolean) : GraphicSize
      {
         var _loc3_:XMLNode = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(param1.attributes.length)
         {
            this._log.warn("[" + this._sUrl + "]" + param1.nodeName + " cannot have attribut");
         }
         var _loc7_:Array;
         var _loc8_:int = (_loc7_ = param1.childNodes).length;
         var _loc9_:GraphicSize = new GraphicSize();
         _loc4_ = 0;
         while(_loc4_ < _loc8_)
         {
            _loc3_ = _loc7_[_loc4_];
            if(_loc3_.nodeName == XmlTagsEnum.TAG_RELDIMENSION)
            {
               if(!param2)
               {
                  this._log.warn("[" + this._sUrl + "]" + param1.nodeName + " does not allow relative size");
               }
               else
               {
                  if(_loc5_ = _loc3_.attributes["x"])
                  {
                     _loc9_.setX(Number(LangManager.getInstance().replaceKey(_loc5_)),GraphicSize.SIZE_PRC);
                  }
                  if(_loc6_ = _loc3_.attributes["y"])
                  {
                     _loc9_.setY(Number(LangManager.getInstance().replaceKey(_loc6_)),GraphicSize.SIZE_PRC);
                  }
               }
            }
            if(_loc3_.nodeName == XmlTagsEnum.TAG_ABSDIMENSION)
            {
               if(_loc5_ = _loc3_.attributes["x"])
               {
                  _loc9_.setX(int(LangManager.getInstance().replaceKey(_loc5_)),GraphicSize.SIZE_PIXEL);
               }
               if(_loc6_ = _loc3_.attributes["y"])
               {
                  _loc9_.setY(int(LangManager.getInstance().replaceKey(_loc6_)),GraphicSize.SIZE_PIXEL);
               }
            }
            _loc4_ = _loc4_ + 1;
         }
         return _loc9_;
      }
      
      protected function parseAnchors(param1:XMLNode) : Array
      {
         var _loc2_:XMLNode = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:XMLNode = null;
         var _loc6_:GraphicLocation = null;
         var _loc7_:* = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         if(param1.attributes.length)
         {
            this._log.warn("[" + this._sUrl + "]" + param1.nodeName + " cannot have attribut");
         }
         var _loc10_:Array;
         var _loc11_:int = (_loc10_ = param1.childNodes).length;
         var _loc12_:Array = new Array();
         _loc3_ = 0;
         while(_loc3_ < _loc11_)
         {
            _loc6_ = new GraphicLocation();
            _loc2_ = _loc10_[_loc3_];
            if(_loc2_.nodeName == XmlTagsEnum.TAG_ANCHOR)
            {
               for(_loc7_ in _loc2_.attributes)
               {
                  switch(_loc7_)
                  {
                     case XmlAttributesEnum.ATTRIBUTE_POINT:
                        if(_loc12_.length != 0)
                        {
                           this._log.error("[" + this._sUrl + "] When using double anchors, you cannot define attribute POINT");
                        }
                        else
                        {
                           _loc6_.setPoint(_loc2_.attributes[_loc7_]);
                        }
                        continue;
                     case XmlAttributesEnum.ATTRIBUTE_RELATIVEPOINT:
                        _loc6_.setRelativePoint(_loc2_.attributes[_loc7_]);
                        continue;
                     case XmlAttributesEnum.ATTRIBUTE_RELATIVETO:
                        _loc6_.setRelativeTo(_loc2_.attributes[_loc7_]);
                        continue;
                     default:
                        this._log.warn("[" + this._sUrl + "]" + param1.nodeName + " cannot have " + _loc7_ + " attribut");
                        continue;
                  }
               }
               _loc9_ = (_loc8_ = _loc2_.childNodes).length;
               _loc4_ = 0;
               for(; _loc4_ < _loc9_; _loc4_ = _loc4_ + 1)
               {
                  _loc5_ = _loc8_[_loc4_];
                  switch(_loc5_.nodeName)
                  {
                     case XmlTagsEnum.TAG_OFFSET:
                        _loc5_ = _loc5_.firstChild;
                        continue;
                     case XmlTagsEnum.TAG_RELDIMENSION:
                        if(_loc5_.attributes["x"] != null)
                        {
                           _loc6_.offsetXType = LocationTypeEnum.LOCATION_TYPE_RELATIVE;
                           _loc6_.setOffsetX(_loc5_.attributes["x"]);
                        }
                        if(_loc5_.attributes["y"] != null)
                        {
                           _loc6_.offsetYType = LocationTypeEnum.LOCATION_TYPE_RELATIVE;
                           _loc6_.setOffsetY(_loc5_.attributes["y"]);
                        }
                        continue;
                     case XmlTagsEnum.TAG_ABSDIMENSION:
                        if(_loc5_.attributes["x"] != null)
                        {
                           _loc6_.offsetXType = LocationTypeEnum.LOCATION_TYPE_ABSOLUTE;
                           _loc6_.setOffsetX(_loc5_.attributes["x"]);
                        }
                        if(_loc5_.attributes["y"] != null)
                        {
                           _loc6_.offsetYType = LocationTypeEnum.LOCATION_TYPE_ABSOLUTE;
                           _loc6_.setOffsetY(_loc5_.attributes["y"]);
                        }
                        continue;
                     default:
                        continue;
                  }
               }
               _loc12_.push(_loc6_.toLocationElement());
            }
            else
            {
               this._log.warn("[" + this._sUrl + "] " + param1.nodeName + " does not allow " + _loc2_.nodeName + " tag");
            }
            _loc3_ = _loc3_ + 1;
         }
         return !!_loc12_.length?_loc12_:null;
      }
      
      protected function parseShortcutsEvent(param1:XMLNode) : Array
      {
         var _loc2_:XMLNode = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array;
         var _loc6_:int = (_loc5_ = param1.childNodes).length;
         var _loc7_:Array = new Array();
         _loc3_ = 0;
         while(_loc3_ < _loc6_)
         {
            _loc2_ = _loc5_[_loc3_];
            _loc4_ = _loc2_.nodeName;
            if(!BindsManager.getInstance().isRegisteredName(_loc4_))
            {
               this._log.info("[" + this._sUrl + "] Shortcut " + _loc4_ + " is not defined.");
            }
            _loc7_.push(_loc4_);
            _loc3_ = _loc3_ + 1;
         }
         return _loc7_;
      }
      
      private function parseEvent(param1:XMLNode) : Array
      {
         var _loc2_:XMLNode = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Array;
         var _loc7_:int = (_loc6_ = param1.childNodes).length;
         var _loc8_:Array = new Array();
         _loc3_ = 0;
         for(; _loc3_ < _loc7_; if(_loc4_.length)
         {
            _loc8_.push(_loc4_);
         },_loc3_ = _loc3_ + 1)
         {
            _loc2_ = _loc6_[_loc3_];
            _loc4_ = "";
            switch(_loc2_.nodeName)
            {
               case EventEnums.EVENT_ONPRESS:
                  _loc4_ = EventEnums.EVENT_ONPRESS_MSG;
                  continue;
               case EventEnums.EVENT_ONRELEASE:
                  _loc4_ = EventEnums.EVENT_ONRELEASE_MSG;
                  continue;
               case EventEnums.EVENT_ONROLLOUT:
                  _loc4_ = EventEnums.EVENT_ONROLLOUT_MSG;
                  continue;
               case EventEnums.EVENT_ONROLLOVER:
                  _loc4_ = EventEnums.EVENT_ONROLLOVER_MSG;
                  continue;
               case EventEnums.EVENT_ONRELEASEOUTSIDE:
                  _loc4_ = EventEnums.EVENT_ONRELEASEOUTSIDE_MSG;
                  continue;
               case EventEnums.EVENT_ONRIGHTCLICK:
                  _loc4_ = EventEnums.EVENT_ONRIGHTCLICK_MSG;
                  continue;
               case EventEnums.EVENT_ONDOUBLECLICK:
                  _loc4_ = EventEnums.EVENT_ONDOUBLECLICK_MSG;
                  continue;
               case EventEnums.EVENT_MIDDLECLICK:
                  _loc4_ = EventEnums.EVENT_MIDDLECLICK_MSG;
                  continue;
               case EventEnums.EVENT_ONCOLORCHANGE:
                  _loc4_ = EventEnums.EVENT_ONCOLORCHANGE_MSG;
                  continue;
               case EventEnums.EVENT_ONENTITYREADY:
                  _loc4_ = EventEnums.EVENT_ONENTITYREADY_MSG;
                  continue;
               case EventEnums.EVENT_ONSELECTITEM:
                  _loc4_ = EventEnums.EVENT_ONSELECTITEM_MSG;
                  continue;
               case EventEnums.EVENT_ONSELECTEMPTYITEM:
                  _loc4_ = EventEnums.EVENT_ONSELECTEMPTYITEM_MSG;
                  continue;
               case EventEnums.EVENT_ONDROP:
                  _loc4_ = EventEnums.EVENT_ONDROP_MSG;
                  continue;
               case EventEnums.EVENT_ONCREATETAB:
                  _loc4_ = EventEnums.EVENT_ONCREATETAB_MSG;
                  continue;
               case EventEnums.EVENT_ONDELETETAB:
                  _loc4_ = EventEnums.EVENT_ONDELETETAB_MSG;
                  continue;
               case EventEnums.EVENT_ONRENAMETAB:
                  _loc4_ = EventEnums.EVENT_ONRENAMETAB_MSG;
                  continue;
               case EventEnums.EVENT_ONITEMROLLOVER:
                  _loc4_ = EventEnums.EVENT_ONITEMROLLOVER_MSG;
                  continue;
               case EventEnums.EVENT_ONITEMROLLOUT:
                  _loc4_ = EventEnums.EVENT_ONITEMROLLOUT_MSG;
                  continue;
               case EventEnums.EVENT_ONITEMRIGHTCLICK:
                  _loc4_ = EventEnums.EVENT_ONITEMRIGHTCLICK_MSG;
                  continue;
               case EventEnums.EVENT_ONWHEEL:
                  _loc4_ = EventEnums.EVENT_ONWHEEL_MSG;
                  continue;
               case EventEnums.EVENT_ONMOUSEUP:
                  _loc4_ = EventEnums.EVENT_ONMOUSEUP_MSG;
                  continue;
               case EventEnums.EVENT_ONMAPELEMENTROLLOUT:
                  _loc4_ = EventEnums.EVENT_ONMAPELEMENTROLLOUT_MSG;
                  continue;
               case EventEnums.EVENT_ONMAPELEMENTROLLOVER:
                  _loc4_ = EventEnums.EVENT_ONMAPELEMENTROLLOVER_MSG;
                  continue;
               case EventEnums.EVENT_ONMAPELEMENTRIGHTCLICK:
                  _loc4_ = EventEnums.EVENT_ONMAPELEMENTRIGHTCLICK_MSG;
                  continue;
               case EventEnums.EVENT_ONMAPMOVE:
                  _loc4_ = EventEnums.EVENT_ONMAPMOVE_MSG;
                  continue;
               case EventEnums.EVENT_ONMAPROLLOVER:
                  _loc4_ = EventEnums.EVENT_ONMAPROLLOVER_MSG;
                  continue;
               case EventEnums.EVENT_ONCOMPONENTREADY:
                  _loc4_ = EventEnums.EVENT_ONCOMPONENTREADY_MSG;
                  continue;
               default:
                  _loc5_ = [EventEnums.EVENT_ONPRESS,EventEnums.EVENT_ONRELEASE,EventEnums.EVENT_ONROLLOUT,EventEnums.EVENT_ONROLLOVER,EventEnums.EVENT_ONRIGHTCLICK,EventEnums.EVENT_ONRELEASEOUTSIDE,EventEnums.EVENT_ONDOUBLECLICK,EventEnums.EVENT_ONCOLORCHANGE,EventEnums.EVENT_ONENTITYREADY,EventEnums.EVENT_ONSELECTITEM,EventEnums.EVENT_ONSELECTEMPTYITEM,EventEnums.EVENT_ONITEMROLLOVER,EventEnums.EVENT_ONITEMROLLOUT,EventEnums.EVENT_ONDROP,EventEnums.EVENT_ONWHEEL,EventEnums.EVENT_ONMOUSEUP,EventEnums.EVENT_ONMAPELEMENTROLLOUT,EventEnums.EVENT_ONMAPELEMENTROLLOVER,EventEnums.EVENT_ONMAPELEMENTRIGHTCLICK,EventEnums.EVENT_ONCREATETAB,EventEnums.EVENT_ONDELETETAB,EventEnums.EVENT_MIDDLECLICK];
                  this._log.warn("[" + this._sUrl + "] " + _loc2_.nodeName + " is an unknown event name" + this.suggest(_loc2_.nodeName,_loc5_));
                  continue;
            }
         }
         return _loc8_;
      }
      
      private function getStrataNum(param1:String) : uint
      {
         var _loc2_:Array = null;
         if(param1 == StrataEnum.STRATA_NAME_LOW)
         {
            return StrataEnum.STRATA_LOW;
         }
         if(param1 == StrataEnum.STRATA_NAME_MEDIUM)
         {
            return StrataEnum.STRATA_MEDIUM;
         }
         if(param1 == StrataEnum.STRATA_NAME_HIGH)
         {
            return StrataEnum.STRATA_HIGH;
         }
         if(param1 == StrataEnum.STRATA_NAME_TOP)
         {
            return StrataEnum.STRATA_TOP;
         }
         if(param1 == StrataEnum.STRATA_NAME_TOOLTIP)
         {
            return StrataEnum.STRATA_TOOLTIP;
         }
         _loc2_ = [StrataEnum.STRATA_NAME_LOW,StrataEnum.STRATA_NAME_MEDIUM,StrataEnum.STRATA_NAME_HIGH,StrataEnum.STRATA_NAME_TOP,StrataEnum.STRATA_NAME_TOOLTIP];
         this._log.warn("[" + this._sUrl + "] " + param1 + " is an unknown strata name" + this.suggest(param1,_loc2_));
         return StrataEnum.STRATA_MEDIUM;
      }
      
      private function suggest(param1:String, param2:Array, param3:uint = 5, param4:uint = 3) : String
      {
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:* = "";
         var _loc8_:Array = new Array();
         _loc6_ = 0;
         while(_loc6_ < param2.length)
         {
            if((_loc5_ = Levenshtein.distance(param1.toUpperCase(),param2[_loc6_].toUpperCase())) <= param3)
            {
               _loc8_.push({
                  "dist":_loc5_,
                  "word":param2[_loc6_]
               });
            }
            _loc6_++;
         }
         if(_loc8_.length)
         {
            _loc7_ = " (did you mean ";
            _loc8_.sortOn("dist",Array.NUMERIC);
            _loc6_ = 0;
            while(_loc6_ < _loc8_.length - 1 && _loc6_ < param4 - 1)
            {
               _loc7_ = _loc7_ + ("\"" + _loc8_[_loc6_].word + "\"" + (_loc6_ < _loc8_.length - 1?", ":""));
               _loc6_++;
            }
            if(_loc8_[_loc6_])
            {
               _loc7_ = _loc7_ + ((!!_loc6_?"or ":"") + "\"" + _loc8_[_loc6_].word);
            }
            _loc7_ = _loc7_ + "\" ?)";
         }
         return _loc7_;
      }
      
      private function onPreProcessCompleted(param1:Event) : void
      {
         this.mainProcess();
      }
      
      private function onXmlLoadComplete(param1:ResourceLoadedEvent) : void
      {
         this.processXml(param1.resource);
      }
      
      private function onXmlLoadError(param1:ResourceErrorEvent) : void
      {
         dispatchEvent(new ParsingErrorEvent(param1.uri.toString(),param1.errorMsg));
      }
   }
}
