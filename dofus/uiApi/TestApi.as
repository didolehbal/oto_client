package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.profiler.showRedrawRegions;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   [Trusted]
   public class TestApi implements IApi
   {
       
      
      protected var _log:Logger;
      
      private var _module:UiModule;
      
      public function TestApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(DataApi));
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
      
      [Untrusted]
      public function getTestInventory(param1:uint) : Vector.<ItemWrapper>
      {
         var _loc2_:Item = null;
         var _loc4_:uint = 0;
         var _loc3_:Vector.<ItemWrapper> = new Vector.<ItemWrapper>();
         while(_loc4_ < param1)
         {
            _loc2_ = null;
            while(!_loc2_)
            {
               _loc2_ = Item.getItemById(Math.floor(Math.random() * 1000));
            }
            _loc3_.push(ItemWrapper.create(63,_loc4_,_loc2_.id,0,null));
            _loc4_++;
         }
         return _loc3_;
      }
      
      [Trusted]
      public function showTrace(param1:Boolean = true) : void
      {
         showRedrawRegions(param1,40349);
      }
   }
}
