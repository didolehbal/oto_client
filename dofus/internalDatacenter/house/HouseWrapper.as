package com.ankamagames.dofus.internalDatacenter.house
{
   import com.ankamagames.dofus.datacenter.houses.House;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.network.types.game.house.HouseInformations;
   import com.ankamagames.dofus.network.types.game.house.HouseInformationsExtended;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class HouseWrapper implements IDataCenter
   {
       
      
      public var houseId:int;
      
      public var name:String;
      
      public var description:String;
      
      public var ownerName:String;
      
      public var isOnSale:Boolean = false;
      
      public var gfxId:int;
      
      public var defaultPrice:uint;
      
      public var guildIdentity:GuildWrapper;
      
      public var isSaleLocked:Boolean;
      
      public function HouseWrapper()
      {
         super();
      }
      
      public static function create(param1:HouseInformations) : HouseWrapper
      {
         var _loc2_:HouseInformationsExtended = null;
         var _loc3_:HouseWrapper = new HouseWrapper();
         var _loc4_:House = House.getGuildHouseById(param1.modelId);
         _loc3_.houseId = param1.houseId;
         _loc3_.name = _loc4_.name;
         _loc3_.description = _loc4_.description;
         _loc3_.ownerName = param1.ownerName;
         _loc3_.isOnSale = param1.isOnSale;
         _loc3_.gfxId = _loc4_.gfxId;
         _loc3_.defaultPrice = _loc4_.defaultPrice;
         _loc3_.isSaleLocked = param1.isSaleLocked;
         if(param1 is HouseInformationsExtended)
         {
            _loc2_ = param1 as HouseInformationsExtended;
            _loc3_.guildIdentity = GuildWrapper.create(_loc2_.guildInfo.guildId,_loc2_.guildInfo.guildName,_loc2_.guildInfo.guildEmblem,0,true);
         }
         return _loc3_;
      }
      
      public static function manualCreate(param1:int, param2:int, param3:String, param4:Boolean, param5:Boolean = false) : HouseWrapper
      {
         var _loc6_:HouseWrapper = new HouseWrapper();
         var _loc7_:House = House.getGuildHouseById(param1);
         _loc6_.houseId = param2;
         _loc6_.name = _loc7_.name;
         _loc6_.description = _loc7_.description;
         _loc6_.ownerName = param3;
         _loc6_.isOnSale = param4;
         _loc6_.gfxId = _loc7_.gfxId;
         _loc6_.defaultPrice = _loc7_.defaultPrice;
         _loc6_.isSaleLocked = param5;
         return _loc6_;
      }
   }
}
