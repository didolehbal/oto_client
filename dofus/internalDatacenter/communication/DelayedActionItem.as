package com.ankamagames.dofus.internalDatacenter.communication
{
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class DelayedActionItem implements IDataCenter
   {
       
      
      public var playerId:uint;
      
      public var type:uint;
      
      public var dataId:int;
      
      public var endTime:Number;
      
      public function DelayedActionItem(param1:uint, param2:uint, param3:int, param4:Number)
      {
         super();
         this.playerId = param1;
         this.type = param2;
         this.dataId = param3;
         this.endTime = param4;
      }
   }
}
