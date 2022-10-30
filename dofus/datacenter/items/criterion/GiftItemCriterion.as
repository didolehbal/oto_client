package com.ankamagames.dofus.datacenter.items.criterion
{
   import com.ankamagames.dofus.datacenter.alignments.AlignmentGift;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentRankJntGift;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.AlignmentFrame;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class GiftItemCriterion extends ItemCriterion implements IDataCenter
   {
       
      
      private var _aliGiftId:uint;
      
      private var _aliGiftLevel:int = -1;
      
      public function GiftItemCriterion(param1:String)
      {
         super(param1);
         var _loc2_:Array = String(_criterionValueText).split(",");
         if(_loc2_ && _loc2_.length > 0)
         {
            if(_loc2_.length <= 2)
            {
               this._aliGiftId = uint(_loc2_[0]);
               this._aliGiftLevel = int(_loc2_[1]);
            }
         }
         else
         {
            this._aliGiftId = uint(_criterionValue);
            this._aliGiftLevel = -1;
         }
      }
      
      override public function get isRespected() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = (Kernel.getWorker().getFrame(AlignmentFrame) as AlignmentFrame).playerRank;
         var _loc3_:AlignmentRankJntGift = AlignmentRankJntGift.getAlignmentRankJntGiftById(_loc2_);
         if(_loc3_ && _loc3_.gifts)
         {
            _loc1_ = 0;
            while(_loc1_ < _loc3_.gifts.length)
            {
               if(_loc3_.gifts[_loc1_] == this._aliGiftId)
               {
                  if(this._aliGiftLevel != 0)
                  {
                     if(_loc3_.levels[_loc1_] > this._aliGiftLevel)
                     {
                        return true;
                     }
                     return false;
                  }
                  return true;
               }
               _loc1_++;
            }
         }
         return false;
      }
      
      override public function get text() : String
      {
         var _loc1_:Array = null;
         if(_operator.text == ">")
         {
            _loc1_ = _criterionValueText.split(",");
            return I18n.getUiText("ui.pvp.giftRequired",[AlignmentGift.getAlignmentGiftById(this._aliGiftId).name + " > " + this._aliGiftLevel]);
         }
         return I18n.getUiText("ui.pvp.giftRequired",[AlignmentGift.getAlignmentGiftById(this._aliGiftId).name]);
      }
      
      override public function clone() : IItemCriterion
      {
         return new GiftItemCriterion(this.basicText);
      }
   }
}
