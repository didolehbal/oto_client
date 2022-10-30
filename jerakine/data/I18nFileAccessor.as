package com.ankamagames.jerakine.data
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Endian;
   import flash.utils.getQualifiedClassName;
   
   public class I18nFileAccessor
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(I18nFileAccessor));
      
      private static var _self:I18nFileAccessor;
       
      
      private var _stream:FileStream;
      
      private var _indexes:Dictionary;
      
      private var _unDiacriticalIndex:Dictionary;
      
      private var _textIndexes:Dictionary;
      
      private var _textIndexesOverride:Dictionary;
      
      private var _textSortIndex:Dictionary;
      
      private var _startTextIndex:uint = 4;
      
      private var _textCount:uint;
      
      private var _directBuffer:ByteArray;
      
      public function I18nFileAccessor()
      {
         super();
         if(_self)
         {
            throw new SingletonError();
         }
      }
      
      public static function getInstance() : I18nFileAccessor
      {
         if(!_self)
         {
            _self = new I18nFileAccessor();
         }
         return _self;
      }
      
      public function init(param1:Uri) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:uint = 0;
         var _loc6_:* = null;
         var _loc9_:uint = 0;
         var _loc11_:uint = 0;
         var _loc7_:File;
         if(!(_loc7_ = param1.toFile()) || !_loc7_.exists)
         {
            throw new Error("I18n file not readable.");
         }
         this._stream = new FileStream();
         this._stream.endian = Endian.BIG_ENDIAN;
         this._stream.open(_loc7_,FileMode.READ);
         this._indexes = new Dictionary();
         this._unDiacriticalIndex = new Dictionary();
         this._textIndexes = new Dictionary();
         this._textIndexesOverride = new Dictionary();
         this._textSortIndex = new Dictionary();
         this._textCount = 0;
         var _loc8_:int = this._stream.readInt();
         this._stream.position = _loc8_;
         var _loc10_:int = this._stream.readInt();
         while(_loc11_ < _loc10_)
         {
            _loc2_ = this._stream.readInt();
            _loc4_ = this._stream.readBoolean();
            _loc3_ = this._stream.readInt();
            this._indexes[_loc2_] = _loc3_;
            _loc9_++;
            if(_loc4_)
            {
               _loc9_++;
               _loc11_ = _loc11_ + 4;
               this._unDiacriticalIndex[_loc2_] = this._stream.readInt();
            }
            else
            {
               this._unDiacriticalIndex[_loc2_] = _loc3_;
            }
            _loc11_ = _loc11_ + 9;
         }
         _loc10_ = this._stream.readInt();
         while(_loc10_ > 0)
         {
            _loc5_ = this._stream.position;
            _loc6_ = this._stream.readUTF();
            _loc3_ = this._stream.readInt();
            ++this._textCount;
            this._textIndexes[_loc6_] = _loc3_;
            _loc10_ = _loc10_ - (this._stream.position - _loc5_);
         }
         _loc10_ = this._stream.readInt();
         _loc11_ = 0;
         while(_loc10_ > 0)
         {
            _loc5_ = this._stream.position;
            this._textSortIndex[this._stream.readInt()] = ++_loc11_;
            _loc10_ = _loc10_ - (this._stream.position - _loc5_);
         }
         for(_loc6_ in this._textIndexes)
         {
            LangManager.getInstance().setEntry(_loc6_,this.getNamedText(_loc6_));
         }
         _log.debug("Initialized !");
      }
      
      public function overrideId(param1:uint, param2:uint) : void
      {
         this._indexes[param1] = this._indexes[param2];
         this._unDiacriticalIndex[param1] = this._unDiacriticalIndex[param2];
      }
      
      public function addOverrideFile(param1:Uri) : void
      {
         var rawContent:String = null;
         var f:File = null;
         var fs:FileStream = null;
         var content:XML = null;
         var override:XML = null;
         var file:Uri = param1;
         if(file.fileType == "xml")
         {
            try
            {
               f = file.toFile();
               if(!f.exists)
               {
                  _log.fatal("Le fichier [" + file + "] utiliser lors de la surcharge du fichier i18n n\'existe pas");
                  return;
               }
               fs = new FileStream();
               fs.open(f,FileMode.READ);
               rawContent = fs.readUTFBytes(fs.bytesAvailable);
            }
            catch(e:Error)
            {
               _log.fatal("Impossible de lire le fichier " + file + " lors de la surcharge du fichier i18n : \n" + e.getStackTrace());
               return;
            }
            try
            {
               content = new XML(rawContent);
               for each(override in content..override)
               {
                  if(override.@type.toString() == "" || override.@type.toString() == "ui")
                  {
                     this._textIndexesOverride[override.@target.toString()] = override.toString();
                  }
                  else
                  {
                     GameData.addOverride(override.@type.toString(),override.@target.toString(),override.toString());
                  }
               }
            }
            catch(e:Error)
            {
               _log.fatal("Erreur lors de la lecture du fichier " + file + " pour la surcharge du fichier i18n : \n" + e.getStackTrace());
            }
            _log.debug("Override done !");
         }
         else
         {
            _log.error("Le fichier d\'override [" + file.fileName + "] n\'est pas un fichier xml.");
         }
      }
      
      public function getOrderIndex(param1:int) : int
      {
         return this._textSortIndex[param1];
      }
      
      public function getText(param1:int) : String
      {
         if(!this._indexes)
         {
            return null;
         }
         var _loc2_:int = this._indexes[param1];
         if(!_loc2_)
         {
            return null;
         }
         if(this._directBuffer == null)
         {
            this._stream.position = _loc2_;
            return this._stream.readUTF();
         }
         this._directBuffer.position = _loc2_;
         return this._directBuffer.readUTF();
      }
      
      public function getUnDiacriticalText(param1:int) : String
      {
         if(!this._unDiacriticalIndex)
         {
            return null;
         }
         var _loc2_:int = this._unDiacriticalIndex[param1];
         if(!_loc2_)
         {
            return null;
         }
         if(this._directBuffer == null)
         {
            this._stream.position = _loc2_;
            return this._stream.readUTF();
         }
         this._directBuffer.position = _loc2_;
         return this._directBuffer.readUTF();
      }
      
      public function hasText(param1:int) : Boolean
      {
         return this._indexes && this._indexes[param1];
      }
      
      public function getNamedText(param1:String) : String
      {
         if(!this._textIndexes)
         {
            return null;
         }
         if(this._textIndexesOverride[param1])
         {
            param1 = this._textIndexesOverride[param1];
         }
         var _loc2_:int = this._textIndexes[param1];
         if(!_loc2_)
         {
            return null;
         }
         this._stream.position = _loc2_;
         return this._stream.readUTF();
      }
      
      public function hasNamedText(param1:String) : Boolean
      {
         return this._textIndexes && this._textIndexes[param1];
      }
      
      public function useDirectBuffer(param1:Boolean) : void
      {
         if(this._directBuffer == null == param1)
         {
            return;
         }
         if(!param1)
         {
            this._directBuffer = null;
         }
         else
         {
            this._directBuffer = new ByteArray();
            this._stream.position = 0;
            this._stream.readBytes(this._directBuffer);
         }
      }
      
      public function close() : void
      {
         if(this._stream)
         {
            try
            {
               this._stream.close();
            }
            catch(e:Error)
            {
            }
            this._stream = null;
         }
         this._indexes = null;
         this._textIndexes = null;
         this._directBuffer = null;
      }
   }
}
