package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.idols.Idol;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.actions.CloseIdolsAction;
   import com.ankamagames.dofus.logic.game.common.actions.IdolSelectRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenIdolsAction;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.messages.game.idol.IdolListMessage;
   import com.ankamagames.dofus.network.messages.game.idol.IdolPartyLostMessage;
   import com.ankamagames.dofus.network.messages.game.idol.IdolPartyRefreshMessage;
   import com.ankamagames.dofus.network.messages.game.idol.IdolPartyRegisterRequestMessage;
   import com.ankamagames.dofus.network.messages.game.idol.IdolSelectErrorMessage;
   import com.ankamagames.dofus.network.messages.game.idol.IdolSelectRequestMessage;
   import com.ankamagames.dofus.network.messages.game.idol.IdolSelectedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectAddedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectDeletedMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.utils.getQualifiedClassName;
   
   public class IdolsFrame implements Frame
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(IdolsFrame));
       
      
      private var _openIdols:Boolean;
      
      public function IdolsFrame()
      {
         super();
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:IdolPartyRegisterRequestMessage = null;
         var _loc3_:Idol = null;
         var _loc4_:IdolSelectRequestAction = null;
         var _loc5_:IdolSelectRequestMessage = null;
         var _loc6_:IdolListMessage = null;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:Object = null;
         var _loc11_:IdolSelectErrorMessage = null;
         var _loc12_:IdolSelectedMessage = null;
         var _loc13_:int = 0;
         var _loc14_:IdolPartyRefreshMessage = null;
         var _loc15_:IdolPartyLostMessage = null;
         var _loc16_:ObjectAddedMessage = null;
         var _loc17_:ObjectDeletedMessage = null;
         var _loc18_:ItemWrapper = null;
         switch(true)
         {
            case param1 is OpenIdolsAction:
               this._openIdols = true;
               _loc2_ = new IdolPartyRegisterRequestMessage();
               _loc2_.initIdolPartyRegisterRequestMessage(true);
               ConnectionsHandler.getConnection().send(_loc2_);
               return true;
            case param1 is CloseIdolsAction:
               _loc2_ = new IdolPartyRegisterRequestMessage();
               _loc2_.initIdolPartyRegisterRequestMessage(false);
               ConnectionsHandler.getConnection().send(_loc2_);
               return true;
            case param1 is IdolSelectRequestAction:
               _loc4_ = param1 as IdolSelectRequestAction;
               (_loc5_ = new IdolSelectRequestMessage()).initIdolSelectRequestMessage(_loc4_.idolId,_loc4_.activate,_loc4_.party);
               ConnectionsHandler.getConnection().send(_loc5_);
               return true;
            case param1 is IdolListMessage:
               _loc6_ = param1 as IdolListMessage;
               PlayedCharacterManager.getInstance().soloIdols.length = 0;
               _loc8_ = _loc6_.chosenIdols.length;
               _loc7_ = 0;
               while(_loc7_ < _loc8_)
               {
                  PlayedCharacterManager.getInstance().soloIdols.push(_loc6_.chosenIdols[_loc7_]);
                  _loc7_++;
               }
               PlayedCharacterManager.getInstance().partyIdols.length = 0;
               _loc9_ = _loc6_.partyChosenIdols.length;
               _loc7_ = 0;
               while(_loc7_ < _loc9_)
               {
                  PlayedCharacterManager.getInstance().partyIdols.push(_loc6_.partyChosenIdols[_loc7_]);
                  _loc7_++;
               }
               (_loc10_ = new Object()).chosenIdols = _loc6_.chosenIdols;
               _loc10_.partyChosenIdols = _loc6_.partyChosenIdols;
               _loc10_.partyIdols = _loc6_.partyIdols;
               if(this._openIdols && !Berilia.getInstance().getUi("idolsTab"))
               {
                  KernelEventsManager.getInstance().processCallback(HookList.OpenBook,"idolsTab",_loc10_);
               }
               else
               {
                  KernelEventsManager.getInstance().processCallback(HookList.IdolsList,_loc10_.chosenIdols,_loc10_.partyChosenIdols,_loc10_.partyIdols);
               }
               this._openIdols = false;
               return true;
            case param1 is IdolSelectErrorMessage:
               _loc11_ = param1 as IdolSelectErrorMessage;
               KernelEventsManager.getInstance().processCallback(HookList.IdolSelectError,_loc11_.reason,_loc11_.idolId,_loc11_.activate,_loc11_.party);
               return true;
            case param1 is IdolSelectedMessage:
               if(!(_loc12_ = param1 as IdolSelectedMessage).party)
               {
                  if(!_loc12_.activate)
                  {
                     if((_loc13_ = PlayedCharacterManager.getInstance().soloIdols.indexOf(_loc12_.idolId)) != -1)
                     {
                        PlayedCharacterManager.getInstance().soloIdols.splice(_loc13_,1);
                     }
                  }
                  else
                  {
                     PlayedCharacterManager.getInstance().soloIdols.push(_loc12_.idolId);
                  }
               }
               else if(!_loc12_.activate)
               {
                  if((_loc13_ = PlayedCharacterManager.getInstance().partyIdols.indexOf(_loc12_.idolId)) != -1)
                  {
                     PlayedCharacterManager.getInstance().partyIdols.splice(_loc13_,1);
                  }
               }
               else
               {
                  PlayedCharacterManager.getInstance().partyIdols.push(_loc12_.idolId);
               }
               KernelEventsManager.getInstance().processCallback(HookList.IdolSelected,_loc12_.idolId,_loc12_.activate,_loc12_.party);
               return true;
            case param1 is IdolPartyRefreshMessage:
               _loc14_ = param1 as IdolPartyRefreshMessage;
               KernelEventsManager.getInstance().processCallback(HookList.IdolPartyRefresh,_loc14_.partyIdol);
               return true;
            case param1 is IdolPartyLostMessage:
               _loc15_ = param1 as IdolPartyLostMessage;
               KernelEventsManager.getInstance().processCallback(HookList.IdolPartyLost,_loc15_.idolId);
               return true;
            case param1 is ObjectAddedMessage:
               _loc16_ = param1 as ObjectAddedMessage;
               _loc3_ = Idol.getIdolByItemId(_loc16_.object.objectGID);
               if(_loc3_)
               {
                  KernelEventsManager.getInstance().processCallback(HookList.IdolAdded,_loc3_.id);
               }
               return false;
            case param1 is ObjectDeletedMessage:
               _loc17_ = param1 as ObjectDeletedMessage;
               _loc18_ = InventoryManager.getInstance().inventory.getItem(_loc17_.objectUID);
               _loc3_ = Idol.getIdolByItemId(_loc18_.objectGID);
               if(_loc3_)
               {
                  KernelEventsManager.getInstance().processCallback(HookList.IdolRemoved,_loc3_.id);
               }
               return false;
            default:
               return false;
         }
      }
      
      public function get priority() : int
      {
         return Priority.HIGH;
      }
   }
}
