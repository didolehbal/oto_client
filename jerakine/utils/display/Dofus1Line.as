package com.ankamagames.jerakine.utils.display
{
   import com.ankamagames.jerakine.types.Point3D;
   import flash.geom.Point;
   
   public class Dofus1Line
   {
      
      public static const useDofus2Line:Boolean = true;
       
      
      public function Dofus1Line()
      {
         super();
      }
      
      public static function getLine(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : Array
      {
         var _loc7_:int = 0;
         var _loc8_:Point = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:uint = 0;
         var _loc20_:uint = 0;
         var _loc33_:uint = 0;
         var _loc21_:Array = new Array();
         var _loc22_:Point3D = new Point3D(param1,param2,param3);
         var _loc23_:Point3D = new Point3D(param4,param5,param6);
         var _loc24_:Point3D = new Point3D(_loc22_.x + 0.5,_loc22_.y + 0.5,_loc22_.z);
         var _loc25_:Point3D = new Point3D(_loc23_.x + 0.5,_loc23_.y + 0.5,_loc23_.z);
         var _loc26_:Number = 0;
         var _loc27_:Number = 0;
         var _loc28_:Number = 0;
         var _loc29_:Number = 0;
         var _loc30_:* = _loc24_.z > _loc25_.z;
         var _loc31_:Array = new Array();
         var _loc32_:Array = new Array();
         if(Math.abs(_loc24_.x - _loc25_.x) == Math.abs(_loc24_.y - _loc25_.y))
         {
            _loc29_ = Math.abs(_loc24_.x - _loc25_.x);
            _loc26_ = _loc25_.x > _loc24_.x?Number(1):Number(-1);
            _loc27_ = _loc25_.y > _loc24_.y?Number(1):Number(-1);
            _loc28_ = _loc29_ == 0?Number(0):!!_loc30_?Number((_loc22_.z - _loc23_.z) / _loc29_):Number((_loc23_.z - _loc22_.z) / _loc29_);
            _loc33_ = 1;
         }
         else if(Math.abs(_loc24_.x - _loc25_.x) > Math.abs(_loc24_.y - _loc25_.y))
         {
            _loc29_ = Math.abs(_loc24_.x - _loc25_.x);
            _loc26_ = _loc25_.x > _loc24_.x?Number(1):Number(-1);
            _loc27_ = (_loc27_ = _loc25_.y > _loc24_.y?Math.abs(_loc24_.y - _loc25_.y) == 0?Number(0):Number(Math.abs(_loc24_.y - _loc25_.y) / _loc29_):Number(-Math.abs(_loc24_.y - _loc25_.y) / _loc29_)) * 100;
            _loc27_ = Math.ceil(_loc27_) / 100;
            _loc28_ = _loc29_ == 0?Number(0):!!_loc30_?Number((_loc22_.z - _loc23_.z) / _loc29_):Number((_loc23_.z - _loc22_.z) / _loc29_);
            _loc33_ = 2;
         }
         else
         {
            _loc29_ = Math.abs(_loc24_.y - _loc25_.y);
            _loc26_ = (_loc26_ = _loc25_.x > _loc24_.x?Math.abs(_loc24_.x - _loc25_.x) == 0?Number(0):Number(Math.abs(_loc24_.x - _loc25_.x) / _loc29_):Number(-Math.abs(_loc24_.x - _loc25_.x) / _loc29_)) * 100;
            _loc26_ = Math.ceil(_loc26_) / 100;
            _loc27_ = _loc25_.y > _loc24_.y?Number(1):Number(-1);
            _loc28_ = _loc29_ == 0?Number(0):!!_loc30_?Number((_loc22_.z - _loc23_.z) / _loc29_):Number((_loc23_.z - _loc22_.z) / _loc29_);
            _loc33_ = 3;
         }
         _loc7_ = 0;
         while(_loc7_ < _loc29_)
         {
            _loc9_ = int(3 + _loc29_ / 2);
            _loc10_ = int(97 - _loc29_ / 2);
            if(_loc33_ == 2)
            {
               _loc11_ = Math.ceil(_loc24_.y * 100 + _loc27_ * 50) / 100;
               _loc12_ = Math.floor(_loc24_.y * 100 + _loc27_ * 150) / 100;
               _loc13_ = Math.floor(Math.abs(Math.floor(_loc11_) * 100 - _loc11_ * 100)) / 100;
               _loc14_ = Math.ceil(Math.abs(Math.ceil(_loc12_) * 100 - _loc12_ * 100)) / 100;
               if(Math.floor(_loc11_) == Math.floor(_loc12_))
               {
                  _loc32_ = [Math.floor(_loc24_.y + _loc27_)];
                  if(_loc11_ == _loc32_[0] && _loc12_ < _loc32_[0])
                  {
                     _loc32_ = [Math.ceil(_loc24_.y + _loc27_)];
                  }
                  else if(_loc11_ == _loc32_[0] && _loc12_ > _loc32_[0])
                  {
                     _loc32_ = [Math.floor(_loc24_.y + _loc27_)];
                  }
                  else if(_loc12_ == _loc32_[0] && _loc11_ < _loc32_[0])
                  {
                     _loc32_ = [Math.ceil(_loc24_.y + _loc27_)];
                  }
                  else if(_loc12_ == _loc32_[0] && _loc11_ > _loc32_[0])
                  {
                     _loc32_ = [Math.floor(_loc24_.y + _loc27_)];
                  }
               }
               else if(Math.ceil(_loc11_) == Math.ceil(_loc12_))
               {
                  _loc32_ = [Math.ceil(_loc24_.y + _loc27_)];
                  if(_loc11_ == _loc32_[0] && _loc12_ < _loc32_[0])
                  {
                     _loc32_ = [Math.floor(_loc24_.y + _loc27_)];
                  }
                  else if(_loc11_ == _loc32_[0] && _loc12_ > _loc32_[0])
                  {
                     _loc32_ = [Math.ceil(_loc24_.y + _loc27_)];
                  }
                  else if(_loc12_ == _loc32_[0] && _loc11_ < _loc32_[0])
                  {
                     _loc32_ = [Math.floor(_loc24_.y + _loc27_)];
                  }
                  else if(_loc12_ == _loc32_[0] && _loc11_ > _loc32_[0])
                  {
                     _loc32_ = [Math.ceil(_loc24_.y + _loc27_)];
                  }
               }
               else if(int(_loc13_ * 100) <= _loc9_)
               {
                  _loc32_ = [Math.floor(_loc12_)];
               }
               else if(int(_loc14_ * 100) >= _loc10_)
               {
                  _loc32_ = [Math.floor(_loc11_)];
               }
               else
               {
                  _loc32_ = [Math.floor(_loc11_),Math.floor(_loc12_)];
               }
            }
            else if(_loc33_ == 3)
            {
               _loc15_ = Math.ceil(_loc24_.x * 100 + _loc26_ * 50) / 100;
               _loc16_ = Math.floor(_loc24_.x * 100 + _loc26_ * 150) / 100;
               _loc17_ = Math.floor(Math.abs(Math.floor(_loc15_) * 100 - _loc15_ * 100)) / 100;
               _loc18_ = Math.ceil(Math.abs(Math.ceil(_loc16_) * 100 - _loc16_ * 100)) / 100;
               if(Math.floor(_loc15_) == Math.floor(_loc16_))
               {
                  _loc31_ = [Math.floor(_loc24_.x + _loc26_)];
                  if(_loc15_ == _loc31_[0] && _loc16_ < _loc31_[0])
                  {
                     _loc31_ = [Math.ceil(_loc24_.x + _loc26_)];
                  }
                  else if(_loc15_ == _loc31_[0] && _loc16_ > _loc31_[0])
                  {
                     _loc31_ = [Math.floor(_loc24_.x + _loc26_)];
                  }
                  else if(_loc16_ == _loc31_[0] && _loc15_ < _loc31_[0])
                  {
                     _loc31_ = [Math.ceil(_loc24_.x + _loc26_)];
                  }
                  else if(_loc16_ == _loc31_[0] && _loc15_ > _loc31_[0])
                  {
                     _loc31_ = [Math.floor(_loc24_.x + _loc26_)];
                  }
               }
               else if(Math.ceil(_loc15_) == Math.ceil(_loc16_))
               {
                  _loc31_ = [Math.ceil(_loc24_.x + _loc26_)];
                  if(_loc15_ == _loc31_[0] && _loc16_ < _loc31_[0])
                  {
                     _loc31_ = [Math.floor(_loc24_.x + _loc26_)];
                  }
                  else if(_loc15_ == _loc31_[0] && _loc16_ > _loc31_[0])
                  {
                     _loc31_ = [Math.ceil(_loc24_.x + _loc26_)];
                  }
                  else if(_loc16_ == _loc31_[0] && _loc15_ < _loc31_[0])
                  {
                     _loc31_ = [Math.floor(_loc24_.x + _loc26_)];
                  }
                  else if(_loc16_ == _loc31_[0] && _loc15_ > _loc31_[0])
                  {
                     _loc31_ = [Math.ceil(_loc24_.x + _loc26_)];
                  }
               }
               else if(int(_loc17_ * 100) <= _loc9_)
               {
                  _loc31_ = [Math.floor(_loc16_)];
               }
               else if(int(_loc18_ * 100) >= _loc10_)
               {
                  _loc31_ = [Math.floor(_loc15_)];
               }
               else
               {
                  _loc31_ = [Math.floor(_loc15_),Math.floor(_loc16_)];
               }
            }
            if(_loc32_.length > 0)
            {
               _loc19_ = 0;
               while(_loc19_ < _loc32_.length)
               {
                  _loc8_ = new Point(Math.floor(_loc24_.x + _loc26_),_loc32_[_loc19_]);
                  _loc21_.push(_loc8_);
                  _loc19_++;
               }
            }
            else if(_loc31_.length > 0)
            {
               _loc20_ = 0;
               while(_loc20_ < _loc31_.length)
               {
                  _loc8_ = new Point(_loc31_[_loc20_],Math.floor(_loc24_.y + _loc27_));
                  _loc21_.push(_loc8_);
                  _loc20_++;
               }
            }
            else if(_loc33_ == 1)
            {
               _loc8_ = new Point(Math.floor(_loc24_.x + _loc26_),Math.floor(_loc24_.y + _loc27_));
               _loc21_.push(_loc8_);
            }
            _loc24_.x = (_loc24_.x * 100 + _loc26_ * 100) / 100;
            _loc24_.y = (_loc24_.y * 100 + _loc27_ * 100) / 100;
            _loc7_++;
         }
         return _loc21_;
      }
   }
}
