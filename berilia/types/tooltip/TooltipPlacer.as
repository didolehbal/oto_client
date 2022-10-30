package com.ankamagames.berilia.types.tooltip
{
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.berilia.types.event.UiRenderEvent;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.display.Rectangle2;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class TooltipPlacer
   {
      
      protected static var _log:Logger = Log.getLogger(getQualifiedClassName(TooltipPlacer));
      
      private static var _tooltips:Vector.<TooltipPosition> = new Vector.<TooltipPosition>(0);
      
      private static var _tooltipsRows:Dictionary = new Dictionary();
      
      private static var _tooltipsToWait:Vector.<String> = new Vector.<String>(0);
      
      private static const _anchors:Array = [];
      
      private static var _init:Boolean;
       
      
      public function TooltipPlacer()
      {
         super();
      }
      
      private static function init() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(_init)
         {
            return;
         }
         _init = true;
         var _loc3_:Array = [LocationEnum.POINT_TOPLEFT,LocationEnum.POINT_TOP,LocationEnum.POINT_TOPRIGHT,LocationEnum.POINT_LEFT,LocationEnum.POINT_CENTER,LocationEnum.POINT_RIGHT,LocationEnum.POINT_BOTTOMLEFT,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_BOTTOMRIGHT];
         for each(_loc1_ in _loc3_)
         {
            for each(_loc2_ in _loc3_)
            {
               _anchors.push({
                  "p1":_loc1_,
                  "p2":_loc2_
               });
            }
         }
      }
      
      private static function getAnchors() : Array
      {
         init();
         return _anchors.concat();
      }
      
      public static function place(param1:DisplayObject, param2:IRectangle, param3:uint = 6, param4:uint = 0, param5:int = 3, param6:Boolean = true) : void
      {
         var _loc7_:Point = null;
         var _loc8_:Point = null;
         var _loc9_:Rectangle2 = null;
         var _loc10_:Point = null;
         var _loc11_:Rectangle2 = null;
         var _loc12_:int = 0;
         var _loc13_:Object = null;
         var _loc14_:Object = null;
         var _loc15_:Object = null;
         var _loc16_:* = false;
         var _loc20_:Boolean = false;
         var _loc17_:Rectangle = param1.getBounds(param1);
         var _loc18_:uint = param3;
         var _loc19_:uint = param4;
         var _loc21_:Array = getAnchors();
         var _loc22_:Array = new Array();
         while(!_loc16_)
         {
            _loc7_ = new Point(param2.x,param2.y);
            _loc8_ = new Point(param1.x,param1.y);
            _loc9_ = new Rectangle2(param1.x,param1.y,param1.width,param1.height);
            processAnchor(_loc8_,_loc9_,param3);
            processAnchor(_loc7_,param2,param4);
            _loc10_ = makeOffset(param3,param5);
            _loc7_.x = _loc7_.x - (_loc8_.x - _loc10_.x + _loc17_.left);
            _loc7_.y = _loc7_.y - (_loc8_.y - _loc10_.y);
            _loc11_ = new Rectangle2(_loc7_.x,_loc7_.y,_loc9_.width,_loc9_.height);
            if(param6)
            {
               if(_loc11_.y < 0)
               {
                  _loc11_.y = 0;
               }
               if(_loc11_.x < 0)
               {
                  _loc11_.x = 0;
               }
               if(_loc11_.y + _loc11_.height > StageShareManager.startHeight)
               {
                  _loc11_.y = _loc11_.y - (_loc11_.height + _loc11_.y - StageShareManager.startHeight);
               }
               if(_loc11_.x + _loc11_.width > StageShareManager.startWidth)
               {
                  _loc11_.x = _loc11_.x - (_loc11_.width + _loc11_.x - StageShareManager.startWidth);
               }
            }
            if(!_loc20_)
            {
               if(!(_loc16_ = (_loc12_ = hitTest(_loc11_,param2)) == 0))
               {
                  if(!(_loc13_ = _loc21_.shift()))
                  {
                     _loc14_ = {
                        "size":param2.width * param2.height,
                        "point":{
                           "p1":_loc18_,
                           "p2":_loc19_
                        }
                     };
                     for each(_loc15_ in _loc22_)
                     {
                        if(_loc14_.size > _loc15_.size)
                        {
                           _loc14_ = _loc15_;
                        }
                     }
                     _loc20_ = true;
                     param3 = _loc14_.point.p1;
                     param4 = _loc14_.point.p2;
                  }
                  else
                  {
                     _loc22_.push({
                        "size":_loc12_,
                        "point":{
                           "p1":param3,
                           "p2":param4
                        }
                     });
                     param3 = _loc13_.p1;
                     param4 = _loc13_.p2;
                  }
               }
            }
            else
            {
               _loc16_ = true;
            }
         }
         param1.x = _loc11_.x;
         param1.y = _loc11_.y;
      }
      
      public static function placeWithArrow(param1:DisplayObject, param2:IRectangle) : Object
      {
         var _loc3_:Point = new Point(param1.x,param1.y);
         var _loc4_:Object = {
            "bottomFlip":false,
            "leftFlip":false
         };
         _loc3_.x = param2.x + param2.width / 2 + 5;
         _loc3_.y = param2.y - param1.height;
         if(_loc3_.x + param1.width > StageShareManager.startWidth)
         {
            _loc4_.leftFlip = true;
            _loc3_.x = _loc3_.x - (param1.width + 10);
         }
         if(_loc3_.y < 0)
         {
            _loc4_.bottomFlip = true;
            _loc3_.y = param2.y + param2.height;
         }
         param1.x = _loc3_.x;
         param1.y = _loc3_.y;
         return _loc4_;
      }
      
      public static function waitBeforeOrder(param1:String) : void
      {
         if(_tooltipsToWait.indexOf(param1) == -1)
         {
            _tooltipsToWait.push(param1);
         }
      }
      
      public static function addTooltipPosition(param1:UiRootContainer, param2:IRectangle, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc6_:Boolean = false;
         var _loc5_:int = _tooltips.length;
         var _loc7_:String;
         if(!(_loc7_ = TooltipManager.getTooltipName(param1)))
         {
            _loc7_ = param1.customUnicName;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(_tooltips[_loc4_].tooltip == param1)
            {
               _loc6_ = true;
               _tooltips.splice(_loc4_,1,new TooltipPosition(param1,param2,param3));
               break;
            }
            _loc4_++;
         }
         if(!_loc6_)
         {
            _tooltips.push(new TooltipPosition(param1,param2,param3));
         }
         var _loc8_:int;
         if((_loc8_ = _tooltipsToWait.indexOf(_loc7_)) != -1)
         {
            _tooltipsToWait.splice(_loc8_,1);
         }
         if(_tooltipsToWait.length == 0)
         {
            checkRender();
         }
      }
      
      public static function checkRender(param1:Event = null) : void
      {
         var _loc2_:TooltipPosition = null;
         if(param1)
         {
            param1.currentTarget.removeEventListener(UiRenderEvent.UIRenderComplete,checkRender);
         }
         for each(_loc2_ in _tooltips)
         {
            if(!_loc2_.tooltip.ready)
            {
               _loc2_.tooltip.addEventListener(UiRenderEvent.UIRenderComplete,checkRender);
               return;
            }
         }
         orderTooltips();
      }
      
      public static function removeTooltipPosition(param1:UiRootContainer) : void
      {
         var _loc2_:TooltipPosition = null;
         var _loc3_:int = 0;
         var _loc4_:int = -1;
         for each(_loc2_ in _tooltips)
         {
            if(_loc2_.tooltip == param1)
            {
               _loc4_ = _tooltips.indexOf(_loc2_);
               break;
            }
         }
         if(_loc4_ != -1)
         {
            _tooltips.splice(_loc4_,1);
         }
         var _loc5_:String = TooltipManager.getTooltipName(param1);
         _loc3_ = _tooltipsToWait.indexOf(_loc5_);
         if(_loc3_ != -1)
         {
            _tooltipsToWait.splice(_loc3_,1);
         }
      }
      
      public static function removeTooltipPositionByName(param1:String) : void
      {
         var _loc2_:TooltipPosition = null;
         var _loc3_:int = 0;
         var _loc4_:int = -1;
         for each(_loc2_ in _tooltips)
         {
            if(_loc2_.tooltip.customUnicName == param1)
            {
               _loc4_ = _tooltips.indexOf(_loc2_);
               break;
            }
         }
         if(_loc4_ != -1)
         {
            _tooltips.splice(_loc4_,1);
         }
         _loc3_ = _tooltipsToWait.indexOf(param1);
         if(_loc3_ != -1)
         {
            _tooltipsToWait.splice(_loc3_,1);
         }
      }
      
      private static function orderTooltips() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TooltipPosition = null;
         var _loc4_:Vector.<TooltipPosition> = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Boolean = false;
         var _loc11_:Number = NaN;
         var _loc12_:Boolean = false;
         var _loc13_:Number = NaN;
         var _loc14_:Boolean = false;
         var _loc15_:* = null;
         var _loc16_:int = _tooltips.length;
         var _loc17_:Number = 0;
         var _loc18_:Number = 0;
         var _loc19_:Number = 0;
         _tooltips.sort(compareVerticalPos);
         _loc1_ = _loc16_ - 1;
         while(_loc1_ >= 0)
         {
            _loc8_ = _tooltips[_loc1_].mapRow;
            if(!_tooltipsRows[_loc8_])
            {
               _tooltipsRows[_loc8_] = new Vector.<TooltipPosition>(0);
            }
            _loc4_ = isTooltipSuperposed(_tooltips[_loc1_]);
            _loc12_ = false;
            for each(_loc3_ in _loc4_)
            {
               if(_loc3_.mapRow == _loc8_ && _loc3_.tooltip.customUnicName != _tooltips[_loc1_].tooltip.customUnicName)
               {
                  _loc12_ = true;
                  break;
               }
            }
            if(_loc12_)
            {
               _tooltipsRows[_loc8_].push(_tooltips[_loc1_]);
            }
            if(_loc1_ + 1 < _loc16_)
            {
               if((_loc7_ = _tooltipsRows[_loc8_].length) > 1)
               {
                  _loc6_ = 0;
                  _loc17_ = 0;
                  _loc19_ = 0;
                  _loc18_ = 0;
                  for each(_loc3_ in _tooltipsRows[_loc8_])
                  {
                     _loc18_ = _loc18_ == 0?Number(_loc3_.tooltip.y):_loc3_.tooltip.y < _loc18_?Number(_loc3_.tooltip.y):Number(_loc18_);
                  }
                  _loc2_ = _loc1_ + 1;
                  while(_loc2_ < _loc16_)
                  {
                     if(_tooltips[_loc2_].mapRow != _loc8_ && _loc18_ > _tooltips[_loc2_].tooltip.y - _tooltips[_loc1_].tooltip.height - 2)
                     {
                        _loc18_ = _tooltips[_loc2_].tooltip.y - _tooltips[_loc1_].tooltip.height - 2;
                        break;
                     }
                     _loc2_++;
                  }
                  for each(_loc3_ in _tooltipsRows[_loc8_])
                  {
                     _loc3_.tooltip.y = _loc18_;
                  }
                  _loc17_ = _loc19_ = _tooltips[_loc1_].target.x;
                  for each(_loc3_ in _tooltipsRows[_loc8_])
                  {
                     if(_loc3_.target.x < _loc17_)
                     {
                        _loc17_ = _loc3_.target.x;
                     }
                     else if(_loc3_.target.x > _loc19_)
                     {
                        _loc19_ = _loc3_.target.x;
                     }
                     _loc6_ = _loc6_ + _loc3_.tooltip.width;
                  }
                  _tooltipsRows[_loc8_].sort(compareHorizontalPos);
                  if((_loc7_ = _tooltipsRows[_loc8_].length) > 0)
                  {
                     _loc6_ = _loc6_ + 2 * (_loc7_ - 1);
                     _loc5_ = _loc19_ - (_loc19_ - _loc17_) / 2;
                     _tooltipsRows[_loc8_][0].tooltip.x = _loc5_ + 43 - _loc6_ / 2;
                     _loc2_ = 1;
                     while(_loc2_ < _loc7_)
                     {
                        _tooltipsRows[_loc8_][_loc2_].tooltip.x = _tooltipsRows[_loc8_][_loc2_ - 1].tooltip.x + _tooltipsRows[_loc8_][_loc2_ - 1].tooltip.width + 2;
                        _loc2_++;
                     }
                  }
               }
               else
               {
                  _loc10_ = false;
                  while(!_loc10_)
                  {
                     _loc2_ = _loc1_ + 1;
                     while(_loc2_ < _loc16_)
                     {
                        _loc10_ = true;
                        if(hitTest(_tooltips[_loc1_].rect,_tooltips[_loc2_].rect) != 0)
                        {
                           if((_loc11_ = _tooltips[_loc2_].tooltip.y - _tooltips[_loc1_].tooltip.height - 2) < 0)
                           {
                              _tooltips[_loc1_].tooltip.y = 0;
                              _loc3_ = _tooltips[_loc2_];
                              _loc13_ = _tooltips[_loc1_].tooltip.x;
                              if(_tooltips[_loc1_].originalX < _loc3_.originalX)
                              {
                                 _tooltips[_loc1_].tooltip.x = _loc3_.tooltip.x - _tooltips[_loc1_].tooltip.width - 2;
                              }
                              else
                              {
                                 _tooltips[_loc1_].tooltip.x = _loc3_.tooltip.x + _loc3_.tooltip.width + 2;
                              }
                              if((_loc14_ = _tooltips[_loc1_].tooltip.x < 0 || _tooltips[_loc1_].tooltip.x + _tooltips[_loc1_].tooltip.width + 2 > StageShareManager.stage.stageWidth) || isTooltipSuperposed(_tooltips[_loc1_]))
                              {
                                 _tooltips[_loc1_].tooltip.x = _loc13_;
                                 _tooltips[_loc1_].tooltip.y = _loc11_;
                              }
                           }
                           else
                           {
                              _tooltips[_loc1_].tooltip.y = _loc11_;
                           }
                           _loc10_ = false;
                           break;
                        }
                        _loc2_++;
                     }
                  }
               }
            }
            _loc1_--;
         }
         for(_loc15_ in _tooltipsRows)
         {
            delete _tooltipsRows[_loc15_];
         }
      }
      
      private static function isTooltipSuperposed(param1:TooltipPosition) : Vector.<TooltipPosition>
      {
         var _loc2_:TooltipPosition = null;
         var _loc3_:Vector.<TooltipPosition> = null;
         for each(_loc2_ in _tooltips)
         {
            if(_loc2_ != param1 && hitTest(_loc2_.rect,param1.rect) != 0)
            {
               if(!_loc3_)
               {
                  _loc3_ = new Vector.<TooltipPosition>(0);
               }
               _loc3_.push(_loc2_);
            }
         }
         return _loc3_;
      }
      
      private static function compareVerticalPos(param1:TooltipPosition, param2:TooltipPosition) : int
      {
         var _loc3_:int = 0;
         if(param1.mapRow > param2.mapRow)
         {
            _loc3_ = 1;
         }
         else if(param1.mapRow < param2.mapRow)
         {
            _loc3_ = -1;
         }
         else
         {
            _loc3_ = 0;
         }
         return _loc3_;
      }
      
      private static function compareHorizontalPos(param1:TooltipPosition, param2:TooltipPosition) : int
      {
         var _loc3_:int = 0;
         if(param1.tooltip.x > param2.tooltip.x)
         {
            _loc3_ = 1;
         }
         else if(param1.tooltip.x < param2.tooltip.x)
         {
            _loc3_ = -1;
         }
         else
         {
            _loc3_ = 0;
         }
         return _loc3_;
      }
      
      private static function hitTest(param1:IRectangle, param2:IRectangle) : int
      {
         var _loc3_:Rectangle = new Rectangle(param1.x,param1.y,param1.width,param1.height);
         var _loc4_:Rectangle = new Rectangle(param2.x,param2.y,param2.width,param2.height);
         var _loc5_:Rectangle;
         return (_loc5_ = _loc3_.intersection(_loc4_)).width * _loc5_.height;
      }
      
      private static function processAnchor(param1:Point, param2:IRectangle, param3:uint) : Point
      {
         switch(param3)
         {
            case LocationEnum.POINT_TOPLEFT:
               break;
            case LocationEnum.POINT_TOP:
               param1.x = param1.x + param2.width / 2;
               break;
            case LocationEnum.POINT_TOPRIGHT:
               param1.x = param1.x + param2.width;
               break;
            case LocationEnum.POINT_LEFT:
               param1.y = param1.y + param2.height / 2;
               break;
            case LocationEnum.POINT_CENTER:
               param1.x = param1.x + param2.width / 2;
               param1.y = param1.y + param2.height / 2;
               break;
            case LocationEnum.POINT_RIGHT:
               param1.x = param1.x + param2.width;
               param1.y = param1.y + param2.height / 2;
               break;
            case LocationEnum.POINT_BOTTOMLEFT:
               param1.y = param1.y + param2.height;
               break;
            case LocationEnum.POINT_BOTTOM:
               param1.x = param1.x + param2.width / 2;
               param1.y = param1.y + param2.height;
               break;
            case LocationEnum.POINT_BOTTOMRIGHT:
               param1.x = param1.x + param2.width;
               param1.y = param1.y + param2.height;
         }
         return param1;
      }
      
      private static function makeOffset(param1:uint, param2:uint) : Point
      {
         var _loc3_:Point = new Point();
         switch(param1)
         {
            case LocationEnum.POINT_TOPLEFT:
            case LocationEnum.POINT_BOTTOMLEFT:
            case LocationEnum.POINT_LEFT:
               _loc3_.x = param2;
               break;
            case LocationEnum.POINT_TOP:
               break;
            case LocationEnum.POINT_BOTTOMRIGHT:
            case LocationEnum.POINT_TOPRIGHT:
            case LocationEnum.POINT_RIGHT:
               _loc3_.x = -param2;
         }
         switch(param1)
         {
            case LocationEnum.POINT_TOPLEFT:
            case LocationEnum.POINT_TOP:
            case LocationEnum.POINT_TOPRIGHT:
               _loc3_.y = param2;
               break;
            case LocationEnum.POINT_BOTTOMLEFT:
            case LocationEnum.POINT_BOTTOMRIGHT:
            case LocationEnum.POINT_BOTTOM:
               _loc3_.y = -param2;
         }
         return _loc3_;
      }
   }
}
