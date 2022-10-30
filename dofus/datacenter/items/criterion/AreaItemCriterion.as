package com.ankamagames.dofus.datacenter.items.criterion
{
   import com.ankamagames.dofus.datacenter.world.Area;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class AreaItemCriterion extends ItemCriterion implements IDataCenter
   {
       
      
      public function AreaItemCriterion(param1:String)
      {
         super(param1);
      }
      
      override public function get isRespected() : Boolean
      {
         switch(_operator.text)
         {
            case ItemCriterionOperator.EQUAL:
            case ItemCriterionOperator.DIFFERENT:
               return super.isRespected;
            default:
               return false;
         }
      }
      
      override public function get text() : String
      {
         var _loc1_:String = null;
         var _loc2_:Area = Area.getAreaById(_criterionValue);
         if(!_loc2_)
         {
            return "error on AreaItemCriterion";
         }
         var _loc3_:String = _loc2_.name;
         switch(_operator.text)
         {
            case ItemCriterionOperator.EQUAL:
               _loc1_ = I18n.getUiText("ui.tooltip.beInArea",[_loc3_]);
               break;
            case ItemCriterionOperator.DIFFERENT:
               _loc1_ = I18n.getUiText("ui.tooltip.dontBeInArea",[_loc3_]);
         }
         return _loc1_;
      }
      
      override public function clone() : IItemCriterion
      {
         return new AreaItemCriterion(this.basicText);
      }
      
      override protected function getCriterion() : int
      {
         return PlayedCharacterManager.getInstance().currentSubArea.area.id;
      }
   }
}
