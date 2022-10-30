package com.ankamagames.atouin.managers
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IInteractive;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.enums.InteractionsEnum;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.getQualifiedClassName;
   
   public class EntitiesManager
   {
      
      private static const RANDOM_ENTITIES_ID_START:uint = 1000000;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(EntitiesManager));
      
      private static var _self:EntitiesManager;
       
      
      private var _entities:Array;
      
      private var _currentRandomEntity:uint = 1000000;
      
      public function EntitiesManager()
      {
         super();
         if(_self)
         {
            throw new SingletonError("Warning : MobilesManager is a singleton class and shoulnd\'t be instancied directly!");
         }
         this._entities = new Array();
         Atouin.getInstance().options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
      }
      
      public static function getInstance() : EntitiesManager
      {
         if(!_self)
         {
            _self = new EntitiesManager();
         }
         return _self;
      }
      
      public function initManager() : void
      {
         Atouin.getInstance().options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
      }
      
      public function addAnimatedEntity(param1:int, param2:IEntity, param3:uint) : void
      {
         if(this._entities[param1] != null)
         {
            _log.warn("Entity overwriting! Entity " + param1 + " has been replaced.");
         }
         this._entities[param1] = param2;
         if(param2 is IDisplayable)
         {
            EntitiesDisplayManager.getInstance().displayEntity(param2 as IDisplayable,param2.position,param3);
         }
         if(param2 is IInteractive)
         {
            this.registerInteractions(IInteractive(param2),true);
            Sprite(param2).buttonMode = IInteractive(param2).useHandCursor;
         }
      }
      
      public function getEntity(param1:int) : IEntity
      {
         return this._entities[param1];
      }
      
      public function getEntityID(param1:IEntity) : int
      {
         var _loc2_:* = null;
         for(_loc2_ in this._entities)
         {
            if(param1 === this._entities[_loc2_])
            {
               return parseInt(_loc2_);
            }
         }
         return 0;
      }
      
      public function removeEntity(param1:int) : void
      {
         if(this._entities[param1])
         {
            if(this._entities[param1] is IDisplayable)
            {
               EntitiesDisplayManager.getInstance().removeEntity(this._entities[param1] as IDisplayable);
            }
            if(this._entities[param1] is IInteractive)
            {
               this.registerInteractions(IInteractive(this._entities[param1]),false);
            }
            if(this._entities[param1] is IMovable && IMovable(this._entities[param1]).isMoving)
            {
               IMovable(this._entities[param1]).stop(true);
            }
            delete this._entities[param1];
         }
      }
      
      public function clearEntities() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TiphonSprite = null;
         var _loc6_:Array = new Array();
         for(_loc1_ in this._entities)
         {
            _loc6_.push(_loc1_);
         }
         _loc2_ = -1;
         _loc3_ = _loc6_.length;
         while(++_loc2_ < _loc3_)
         {
            _loc4_ = _loc6_[_loc2_];
            _loc5_ = this._entities[_loc4_] as TiphonSprite;
            this.removeEntity(_loc4_);
            if(_loc5_)
            {
               _loc5_.destroy();
            }
         }
         this._entities = new Array();
      }
      
      public function setEntitiesVisibility(param1:Boolean) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TiphonSprite = null;
         var _loc7_:Array = new Array();
         for(_loc2_ in this._entities)
         {
            _loc7_.push(_loc2_);
         }
         _loc3_ = -1;
         _loc4_ = _loc7_.length;
         while(++_loc3_ < _loc4_)
         {
            _loc5_ = _loc7_[_loc3_];
            (_loc6_ = this._entities[_loc5_] as TiphonSprite).visible = param1;
         }
      }
      
      public function get entities() : Array
      {
         return this._entities;
      }
      
      public function get entitiesCount() : int
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         for each(_loc1_ in this._entities)
         {
            _loc2_++;
         }
         return _loc2_;
      }
      
      public function getFreeEntityId() : int
      {
         while(this._entities[++this._currentRandomEntity] != null)
         {
            ++this._currentRandomEntity;
         }
         return this._currentRandomEntity;
      }
      
      private function registerInteractions(param1:IInteractive, param2:Boolean) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = param1.enabledInteractions;
         while(_loc4_ > 0)
         {
            this.registerInteraction(param1,1 << _loc3_++,param2);
            _loc4_ = _loc4_ >> 1;
         }
      }
      
      public function registerInteraction(param1:IInteractive, param2:uint, param3:Boolean) : void
      {
         var _loc4_:String = null;
         var _loc5_:Array = InteractionsEnum.getEvents(param2);
         for each(_loc4_ in _loc5_)
         {
            if(param3 && !param1.hasEventListener(_loc4_))
            {
               param1.addEventListener(_loc4_,this.onInteraction,false,0,true);
            }
            else if(!param3 && param1.hasEventListener(_loc4_))
            {
               param1.removeEventListener(_loc4_,this.onInteraction,false);
            }
         }
      }
      
      public function getEntityOnCell(param1:uint, param2:* = null) : IEntity
      {
         var _loc3_:IEntity = null;
         var _loc4_:uint = 0;
         var _loc5_:*;
         var _loc6_:Boolean = (_loc5_ = param2 != null) && param2 is Array;
         for each(_loc3_ in this._entities)
         {
            if(_loc3_ && _loc3_.position && _loc3_.position.cellId == param1)
            {
               if(!_loc6_)
               {
                  if(!_loc5_ || !_loc6_ && _loc3_ is param2)
                  {
                     return _loc3_;
                  }
               }
               else
               {
                  _loc4_ = 0;
                  while(_loc4_ < (param2 as Array).length)
                  {
                     if(_loc3_ is param2[_loc4_])
                     {
                        return _loc3_;
                     }
                     _loc4_++;
                  }
               }
            }
         }
         return null;
      }
      
      public function getEntitiesOnCell(param1:uint, param2:* = null) : Array
      {
         var _loc3_:IEntity = null;
         var _loc4_:uint = 0;
         var _loc5_:*;
         var _loc6_:Boolean = (_loc5_ = param2 != null) && param2 is Array;
         var _loc7_:Array = [];
         for each(_loc3_ in this._entities)
         {
            if(_loc3_ && _loc3_.position && _loc3_.position.cellId == param1)
            {
               if(!_loc6_)
               {
                  if(!_loc5_ || !_loc6_ && _loc3_ is param2)
                  {
                     _loc7_.push(_loc3_);
                  }
               }
               else
               {
                  _loc4_ = 0;
                  while(_loc4_ < (param2 as Array).length)
                  {
                     if(_loc3_ is param2[_loc4_])
                     {
                        _loc7_.push(_loc3_);
                     }
                     _loc4_++;
                  }
               }
            }
         }
         return _loc7_;
      }
      
      private function onInteraction(param1:Event) : void
      {
         var _loc2_:IInteractive = IInteractive(param1.target);
         var _loc3_:Class = InteractionsEnum.getMessage(param1.type);
         _loc2_.handler.process(new _loc3_(_loc2_));
      }
      
      private function onPropertyChanged(param1:PropertyChangeEvent) : void
      {
         var _loc2_:IEntity = null;
         if(param1.propertyName == "transparentOverlayMode")
         {
            for each(_loc2_ in this._entities)
            {
               if(_loc2_ is IDisplayable)
               {
                  EntitiesDisplayManager.getInstance().refreshAlphaEntity(_loc2_ as IDisplayable,_loc2_.position);
               }
            }
         }
      }
   }
}
