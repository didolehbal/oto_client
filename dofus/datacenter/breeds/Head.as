package com.ankamagames.dofus.datacenter.breeds
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.getQualifiedClassName;
   
   public class Head implements IDataCenter
   {
      
      public static const MODULE:String = "Heads";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Head));
       
      
      public var id:int;
      
      public var skins:String;
      
      public var assetId:String;
      
      public var breed:uint;
      
      public var gender:uint;
      
      public var label:String;
      
      public var order:uint;
      
      public function Head()
      {
         super();
      }
      
      public static function getHeadById(param1:int) : Head
      {
         return GameData.getObject(MODULE,param1) as Head;
      }
      
      public static function getHeads() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public static function getHead(param1:uint, param2:uint) : Array
      {
         var _loc3_:Head = null;
         var _loc4_:Array = GameData.getObjects(MODULE);
         var _loc5_:Array = [];
         for each(_loc3_ in _loc4_)
         {
            if(_loc3_.breed == param1 && _loc3_.gender == param2)
            {
               _loc5_.push(_loc3_);
            }
         }
         return _loc5_;
      }
   }
}
