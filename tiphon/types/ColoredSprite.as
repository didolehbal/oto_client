package com.ankamagames.tiphon.types
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.geom.ColorTransform;
   import flash.utils.getQualifiedClassName;
   
   public class ColoredSprite extends DynamicSprite
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ColoredSprite));
      
      private static const NEUTRAL_COLOR_TRANSFORM:ColorTransform = new ColorTransform();
       
      
      public function ColoredSprite()
      {
         super();
      }
      
      override public function init(param1:IAnimationSpriteHandler) : void
      {
         var _loc2_:ColorTransform = null;
         var _loc3_:uint = parseInt(getQualifiedClassName(this).split("_")[1]);
         _loc2_ = param1.getColorTransform(_loc3_);
         if(_loc2_)
         {
            this.colorize(_loc2_);
         }
         param1.registerColoredSprite(this,_loc3_);
      }
      
      public function colorize(param1:ColorTransform) : void
      {
         if(param1)
         {
            transform.colorTransform = param1;
         }
         else
         {
            transform.colorTransform = NEUTRAL_COLOR_TRANSFORM;
         }
      }
   }
}
