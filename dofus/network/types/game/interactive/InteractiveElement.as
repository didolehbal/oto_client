package com.ankamagames.dofus.network.types.game.interactive
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   [Trusted]
   public class InteractiveElement implements INetworkType
   {
      
      public static const protocolId:uint = 80;
       
      
      public var elementId:uint = 0;
      
      public var elementTypeId:int = 0;
      
      public var enabledSkills:Vector.<InteractiveElementSkill>;
      
      public var disabledSkills:Vector.<InteractiveElementSkill>;
      
      public function InteractiveElement()
      {
         this.enabledSkills = new Vector.<InteractiveElementSkill>();
         this.disabledSkills = new Vector.<InteractiveElementSkill>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 80;
      }
      
      public function initInteractiveElement(param1:uint = 0, param2:int = 0, param3:Vector.<InteractiveElementSkill> = null, param4:Vector.<InteractiveElementSkill> = null) : InteractiveElement
      {
         this.elementId = param1;
         this.elementTypeId = param2;
         this.enabledSkills = param3;
         this.disabledSkills = param4;
         return this;
      }
      
      public function reset() : void
      {
         this.elementId = 0;
         this.elementTypeId = 0;
         this.enabledSkills = new Vector.<InteractiveElementSkill>();
         this.disabledSkills = new Vector.<InteractiveElementSkill>();
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_InteractiveElement(param1);
      }
      
      public function serializeAs_InteractiveElement(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(this.elementId < 0)
         {
            throw new Error("Forbidden value (" + this.elementId + ") on element elementId.");
         }
         param1.writeInt(this.elementId);
         param1.writeInt(this.elementTypeId);
         param1.writeShort(this.enabledSkills.length);
         while(_loc2_ < this.enabledSkills.length)
         {
            param1.writeShort((this.enabledSkills[_loc2_] as InteractiveElementSkill).getTypeId());
            (this.enabledSkills[_loc2_] as InteractiveElementSkill).serialize(param1);
            _loc2_++;
         }
         param1.writeShort(this.disabledSkills.length);
         while(_loc3_ < this.disabledSkills.length)
         {
            param1.writeShort((this.disabledSkills[_loc3_] as InteractiveElementSkill).getTypeId());
            (this.disabledSkills[_loc3_] as InteractiveElementSkill).serialize(param1);
            _loc3_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_InteractiveElement(param1);
      }
      
      public function deserializeAs_InteractiveElement(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:InteractiveElementSkill = null;
         var _loc4_:uint = 0;
         var _loc5_:InteractiveElementSkill = null;
         var _loc7_:uint = 0;
         var _loc9_:uint = 0;
         this.elementId = param1.readInt();
         if(this.elementId < 0)
         {
            throw new Error("Forbidden value (" + this.elementId + ") on element of InteractiveElement.elementId.");
         }
         this.elementTypeId = param1.readInt();
         var _loc6_:uint = param1.readUnsignedShort();
         while(_loc7_ < _loc6_)
         {
            _loc2_ = param1.readUnsignedShort();
            _loc3_ = ProtocolTypeManager.getInstance(InteractiveElementSkill,_loc2_);
            _loc3_.deserialize(param1);
            this.enabledSkills.push(_loc3_);
            _loc7_++;
         }
         var _loc8_:uint = param1.readUnsignedShort();
         while(_loc9_ < _loc8_)
         {
            _loc4_ = param1.readUnsignedShort();
            (_loc5_ = ProtocolTypeManager.getInstance(InteractiveElementSkill,_loc4_)).deserialize(param1);
            this.disabledSkills.push(_loc5_);
            _loc9_++;
         }
      }
   }
}
