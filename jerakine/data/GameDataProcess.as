package com.ankamagames.jerakine.data
{
   import com.ankamagames.jerakine.enum.GameDataTypeEnum;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.IDataInput;
   
   public class GameDataProcess
   {
       
      
      private var _searchFieldIndex:Dictionary;
      
      private var _searchFieldCount:Dictionary;
      
      private var _searchFieldType:Dictionary;
      
      private var _queryableField:Vector.<String>;
      
      private var _stream:IDataInput;
      
      private var _currentStream:IDataInput;
      
      private var _sortIndex:Dictionary;
      
      public function GameDataProcess(param1:IDataInput)
      {
         super();
         this._stream = param1;
         this._sortIndex = new Dictionary();
         this.parseStream();
      }
      
      public function getQueryableField() : Vector.<String>
      {
         return this._queryableField;
      }
      
      public function getFieldType(param1:String) : int
      {
         return this._searchFieldType[param1];
      }
      
      public function query(param1:String, param2:Function) : Vector.<uint>
      {
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc9_:uint = 0;
         var _loc5_:Vector.<uint> = new Vector.<uint>();
         if(!this._searchFieldIndex[param1])
         {
            return null;
         }
         var _loc6_:int = this._searchFieldType[param1];
         var _loc7_:Function = this.getReadFunction(_loc6_);
         var _loc8_:uint = this._searchFieldCount[param1];
         Object(this._stream).position = this._searchFieldIndex[param1];
         if(_loc7_ == null)
         {
            return null;
         }
         while(_loc9_++ < _loc8_)
         {
            if(param2(_loc7_()))
            {
               _loc3_ = this._stream.readInt() * 0.25;
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  _loc5_.push(this._stream.readInt());
                  _loc4_++;
               }
            }
            else
            {
               Object(this._stream).position = this._stream.readInt() + Object(this._stream).position;
            }
         }
         return _loc5_;
      }
      
      public function queryEquals(param1:String, param2:*) : Vector.<uint>
      {
         var _loc3_:* = undefined;
         var _loc4_:Number = NaN;
         var _loc5_:uint = 0;
         var _loc11_:uint = 0;
         var _loc13_:uint = 0;
         var _loc6_:Vector.<uint> = new Vector.<uint>();
         if(!this._searchFieldIndex[param1])
         {
            return null;
         }
         var _loc7_:*;
         if((_loc7_ = !(param2 is uint || param2 is int || param2 is Number || param2 is String || param2 is Boolean || param2 == null)) && param2.length == 0)
         {
            return _loc6_;
         }
         if(!_loc7_)
         {
            param2 = [param2];
         }
         var _loc8_:uint = this._searchFieldCount[param1];
         Object(this._stream).position = this._searchFieldIndex[param1];
         var _loc9_:int = this._searchFieldType[param1];
         var _loc10_:Function;
         if((_loc10_ = this.getReadFunction(_loc9_)) == null)
         {
            return null;
         }
         param2.sort(Array.NUMERIC);
         var _loc12_:* = param2[0];
         while(_loc13_++ < _loc8_)
         {
            _loc3_ = _loc10_();
            while(_loc3_ > _loc12_)
            {
               if(++_loc11_ == param2.length)
               {
                  return _loc6_;
               }
               _loc12_ = param2[_loc11_];
            }
            if(_loc3_ == _loc12_)
            {
               _loc4_ = this._stream.readInt() * 0.25;
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  _loc6_.push(this._stream.readInt());
                  _loc5_++;
               }
               if(++_loc11_ == param2.length)
               {
                  return _loc6_;
               }
               _loc12_ = param2[_loc11_];
            }
            else
            {
               Object(this._stream).position = this._stream.readInt() + Object(this._stream).position;
            }
         }
         return _loc6_;
      }
      
      public function sort(param1:*, param2:Vector.<uint>, param3:* = true) : Vector.<uint>
      {
         param2.sort(this.getSortFunction(param1,param3));
         return param2;
      }
      
      private function getSortFunction(param1:*, param2:*) : Function
      {
         var sortWay:Vector.<Number> = null;
         var indexes:Vector.<Dictionary> = null;
         var maxFieldIndex:uint = 0;
         var fieldName:String = null;
         var i:uint = 0;
         var fieldNames:* = param1;
         var ascending:* = param2;
         if(fieldNames is String)
         {
            fieldNames = [fieldNames];
         }
         if(ascending is Boolean)
         {
            ascending = [ascending];
         }
         sortWay = new Vector.<Number>();
         indexes = new Vector.<Dictionary>();
         while(i < fieldNames.length)
         {
            fieldName = fieldNames[i];
            if(this._searchFieldType[fieldName] == GameDataTypeEnum.I18N)
            {
               this.buildI18nSortIndex(fieldName);
            }
            else
            {
               this.buildSortIndex(fieldName);
            }
            if(ascending.length < fieldNames.length)
            {
               ascending.push(true);
            }
            sortWay.push(!!ascending[i]?1:-1);
            indexes.push(this._sortIndex[fieldName]);
            i++;
         }
         maxFieldIndex = fieldNames.length;
         return function(param1:uint, param2:uint):Number
         {
            var _loc3_:* = 0;
            while(_loc3_ < maxFieldIndex)
            {
               if(indexes[_loc3_][param1] < indexes[_loc3_][param2])
               {
                  return -sortWay[_loc3_];
               }
               if(indexes[_loc3_][param1] > indexes[_loc3_][param2])
               {
                  return sortWay[_loc3_];
               }
               _loc3_++;
            }
            return 0;
         };
      }
      
      private function buildSortIndex(param1:String) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         if(this._sortIndex[param1] || !this._searchFieldIndex[param1])
         {
            return;
         }
         var _loc5_:Vector.<uint> = new Vector.<uint>();
         var _loc6_:uint = this._searchFieldCount[param1];
         Object(this._stream).position = this._searchFieldIndex[param1];
         var _loc7_:Dictionary = new Dictionary();
         this._sortIndex[param1] = _loc7_;
         var _loc8_:int = this._searchFieldType[param1];
         var _loc9_:Function;
         if((_loc9_ = this.getReadFunction(_loc8_)) == null)
         {
            return;
         }
         while(_loc12_++ < _loc6_)
         {
            _loc2_ = _loc9_();
            _loc3_ = this._stream.readInt() * 0.25;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc7_[this._stream.readInt()] = _loc2_;
               _loc4_++;
            }
         }
      }
      
      private function buildI18nSortIndex(param1:String) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc9_:uint = 0;
         if(this._sortIndex[param1] || !this._searchFieldIndex[param1])
         {
            return;
         }
         var _loc6_:Vector.<uint> = new Vector.<uint>();
         var _loc7_:uint = this._searchFieldCount[param1];
         Object(this._stream).position = this._searchFieldIndex[param1];
         var _loc8_:Dictionary = new Dictionary();
         this._sortIndex[param1] = _loc8_;
         while(_loc9_++ < _loc7_)
         {
            _loc2_ = this._stream.readInt();
            _loc3_ = this._stream.readInt() * 0.25;
            if(_loc3_)
            {
               _loc4_ = I18nFileAccessor.getInstance().getOrderIndex(_loc2_);
               _loc5_ = 0;
               while(_loc5_ < _loc3_)
               {
                  _loc8_[this._stream.readInt()] = _loc4_;
                  _loc5_++;
               }
            }
         }
      }
      
      private function readI18n() : String
      {
         return I18nFileAccessor.getInstance().getUnDiacriticalText(this._currentStream.readInt());
      }
      
      private function getReadFunction(param1:int) : Function
      {
         var _loc2_:Function = null;
         var _loc3_:ByteArray = null;
         switch(param1)
         {
            case GameDataTypeEnum.INT:
               _loc2_ = this._stream.readInt;
               break;
            case GameDataTypeEnum.BOOLEAN:
               _loc2_ = this._stream.readBoolean;
               break;
            case GameDataTypeEnum.STRING:
               _loc2_ = this._stream.readUTF;
               break;
            case GameDataTypeEnum.NUMBER:
               _loc2_ = this._stream.readDouble;
               break;
            case GameDataTypeEnum.I18N:
               I18nFileAccessor.getInstance().useDirectBuffer(true);
               _loc2_ = this.readI18n;
               if(!(this._stream is ByteArray))
               {
                  _loc3_ = new ByteArray();
                  Object(this._stream).position = 0;
                  this._stream.readBytes(_loc3_);
                  _loc3_.position = 0;
                  this._stream = _loc3_;
                  this._currentStream = this._stream;
               }
               break;
            case GameDataTypeEnum.UINT:
               _loc2_ = this._stream.readUnsignedInt;
         }
         return _loc2_;
      }
      
      private function parseStream() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:String = null;
         this._queryableField = new Vector.<String>();
         this._searchFieldIndex = new Dictionary();
         this._searchFieldType = new Dictionary();
         this._searchFieldCount = new Dictionary();
         var _loc3_:int = this._stream.readInt();
         var _loc4_:uint = Object(this._stream).position + _loc3_ + 4;
         while(_loc3_)
         {
            _loc1_ = this._stream.bytesAvailable;
            _loc2_ = this._stream.readUTF();
            this._queryableField.push(_loc2_);
            this._searchFieldIndex[_loc2_] = this._stream.readInt() + _loc4_;
            this._searchFieldType[_loc2_] = this._stream.readInt();
            this._searchFieldCount[_loc2_] = this._stream.readInt();
            _loc3_ = _loc3_ - (_loc1_ - this._stream.bytesAvailable);
         }
      }
   }
}
