package com.ankamagames.jerakine.entities.messages
{
   import com.ankamagames.jerakine.entities.interfaces.IInteractive;
   
   public class EntityMouseOverMessage extends EntityInteractionMessage
   {
       
      
      public var virtual:Boolean;
      
      public function EntityMouseOverMessage(param1:IInteractive, param2:Boolean = false)
      {
         super(param1);
         this.virtual = param2;
      }
   }
}
