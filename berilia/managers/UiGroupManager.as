package com.ankamagames.berilia.managers
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.types.data.UiGroup;
   import com.ankamagames.berilia.types.event.UiRenderAskEvent;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.utils.getQualifiedClassName;
   
   public class UiGroupManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(UiGroupManager));
      
      private static var _self:UiGroupManager;
       
      
      private var _registeredGroup:Array;
      
      private var _uis:Array;
      
      public function UiGroupManager()
      {
         this._registeredGroup = new Array();
         this._uis = new Array();
         super();
         if(_self)
         {
            throw new SingletonError();
         }
         Berilia.getInstance().addEventListener(UiRenderAskEvent.UI_RENDER_ASK,this.onUiRenderAsk);
      }
      
      public static function getInstance() : UiGroupManager
      {
         if(!_self)
         {
            _self = new UiGroupManager();
         }
         return _self;
      }
      
      public function registerGroup(param1:UiGroup) : void
      {
         this._registeredGroup[param1.name] = param1;
      }
      
      public function removeGroup(param1:String) : void
      {
         delete this._registeredGroup[param1];
      }
      
      public function getGroup(param1:String) : UiGroup
      {
         return this._registeredGroup[param1];
      }
      
      public function destroy() : void
      {
         Berilia.getInstance().removeEventListener(UiRenderAskEvent.UI_RENDER_ASK,this.onUiRenderAsk);
         _self = null;
      }
      
      private function onUiRenderAsk(param1:UiRenderAskEvent) : void
      {
         var _loc2_:UiGroup = null;
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         if(!param1.uiData)
         {
            _log.error("No data for this UI.");
            return;
         }
         if(!param1.uiData.uiGroupName || !this._registeredGroup[param1.uiData.uiGroupName])
         {
            return;
         }
         if(!this._uis[param1.uiData.uiGroupName])
         {
            this._uis[param1.uiData.uiGroupName] = new Array();
         }
         var _loc7_:UiGroup;
         if(!(_loc7_ = this.getGroup(param1.uiData.uiGroupName)))
         {
            return;
         }
         for each(_loc2_ in this._registeredGroup)
         {
            if(_loc7_.exclusive && !_loc2_.permanent && _loc2_.name != _loc7_.name)
            {
               if(this._uis[_loc2_.name] != null)
               {
                  _loc3_ = this._registeredGroup[_loc2_.name].uis;
                  for each(_loc4_ in _loc3_)
                  {
                     _loc5_ = true;
                     for each(_loc6_ in _loc7_.uis)
                     {
                        if(_loc4_ == _loc6_)
                        {
                           _loc5_ = false;
                        }
                     }
                     if(_loc5_ && _loc6_ != null)
                     {
                        Berilia.getInstance().unloadUi(_loc4_);
                     }
                     delete this._uis[_loc2_.name][_loc4_];
                  }
               }
            }
         }
         this._uis[param1.uiData.uiGroupName][param1.name] = param1.uiData;
      }
   }
}
