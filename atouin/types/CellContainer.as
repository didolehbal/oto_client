package com.ankamagames.atouin.types
{
   import com.ankamagames.jerakine.data.XmlConfig;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   
   public class CellContainer extends Sprite implements ICellContainer
   {
      
      private static var _ratio:Number;
      
      private static var cltr:ColorTransform;
       
      
      private var _cellId:int = 0;
      
      private var _layerId:int = 0;
      
      private var _startX:int = 0;
      
      private var _startY:int = 0;
      
      private var _depth:int = 0;
      
      public function CellContainer(param1:uint)
      {
         super();
         this.cellId = param1;
         name = "Cell_" + this.cellId;
      }
      
      public function get cellId() : uint
      {
         return this._cellId;
      }
      
      public function set cellId(param1:uint) : void
      {
         this._cellId = param1;
      }
      
      public function get layerId() : int
      {
         return this._layerId;
      }
      
      public function set layerId(param1:int) : void
      {
         this._layerId = param1;
      }
      
      public function get startX() : int
      {
         return this._startX;
      }
      
      public function set startX(param1:int) : void
      {
         this._startX = param1;
      }
      
      public function get startY() : int
      {
         return this._startY;
      }
      
      public function set startY(param1:int) : void
      {
         this._startY = param1;
      }
      
      public function get depth() : int
      {
         return this._depth;
      }
      
      public function set depth(param1:int) : void
      {
         this._depth = param1;
      }
      
      public function addFakeChild(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:* = undefined;
         if(isNaN(_ratio))
         {
            _loc4_ = XmlConfig.getInstance().getEntry("config.gfx.world.scaleRatio");
            _ratio = _loc4_ == null?Number(1):Number(parseFloat(_loc4_));
         }
         var _loc5_:DisplayObject = param1 as DisplayObject;
         if(param2 != null)
         {
            if(param1 is Bitmap)
            {
               _loc5_.x = param2.x * _ratio;
               _loc5_.y = param2.y * _ratio;
            }
            else
            {
               _loc5_.x = param2.x;
               _loc5_.y = param2.y;
            }
            _loc5_.alpha = param2.alpha;
            _loc5_.scaleX = param2.scaleX;
            _loc5_.scaleY = param2.scaleY;
         }
         if(param3 != null)
         {
            if(cltr == null)
            {
               cltr = new ColorTransform();
            }
            cltr.redMultiplier = param3.red;
            cltr.greenMultiplier = param3.green;
            cltr.blueMultiplier = param3.blue;
            cltr.alphaMultiplier = param3.alpha;
            _loc5_.transform.colorTransform = cltr;
         }
         addChild(_loc5_);
      }
   }
}
