package com.ankamagames.tiphon.types
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class EquipmentSprite extends DynamicSprite
   {
      
      public static var enableLiveReference:Boolean = false;
      
      public static var liveReference:Dictionary = new Dictionary(false);
      
      private static const _handlerRef:Dictionary = new Dictionary(true);
       
      
      public function EquipmentSprite()
      {
         super();
      }
      
      public function updateTransform() : void
      {
         if(_handlerRef[this])
         {
            this.makeChild(_handlerRef[this]);
         }
      }
      
      override public function init(param1:IAnimationSpriteHandler) : void
      {
         if(getQualifiedClassName(parent) == getQualifiedClassName(this))
         {
            return;
         }
         var _loc2_:DisplayObject = this.makeChild(param1);
         if(_loc2_ && enableLiveReference)
         {
            if(!liveReference[getQualifiedClassName(_loc2_)])
            {
               liveReference[getQualifiedClassName(_loc2_)] = new Dictionary(true);
            }
            liveReference[getQualifiedClassName(_loc2_)][this] = 1;
            _handlerRef[this] = param1;
         }
      }
      
      private function makeChild(param1:IAnimationSpriteHandler) : DisplayObject
      {
         var _loc2_:uint = 0;
         var _loc3_:Sprite = param1.getSkinSprite(this);
         if(_loc3_ && _loc3_ != this)
         {
            _loc2_ = 0;
            while(numChildren && _loc2_ != numChildren)
            {
               _loc2_ = numChildren;
               removeChildAt(0);
            }
            return addChild(_loc3_);
         }
         return null;
      }
   }
}
