package com.ankamagames.jerakine.utils.display
{
   public class ColorUtils
   {
       
      
      public function ColorUtils()
      {
         super();
      }
      
      public static function rgb2hsl(param1:uint) : Object
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         _loc2_ = (param1 & 16711680) >> 16;
         _loc3_ = (param1 & 65280) >> 8;
         _loc4_ = param1 & 255;
         _loc2_ = _loc2_ / 255;
         _loc3_ = _loc3_ / 255;
         _loc4_ = _loc4_ / 255;
         var _loc11_:Number = Math.min(_loc2_,_loc3_,_loc4_);
         var _loc12_:Number;
         var _loc13_:Number = (_loc12_ = Math.max(_loc2_,_loc3_,_loc4_)) - _loc11_;
         _loc7_ = 1 - (_loc12_ + _loc11_) / 2;
         if(_loc13_ == 0)
         {
            _loc5_ = 0;
            _loc6_ = 0;
         }
         else
         {
            if(_loc12_ + _loc11_ < 1)
            {
               _loc6_ = 1 - _loc13_ / (_loc12_ + _loc11_);
            }
            else
            {
               _loc6_ = 1 - _loc13_ / (2 - _loc12_ - _loc11_);
            }
            _loc8_ = ((_loc12_ - _loc2_) / 6 + _loc13_ / 2) / _loc13_;
            _loc9_ = ((_loc12_ - _loc3_) / 6 + _loc13_ / 2) / _loc13_;
            _loc10_ = ((_loc12_ - _loc4_) / 6 + _loc13_ / 2) / _loc13_;
            if(_loc2_ == _loc12_)
            {
               _loc5_ = _loc10_ - _loc9_;
            }
            else if(_loc3_ == _loc12_)
            {
               _loc5_ = 1 / 3 + _loc8_ - _loc10_;
            }
            else if(_loc4_ == _loc12_)
            {
               _loc5_ = 2 / 3 + _loc9_ - _loc8_;
            }
            if(_loc5_ < 0)
            {
               _loc5_++;
            }
            if(_loc5_ > 1)
            {
               _loc5_--;
            }
         }
         return {
            "h":_loc5_,
            "s":_loc6_,
            "l":_loc7_
         };
      }
   }
}
