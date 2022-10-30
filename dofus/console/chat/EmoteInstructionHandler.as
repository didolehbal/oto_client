package com.ankamagames.dofus.console.chat
{
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.AbstractEntitiesFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.roleplay.actions.EmotePlayRequestAction;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.network.enums.PlayerLifeStatusEnum;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   
   public class EmoteInstructionHandler implements ConsoleInstructionHandler
   {
       
      
      public function EmoteInstructionHandler()
      {
         super();
      }
      
      public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
      {
         var _loc4_:EmotePlayRequestAction = null;
         var _loc5_:uint = this.getEmoteId(param2);
         var _loc6_:PlayedCharacterManager = PlayedCharacterManager.getInstance();
         var _loc7_:AbstractEntitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as AbstractEntitiesFrame;
         if(_loc5_ > 0 && _loc6_.state == PlayerLifeStatusEnum.STATUS_ALIVE_AND_KICKING && (_loc6_.isRidding || _loc6_.isPetsMounting || _loc6_.infos.entityLook.bonesId == 1 || _loc7_ && _loc7_.creaturesMode))
         {
            _loc4_ = EmotePlayRequestAction.create(_loc5_);
            Kernel.getWorker().process(_loc4_);
         }
      }
      
      public function getHelp(param1:String) : String
      {
         return null;
      }
      
      private function getEmoteId(param1:String) : uint
      {
         var _loc2_:Emoticon = null;
         for each(_loc2_ in Emoticon.getEmoticons())
         {
            if(_loc2_.shortcut == param1)
            {
               return _loc2_.id;
            }
            if(_loc2_.defaultAnim == param1)
            {
               return _loc2_.id;
            }
         }
         return 0;
      }
      
      public function getParamPossibilities(param1:String, param2:uint = 0, param3:Array = null) : Array
      {
         return [];
      }
   }
}
