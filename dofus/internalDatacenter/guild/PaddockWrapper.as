package com.ankamagames.dofus.internalDatacenter.guild
{
   import com.ankamagames.dofus.network.types.game.paddock.PaddockAbandonnedInformations;
   import com.ankamagames.dofus.network.types.game.paddock.PaddockBuyableInformations;
   import com.ankamagames.dofus.network.types.game.paddock.PaddockInformations;
   import com.ankamagames.dofus.network.types.game.paddock.PaddockPrivateInformations;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class PaddockWrapper implements IDataCenter
   {
       
      
      public var maxOutdoorMount:uint;
      
      public var maxItems:uint;
      
      public var price:uint = 0;
      
      public var guildId:int = 0;
      
      public var guildIdentity:GuildWrapper;
      
      public var isSaleLocked:Boolean;
      
      public var isAbandonned:Boolean;
      
      public function PaddockWrapper()
      {
         super();
      }
      
      public static function create(param1:PaddockInformations) : PaddockWrapper
      {
         var _loc2_:PaddockBuyableInformations = null;
         var _loc3_:PaddockAbandonnedInformations = null;
         var _loc4_:PaddockPrivateInformations = null;
         var _loc5_:PaddockWrapper;
         (_loc5_ = new PaddockWrapper()).maxOutdoorMount = param1.maxOutdoorMount;
         _loc5_.maxItems = param1.maxItems;
         if(param1 is PaddockBuyableInformations)
         {
            _loc2_ = param1 as PaddockBuyableInformations;
            _loc5_.price = _loc2_.price;
            _loc5_.isSaleLocked = _loc2_.locked;
         }
         if(param1 is PaddockAbandonnedInformations)
         {
            _loc3_ = param1 as PaddockAbandonnedInformations;
            _loc5_.guildId = _loc3_.guildId;
            _loc5_.isAbandonned = true;
         }
         if(param1 is PaddockPrivateInformations)
         {
            _loc4_ = param1 as PaddockPrivateInformations;
            _loc5_.guildIdentity = GuildWrapper.create(_loc4_.guildInfo.guildId,_loc4_.guildInfo.guildName,_loc4_.guildInfo.guildEmblem,0,true);
         }
         return _loc5_;
      }
   }
}
