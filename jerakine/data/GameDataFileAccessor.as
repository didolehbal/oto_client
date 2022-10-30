package com.ankamagames.jerakine.data
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.crypto.Signature;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.Dictionary;
   import flash.utils.Endian;
   import flash.utils.IDataInput;
   import flash.utils.getQualifiedClassName;
   
   public class GameDataFileAccessor
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(GameDataFileAccessor));
      
      private static var _self:GameDataFileAccessor;
       
      
      private var _streams:Dictionary;
      
      private var _streamStartIndex:Dictionary;
      
      private var _indexes:Dictionary;
      
      private var _classes:Dictionary;
      
      private var _counter:Dictionary;
      
      private var _gameDataProcessor:Dictionary;
      
      public function GameDataFileAccessor()
      {
         super();
         if(_self)
         {
            throw new SingletonError();
         }
      }
      
      public static function getInstance() : GameDataFileAccessor
      {
         if(!_self)
         {
            _self = new GameDataFileAccessor();
         }
         return _self;
      }
      
      public function init(param1:Uri) : void
      {
         var _loc2_:File = param1.toFile();
         if(!_loc2_ || !_loc2_.exists)
         {
            throw new Error("Game data file \'" + _loc2_ + "\' not readable.");
         }
         var _loc3_:String = param1.fileName.substr(0,param1.fileName.indexOf(".d2o"));
         if(!this._streams)
         {
            this._streams = new Dictionary();
         }
         if(!this._streamStartIndex)
         {
            this._streamStartIndex = new Dictionary();
         }
         var _loc4_:FileStream;
         if(!(_loc4_ = this._streams[_loc3_]))
         {
            (_loc4_ = new FileStream()).endian = Endian.BIG_ENDIAN;
            _loc4_.open(_loc2_,FileMode.READ);
            this._streams[_loc3_] = _loc4_;
            this._streamStartIndex[_loc3_] = 7;
         }
         else
         {
            _loc4_.position = 0;
         }
         this.initFromIDataInput(_loc4_,_loc3_);
      }
      
      public function initFromIDataInput(param1:IDataInput, param2:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc10_:uint = 0;
         var _loc14_:uint = 0;
         var _loc17_:uint = 0;
         if(!this._streams)
         {
            this._streams = new Dictionary();
         }
         if(!this._indexes)
         {
            this._indexes = new Dictionary();
         }
         if(!this._classes)
         {
            this._classes = new Dictionary();
         }
         if(!this._counter)
         {
            this._counter = new Dictionary();
         }
         if(!this._streamStartIndex)
         {
            this._streamStartIndex = new Dictionary();
         }
         if(!this._gameDataProcessor)
         {
            this._gameDataProcessor = new Dictionary();
         }
         this._streams[param2] = param1;
         if(!this._streamStartIndex[param2])
         {
            this._streamStartIndex[param2] = 7;
         }
         var _loc9_:Dictionary = new Dictionary();
         this._indexes[param2] = _loc9_;
         var _loc11_:String;
         if((_loc11_ = param1.readMultiByte(3,"ASCII")) != "D2O")
         {
            param1["position"] = 0;
            try
            {
               _loc11_ = param1.readUTF();
            }
            catch(e:Error)
            {
            }
            if(_loc11_ != Signature.ANKAMA_SIGNED_FILE_HEADER)
            {
               throw new Error("Malformated game data file.");
            }
            _loc7_ = param1.readShort();
            _loc8_ = param1.readInt();
            param1["position"] = param1["position"] + _loc8_;
            _loc10_ = param1["position"];
            this._streamStartIndex[param2] = _loc10_ + 7;
            if((_loc11_ = param1.readMultiByte(3,"ASCII")) != "D2O")
            {
               throw new Error("Malformated game data file.");
            }
         }
         var _loc12_:int = param1.readInt();
         param1["position"] = _loc10_ + _loc12_;
         var _loc13_:int = param1.readInt();
         while(_loc14_ < _loc13_)
         {
            _loc3_ = param1.readInt();
            _loc4_ = param1.readInt();
            _loc9_[_loc3_] = _loc10_ + _loc4_;
            _loc5_++;
            _loc14_ = _loc14_ + 8;
         }
         this._counter[param2] = _loc5_;
         var _loc15_:Dictionary = new Dictionary();
         this._classes[param2] = _loc15_;
         var _loc16_:int = param1.readInt();
         while(_loc17_ < _loc16_)
         {
            _loc6_ = param1.readInt();
            this.readClassDefinition(_loc6_,param1,_loc15_);
            _loc17_++;
         }
         if(param1.bytesAvailable)
         {
            this._gameDataProcessor[param2] = new GameDataProcess(param1);
         }
      }
      
      public function getDataProcessor(param1:String) : GameDataProcess
      {
         return this._gameDataProcessor[param1];
      }
      
      public function getClassDefinition(param1:String, param2:int) : GameDataClassDefinition
      {
         return this._classes[param1][param2];
      }
      
      public function getCount(param1:String) : uint
      {
         return this._counter[param1];
      }
      
      public function getObject(param1:String, param2:int) : *
      {
         if(!this._indexes || !this._indexes[param1])
         {
            return null;
         }
         var _loc3_:int = this._indexes[param1][param2];
         if(!_loc3_)
         {
            return null;
         }
         this._streams[param1].position = _loc3_;
         var _loc4_:int = this._streams[param1].readInt();
         return this._classes[param1][_loc4_].read(param1,this._streams[param1]);
      }
      
      public function getObjects(param1:String) : Array
      {
         var _loc6_:uint = 0;
         if(!this._counter || !this._counter[param1])
         {
            return null;
         }
         var _loc2_:uint = this._counter[param1];
         var _loc3_:Dictionary = this._classes[param1];
         var _loc4_:IDataInput;
         (_loc4_ = this._streams[param1])["position"] = this._streamStartIndex[param1];
         var _loc5_:Array = new Array(_loc2_);
         while(_loc6_ < _loc2_)
         {
            _loc5_[_loc6_] = _loc3_[_loc4_.readInt()].read(param1,_loc4_);
            _loc6_++;
         }
         return _loc5_;
      }
      
      public function close() : void
      {
         var _loc1_:IDataInput = null;
         for each(_loc1_ in this._streams)
         {
            try
            {
               if(_loc1_ is FileStream)
               {
                  FileStream(_loc1_).close();
               }
            }
            catch(e:Error)
            {
               continue;
            }
         }
         this._streams = null;
         this._indexes = null;
         this._classes = null;
      }
      
      private function readClassDefinition(param1:int, param2:IDataInput, param3:Dictionary) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc10_:uint = 0;
         var _loc6_:String = param2.readUTF();
         var _loc7_:String = param2.readUTF();
         var _loc8_:GameDataClassDefinition = new GameDataClassDefinition(_loc7_,_loc6_);
         var _loc9_:int = param2.readInt();
         while(_loc10_ < _loc9_)
         {
            _loc4_ = param2.readUTF();
            _loc8_.addField(_loc4_,param2);
            _loc10_++;
         }
         param3[param1] = _loc8_;
      }
   }
}
