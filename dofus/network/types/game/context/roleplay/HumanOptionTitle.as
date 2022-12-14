package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   [Trusted]
   public class HumanOptionTitle extends HumanOption implements INetworkType
   {
      
      public static const protocolId:uint = 408;
       
      
      public var titleId:uint = 0;
      
      public var titleParam:String = "";
      
      public function HumanOptionTitle()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 408;
      }
      
      public function initHumanOptionTitle(param1:uint = 0, param2:String = "") : HumanOptionTitle
      {
         this.titleId = param1;
         this.titleParam = param2;
         return this;
      }
      
      override public function reset() : void
      {
         this.titleId = 0;
         this.titleParam = "";
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_HumanOptionTitle(param1);
      }
      
      public function serializeAs_HumanOptionTitle(param1:ICustomDataOutput) : void
      {
         super.serializeAs_HumanOption(param1);
         if(this.titleId < 0)
         {
            throw new Error("Forbidden value (" + this.titleId + ") on element titleId.");
         }
         param1.writeVarShort(this.titleId);
         param1.writeUTF(this.titleParam);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_HumanOptionTitle(param1);
      }
      
      public function deserializeAs_HumanOptionTitle(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.titleId = param1.readVarUhShort();
         if(this.titleId < 0)
         {
            throw new Error("Forbidden value (" + this.titleId + ") on element of HumanOptionTitle.titleId.");
         }
         this.titleParam = param1.readUTF();
      }
   }
}
