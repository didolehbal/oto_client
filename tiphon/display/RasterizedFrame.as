package com.ankamagames.tiphon.display
{
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class RasterizedFrame
   {
       
      
      public var bitmapData:BitmapData;
      
      public var x:Number = 0;
      
      public var y:Number = 0;
      
      public function RasterizedFrame(param1:MovieClip, param2:int)
      {
         var _loc3_:BitmapData = null;
         var _loc4_:Matrix = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         super();
         param1.gotoAndStop(param2 + 1);
         var _loc11_:Rectangle;
         if((_loc11_ = param1.getBounds(param1)).width + _loc11_.height)
         {
            _loc4_ = new Matrix();
            _loc5_ = param1.scaleX;
            _loc6_ = param1.scaleY;
            _loc7_ = _loc5_ > 0?Number(_loc11_.width * _loc5_):Number(-_loc11_.width * _loc5_);
            _loc8_ = _loc6_ > 0?Number(_loc11_.height * _loc6_):Number(-_loc11_.height * _loc6_);
            _loc9_ = _loc5_ > 0?Number(_loc11_.x * _loc5_):Number((_loc11_.x + _loc11_.width) * _loc5_);
            _loc10_ = _loc6_ > 0?Number(_loc11_.y * _loc6_):Number((_loc11_.y + _loc11_.height) * _loc6_);
            _loc4_.scale(_loc5_,_loc6_);
            _loc4_.translate(-_loc9_,-_loc10_);
            this.x = _loc9_;
            this.y = _loc10_;
            _loc3_ = new BitmapData(_loc7_,_loc8_,true,16777215);
            _loc3_.draw(param1,_loc4_,null,null,null,true);
         }
         else
         {
            _loc3_ = new BitmapData(1,1,true,16777215);
         }
         this.bitmapData = _loc3_;
         if(param1.currentFrame == param1.framesLoaded && param1.parent)
         {
            param1.parent.removeChild(param1);
         }
      }
      
      public function toString() : String
      {
         return "[RasterizedFrame " + this.x + "," + this.y + ": " + this.bitmapData + " (" + this.bitmapData.width + "/" + this.bitmapData.height + ")]";
      }
   }
}
