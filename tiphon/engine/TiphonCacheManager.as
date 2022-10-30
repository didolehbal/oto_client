package com.ankamagames.tiphon.engine
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.PerformanceManager;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.Swl;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.types.ScriptedAnimation;
   import com.ankamagames.tiphon.types.TiphonUtility;
   import com.ankamagames.tiphon.types.cache.AnimCache;
   import com.ankamagames.tiphon.types.cache.SpriteCacheInfo;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class TiphonCacheManager
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(TiphonCacheManager));
      
      public static const _cacheList:Dictionary = new Dictionary();
      
      private static const _spritesListToRender:Vector.<SpriteCacheInfo> = new Vector.<SpriteCacheInfo>();
      
      private static var _processing:Boolean = false;
      
      private static var _lastRender:int = 0;
      
      private static var _waitRender:int = 0;
       
      
      public function TiphonCacheManager()
      {
         super();
      }
      
      public static function init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Array = new Array(15,16,17,18,22,34,36,38,40,12,13,14);
         var _loc5_:Array = new Array("AnimStatique","AnimMarche","AnimCourse");
         var _loc6_:int = -1;
         var _loc7_:int = _loc4_.length;
         var _loc8_:int = _loc5_.length;
         while(++_loc6_ < _loc7_)
         {
            _loc1_ = _loc4_[_loc6_];
            _loc2_ = -1;
            while(++_loc2_ < _loc8_)
            {
               _loc3_ = _loc5_[_loc2_];
               _cacheList[_loc1_ + "_" + _loc3_] = new AnimCache();
               Tiphon.skullLibrary.askResource(_loc1_,_loc3_,new Callback(checkRessourceState),new Callback(onRenderFail));
            }
         }
      }
      
      public static function addSpriteToRender(param1:TiphonSprite, param2:TiphonEntityLook) : void
      {
         _spritesListToRender.push(new SpriteCacheInfo(param1,param2));
         if(!_processing)
         {
            StageShareManager.stage.addEventListener(Event.ENTER_FRAME,onEnterFrame);
         }
      }
      
      public static function hasCache(param1:int, param2:String) : Boolean
      {
         if(_cacheList[param1 + "_" + param2])
         {
            return true;
         }
         return false;
      }
      
      public static function pushScriptedAnimation(param1:ScriptedAnimation) : void
      {
         var _loc2_:AnimCache = _cacheList[param1.bone + "_" + param1.animationName];
         if(_loc2_)
         {
            _loc2_.pushAnimation(param1,param1.direction);
         }
      }
      
      public static function getScriptedAnimation(param1:int, param2:String, param3:int) : ScriptedAnimation
      {
         var _loc4_:ScriptedAnimation = null;
         var _loc5_:Class = null;
         var _loc6_:Swl = null;
         var _loc7_:String = null;
         var _loc8_:AnimCache;
         if(_loc8_ = _cacheList[param1 + "_" + param2])
         {
            if(_loc4_ = _loc8_.getAnimation(param3))
            {
               return _loc4_;
            }
            _loc6_ = Tiphon.skullLibrary.getResourceById(param1,param2);
            _loc7_ = param2 + "_" + param3;
            if(_loc6_.hasDefinition(_loc7_))
            {
               _loc5_ = _loc6_.getDefinition(_loc7_) as Class;
            }
            else
            {
               _loc7_ = param2 + "_" + TiphonUtility.getFlipDirection(param3);
               if(_loc6_.hasDefinition(_loc7_))
               {
                  _loc5_ = _loc6_.getDefinition(_loc7_) as Class;
               }
            }
            (_loc4_ = new _loc5_() as ScriptedAnimation).bone = param1;
            _loc4_.animationName = param2;
            _loc4_.direction = param3;
            _loc4_.inCache = true;
            return _loc4_;
         }
         return null;
      }
      
      private static function onEnterFrame(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:SpriteCacheInfo = null;
         var _loc4_:TiphonSprite = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         if(_spritesListToRender.length)
         {
            _loc2_ = getTimer();
            if(_loc2_ - _lastRender > _waitRender)
            {
               _lastRender = _loc2_;
               _loc3_ = _spritesListToRender.shift();
               while(_loc3_.sprite.destroyed && _spritesListToRender.length)
               {
                  _loc3_ = _spritesListToRender.shift();
               }
               _loc5_ = (_loc4_ = _loc3_.sprite).getAnimation();
               _loc6_ = _loc4_.getDirection();
               _loc4_.look.updateFrom(_loc3_.look);
               _loc4_.setAnimationAndDirection(_loc5_,_loc6_);
               if(PerformanceManager.performance == PerformanceManager.NORMAL)
               {
                  _waitRender = 20;
               }
               else if(PerformanceManager.performance == PerformanceManager.LIMITED)
               {
                  _waitRender = 200;
               }
               else
               {
                  _waitRender = 500;
               }
            }
         }
         else
         {
            StageShareManager.stage.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
            _processing = false;
         }
      }
      
      private static function checkRessourceState() : void
      {
      }
      
      private static function onRenderFail() : void
      {
      }
   }
}
