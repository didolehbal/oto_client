package com.ankamagames.jerakine.managers
{
   import by.blooddy.crypto.MD5;
   import com.ankamagames.jerakine.JerakineConstants;
   import com.ankamagames.jerakine.interfaces.Secure;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.CustomSharedObject;
   import com.ankamagames.jerakine.types.DataStoreType;
   import com.ankamagames.jerakine.types.enums.DataStoreEnum;
   import com.ankamagames.jerakine.types.events.RegisterClassLogEvent;
   import com.ankamagames.jerakine.utils.crypto.Base64;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   import flash.net.ObjectEncoding;
   import flash.net.registerClassAlias;
   import flash.utils.Dictionary;
   import flash.utils.IExternalizable;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class StoreDataManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(StoreDataManager));
      
      private static var _self:StoreDataManager;
       
      
      private var _aData:Array;
      
      private var _bStoreSequence:Boolean;
      
      private var _nCurrentSequenceNum:uint = 0;
      
      private var _aStoreSequence:Array;
      
      private var _aSharedObjectCache:Array;
      
      private var _aRegisteredClassAlias:Dictionary;
      
      private var _describeType:Function;
      
      public function StoreDataManager()
      {
         var oClass:Class = null;
         var className:String = null;
         var s:String = null;
         this._describeType = DescribeTypeCache.typeDescription;
         super();
         if(_self != null)
         {
            throw new SingletonError("DataManager is a singleton and should not be instanciated directly.");
         }
         this._bStoreSequence = false;
         this._aData = new Array();
         this._aSharedObjectCache = new Array();
         this._aRegisteredClassAlias = new Dictionary();
         var aClass:Array = this.getData(JerakineConstants.DATASTORE_CLASS_ALIAS,"classAliasList");
         var nonVectorClass:Array = [];
         var vectorClass:Array = [];
         for(s in aClass)
         {
            className = Base64.decode(s);
            _log.logDirectly(new RegisterClassLogEvent(className));
            try
            {
               oClass = Class(getDefinitionByName(className));
               registerClassAlias(aClass[s],oClass);
            }
            catch(e:ReferenceError)
            {
               _log.warn("Impossible de trouver la classe " + className);
            }
            this._aRegisteredClassAlias[className] = true;
         }
      }
      
      public static function getInstance() : StoreDataManager
      {
         if(_self == null)
         {
            _self = new StoreDataManager();
         }
         return _self;
      }
      
      public function getData(param1:DataStoreType, param2:String) : *
      {
         var _loc3_:CustomSharedObject = null;
         if(param1.persistant)
         {
            switch(param1.location)
            {
               case DataStoreEnum.LOCATION_LOCAL:
                  _loc3_ = this.getSharedObject(param1.category);
                  return _loc3_.data[param2];
               case DataStoreEnum.LOCATION_SERVER:
            }
            return;
         }
         if(this._aData[param1.category] != null)
         {
            return this._aData[param1.category][param2];
         }
         return null;
      }
      
      public function registerClass(param1:*, param2:Boolean = false, param3:Boolean = true) : void
      {
         var className:String = null;
         var sAlias:String = null;
         var aClassAlias:Array = null;
         var desc:Object = null;
         var key:String = null;
         var tmp:String = null;
         var leftBracePos:int = 0;
         var oInstance:* = param1;
         var deepClassScan:Boolean = param2;
         var keepClassInSo:Boolean = param3;
         if(oInstance is IExternalizable)
         {
            throw new ArgumentError("Can\'t store a customized IExternalizable in a shared object.");
         }
         if(oInstance is Secure)
         {
            throw new ArgumentError("Can\'t store a Secure class");
         }
         if(this.isComplexType(oInstance))
         {
            className = getQualifiedClassName(oInstance);
            if(this._aRegisteredClassAlias[className] != null)
            {
               return;
            }
            sAlias = MD5.hash(className);
            _log.logDirectly(new RegisterClassLogEvent(className));
            try
            {
               registerClassAlias(sAlias,Class(getDefinitionByName(className)));
               _log.warn("Register " + className);
            }
            catch(e:Error)
            {
               _aRegisteredClassAlias[className] = true;
               _log.fatal("Impossible de trouver la classe " + className + " dans l\'application domain courant");
               return;
            }
            if(keepClassInSo)
            {
               aClassAlias = this.getSetData(JerakineConstants.DATASTORE_CLASS_ALIAS,"classAliasList",new Array());
               aClassAlias[Base64.encode(className)] = sAlias;
               this.setData(JerakineConstants.DATASTORE_CLASS_ALIAS,"classAliasList",aClassAlias);
            }
            this._aRegisteredClassAlias[className] = true;
         }
         if(deepClassScan)
         {
            if(oInstance is Dictionary || oInstance is Array || oInstance is Vector.<*> || oInstance is Vector.<uint>)
            {
               desc = oInstance;
               if(oInstance is Vector.<*>)
               {
                  tmp = getQualifiedClassName(oInstance);
                  leftBracePos = tmp.indexOf("<");
                  tmp = tmp.substr(leftBracePos + 1,tmp.lastIndexOf(">") - leftBracePos - 1);
                  this.registerClass(new (getDefinitionByName(tmp) as Class)(),true,keepClassInSo);
               }
            }
            else
            {
               desc = this.scanType(oInstance);
            }
            for(key in desc)
            {
               if(this.isComplexType(oInstance[key]))
               {
                  this.registerClass(oInstance[key],true);
               }
               if(desc === oInstance)
               {
                  break;
               }
            }
         }
      }
      
      public function getClass(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:XML = this._describeType(param1);
         this.registerClass(param1);
         for(_loc2_ in _loc3_..accessor)
         {
            if(this.isComplexType(_loc2_))
            {
               this.getClass(_loc2_);
            }
         }
      }
      
      public function setData(param1:DataStoreType, param2:String, param3:*, param4:Boolean = false) : Boolean
      {
         var _loc5_:CustomSharedObject = null;
         if(this._aData[param1.category] == null)
         {
            this._aData[param1.category] = new Dictionary(true);
         }
         this._aData[param1.category][param2] = param3;
         if(param1.persistant)
         {
            switch(param1.location)
            {
               case DataStoreEnum.LOCATION_LOCAL:
                  this.registerClass(param3,param4);
                  (_loc5_ = this.getSharedObject(param1.category)).data[param2] = param3;
                  if(!this._bStoreSequence)
                  {
                     if(!_loc5_.flush())
                     {
                        return false;
                     }
                  }
                  else
                  {
                     this._aStoreSequence[param1.category] = param1;
                  }
                  return true;
               case DataStoreEnum.LOCATION_SERVER:
                  return false;
            }
         }
         return true;
      }
      
      public function getSetData(param1:DataStoreType, param2:String, param3:*) : *
      {
         var _loc4_:*;
         if((_loc4_ = this.getData(param1,param2)) != null)
         {
            return _loc4_;
         }
         this.setData(param1,param2,param3);
         return param3;
      }
      
      public function startStoreSequence() : void
      {
         this._bStoreSequence = true;
         if(!this._nCurrentSequenceNum)
         {
            this._aStoreSequence = new Array();
         }
         ++this._nCurrentSequenceNum;
      }
      
      public function stopStoreSequence() : void
      {
         var _loc1_:DataStoreType = null;
         var _loc2_:* = null;
         this._bStoreSequence = --this._nCurrentSequenceNum != 0;
         if(this._bStoreSequence)
         {
            return;
         }
         for(_loc2_ in this._aStoreSequence)
         {
            _loc1_ = this._aStoreSequence[_loc2_];
            switch(_loc1_.location)
            {
               case DataStoreEnum.LOCATION_LOCAL:
                  this.getSharedObject(_loc1_.category).flush();
                  continue;
               case DataStoreEnum.LOCATION_SERVER:
                  continue;
               default:
                  continue;
            }
         }
         this._aStoreSequence = null;
      }
      
      public function clear(param1:DataStoreType) : void
      {
         this._aData = new Array();
         var _loc2_:CustomSharedObject = this.getSharedObject(param1.category);
         _loc2_.clear();
         _loc2_.flush();
      }
      
      public function reset() : void
      {
         var _loc1_:CustomSharedObject = null;
         for each(_loc1_ in this._aSharedObjectCache)
         {
            _loc1_.clear();
            try
            {
               _loc1_.flush();
               _loc1_.close();
            }
            catch(e:Error)
            {
            }
         }
         this._aSharedObjectCache = [];
         _self = null;
      }
      
      public function close(param1:DataStoreType) : void
      {
         switch(param1.location)
         {
            case DataStoreEnum.LOCATION_LOCAL:
               this._aSharedObjectCache[param1.category].close();
               delete this._aSharedObjectCache[param1.category];
               return;
            default:
               return;
         }
      }
      
      private function getSharedObject(param1:String) : CustomSharedObject
      {
         if(this._aSharedObjectCache[param1] != null)
         {
            return this._aSharedObjectCache[param1];
         }
         var _loc2_:CustomSharedObject = CustomSharedObject.getLocal(param1);
         _loc2_.objectEncoding = ObjectEncoding.AMF3;
         this._aSharedObjectCache[param1] = _loc2_;
         return _loc2_;
      }
      
      private function isComplexType(param1:*) : Boolean
      {
         switch(true)
         {
            case param1 is int:
            case param1 is uint:
            case param1 is Number:
            case param1 is Boolean:
            case param1 is Array:
            case param1 is String:
            case param1 == null:
            case param1 == undefined:
               return false;
            default:
               return true;
         }
      }
      
      private function isComplexTypeFromString(param1:String) : Boolean
      {
         var _loc2_:* = undefined;
         switch(param1)
         {
            case "int":
            case "uint":
            case "Number":
            case "Boolean":
            case "Array":
            case "String":
               return false;
            default:
               _loc2_ = this._aRegisteredClassAlias[param1];
               if(this._aRegisteredClassAlias[param1] === true)
               {
                  return false;
               }
               return true;
         }
      }
      
      private function scanType(param1:*) : Object
      {
         var _loc2_:XML = null;
         var _loc3_:XML = null;
         var _loc4_:Object = new Object();
         var _loc5_:XML = this._describeType(param1);
         for each(_loc2_ in _loc5_..accessor)
         {
            if(this.isComplexTypeFromString(_loc2_.@type))
            {
               _loc4_[_loc2_.@name] = true;
            }
         }
         for each(_loc3_ in _loc5_..variable)
         {
            if(this.isComplexTypeFromString(_loc3_.@type))
            {
               _loc4_[_loc3_.@name] = true;
            }
         }
         return _loc4_;
      }
   }
}
