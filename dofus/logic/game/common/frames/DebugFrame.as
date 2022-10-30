package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.SelectionManager;
   import com.ankamagames.atouin.renderers.ZoneDARenderer;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.fight.managers.TacticModeManager;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.network.enums.DebugLevelEnum;
   import com.ankamagames.dofus.network.messages.debug.DebugClearHighlightCellsMessage;
   import com.ankamagames.dofus.network.messages.debug.DebugHighlightCellsMessage;
   import com.ankamagames.dofus.network.messages.debug.DebugInClientMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightJoinMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.CurrentMapMessage;
   import com.ankamagames.jerakine.handlers.FocusHandler;
   import com.ankamagames.jerakine.handlers.messages.keyboard.KeyboardKeyDownMessage;
   import com.ankamagames.jerakine.handlers.messages.keyboard.KeyboardKeyUpMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.zones.Custom;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.utils.getQualifiedClassName;
   
   public class DebugFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(DebugFrame));
       
      
      private var _sName:String;
      
      private var _aZones:Array;
      
      private var isCellsHighLighted = false;
      
      public function DebugFrame()
      {
         this._aZones = new Array();
         super();
      }
      
      public function get priority() : int
      {
         return 0;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:DebugHighlightCellsMessage = null;
         var _loc3_:DebugInClientMessage = null;
         var _loc4_:KeyboardKeyDownMessage = null;
         var _loc5_:KeyboardKeyUpMessage = null;
         var _loc6_:RoleplayEntitiesFrame = null;
         var _loc7_:Vector.<uint> = null;
         var _loc8_:Vector.<uint> = null;
         var _loc9_:int = 0;
         switch(true)
         {
            case param1 is DebugHighlightCellsMessage:
               _loc2_ = param1 as DebugHighlightCellsMessage;
               this._sName = "debug_zone" + _loc2_.color + "_" + Math.round(Math.random() * 10000);
               this.setDebugCells(this._sName,_loc2_.color,_loc2_.cells);
               return true;
            case param1 is DebugClearHighlightCellsMessage:
            case param1 is CurrentMapMessage:
            case param1 is GameFightJoinMessage:
               this.clear();
               return false;
            case param1 is DebugInClientMessage:
               _loc3_ = param1 as DebugInClientMessage;
               switch(_loc3_.level)
               {
                  case DebugLevelEnum.LEVEL_DEBUG:
                     _log.debug(_loc3_.message);
                     break;
                  case DebugLevelEnum.LEVEL_ERROR:
                     _log.error(_loc3_.message);
                     break;
                  case DebugLevelEnum.LEVEL_FATAL:
                     _log.fatal(_loc3_.message);
                     break;
                  case DebugLevelEnum.LEVEL_INFO:
                     _log.info(_loc3_.message);
                     break;
                  case DebugLevelEnum.LEVEL_TRACE:
                     _log.trace(_loc3_.message);
                     break;
                  case DebugLevelEnum.LEVEL_WARN:
                     _log.warn(_loc3_.message);
               }
               return true;
            case param1 is KeyboardKeyDownMessage:
               _loc4_ = param1 as KeyboardKeyDownMessage;
               _loc6_ = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
               if(_loc4_.keyboardEvent.keyCode == Keyboard.H && !this.isCellsHighLighted && !(FocusHandler.getInstance().getFocus() is TextField))
               {
                  _loc7_ = new Vector.<uint>();
                  _loc8_ = new Vector.<uint>();
                  for each(_loc9_ in _loc6_.redCells)
                  {
                     _loc7_.push(_loc9_);
                  }
                  for each(_loc9_ in _loc6_.blueCells)
                  {
                     _loc8_.push(_loc9_);
                  }
                  this.setDebugCells("red_cells",16394280,_loc7_);
                  this.setDebugCells("blue_cells",3093242,_loc8_);
                  this.isCellsHighLighted = true;
                  TacticModeManager.getInstance().show(PlayedCharacterManager.getInstance().currentMap);
               }
               return false;
            case param1 is KeyboardKeyUpMessage:
               if((_loc5_ = param1 as KeyboardKeyUpMessage).keyboardEvent.keyCode == Keyboard.H && !(FocusHandler.getInstance().getFocus() is TextField))
               {
                  this.clear();
                  this.isCellsHighLighted = false;
                  TacticModeManager.getInstance().hide();
               }
               return false;
            default:
               return false;
         }
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      private function setDebugCells(param1:String, param2:int, param3:Vector.<uint>) : void
      {
         this.displayZone(param1 + "_foreground",param3,param2,PlacementStrataEnums.STRATA_FOREGROUND);
         this._aZones.push(param1 + "_foreground");
      }
      
      private function clear() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in this._aZones)
         {
            SelectionManager.getInstance().getSelection(_loc1_).remove();
         }
      }
      
      private function displayZone(param1:String, param2:Vector.<uint>, param3:uint, param4:uint) : void
      {
         var _loc5_:Selection;
         (_loc5_ = new Selection()).renderer = new ZoneDARenderer(param4);
         _loc5_.color = new Color(param3);
         _loc5_.zone = new Custom(param2);
         SelectionManager.getInstance().addSelection(_loc5_,param1);
         SelectionManager.getInstance().update(param1);
      }
   }
}
