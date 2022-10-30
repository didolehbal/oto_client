package com.ankamagames.berilia.managers
{
   import com.ankamagames.jerakine.interfaces.ISlotData;
   import com.ankamagames.jerakine.interfaces.ISlotDataHolder;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class SlotDataHolderManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SlotDataHolderManager));
       
      
      private var _weakHolderReference:Dictionary;
      
      private var _linkedSlotsData:Vector.<ISlotData>;
      
      public function SlotDataHolderManager(param1:ISlotData)
      {
         this._weakHolderReference = new Dictionary(true);
         super();
         this._linkedSlotsData = new Vector.<ISlotData>();
         this._linkedSlotsData.push(param1);
      }
      
      public function setLinkedSlotData(param1:ISlotData) : void
      {
         if(!this._linkedSlotsData)
         {
            this._linkedSlotsData = new Vector.<ISlotData>();
         }
         if(this._linkedSlotsData.indexOf(param1) == -1)
         {
            this._linkedSlotsData.push(param1);
         }
      }
      
      public function addHolder(param1:ISlotDataHolder) : void
      {
         this._weakHolderReference[param1] = true;
      }
      
      public function removeHolder(param1:ISlotDataHolder) : void
      {
         delete this._weakHolderReference[param1];
      }
      
      public function getHolders() : Array
      {
         var _loc1_:* = null;
         var _loc2_:Array = [];
         for(_loc1_ in this._weakHolderReference)
         {
            _loc2_.push(_loc1_);
         }
         return _loc2_;
      }
      
      public function refreshAll() : void
      {
         var _loc1_:* = null;
         var _loc2_:ISlotData = null;
         for(_loc1_ in this._weakHolderReference)
         {
            for each(_loc2_ in this._linkedSlotsData)
            {
               if(_loc1_ && ISlotDataHolder(_loc1_).data === _loc2_)
               {
                  _loc1_.refresh();
               }
            }
         }
      }
   }
}
