package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.dofus.network.types.game.look.IndexedEntityLook;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   [Trusted]
   public class HumanOptionFollowers extends HumanOption implements INetworkType
   {
      
      public static const protocolId:uint = 410;
       
      
      public var followingCharactersLook:Vector.<IndexedEntityLook>;
      
      public function HumanOptionFollowers()
      {
         this.followingCharactersLook = new Vector.<IndexedEntityLook>();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 410;
      }
      
      public function initHumanOptionFollowers(param1:Vector.<IndexedEntityLook> = null) : HumanOptionFollowers
      {
         this.followingCharactersLook = param1;
         return this;
      }
      
      override public function reset() : void
      {
         this.followingCharactersLook = new Vector.<IndexedEntityLook>();
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_HumanOptionFollowers(param1);
      }
      
      public function serializeAs_HumanOptionFollowers(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         super.serializeAs_HumanOption(param1);
         param1.writeShort(this.followingCharactersLook.length);
         while(_loc2_ < this.followingCharactersLook.length)
         {
            (this.followingCharactersLook[_loc2_] as IndexedEntityLook).serializeAs_IndexedEntityLook(param1);
            _loc2_++;
         }
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_HumanOptionFollowers(param1);
      }
      
      public function deserializeAs_HumanOptionFollowers(param1:ICustomDataInput) : void
      {
         var _loc2_:IndexedEntityLook = null;
         var _loc4_:uint = 0;
         super.deserialize(param1);
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new IndexedEntityLook();
            _loc2_.deserialize(param1);
            this.followingCharactersLook.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
