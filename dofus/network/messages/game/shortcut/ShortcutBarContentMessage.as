package com.ankamagames.dofus.network.messages.game.shortcut
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.shortcut.Shortcut;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class ShortcutBarContentMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6231;
       
      
      private var _isInitialized:Boolean = false;
      
      public var barType:uint = 0;
      
      public var shortcuts:Vector.<Shortcut>;
      
      public function ShortcutBarContentMessage()
      {
         this.shortcuts = new Vector.<Shortcut>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6231;
      }
      
      public function initShortcutBarContentMessage(param1:uint = 0, param2:Vector.<Shortcut> = null) : ShortcutBarContentMessage
      {
         this.barType = param1;
         this.shortcuts = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.barType = 0;
         this.shortcuts = new Vector.<Shortcut>();
         this._isInitialized = false;
      }
      
      override public function pack(param1:ICustomDataOutput) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         this.serialize(new CustomDataWrapper(_loc2_));
         writePacket(param1,this.getMessageId(),_loc2_);
      }
      
      override public function unpack(param1:ICustomDataInput, param2:uint) : void
      {
         this.deserialize(param1);
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_ShortcutBarContentMessage(param1);
      }
      
      public function serializeAs_ShortcutBarContentMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeByte(this.barType);
         param1.writeShort(this.shortcuts.length);
         while(_loc2_ < this.shortcuts.length)
         {
            param1.writeShort((this.shortcuts[_loc2_] as Shortcut).getTypeId());
            (this.shortcuts[_loc2_] as Shortcut).serialize(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ShortcutBarContentMessage(param1);
      }
      
      public function deserializeAs_ShortcutBarContentMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Shortcut = null;
         var _loc5_:uint = 0;
         this.barType = param1.readByte();
         if(this.barType < 0)
         {
            throw new Error("Forbidden value (" + this.barType + ") on element of ShortcutBarContentMessage.barType.");
         }
         var _loc4_:uint = param1.readUnsignedShort();
         while(_loc5_ < _loc4_)
         {
            _loc2_ = param1.readUnsignedShort();
            _loc3_ = ProtocolTypeManager.getInstance(Shortcut,_loc2_);
            _loc3_.deserialize(param1);
            this.shortcuts.push(_loc3_);
            _loc5_++;
         }
      }
   }
}
