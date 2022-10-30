package com.ankamagames.jerakine.utils.display
{
   import flash.geom.Point;
   import mapTools.MapTools;
   
   public class Dofus2Line
   {
      
      public static var isMapInitialized:Boolean = false;
       
      
      public function Dofus2Line()
      {
         super();
      }
      
      public static function getLine(param1:uint, param2:uint) : Vector.<Point>
      {
         if(!isMapInitialized)
         {
            MapTools.initialize();
            isMapInitialized = true;
         }
         return MapTools.getLOSCellsVector(param1,param2).reverse();
      }
   }
}
