package com.ankamagames.dofus.datacenter.misc
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class Pack implements IDataCenter
   {
      
      public static const MODULE:String = "Pack";
       
      
      public var id:int;
      
      public var name:String;
      
      public var hasSubAreas:Boolean;
      
      public function Pack()
      {
         super();
      }
      
      public static function getPackById(param1:int) : Pack
      {
         return GameData.getObject(MODULE,param1) as Pack;
      }
      
      public static function getPackByName(param1:String) : Pack
      {
         var _loc2_:Pack = null;
         var _loc3_:Array = getAllPacks();
         for each(_loc2_ in _loc3_)
         {
            if(param1 == _loc2_.name)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getAllPacks() : Array
      {
         return GameData.getObjects(MODULE);
      }
   }
}
