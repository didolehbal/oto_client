package com.ankamagames.dofus.datacenter.items.criterion
{
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class SpellItemCriterion extends ItemCriterion implements IDataCenter
   {
       
      
      private var _spellId:uint;
      
      public function SpellItemCriterion(param1:String)
      {
         super(param1);
         var _loc2_:Array = String(_criterionValueText).split(",");
         if(_loc2_ && _loc2_.length > 0)
         {
            if(_loc2_.length <= 1)
            {
               this._spellId = uint(_loc2_[0]);
            }
         }
         else
         {
            this._spellId = uint(_criterionValue);
         }
      }
      
      override public function get isRespected() : Boolean
      {
         var _loc1_:SpellWrapper = null;
         for each(_loc1_ in PlayedCharacterManager.getInstance().playerSpellList)
         {
            if(_loc1_.id == this._spellId)
            {
               if(_operator.text == ItemCriterionOperator.EQUAL)
               {
                  return true;
               }
               return false;
            }
         }
         if(_operator.text == ItemCriterionOperator.DIFFERENT)
         {
            return true;
         }
         return false;
      }
      
      override public function get text() : String
      {
         var _loc1_:* = "";
         var _loc2_:* = "";
         var _loc3_:Spell = Spell.getSpellById(this._spellId);
         if(!_loc3_)
         {
            return _loc2_;
         }
         var _loc4_:String = _loc3_.name;
         switch(_operator.text)
         {
            case ItemCriterionOperator.EQUAL:
               _loc2_ = I18n.getUiText("ui.criterion.gotSpell",[_loc4_]);
               break;
            case ItemCriterionOperator.DIFFERENT:
               _loc2_ = I18n.getUiText("ui.criterion.doesntGotSpell",[_loc4_]);
         }
         return _loc2_;
      }
      
      override public function clone() : IItemCriterion
      {
         return new SpellItemCriterion(this.basicText);
      }
   }
}
