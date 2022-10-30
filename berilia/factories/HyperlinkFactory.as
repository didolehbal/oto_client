package com.ankamagames.berilia.factories
{
   import com.ankamagames.berilia.events.LinkInteractionEvent;
   import com.ankamagames.berilia.frames.ShortcutsFrame;
   import com.ankamagames.berilia.managers.HtmlManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.utils.BeriliaHookList;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.utils.display.FrameIdManager;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.events.EventDispatcher;
   import flash.events.TextEvent;
   import flash.events.TimerEvent;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class HyperlinkFactory
   {
      
      private static var LEFT:String = "{";
      
      private static var RIGHT:String = "}";
      
      private static var SEPARATOR:String = "::";
      
      private static var PROTOCOL:Dictionary = new Dictionary();
      
      private static var PROTOCOL_TEXT:Dictionary = new Dictionary();
      
      private static var PROTOCOL_SHIFT:Dictionary = new Dictionary();
      
      private static var PROTOCOL_BOLD:Dictionary = new Dictionary();
      
      private static var PROTOCOL_ROLL_OVER:Dictionary = new Dictionary();
      
      private static var staticStyleSheet:StyleSheet;
      
      public static var lastClickEventFrame:uint;
      
      private static var _rollOverTimer:Timer;
      
      private static var _rollOverData:String;
       
      
      public function HyperlinkFactory()
      {
         super();
      }
      
      public static function protocolIsRegister(param1:String) : Boolean
      {
         return !!PROTOCOL[param1]?true:false;
      }
      
      public static function textProtocolIsRegister(param1:String) : Boolean
      {
         return !!PROTOCOL_TEXT[param1]?true:false;
      }
      
      public static function shiftProtocolIsRegister(param1:String) : Boolean
      {
         return !!PROTOCOL_SHIFT[param1]?true:false;
      }
      
      public static function boldProtocolIsRegister(param1:String) : Boolean
      {
         return !!PROTOCOL_BOLD[param1]?true:false;
      }
      
      public static function createTextClickHandler(param1:EventDispatcher, param2:Boolean = false) : void
      {
         var _loc3_:TextField = null;
         if(param1 is TextField)
         {
            _loc3_ = param1 as TextField;
            _loc3_.htmlText = decode(_loc3_.htmlText,true,!!param2?_loc3_:null);
            _loc3_.mouseEnabled = true;
         }
         param1.addEventListener(TextEvent.LINK,processClick);
      }
      
      public static function createRollOverHandler(param1:EventDispatcher) : void
      {
         param1.addEventListener(LinkInteractionEvent.ROLL_OVER,processRollOver);
         param1.addEventListener(LinkInteractionEvent.ROLL_OUT,processRollOut);
      }
      
      public static function activeSmallHyperlink(param1:TextField) : void
      {
         param1.addEventListener(TextEvent.LINK,processClick);
      }
      
      public static function decode(param1:String, param2:Boolean = true, param3:TextField = null) : String
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         var _loc11_:String = null;
         var _loc12_:Array = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:String = null;
         var _loc19_:Function = null;
         var _loc20_:Boolean = false;
         var _loc21_:StyleSheet = null;
         var _loc22_:String = param1;
         while((_loc4_ = _loc22_.indexOf(LEFT)) != -1)
         {
            if((_loc5_ = _loc22_.indexOf(RIGHT)) == -1)
            {
               break;
            }
            if(_loc4_ > _loc5_)
            {
               break;
            }
            _loc6_ = _loc22_.substring(0,_loc4_);
            _loc7_ = _loc22_.substring(_loc5_ + 1);
            _loc13_ = (_loc12_ = (_loc11_ = (_loc10_ = (_loc8_ = _loc22_.substring(_loc4_,_loc5_)).split("::"))[0].substr(1)).split(",")).shift();
            _loc17_ = _loc12_.length;
            _loc16_ = 0;
            while(_loc16_ < _loc17_)
            {
               if((_loc18_ = _loc12_[_loc16_]).indexOf("linkColor") != -1)
               {
                  _loc14_ = _loc18_.split(":")[1];
                  _loc12_.splice(_loc16_,1);
                  _loc16_--;
                  _loc17_--;
               }
               if(_loc18_.indexOf("hoverColor") != -1)
               {
                  _loc15_ = _loc18_.split(":")[1];
                  _loc12_.splice(_loc16_,1);
                  _loc16_--;
                  _loc17_--;
               }
               _loc16_++;
            }
            if(_loc14_ || _loc15_)
            {
               _loc11_ = _loc13_ + "," + _loc12_.join(",");
            }
            if(_loc10_.length == 1)
            {
               if((_loc19_ = PROTOCOL_TEXT[_loc13_]) != null)
               {
                  _loc10_.push(_loc19_.apply(_loc19_,_loc12_));
               }
            }
            if(param2)
            {
               _loc9_ = _loc10_[1];
               if(PROTOCOL_BOLD[_loc13_])
               {
                  _loc9_ = HtmlManager.addTag(_loc9_,HtmlManager.BOLD);
               }
               _loc22_ = (_loc22_ = (_loc22_ = _loc6_) + HtmlManager.addLink(_loc9_,"event:" + _loc11_,null,true)) + _loc7_;
               if(param3)
               {
                  _loc20_ = _loc14_ || _loc15_;
                  if(!_loc14_)
                  {
                     _loc14_ = (_loc14_ = XmlConfig.getInstance().getEntry("colors.hyperlink.link")).replace("0x","#");
                  }
                  if(!_loc15_)
                  {
                     _loc15_ = (_loc15_ = XmlConfig.getInstance().getEntry("colors.hyperlink.hover")).replace("0x","#");
                  }
                  if(!_loc20_)
                  {
                     if(!staticStyleSheet)
                     {
                        staticStyleSheet = new StyleSheet();
                     }
                     _loc21_ = staticStyleSheet;
                  }
                  else
                  {
                     _loc21_ = new StyleSheet();
                  }
                  if(_loc21_.styleNames.length == 0)
                  {
                     _loc21_.setStyle("a:link",{"color":_loc14_});
                     _loc21_.setStyle("a:hover",{"color":_loc15_});
                  }
                  param3.styleSheet = _loc21_;
               }
            }
            else
            {
               _loc9_ = _loc10_.length == 2?_loc10_[1]:"";
               _loc22_ = _loc6_ + _loc9_ + _loc7_;
            }
         }
         return _loc22_;
      }
      
      public static function registerProtocol(param1:String, param2:Function, param3:Function = null, param4:Function = null, param5:Boolean = true, param6:Function = null) : void
      {
         PROTOCOL[param1] = param2;
         if(param3 != null)
         {
            PROTOCOL_TEXT[param1] = param3;
         }
         if(param4 != null)
         {
            PROTOCOL_SHIFT[param1] = param4;
         }
         if(param5)
         {
            PROTOCOL_BOLD[param1] = true;
         }
         if(param6 != null)
         {
            PROTOCOL_ROLL_OVER[param1] = param6;
         }
      }
      
      public static function processClick(param1:TextEvent) : void
      {
         var _loc2_:Function = null;
         var _loc3_:Function = null;
         lastClickEventFrame = FrameIdManager.frameId;
         StageShareManager.stage.focus = StageShareManager.stage;
         var _loc4_:Array = param1.text.split(",");
         if(ShortcutsFrame.shiftKey)
         {
            _loc2_ = PROTOCOL_SHIFT[_loc4_[0]];
            if(_loc2_ == null)
            {
               KernelEventsManager.getInstance().processCallback(BeriliaHookList.ChatHyperlink,"{" + _loc4_.join(",") + "}");
            }
            else
            {
               _loc4_.shift();
               _loc2_.apply(null,_loc4_);
            }
         }
         else
         {
            _loc3_ = PROTOCOL[_loc4_.shift()];
            if(_loc3_ != null)
            {
               _loc3_.apply(null,_loc4_);
            }
         }
      }
      
      public static function processRollOver(param1:LinkInteractionEvent) : void
      {
         if(_rollOverTimer == null)
         {
            _rollOverTimer = new Timer(800,1);
            _rollOverTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onRollOverTimerComplete);
         }
         else
         {
            _rollOverTimer.reset();
         }
         _rollOverData = param1.text;
         _rollOverTimer.start();
      }
      
      public static function processRollOut(param1:LinkInteractionEvent) : void
      {
         if(_rollOverTimer != null)
         {
            _rollOverTimer.reset();
         }
         _rollOverData = null;
      }
      
      private static function onRollOverTimerComplete(param1:TimerEvent) : void
      {
         if(_rollOverData == null)
         {
            return;
         }
         _rollOverTimer.stop();
         var _loc2_:Array = _rollOverData.split(",");
         _loc2_[1] = StageShareManager.stage.mouseX;
         var _loc3_:Function = PROTOCOL_ROLL_OVER[_loc2_.shift()];
         if(_loc3_ != null)
         {
            _loc3_.apply(null,_loc2_);
         }
      }
   }
}
