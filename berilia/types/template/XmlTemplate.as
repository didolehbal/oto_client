package com.ankamagames.berilia.types.template
{
   import com.ankamagames.berilia.enums.XmlAttributesEnum;
   import com.ankamagames.berilia.enums.XmlTagsEnum;
   import com.ankamagames.jerakine.eval.Evaluator;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.getQualifiedClassName;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   
   public class XmlTemplate
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(XmlTemplate));
       
      
      private var _aTemplateParams:Array;
      
      private var _sXml:String;
      
      private var _xDoc:XMLDocument;
      
      private var _aVariablesStack:Array;
      
      private var _filename:String;
      
      public function XmlTemplate(param1:String = null, param2:String = null)
      {
         this._aVariablesStack = new Array();
         super();
         this._filename = param2;
         if(param1 != null)
         {
            this.xml = param1;
         }
      }
      
      public function get xml() : String
      {
         return this._sXml;
      }
      
      public function set xml(param1:String) : void
      {
         this._sXml = param1;
         this.parseTemplate();
      }
      
      public function get filename() : String
      {
         return this._filename;
      }
      
      public function set filename(param1:String) : void
      {
         this._filename = param1;
      }
      
      public function get templateParams() : Array
      {
         return this._aTemplateParams;
      }
      
      public function get variablesStack() : Array
      {
         return this._aVariablesStack;
      }
      
      public function makeTemplate(param1:Array) : XMLNode
      {
         var _loc2_:* = null;
         var _loc3_:Array = null;
         var _loc4_:TemplateVar = null;
         var _loc5_:uint = 0;
         var _loc6_:Evaluator = new Evaluator();
         var _loc7_:String = this._xDoc.toString();
         var _loc8_:Array = [];
         for(_loc2_ in this._aTemplateParams)
         {
            _loc8_[_loc2_] = this._aTemplateParams[_loc2_];
         }
         for(_loc2_ in param1)
         {
            if(!this._aTemplateParams[_loc2_])
            {
               _log.error("Template " + this._filename + ", param " + _loc2_ + " is not defined");
               delete param1[_loc2_];
            }
            else
            {
               _loc8_[_loc2_] = param1[_loc2_];
            }
         }
         _loc7_ = this.replaceParam(_loc7_,_loc8_,"#");
         _loc3_ = new Array();
         _loc5_ = 0;
         while(_loc5_ < this._aVariablesStack.length)
         {
            (_loc4_ = this._aVariablesStack[_loc5_].clone()).value = _loc6_.eval(this.replaceParam(this.replaceParam(_loc4_.value,_loc8_,"#"),_loc3_,"$"));
            _loc3_[_loc4_.name] = _loc4_;
            _loc5_++;
         }
         _loc7_ = this.replaceParam(_loc7_,_loc3_,"$");
         var _loc9_:XMLDocument;
         (_loc9_ = new XMLDocument()).parseXML(_loc7_);
         return _loc9_;
      }
      
      private function parseTemplate() : void
      {
         this._xDoc = new XMLDocument();
         this._aTemplateParams = new Array();
         this._xDoc.ignoreWhite = true;
         this._xDoc.parseXML(this._sXml);
         if(this._xDoc.firstChild.nodeName + ".xml" != this._filename)
         {
            _log.error("Wrong root node name in " + this._filename + ", found " + this._xDoc.firstChild.nodeName + ", waiting for " + this._filename.replace(".xml",""));
            return;
         }
         this.matchDynamicsParts(this._xDoc.firstChild);
      }
      
      private function matchDynamicsParts(param1:XMLNode) : void
      {
         var _loc2_:XMLNode = null;
         var _loc3_:TemplateVar = null;
         var _loc4_:TemplateParam = null;
         var _loc5_:uint = 0;
         for(; _loc5_ < param1.childNodes.length; _loc5_++)
         {
            _loc2_ = param1.childNodes[_loc5_];
            if(_loc2_.nodeName == XmlTagsEnum.TAG_VAR)
            {
               if(_loc2_.attributes[XmlAttributesEnum.ATTRIBUTE_NAME])
               {
                  _loc3_ = new TemplateVar(_loc2_.attributes[XmlAttributesEnum.ATTRIBUTE_NAME]);
                  _loc3_.value = _loc2_.firstChild.toString().replace(/&apos;/g,"\'");
                  this._aVariablesStack.push(_loc3_);
                  _loc2_.removeNode();
                  _loc5_--;
                  continue;
               }
               _log.warn(_loc2_.nodeName + " must have [" + XmlAttributesEnum.ATTRIBUTE_NAME + "] attribute");
            }
            if(_loc2_.nodeName == XmlTagsEnum.TAG_PARAM)
            {
               if(_loc2_.attributes[XmlAttributesEnum.ATTRIBUTE_NAME])
               {
                  _loc4_ = new TemplateParam(_loc2_.attributes[XmlAttributesEnum.ATTRIBUTE_NAME]);
                  this._aTemplateParams[_loc4_.name] = _loc4_;
                  if(_loc2_.hasChildNodes())
                  {
                     _loc4_.defaultValue = _loc2_.firstChild.toString();
                  }
                  else
                  {
                     _loc4_.defaultValue = "";
                  }
                  _loc2_.removeNode();
                  _loc5_--;
               }
               else
               {
                  _log.warn(_loc2_.nodeName + " must have [" + XmlAttributesEnum.ATTRIBUTE_NAME + "] attribute");
               }
            }
         }
      }
      
      private function replaceParam(param1:String, param2:Array, param3:String, param4:uint = 1) : String
      {
         var _loc5_:String = null;
         var _loc6_:* = null;
         var _loc7_:uint = 0;
         if(!param1)
         {
            return param1;
         }
         var _loc8_:Array = new Array();
         for(_loc6_ in param2)
         {
            _loc8_.push(_loc6_);
         }
         _loc8_.sort(Array.DESCENDING);
         _loc7_ = 0;
         while(_loc7_ < _loc8_.length)
         {
            _loc6_ = _loc8_[_loc7_];
            if(param2[_loc6_] != null)
            {
               if(!(_loc5_ = param2[_loc6_].value) && param2[_loc6_] is TemplateParam)
               {
                  _loc5_ = param2[_loc6_].defaultValue;
               }
               if(_loc5_ == null)
               {
                  _log.warn("No value for " + param3 + _loc6_);
               }
               else
               {
                  param1 = param1.split(param3 + _loc6_).join(_loc5_);
               }
            }
            _loc7_++;
         }
         return param1;
      }
   }
}
