package com.ankamagames.berilia.frames
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.managers.BindsManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.types.shortcut.Bind;
   import com.ankamagames.berilia.types.shortcut.Shortcut;
   import com.ankamagames.berilia.utils.BeriliaHookList;
   import com.ankamagames.jerakine.handlers.FocusHandler;
   import com.ankamagames.jerakine.handlers.messages.keyboard.KeyboardKeyDownMessage;
   import com.ankamagames.jerakine.handlers.messages.keyboard.KeyboardKeyUpMessage;
   import com.ankamagames.jerakine.handlers.messages.keyboard.KeyboardMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.replay.KeyboardShortcut;
   import com.ankamagames.jerakine.replay.LogFrame;
   import com.ankamagames.jerakine.replay.LogTypeEnum;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import flash.events.Event;
   import flash.system.IME;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
   import flash.utils.getQualifiedClassName;
   
   public class ShortcutsFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ShortcutsFrame));
      
      public static var shiftKey:Boolean = false;
      
      public static var ctrlKey:Boolean = false;
      
      public static var altKey:Boolean = false;
      
      public static var shiftKeyDown:Boolean;
      
      public static var ctrlKeyDown:Boolean;
      
      public static var altKeyDown:Boolean;
      
      public static var shortcutsEnabled:Boolean = true;
       
      
      private var _lastCtrlKey:Boolean = false;
      
      private var _isProcessingDirectInteraction:Boolean;
      
      private var _heldShortcuts:Vector.<String>;
      
      public function ShortcutsFrame()
      {
         super();
      }
      
      public function get isProcessingDirectInteraction() : Boolean
      {
         return this._isProcessingDirectInteraction;
      }
      
      public function get heldShortcuts() : Vector.<String>
      {
         return this._heldShortcuts;
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:KeyboardKeyDownMessage = null;
         var _loc3_:Shortcut = null;
         var _loc4_:KeyboardKeyUpMessage = null;
         this._isProcessingDirectInteraction = false;
         if(!shortcutsEnabled)
         {
            return false;
         }
         switch(true)
         {
            case param1 is KeyboardKeyDownMessage:
               _loc2_ = KeyboardKeyDownMessage(param1);
               shiftKey = _loc2_.keyboardEvent.shiftKey;
               ctrlKey = _loc2_.keyboardEvent.ctrlKey;
               altKey = _loc2_.keyboardEvent.altKey;
               this._lastCtrlKey = false;
               if(!shiftKeyDown)
               {
                  shiftKeyDown = _loc2_.keyboardEvent.keyCode == Keyboard.SHIFT;
               }
               if(!ctrlKeyDown)
               {
                  ctrlKeyDown = _loc2_.keyboardEvent.keyCode == Keyboard.CONTROL;
               }
               if(!altKeyDown)
               {
                  altKeyDown = _loc2_.keyboardEvent.keyCode == Keyboard.ALTERNATE;
               }
               _loc3_ = this.getShortcut(_loc2_);
               if(_loc3_ && _loc3_.holdKeys && this._heldShortcuts.indexOf(_loc3_.defaultBind.targetedShortcut) == -1)
               {
                  this.handleMessage(_loc2_);
                  this._heldShortcuts.push(_loc3_.defaultBind.targetedShortcut);
               }
               return false;
            case param1 is KeyboardKeyUpMessage:
               _loc4_ = KeyboardKeyUpMessage(param1);
               shiftKey = _loc4_.keyboardEvent.shiftKey;
               ctrlKey = _loc4_.keyboardEvent.ctrlKey;
               altKey = _loc4_.keyboardEvent.altKey;
               switch(_loc4_.keyboardEvent.keyCode)
               {
                  case Keyboard.SHIFT:
                     shiftKeyDown = false;
                     break;
                  case Keyboard.CONTROL:
                     ctrlKeyDown = false;
                     break;
                  case Keyboard.ALTERNATE:
                     altKeyDown = false;
               }
               return this.handleMessage(_loc4_);
            default:
               this._isProcessingDirectInteraction = false;
               return false;
         }
      }
      
      private function handleMessage(param1:KeyboardMessage) : Boolean
      {
         var _loc2_:* = false;
         var _loc3_:Shortcut = null;
         var _loc4_:TextField = null;
         var _loc5_:TextField = null;
         var _loc6_:int = 0;
         var _loc7_:int;
         if((_loc7_ = param1.keyboardEvent.keyCode) == Keyboard.CONTROL)
         {
            this._lastCtrlKey = true;
         }
         else if(this._lastCtrlKey)
         {
            this._lastCtrlKey = false;
            return false;
         }
         this._isProcessingDirectInteraction = true;
         var _loc8_:String = BindsManager.getInstance().getShortcutString(param1.keyboardEvent.keyCode,this.getCharCode(param1));
         if(FocusHandler.getInstance().getFocus() is TextField && Berilia.getInstance().useIME && IME.enabled)
         {
            if((_loc4_ = FocusHandler.getInstance().getFocus() as TextField).parent is Input)
            {
               _loc2_ = _loc4_.text != Input(_loc4_.parent).lastTextOnInput;
               if(!_loc2_ && Input(_loc4_.parent).imeActive)
               {
                  Input(_loc4_.parent).imeActive = false;
                  _loc2_ = true;
               }
               else
               {
                  Input(_loc4_.parent).imeActive = _loc2_;
               }
            }
         }
         else
         {
            IME.enabled = false;
         }
         if(_loc8_ == null || _loc2_)
         {
            this._isProcessingDirectInteraction = false;
            return true;
         }
         var _loc9_:Bind = new Bind(_loc8_,"",param1.keyboardEvent.altKey,param1.keyboardEvent.ctrlKey,param1.keyboardEvent.shiftKey);
         var _loc10_:Bind;
         if((_loc10_ = BindsManager.getInstance().getBind(_loc9_)) != null)
         {
            _loc3_ = Shortcut.getShortcutByName(_loc10_.targetedShortcut);
         }
         if(BindsManager.getInstance().canBind(_loc9_) && (_loc3_ != null && !_loc3_.disable || _loc3_ == null))
         {
            KernelEventsManager.getInstance().processCallback(BeriliaHookList.KeyboardShortcut,_loc9_,param1.keyboardEvent.keyCode);
         }
         if(_loc10_ != null && _loc3_ && !_loc3_.disable)
         {
            if(!Shortcut.getShortcutByName(_loc10_.targetedShortcut))
            {
               return false;
            }
            if(_loc3_.holdKeys)
            {
               if((_loc6_ = this._heldShortcuts.indexOf(_loc3_.defaultBind.targetedShortcut)) != -1)
               {
                  this._heldShortcuts.splice(_loc6_,1);
               }
            }
            if((_loc5_ = StageShareManager.stage.focus as TextField) && _loc5_.type == TextFieldType.INPUT)
            {
               if(!Shortcut.getShortcutByName(_loc10_.targetedShortcut).textfieldEnabled)
               {
                  return false;
               }
            }
            LogFrame.log(LogTypeEnum.SHORTCUT,new KeyboardShortcut(_loc10_.targetedShortcut));
            BindsManager.getInstance().processCallback(_loc10_,_loc10_.targetedShortcut);
         }
         this._isProcessingDirectInteraction = false;
         return false;
      }
      
      private function getShortcut(param1:KeyboardMessage) : Shortcut
      {
         var _loc2_:String = BindsManager.getInstance().getShortcutString(param1.keyboardEvent.keyCode,this.getCharCode(param1));
         var _loc3_:Bind = BindsManager.getInstance().getBind(new Bind(_loc2_,"",param1.keyboardEvent.altKey,param1.keyboardEvent.ctrlKey,param1.keyboardEvent.shiftKey));
         return !!_loc3_?Shortcut.getShortcutByName(_loc3_.targetedShortcut):null;
      }
      
      private function getCharCode(param1:KeyboardMessage) : int
      {
         var _loc2_:int = 0;
         if(param1.keyboardEvent.shiftKey && param1.keyboardEvent.keyCode == 52)
         {
            _loc2_ = 39;
         }
         else if(param1.keyboardEvent.shiftKey && param1.keyboardEvent.keyCode == 54)
         {
            _loc2_ = 45;
         }
         else
         {
            _loc2_ = param1.keyboardEvent.charCode;
         }
         return _loc2_;
      }
      
      private function onWindowDeactivate(param1:Event) : void
      {
         this._heldShortcuts.length = 0;
         shiftKey = ctrlKey = altKey = false;
         shiftKeyDown = false;
         ctrlKeyDown = false;
         altKeyDown = false;
      }
      
      public function pushed() : Boolean
      {
         this._heldShortcuts = new Vector.<String>(0);
         if(AirScanner.hasAir())
         {
            StageShareManager.stage.nativeWindow.addEventListener(Event.DEACTIVATE,this.onWindowDeactivate);
         }
         return true;
      }
      
      public function pulled() : Boolean
      {
         if(AirScanner.hasAir())
         {
            StageShareManager.stage.nativeWindow.removeEventListener(Event.DEACTIVATE,this.onWindowDeactivate);
         }
         return true;
      }
   }
}
