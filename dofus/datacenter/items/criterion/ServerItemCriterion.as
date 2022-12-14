package com.ankamagames.dofus.datacenter.items.criterion
{
   import com.ankamagames.dofus.datacenter.servers.Server;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class ServerItemCriterion extends ItemCriterion implements IDataCenter
   {
       
      
      public function ServerItemCriterion(param1:String)
      {
         super(param1);
      }
      
      override public function get text() : String
      {
         var _loc1_:String = Server.getServerById(_criterionValue).name;
         var _loc2_:String = I18n.getUiText("ui.header.server");
         return _loc2_ + " " + _operator.text + " " + _loc1_;
      }
      
      override public function clone() : IItemCriterion
      {
         return new ServerItemCriterion(this.basicText);
      }
      
      override protected function getCriterion() : int
      {
         return PlayerManager.getInstance().server.id;
      }
   }
}
