package com.ankamagames.berilia.types.data
{
   import com.ankamagames.berilia.managers.CssManager;
   import com.ankamagames.berilia.types.event.CssEvent;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.FontManager;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.types.Callback;
   import flash.text.AntiAliasType;
   import flash.text.StyleSheet;
   import flash.text.engine.CFFHinting;
   import flash.text.engine.FontLookup;
   import flash.text.engine.RenderingMode;
   import flash.utils.getQualifiedClassName;
   import flashx.textLayout.formats.TextLayoutFormat;
   
   public class ExtendedStyleSheet extends StyleSheet
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ExtendedStyleSheet));
      
      private static const CSS_INHERITANCE_KEYWORD:String = "extends";
      
      private static const CSS_FILES_KEYWORD:String = "files";
       
      
      private var _inherit:Array;
      
      private var _inherited:uint = 0;
      
      private var _url:String;
      
      public function ExtendedStyleSheet(param1:String)
      {
         this._inherit = new Array();
         this._url = param1;
         super();
      }
      
      public function get inherit() : Array
      {
         return this._inherit;
      }
      
      public function get ready() : Boolean
      {
         return this._inherited == this._inherit.length;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      override public function parseCSS(param1:String) : void
      {
         var _loc2_:Object = null;
         var _loc3_:RegExp = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         super.parseCSS(param1);
         var _loc7_:int;
         if((_loc7_ = styleNames.indexOf(CSS_INHERITANCE_KEYWORD)) != -1)
         {
            _loc2_ = getStyle(styleNames[_loc7_]);
            if(_loc2_[CSS_FILES_KEYWORD])
            {
               _loc3_ = /url\('?([^']*)'\)?/g;
               _loc4_ = String(_loc2_[CSS_FILES_KEYWORD]).match(_loc3_);
               _loc6_ = 0;
               while(_loc6_ < _loc4_.length)
               {
                  _loc5_ = String(_loc4_[_loc6_]).replace(_loc3_,"$1");
                  if(-1 == this._inherit.indexOf(_loc5_))
                  {
                     _loc5_ = LangManager.getInstance().replaceKey(_loc5_);
                     CssManager.getInstance().askCss(_loc5_,new Callback(this.makeMerge,_loc5_));
                     this._inherit.push(_loc5_);
                  }
                  _loc6_++;
               }
            }
            else
            {
               _log.warn("property \'" + CSS_FILES_KEYWORD + "\' wasn\'t found (flash css doesn\'t support space between property name and colon, propertyName:value)");
               dispatchEvent(new CssEvent(CssEvent.CSS_PARSED,false,false,this));
            }
         }
         else
         {
            dispatchEvent(new CssEvent(CssEvent.CSS_PARSED,false,false,this));
         }
      }
      
      public function merge(param1:ExtendedStyleSheet, param2:Boolean = false) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:* = null;
         var _loc6_:uint = 0;
         while(_loc6_ < param1.styleNames.length)
         {
            if(param1.styleNames[_loc6_] != CSS_INHERITANCE_KEYWORD)
            {
               _loc3_ = getStyle(param1.styleNames[_loc6_]);
               _loc4_ = param1.getStyle(param1.styleNames[_loc6_]);
               if(_loc3_)
               {
                  for(_loc5_ in _loc4_)
                  {
                     if(_loc3_[_loc5_] == null || param2)
                     {
                        _loc3_[_loc5_] = _loc4_[_loc5_];
                     }
                  }
                  _loc4_ = _loc3_;
               }
               setStyle(param1.styleNames[_loc6_],_loc4_);
            }
            _loc6_++;
         }
      }
      
      override public function toString() : String
      {
         var _loc1_:Object = null;
         var _loc2_:* = null;
         var _loc4_:uint = 0;
         var _loc3_:* = "";
         _loc3_ = _loc3_ + ("File " + this.url + " :\n");
         while(_loc4_ < styleNames.length)
         {
            _loc1_ = getStyle(styleNames[_loc4_]);
            _loc3_ = _loc3_ + (" [" + styleNames[_loc4_] + "]\n");
            for(_loc2_ in _loc1_)
            {
               _loc3_ = _loc3_ + ("  " + _loc2_ + " : " + _loc1_[_loc2_] + "\n");
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function TLFTransform(param1:Object) : TextLayoutFormat
      {
         var _loc2_:String = null;
         var _loc3_:TextLayoutFormat = new TextLayoutFormat();
         if(param1["fontFamily"])
         {
            _loc2_ = param1["fontFamily"];
            if(FontManager.getInstance().getFontClassRenderingMode(_loc2_) == AntiAliasType.ADVANCED)
            {
               _loc3_.renderingMode = RenderingMode.CFF;
               _loc3_.fontLookup = FontLookup.EMBEDDED_CFF;
               _loc3_.cffHinting = CFFHinting.HORIZONTAL_STEM;
            }
            _loc3_.fontFamily = _loc2_;
         }
         if(param1["color"])
         {
            _loc3_.color = param1["color"];
         }
         if(param1["fontSize"])
         {
            _loc3_.fontSize = param1["fontSize"];
         }
         if(param1["paddingLeft"])
         {
            _loc3_.paddingLeft = param1["paddingLeft"];
         }
         if(param1["paddingRight"])
         {
            _loc3_.paddingRight = param1["paddingRight"];
         }
         if(param1["paddingBottom"])
         {
            _loc3_.paddingBottom = param1["paddingBottom"];
         }
         if(param1["paddingTop"])
         {
            _loc3_.paddingTop = param1["paddingTop"];
         }
         if(param1["textIndent"])
         {
            _loc3_.textIndent = param1["textIndent"];
         }
         return _loc3_;
      }
      
      private function makeMerge(param1:String) : void
      {
         this.merge(CssManager.getInstance().getCss(param1));
         ++this._inherited;
         if(this.ready)
         {
            dispatchEvent(new CssEvent(CssEvent.CSS_PARSED,false,false,this));
         }
      }
   }
}
