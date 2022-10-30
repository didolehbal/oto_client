package com.ankamagames.dofus.logic.game.roleplay.actions.preset
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class InventoryPresetSaveCustomAction implements Action
   {
       
      
      public var presetId:uint;
      
      public var symbolId:uint;
      
      public var itemsUids:Vector.<uint>;
      
      public var itemsPositions:Vector.<uint>;
      
      public function InventoryPresetSaveCustomAction()
      {
         this.itemsUids = new Vector.<uint>();
         this.itemsPositions = new Vector.<uint>();
         super();
      }
      
      public static function create(param1:uint, param2:uint, param3:Vector.<uint>, param4:Vector.<uint>) : InventoryPresetSaveCustomAction
      {
         var _loc5_:InventoryPresetSaveCustomAction;
         (_loc5_ = new InventoryPresetSaveCustomAction()).presetId = param1;
         _loc5_.symbolId = param2;
         _loc5_.itemsUids = param3;
         _loc5_.itemsPositions = param4;
         return _loc5_;
      }
   }
}
