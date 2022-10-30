package com.ankamagames.dofus.datacenter.livingObjects
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.getQualifiedClassName;
   
   public class LivingObjectSkinJntMood implements IDataCenter
   {
      
      public static const MODULE:String = "LivingObjectSkinJntMood";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SpeakingItemText));
       
      
      public var skinId:int;
      
      public var moods:Vector.<Vector.<int>>;
      
      public function LivingObjectSkinJntMood()
      {
         super();
      }
      
      public static function getLivingObjectSkin(param1:int, param2:int, param3:int) : int
      {
         var _loc4_:LivingObjectSkinJntMood;
         if(!(_loc4_ = GameData.getObject(MODULE,param1) as LivingObjectSkinJntMood) || !_loc4_.moods[param2])
         {
            return 0;
         }
         var _loc5_:Vector.<int>;
         return (_loc5_ = _loc4_.moods[param2] as Vector.<int>)[Math.max(0,param3 - 1)];
      }
      
      public static function getLivingObjectSkins() : Array
      {
         return GameData.getObjects(MODULE);
      }
   }
}
