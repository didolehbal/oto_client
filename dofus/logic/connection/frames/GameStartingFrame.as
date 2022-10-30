package com.ankamagames.dofus.logic.connection.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.dofus.datacenter.communication.InfoMessage;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.kernel.net.DisconnectionReasonEnum;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.logic.common.actions.AgreementAgreedAction;
   import com.ankamagames.dofus.logic.common.frames.DisconnectionHandlerFrame;
   import com.ankamagames.dofus.logic.connection.messages.DelayedSystemMessageDisplayMessage;
   import com.ankamagames.dofus.logic.connection.messages.GameStartingMessage;
   import com.ankamagames.dofus.logic.game.common.actions.OpenMainMenuAction;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.utils.ParamsDecoder;
   import com.ankamagames.dofus.misc.utils.mapeditor.MapEditorManager;
   import com.ankamagames.dofus.network.messages.server.basic.SystemMessageDisplayMessage;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.messages.Worker;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.utils.getQualifiedClassName;
   
   public class GameStartingFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(GameStartingFrame));
       
      
      private var _worker:Worker;
      
      private var m:MapEditorManager;
      
      public function GameStartingFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function pushed() : Boolean
      {
         this._worker = Kernel.getWorker();
         this.m = new MapEditorManager();
         Kernel.getWorker().process(new GameStartingMessage());
         Dofus.getInstance().renameApp("Dofus");
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:DelayedSystemMessageDisplayMessage = null;
         var _loc3_:SystemMessageDisplayMessage = null;
         var _loc4_:AgreementAgreedAction = null;
         var _loc5_:String = null;
         var _loc6_:DelayedSystemMessageDisplayMessage = null;
         switch(true)
         {
            case param1 is DelayedSystemMessageDisplayMessage:
               _loc2_ = param1 as DelayedSystemMessageDisplayMessage;
               this.systemMessageDisplay(_loc2_);
               return true;
            case param1 is SystemMessageDisplayMessage:
               _loc3_ = param1 as SystemMessageDisplayMessage;
               if(_loc3_.hangUp)
               {
                  ConnectionsHandler.connectionGonnaBeClosed(DisconnectionReasonEnum.DISCONNECTED_BY_POPUP);
                  (_loc6_ = new DelayedSystemMessageDisplayMessage()).initDelayedSystemMessageDisplayMessage(_loc3_.hangUp,_loc3_.msgId,_loc3_.parameters);
                  DisconnectionHandlerFrame.messagesAfterReset.push(_loc6_);
               }
               this.systemMessageDisplay(_loc3_);
               return true;
            case param1 is AgreementAgreedAction:
               if((_loc4_ = AgreementAgreedAction(param1)).fileName == "tou")
               {
                  _loc5_ = XmlConfig.getInstance().getEntry("config.lang.current") + "#" + (I18n.getUiText("ui.legal.tou1") + I18n.getUiText("ui.legal.tou2")).length;
                  OptionManager.getOptionManager("dofus")["legalAgreementTou"] = _loc5_;
               }
               if(_loc4_.fileName == "modstou")
               {
                  _loc5_ = XmlConfig.getInstance().getEntry("config.lang.current") + "#" + I18n.getUiText("ui.legal.modstou").length;
                  OptionManager.getOptionManager("dofus")["legalAgreementModsTou"] = _loc5_;
               }
               return true;
            case param1 is OpenMainMenuAction:
               KernelEventsManager.getInstance().processCallback(HookList.OpenMainMenu);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      private function systemMessageDisplay(param1:SystemMessageDisplayMessage) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:uint = 0;
         var _loc4_:Object = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
         var _loc5_:Array = new Array();
         for each(_loc2_ in param1.parameters)
         {
            _loc5_.push(_loc2_);
         }
         if(InfoMessage.getInfoMessageById(40000 + param1.msgId) && InfoMessage.getInfoMessageById(40000 + param1.msgId).textId)
         {
            _loc3_ = InfoMessage.getInfoMessageById(40000 + param1.msgId).textId;
         }
         else
         {
            _log.error("Information message " + (40000 + param1.msgId) + " cannot be found.");
            _loc3_ = InfoMessage.getInfoMessageById(207).textId;
            (_loc5_ = new Array()).push(param1.msgId);
         }
         var _loc6_:String;
         if(_loc6_ = I18n.getText(_loc3_))
         {
            _loc6_ = ParamsDecoder.applyParams(_loc6_,_loc5_);
            _loc4_.openPopup(I18n.getUiText("ui.popup.warning"),_loc6_,[I18n.getUiText("ui.common.ok")],null,null,null,null,false,true);
            SoundManager.getInstance().manager.removeAllSounds();
            return;
         }
      }
   }
}
