package com.ankamagames.dofus.kernel.updaterv2.messages.impl
{
   import by.blooddy.crypto.serialization.JSON;
   import com.ankamagames.dofus.kernel.updaterv2.messages.IUpdaterOutputMessage;
   import com.ankamagames.dofus.kernel.updaterv2.messages.UpdaterMessageIDEnum;
   
   public class GetComponentsListMessage implements IUpdaterOutputMessage
   {
       
      
      private var _project:String;
      
      public function GetComponentsListMessage(param1:String = "game")
      {
         super();
         this._project = param1;
      }
      
      public function serialize() : String
      {
         return by.blooddy.crypto.serialization.JSON.encode({
            "_msg_id":UpdaterMessageIDEnum.GET_COMPONENTS_LIST,
            "project":this._project
         });
      }
   }
}
