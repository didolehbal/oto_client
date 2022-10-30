package com.ankamagames.dofus.logic.game.common.steps
{
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.network.messages.game.context.GameContextRemoveElementMessage;
   import com.ankamagames.dofus.scripts.api.EntityApi;
   import com.ankamagames.jerakine.lua.LuaPlayer;
   import com.ankamagames.jerakine.script.ScriptsManager;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   
   public class RemoveEntityStep extends AbstractSequencable
   {
       
      
      private var _id:int;
      
      public function RemoveEntityStep(param1:int)
      {
         super();
         this._id = param1;
      }
      
      override public function start() : void
      {
         var _loc1_:EntityApi = null;
         var _loc2_:GameContextRemoveElementMessage = new GameContextRemoveElementMessage();
         _loc2_.initGameContextRemoveElementMessage(this._id);
         Kernel.getWorker().process(_loc2_);
         var _loc3_:LuaPlayer = ScriptsManager.getInstance().getPlayer(ScriptsManager.LUA_PLAYER) as LuaPlayer;
         if(_loc3_)
         {
            _loc1_ = ScriptsManager.getInstance().getPlayerApi(_loc3_,"EntityApi") as EntityApi;
            if(_loc1_)
            {
               _loc1_.removeEntity(this._id);
            }
         }
         executeCallbacks();
      }
   }
}
