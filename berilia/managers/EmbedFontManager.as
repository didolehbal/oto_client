package com.ankamagames.berilia.managers
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoaderProgressEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.types.Swl;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.utils.files.FileUtils;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.text.Font;
   import flash.utils.getQualifiedClassName;
   
   public class EmbedFontManager extends EventDispatcher
   {
      
      private static var _self:EmbedFontManager;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(EmbedFontManager));
       
      
      private var _aFonts:Array;
      
      private var _currentlyLoading:String;
      
      private var _loadingFonts:Array;
      
      private var _loader:IResourceLoader;
      
      public function EmbedFontManager()
      {
         super();
         if(_self != null)
         {
            throw new SingletonError("EmbedFontManager constructor should not be called directly.");
         }
         _self = this;
         this._aFonts = new Array();
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SERIAL_LOADER);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onComplete);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onError);
         this._loader.addEventListener(ResourceLoaderProgressEvent.LOADER_COMPLETE,this.onAllFontLoaded);
      }
      
      public static function getInstance() : EmbedFontManager
      {
         if(_self == null)
         {
            _self = new EmbedFontManager();
         }
         return _self;
      }
      
      public function initialize(param1:Array) : void
      {
         if(this._loadingFonts == null)
         {
            this._loadingFonts = new Array();
         }
         this._loadingFonts = this._loadingFonts.concat(param1);
         this.loadFonts();
      }
      
      public function isEmbed(param1:String) : Boolean
      {
         return this._aFonts[param1] == true;
      }
      
      public function getFont(param1:String) : Font
      {
         var _loc3_:uint = 0;
         var _loc2_:Array = Font.enumerateFonts();
         while(_loc3_ < _loc2_.length)
         {
            if(Font(_loc2_[_loc3_]).fontName.toUpperCase() == param1.toUpperCase())
            {
               return _loc2_[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      private function loadFonts() : void
      {
         var _loc1_:String = null;
         if(this._currentlyLoading != null)
         {
            return;
         }
         if(this._loadingFonts.length == 0)
         {
            dispatchEvent(new Event(Event.COMPLETE));
            return;
         }
         var _loc2_:Array = new Array();
         for each(_loc1_ in this._loadingFonts)
         {
            _loc2_.push(new Uri(_loc1_));
         }
         this._loadingFonts = null;
         this._loader.load(_loc2_);
      }
      
      private function onComplete(param1:ResourceLoadedEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Class = Swl(param1.resource).getDefinition(FileUtils.getFileStartName(param1.uri.uri)) as Class;
         this._aFonts[FileUtils.getFileStartName(param1.uri.uri)] = true;
         if(_loc4_["EMBED_FONT"])
         {
            Font.registerFont(_loc4_["EMBED_FONT"]);
         }
         else
         {
            _loc2_ = _loc4_["FONTS_LIST"];
            if(_loc2_)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  Font.registerFont(_loc2_[_loc3_]);
                  _loc3_++;
               }
            }
         }
         this._currentlyLoading = null;
      }
      
      private function onAllFontLoaded(param1:ResourceLoaderProgressEvent) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function onError(param1:ResourceErrorEvent) : void
      {
         _log.error("Unabled to load a font : " + param1.uri);
      }
   }
}
