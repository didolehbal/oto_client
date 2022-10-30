package com.ankamagames.atouin.managers
{
   import com.ankamagames.atouin.types.AnimatedElementInfo;
   import com.ankamagames.jerakine.sequencer.CallbackStep;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import com.ankamagames.tiphon.sequence.SetAnimationStep;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   public final class AnimatedElementManager
   {
      
      private static var _elements:Vector.<AnimatedElementInfo>;
      
      private static const SEQUENCE_TYPE_NAME:String = "AnimatedElementManager_sequence";
      
      private static const MAX_ANIMATION_LENGTH:int = 20000;
       
      
      private var _sequenceRef:Dictionary;
      
      public function AnimatedElementManager()
      {
         this._sequenceRef = new Dictionary(true);
         super();
      }
      
      public static function reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:AnimatedElementInfo = null;
         if(_elements)
         {
            _loc1_ = _elements.length;
            _loc2_ = -1;
            while(++_loc2_ < _loc1_)
            {
               _loc3_ = _elements[_loc2_];
               _loc3_.tiphonSprite.destroy();
            }
         }
         _elements = new Vector.<AnimatedElementInfo>();
         StageShareManager.stage.removeEventListener(Event.ENTER_FRAME,loop);
      }
      
      public static function addAnimatedElement(param1:TiphonSprite, param2:int, param3:int) : void
      {
         if(_elements.length == 0)
         {
            StageShareManager.stage.addEventListener(Event.ENTER_FRAME,loop);
         }
         _elements.push(new AnimatedElementInfo(param1,param2,param3));
      }
      
      public static function removeAnimatedElement(param1:TiphonSprite) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:AnimatedElementInfo = null;
         while(_loc2_ < _elements.length)
         {
            _loc3_ = _elements[_loc2_];
            if(_loc3_.tiphonSprite == param1)
            {
               _elements.splice(_loc2_,1);
               if(_elements.length == 0)
               {
                  StageShareManager.stage.removeEventListener(Event.ENTER_FRAME,loop);
                  SerialSequencer.clearByType(SEQUENCE_TYPE_NAME);
               }
               return;
            }
            _loc2_++;
         }
      }
      
      public static function loop(param1:Event) : void
      {
         var _loc2_:AnimatedElementInfo = null;
         var _loc3_:SerialSequencer = null;
         var _loc4_:PlayAnimationStep = null;
         var _loc5_:int = getTimer();
         var _loc6_:int = -1;
         var _loc7_:int = _elements.length;
         while(++_loc6_ < _loc7_)
         {
            _loc2_ = _elements[_loc6_];
            if(_loc5_ - _loc2_.nextAnimation > 0)
            {
               _loc2_.setNextAnimation();
               _loc3_ = new SerialSequencer(SEQUENCE_TYPE_NAME);
               (_loc4_ = new PlayAnimationStep(_loc2_.tiphonSprite,"AnimStart",false)).timeout = MAX_ANIMATION_LENGTH;
               _loc3_.addStep(_loc4_);
               _loc3_.addStep(new SetAnimationStep(_loc2_.tiphonSprite,"AnimStatique"));
               _loc3_.addStep(new CallbackStep(new Callback(onSequenceEnd,_loc3_,_loc2_.tiphonSprite)));
               _loc3_.start();
            }
         }
      }
      
      private static function onSequenceEnd(param1:SerialSequencer, param2:TiphonSprite) : void
      {
         param1.clear();
         if(param2.getAnimation() == "AnimStart")
         {
            param2.stopAnimation();
         }
      }
   }
}
