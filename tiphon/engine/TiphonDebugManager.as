package com.ankamagames.tiphon.engine
{
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   
   public final class TiphonDebugManager
   {
      
      private static var _enabled:Boolean = false;
      
      private static var _textList:Vector.<Object> = new Vector.<Object>();
       
      
      public function TiphonDebugManager()
      {
         super();
      }
      
      public static function enable() : void
      {
         _enabled = true;
      }
      
      public static function disable() : void
      {
         _enabled = false;
      }
      
      public static function displayDofusScriptError(param1:String, param2:TiphonSprite) : void
      {
         var _loc3_:TextField = null;
         var _loc4_:Timer = null;
         var _loc5_:Point = null;
         if(_enabled && param2)
         {
            _loc3_ = new TextField();
            _loc3_.defaultTextFormat = new TextFormat("Verdana",14,16777215,true,null,null,null,null,"center");
            _loc3_.filters = new Array(new GlowFilter(16711680,1,3,3,3,3));
            _loc3_.text = param1 + "\n" + (!!param2.look?param2.look.toString():"");
            _loc3_.autoSize = TextFieldAutoSize.LEFT;
            _loc3_.mouseEnabled = false;
            (_loc4_ = new Timer(10000,1)).addEventListener(TimerEvent.TIMER,onTimer);
            _loc4_.start();
            _textList.push(_loc4_,_loc3_);
            StageShareManager.stage.addChild(_loc3_);
            _loc5_ = param2.localToGlobal(new Point(0,0));
            _loc3_.x = _loc5_.x - _loc3_.width / 2;
            _loc3_.y = _loc5_.y - param2.height / 2 + (20 - Math.random() * 40);
         }
      }
      
      private static function onTimer(param1:TimerEvent) : void
      {
         var _loc2_:TextField = null;
         var _loc5_:int = 0;
         var _loc3_:Timer = param1.currentTarget as Timer;
         var _loc4_:int = _textList.length;
         while(_loc5_ < _loc4_)
         {
            if(_loc3_ == _textList[_loc5_])
            {
               _loc2_ = _textList[_loc5_ + 1] as TextField;
               if(_loc2_.parent)
               {
                  _loc2_.parent.removeChild(_loc2_);
               }
               _textList.splice(_loc5_,2);
               return;
            }
            _loc5_ = _loc5_ + 2;
         }
      }
   }
}
