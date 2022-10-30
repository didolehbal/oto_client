package com.ankamagames.berilia.uiRender
{
   import com.ankamagames.berilia.enums.XmlAttributesEnum;
   import com.ankamagames.berilia.enums.XmlTagsEnum;
   import com.ankamagames.berilia.managers.TemplateManager;
   import com.ankamagames.berilia.types.event.PreProcessEndEvent;
   import com.ankamagames.berilia.types.event.TemplateLoadedEvent;
   import com.ankamagames.berilia.types.template.TemplateParam;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.LangManager;
   import flash.events.EventDispatcher;
   import flash.utils.getQualifiedClassName;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   
   public class XmlPreProcessor extends EventDispatcher
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(XmlPreProcessor));
       
      
      private var _xDoc:XMLDocument;
      
      private var _bMustBeRendered:Boolean = true;
      
      private var _aImportFile:Array;
      
      public function XmlPreProcessor(param1:XMLDocument)
      {
         super();
         this._xDoc = param1;
      }
      
      public function get importedFiles() : int
      {
         return this._aImportFile.length;
      }
      
      public function processTemplate() : void
      {
         var _loc1_:uint = 0;
         this._aImportFile = new Array();
         TemplateManager.getInstance().addEventListener(TemplateLoadedEvent.EVENT_TEMPLATE_LOADED,this.onTemplateLoaded);
         this.matchImport(this._xDoc.firstChild);
         if(!this._aImportFile.length)
         {
            dispatchEvent(new PreProcessEndEvent(this));
            TemplateManager.getInstance().removeEventListener(TemplateLoadedEvent.EVENT_TEMPLATE_LOADED,this.onTemplateLoaded);
            return;
         }
         while(_loc1_ < this._aImportFile.length)
         {
            TemplateManager.getInstance().register(this._aImportFile[_loc1_]);
            _loc1_++;
         }
      }
      
      private function matchImport(param1:XMLNode) : void
      {
         var _loc2_:XMLNode = null;
         var _loc3_:uint = 0;
         if(param1 == null)
         {
            return;
         }
         while(_loc3_ < param1.childNodes.length)
         {
            _loc2_ = param1.childNodes[_loc3_];
            if(_loc2_.nodeName == XmlTagsEnum.TAG_IMPORT)
            {
               if(_loc2_.attributes[XmlAttributesEnum.ATTRIBUTE_URL] == null)
               {
                  _log.warn("Attribute \'" + XmlAttributesEnum.ATTRIBUTE_URL + "\' is missing in " + XmlTagsEnum.TAG_IMPORT + " tag.");
               }
               else
               {
                  this._aImportFile.push(LangManager.getInstance().replaceKey(_loc2_.attributes[XmlAttributesEnum.ATTRIBUTE_URL]));
               }
               _loc2_.removeNode();
               _loc3_--;
            }
            else if(_loc2_ != null)
            {
               this.matchImport(_loc2_);
            }
            _loc3_++;
         }
      }
      
      private function replaceTemplateCall(param1:XMLNode) : Boolean
      {
         var _loc2_:XMLNode = null;
         var _loc3_:XMLNode = null;
         var _loc4_:XMLNode = null;
         var _loc5_:XMLNode = null;
         var _loc6_:uint = 0;
         var _loc7_:* = null;
         var _loc8_:uint = 0;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc11_:Array = null;
         var _loc12_:Boolean = false;
         var _loc13_:String = null;
         var _loc14_:XMLNode = null;
         var _loc15_:Boolean = false;
         var _loc16_:uint = 0;
         while(_loc16_ < param1.childNodes.length)
         {
            _loc2_ = param1.childNodes[_loc16_];
            _loc12_ = false;
            _loc6_ = 0;
            while(_loc6_ < this._aImportFile.length)
            {
               _loc9_ = this._aImportFile[_loc6_].split("/");
               if((_loc10_ = _loc9_[_loc9_.length - 1]).toUpperCase() == (_loc2_.nodeName + ".xml").toUpperCase())
               {
                  _loc11_ = new Array();
                  for(_loc7_ in _loc2_.attributes)
                  {
                     _loc11_[_loc7_] = new TemplateParam(_loc7_,_loc2_.attributes[_loc7_]);
                  }
                  _loc8_ = 0;
                  while(_loc8_ < _loc2_.childNodes.length)
                  {
                     _loc3_ = _loc2_.childNodes[_loc8_];
                     _loc13_ = "";
                     for each(_loc14_ in _loc3_.childNodes)
                     {
                        _loc13_ = _loc13_ + _loc14_;
                     }
                     _loc11_[_loc3_.nodeName] = new TemplateParam(_loc3_.nodeName,_loc13_);
                     _loc8_++;
                  }
                  _loc4_ = TemplateManager.getInstance().getTemplate(_loc10_).makeTemplate(_loc11_);
                  _loc8_ = 0;
                  while(_loc8_ < _loc4_.firstChild.childNodes.length)
                  {
                     _loc5_ = _loc4_.firstChild.childNodes[_loc8_].cloneNode(true);
                     _loc2_.parentNode.insertBefore(_loc5_,_loc2_);
                     _loc8_++;
                  }
                  _loc2_.removeNode();
                  _loc15_ = _loc12_ = true;
               }
               _loc6_++;
            }
            if(!_loc12_)
            {
               _loc15_ = this.replaceTemplateCall(_loc2_) || _loc15_;
            }
            _loc16_++;
         }
         return _loc15_;
      }
      
      private function onTemplateLoaded(param1:TemplateLoadedEvent) : void
      {
         if(TemplateManager.getInstance().areLoaded(this._aImportFile) && this._bMustBeRendered)
         {
            this._bMustBeRendered = this.replaceTemplateCall(this._xDoc.firstChild);
            if(this._bMustBeRendered)
            {
               this.processTemplate();
            }
            else
            {
               dispatchEvent(new PreProcessEndEvent(this));
               TemplateManager.getInstance().removeEventListener(TemplateLoadedEvent.EVENT_TEMPLATE_LOADED,this.onTemplateLoaded);
            }
         }
      }
   }
}
