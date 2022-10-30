package com.ankamagames.atouin.utils
{
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class CellUtil
   {
       
      
      public function CellUtil()
      {
         super();
      }
      
      public static function getPixelXFromMapPoint(param1:MapPoint) : int
      {
         var _loc2_:Sprite = InteractiveCellManager.getInstance().getCell(param1.cellId);
         return _loc2_.x + _loc2_.width / 2;
      }
      
      public static function getPixelYFromMapPoint(param1:MapPoint) : int
      {
         var _loc2_:Sprite = InteractiveCellManager.getInstance().getCell(param1.cellId);
         return _loc2_.y + _loc2_.height / 2;
      }
      
      public static function getPixelsPointFromMapPoint(param1:MapPoint, param2:Boolean = true) : Point
      {
         var _loc3_:Sprite = InteractiveCellManager.getInstance().getCell(param1.cellId);
         return new Point(!!param2?Number(_loc3_.x + _loc3_.width / 2):Number(_loc3_.x),!!param2?Number(_loc3_.y + _loc3_.height / 2):Number(_loc3_.y));
      }
      
      public static function isLeftCol(param1:int) : Boolean
      {
         return param1 % 14 == 0;
      }
      
      public static function isRightCol(param1:int) : Boolean
      {
         return isLeftCol(param1 + 1);
      }
      
      public static function isTopRow(param1:int) : Boolean
      {
         return param1 < 28;
      }
      
      public static function isBottomRow(param1:int) : Boolean
      {
         return param1 > 531;
      }
      
      public static function isEvenRow(param1:int) : Boolean
      {
         return Math.floor(param1 / 14) % 2 == 0;
      }
   }
}
