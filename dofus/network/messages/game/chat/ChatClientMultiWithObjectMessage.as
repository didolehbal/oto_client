package com.ankamagames.dofus.network.messages.game.chat
{
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItem;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class ChatClientMultiWithObjectMessage extends ChatClientMultiMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 862;
       
      
      private var _isInitialized:Boolean = false;
      
      public var objects:Vector.<ObjectItem>;
      
      public function ChatClientMultiWithObjectMessage()
      {
         this.objects = new Vector.<ObjectItem>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 862;
      }
      
      public function initChatClientMultiWithObjectMessage(param1:String = "", param2:uint = 0, param3:Vector.<ObjectItem> = null) : ChatClientMultiWithObjectMessage
      {
         super.initChatClientMultiMessage(param1,param2);
         this.objects = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.objects = new Vector.<ObjectItem>();
         this._isInitialized = false;
      }
      
      override public function pack(param1:ICustomDataOutput) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         this.serialize(new CustomDataWrapper(_loc2_));
         if(HASH_FUNCTION != null)
         {
            HASH_FUNCTION(_loc2_);
         }
         writePacket(param1,this.getMessageId(),_loc2_);
      }
      
      override public function unpack(param1:ICustomDataInput, param2:uint) : void
      {
         this.deserialize(param1);
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_ChatClientMultiWithObjectMessage(param1);
      }
      
      public function serializeAs_ChatClientMultiWithObjectMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         super.serializeAs_ChatClientMultiMessage(param1);
         param1.writeShort(this.objects.length);
         while(_loc2_ < this.objects.length)
         {
            (this.objects[_loc2_] as ObjectItem).serializeAs_ObjectItem(param1);
            _loc2_++;
         }
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ChatClientMultiWithObjectMessage(param1);
      }
      
      public function deserializeAs_ChatClientMultiWithObjectMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:ObjectItem = null;
         var _loc4_:uint = 0;
         super.deserialize(param1);
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new ObjectItem();
            _loc2_.deserialize(param1);
            this.objects.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
