package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.AveragePricesFrame;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class AveragePricesApi implements IApi
   {
       
      
      protected var _log:Logger;
      
      private var _module:UiModule;
      
      public function AveragePricesApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(AveragePricesApi));
         super();
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._module = null;
      }
      
      [Trusted]
      public function getItemAveragePrice(param1:uint) : int
      {
         var _loc2_:int = 0;
         var _loc3_:AveragePricesFrame = null;
         if(this.dataAvailable())
         {
            _loc3_ = Kernel.getWorker().getFrame(AveragePricesFrame) as AveragePricesFrame;
            _loc2_ = _loc3_.pricesData.items["item" + param1];
         }
         return _loc2_;
      }
      
      [Trusted]
      public function getItemAveragePriceString(param1:*, param2:Boolean = false) : String
      {
         var _loc3_:int = 0;
         var _loc4_:* = false;
         var _loc5_:* = "";
         if(param1.exchangeable)
         {
            _loc3_ = this.getItemAveragePrice(param1.objectGID);
            _loc4_ = _loc3_ > 0;
            _loc5_ = _loc5_ + ((!!param2?"\n":"") + I18n.getUiText("ui.item.averageprice") + I18n.getUiText("ui.common.colon") + (!!_loc4_?StringUtils.kamasToString(_loc3_):I18n.getUiText("ui.item.averageprice.unavailable")));
            if(_loc4_ && param1.quantity > 1)
            {
               _loc5_ = _loc5_ + ("\n" + I18n.getUiText("ui.item.averageprice.stack") + I18n.getUiText("ui.common.colon") + StringUtils.kamasToString(_loc3_ * param1.quantity));
            }
         }
         return _loc5_;
      }
      
      [Trusted]
      public function dataAvailable() : Boolean
      {
         var _loc1_:AveragePricesFrame = Kernel.getWorker().getFrame(AveragePricesFrame) as AveragePricesFrame;
         return _loc1_.dataAvailable;
      }
   }
}
