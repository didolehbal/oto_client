package com.ankamagames.dofus.misc.utils
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;
   
   public class EmbedAssets
   {
      
      private static var _cache:Dictionary = new Dictionary();
      
      public static const DefaultBeriliaSlotIcon:Class = EmbedAssets_DefaultBeriliaSlotIcon;
      
      public static const CHECKPOINT_CLIP_TOP:Class = EmbedAssets_CHECKPOINT_CLIP_TOP;
      
      public static const CHECKPOINT_CLIP_TOP_WALK:Class = EmbedAssets_CHECKPOINT_CLIP_TOP_WALK;
      
      public static const CHECKPOINT_CLIP_LEFT:Class = EmbedAssets_CHECKPOINT_CLIP_LEFT;
      
      public static const CHECKPOINT_CLIP_LEFT_WALK:Class = EmbedAssets_CHECKPOINT_CLIP_LEFT_WALK;
      
      public static const CHECKPOINT_CLIP_BOTTOM:Class = EmbedAssets_CHECKPOINT_CLIP_BOTTOM;
      
      public static const CHECKPOINT_CLIP_BOTTOM_WALK:Class = EmbedAssets_CHECKPOINT_CLIP_BOTTOM_WALK;
      
      public static const CHECKPOINT_CLIP_RIGHT:Class = EmbedAssets_CHECKPOINT_CLIP_RIGHT;
      
      public static const CHECKPOINT_CLIP_RIGHT_WALK:Class = EmbedAssets_CHECKPOINT_CLIP_RIGHT_WALK;
      
      private static const CHECKPOINT_CLIP:Class = EmbedAssets_CHECKPOINT_CLIP;
      
      private static const CHECKPOINT_CLIP_WALK:Class = EmbedAssets_CHECKPOINT_CLIP_WALK;
      
      private static const QUEST_CLIP:Class = EmbedAssets_QUEST_CLIP;
      
      private static const QUEST_REPEATABLE_CLIP:Class = EmbedAssets_QUEST_REPEATABLE_CLIP;
      
      private static const QUEST_OBJECTIVE_CLIP:Class = EmbedAssets_QUEST_OBJECTIVE_CLIP;
      
      private static const QUEST_REPEATABLE_OBJECTIVE_CLIP:Class = EmbedAssets_QUEST_REPEATABLE_OBJECTIVE_CLIP;
      
      private static const TEAM_CIRCLE_CLIP:Class = EmbedAssets_TEAM_CIRCLE_CLIP;
      
      private static const SWORDS_CLIP:Class = EmbedAssets_SWORDS_CLIP;
      
      private static const FLAG_CURSOR:Class = EmbedAssets_FLAG_CURSOR;
      
      private static var matrix:Matrix = new Matrix();
       
      
      public function EmbedAssets()
      {
         super();
      }
      
      public static function getBitmap(param1:String, param2:Boolean = false, param3:Boolean = true) : Bitmap
      {
         var _loc4_:Bitmap = null;
         var _loc5_:BitmapData = null;
         if(param3 && _cache[param1] != null)
         {
            _loc4_ = _cache[param1];
            if(!param2)
            {
               return _loc4_;
            }
            (_loc5_ = new BitmapData(_loc4_.width,_loc4_.height,true,16711935)).draw(_loc4_,matrix);
            return new Bitmap(_loc5_);
         }
         var _loc6_:Class;
         _loc4_ = new (_loc6_ = EmbedAssets[param1] as Class)() as Bitmap;
         if(param3)
         {
            saveCache(param1,_loc4_);
         }
         return _loc4_;
      }
      
      public static function getSprite(param1:String) : Sprite
      {
         var _loc2_:Class = EmbedAssets[param1] as Class;
         return new _loc2_() as Sprite;
      }
      
      public static function getClass(param1:String) : Class
      {
         return EmbedAssets[param1] as Class;
      }
      
      private static function saveCache(param1:String, param2:*) : void
      {
         _cache[param1] = param2;
      }
   }
}
