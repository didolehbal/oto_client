package com.ankamagames.dofus.datacenter.items.criterion
{
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayCharacterInformations;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import flash.utils.Dictionary;
   
   public class MapCharactersItemCriterion extends ItemCriterion implements IDataCenter
   {
       
      
      private var _mapId:int;
      
      private var _nbCharacters:uint;
      
      public function MapCharactersItemCriterion(param1:String)
      {
         super(param1);
         var _loc2_:Array = _criterionValueText.split(",");
         if(_loc2_.length == 1)
         {
            this._mapId = PlayedCharacterManager.getInstance().currentMap.mapId;
            this._nbCharacters = uint(_loc2_[0]);
         }
         else if(_loc2_.length == 2)
         {
            this._mapId = int(_loc2_[0]);
            this._nbCharacters = uint(_loc2_[1]);
         }
      }
      
      override public function get text() : String
      {
         var _loc1_:String = I18n.getUiText("ui.criterion.MK",[this._mapId]);
         return _loc1_ + " " + _operator.text + " " + this._nbCharacters;
      }
      
      override public function clone() : IItemCriterion
      {
         return new MapCharactersItemCriterion(this.basicText);
      }
      
      override protected function getCriterion() : int
      {
         var _loc1_:int = 0;
         var _loc2_:Dictionary = null;
         var _loc3_:GameContextActorInformations = null;
         var _loc4_:RoleplayEntitiesFrame;
         if(_loc4_ = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame)
         {
            _loc2_ = _loc4_.getEntitiesDictionnary();
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_ is GameRolePlayCharacterInformations)
               {
                  _loc1_++;
               }
            }
         }
         return _loc1_;
      }
   }
}
