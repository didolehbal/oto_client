package com.ankamagames.dofus.network.types.game.startup
{
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItemInformationWithQuantity;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   [Trusted]
   public class StartupActionAddObject implements INetworkType
   {
      
      public static const protocolId:uint = 52;
       
      
      public var uid:uint = 0;
      
      public var title:String = "";
      
      public var text:String = "";
      
      public var descUrl:String = "";
      
      public var pictureUrl:String = "";
      
      public var items:Vector.<ObjectItemInformationWithQuantity>;
      
      public function StartupActionAddObject()
      {
         this.items = new Vector.<ObjectItemInformationWithQuantity>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 52;
      }
      
      public function initStartupActionAddObject(param1:uint = 0, param2:String = "", param3:String = "", param4:String = "", param5:String = "", param6:Vector.<ObjectItemInformationWithQuantity> = null) : StartupActionAddObject
      {
         this.uid = param1;
         this.title = param2;
         this.text = param3;
         this.descUrl = param4;
         this.pictureUrl = param5;
         this.items = param6;
         return this;
      }
      
      public function reset() : void
      {
         this.uid = 0;
         this.title = "";
         this.text = "";
         this.descUrl = "";
         this.pictureUrl = "";
         this.items = new Vector.<ObjectItemInformationWithQuantity>();
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_StartupActionAddObject(param1);
      }
      
      public function serializeAs_StartupActionAddObject(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         if(this.uid < 0)
         {
            throw new Error("Forbidden value (" + this.uid + ") on element uid.");
         }
         param1.writeInt(this.uid);
         param1.writeUTF(this.title);
         param1.writeUTF(this.text);
         param1.writeUTF(this.descUrl);
         param1.writeUTF(this.pictureUrl);
         param1.writeShort(this.items.length);
         while(_loc2_ < this.items.length)
         {
            (this.items[_loc2_] as ObjectItemInformationWithQuantity).serializeAs_ObjectItemInformationWithQuantity(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_StartupActionAddObject(param1);
      }
      
      public function deserializeAs_StartupActionAddObject(param1:ICustomDataInput) : void
      {
         var _loc2_:ObjectItemInformationWithQuantity = null;
         var _loc4_:uint = 0;
         this.uid = param1.readInt();
         if(this.uid < 0)
         {
            throw new Error("Forbidden value (" + this.uid + ") on element of StartupActionAddObject.uid.");
         }
         this.title = param1.readUTF();
         this.text = param1.readUTF();
         this.descUrl = param1.readUTF();
         this.pictureUrl = param1.readUTF();
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new ObjectItemInformationWithQuantity();
            _loc2_.deserialize(param1);
            this.items.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
