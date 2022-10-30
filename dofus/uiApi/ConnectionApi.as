package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.datacenter.servers.Server;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.connection.frames.ServerSelectionFrame;
   import com.ankamagames.dofus.logic.connection.managers.GuestModeManager;
   import com.ankamagames.dofus.logic.game.approach.frames.GameServerApproachFrame;
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.dofus.network.enums.ServerStatusEnum;
   import com.ankamagames.dofus.network.types.connection.GameServerInformations;
   
   [InstanciedApi]
   [Trusted]
   public class ConnectionApi implements IApi
   {
       
      
      public function ConnectionApi()
      {
         super();
      }
      
      private function get serverSelectionFrame() : ServerSelectionFrame
      {
         return Kernel.getWorker().getFrame(ServerSelectionFrame) as ServerSelectionFrame;
      }
      
      [Untrusted]
      public function getUsedServers() : Vector.<GameServerInformations>
      {
         return this.serverSelectionFrame.usedServers;
      }
      
      [Untrusted]
      public function getServers() : Vector.<GameServerInformations>
      {
         return this.serverSelectionFrame.servers;
      }
      
      [Untrusted]
      public function hasGuestAccount() : Boolean
      {
         return GuestModeManager.getInstance().hasGuestAccount();
      }
      
      [Untrusted]
      public function isCharacterWaitingForChange(param1:int) : Boolean
      {
         var _loc2_:GameServerApproachFrame = Kernel.getWorker().getFrame(GameServerApproachFrame) as GameServerApproachFrame;
         if(_loc2_)
         {
            return _loc2_.isCharacterWaitingForChange(param1);
         }
         return false;
      }
      
      [Untrusted]
      public function allowAutoConnectCharacter(param1:Boolean) : void
      {
         PlayerManager.getInstance().allowAutoConnectCharacter = param1;
         PlayerManager.getInstance().autoConnectOfASpecificCharacterId = -1;
      }
      
      [Untrusted]
      public function getAutoChosenServer(param1:int) : GameServerInformations
      {
         var _loc2_:Server = null;
         var _loc3_:GameServerInformations = null;
         var _loc4_:Object = null;
         var _loc5_:GameServerInformations = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:GameServerInformations = null;
         var _loc9_:Object = null;
         var _loc10_:Array = new Array();
         var _loc11_:Array = new Array();
         var _loc12_:int = PlayerManager.getInstance().communityId;
         for each(_loc3_ in this.serverSelectionFrame.servers)
         {
            _loc2_ = Server.getServerById(_loc3_.id);
            if(_loc4_ = Server.getServerById(_loc3_.id))
            {
               if((param1 != 0 || _loc4_.communityId == _loc12_ || (_loc12_ == 1 || _loc12_ == 2) && (_loc4_.communityId == 1 || _loc4_.communityId == 2)) && _loc2_.gameTypeId == param1)
               {
                  _loc11_.push(_loc3_);
               }
            }
         }
         if(_loc11_.length == 0)
         {
            for each(_loc5_ in this.serverSelectionFrame.servers)
            {
               if((_loc6_ = Server.getServerById(_loc5_.id)) && _loc6_.communityId == 2)
               {
                  _loc11_.push(_loc5_);
               }
            }
         }
         _loc11_.sortOn("completion",Array.NUMERIC);
         if(_loc11_.length > 0)
         {
            _loc7_ = -1;
            for each(_loc8_ in _loc11_)
            {
               if(BuildInfos.BUILD_TYPE == BuildTypeEnum.RELEASE && _loc8_.id == 36 && _loc8_.status == ServerStatusEnum.ONLINE)
               {
                  return _loc8_;
               }
               _loc9_ = Server.getServerById(_loc8_.id);
               if(_loc8_.status == ServerStatusEnum.ONLINE && _loc7_ == -1)
               {
                  _loc7_ = _loc8_.completion;
               }
               if(_loc7_ != -1 && _loc9_.population.id == _loc7_ && _loc8_.status == ServerStatusEnum.ONLINE)
               {
                  if(BuildInfos.BUILD_TYPE != BuildTypeEnum.RELEASE || _loc9_.name.indexOf("Test") == -1)
                  {
                     _loc10_.push(_loc8_);
                  }
               }
            }
            if(_loc10_.length > 0)
            {
               return _loc10_[Math.floor(Math.random() * _loc10_.length)];
            }
         }
         return null;
      }
   }
}
