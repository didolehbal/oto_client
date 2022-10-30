package com.ankamagames.berilia.components.gridRenderer
{
   import com.ankamagames.berilia.UIComponent;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.interfaces.IGridRenderer;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.Uri;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Transform;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class LabelGridRenderer implements IGridRenderer
   {
       
      
      protected var _log:Logger;
      
      private var _grid:Grid;
      
      private var _bgColor1:ColorTransform;
      
      private var _bgColor2:ColorTransform;
      
      private var _selectedColor:ColorTransform;
      
      private var _overColor:ColorTransform;
      
      private var _cssUri:Uri;
      
      private var _shapeIndex:Dictionary;
      
      public function LabelGridRenderer(param1:String)
      {
         var _loc2_:Array = null;
         this._log = Log.getLogger(getQualifiedClassName(LabelGridRenderer));
         this._shapeIndex = new Dictionary(true);
         super();
         if(param1)
         {
            _loc2_ = !!param1.length?param1.split(","):null;
            if(_loc2_[0] && _loc2_[0].length)
            {
               this._cssUri = new Uri(_loc2_[0]);
            }
            if(_loc2_[1] && _loc2_[1].length)
            {
               this._bgColor1 = new ColorTransform();
               this._bgColor1.color = parseInt(_loc2_[1],16);
            }
            if(_loc2_[2] && _loc2_[2].length)
            {
               this._bgColor2 = new ColorTransform();
               this._bgColor2.color = parseInt(_loc2_[2],16);
            }
            if(_loc2_[3] && _loc2_[3].length)
            {
               this._overColor = new ColorTransform();
               this._overColor.color = parseInt(_loc2_[3],16);
            }
            if(_loc2_[4] && _loc2_[4].length)
            {
               this._selectedColor = new ColorTransform();
               this._selectedColor.color = parseInt(_loc2_[4],16);
            }
         }
      }
      
      public function set grid(param1:Grid) : void
      {
         this._grid = param1;
      }
      
      public function render(param1:*, param2:uint, param3:Boolean, param4:uint = 0) : DisplayObject
      {
         var _loc5_:Label = null;
         (_loc5_ = new Label()).mouseEnabled = true;
         _loc5_.useHandCursor = true;
         _loc5_.mouseEnabled = true;
         _loc5_.width = this._grid.slotWidth - 6;
         _loc5_.height = this._grid.slotHeight;
         _loc5_.verticalAlign = "CENTER";
         _loc5_.name = this._grid.getUi().name + "::" + this._grid.name + "::item" + param2;
         if(param1 is String || param1 == null)
         {
            _loc5_.text = param1;
         }
         else
         {
            _loc5_.text = param1.label;
         }
         if(this._cssUri)
         {
            _loc5_.css = this._cssUri;
         }
         this.updateBackground(_loc5_,param2,param3);
         _loc5_.finalize();
         _loc5_.addEventListener(MouseEvent.MOUSE_OVER,this.onRollOver);
         _loc5_.addEventListener(MouseEvent.MOUSE_OUT,this.onRollOut);
         return _loc5_;
      }
      
      public function update(param1:*, param2:uint, param3:DisplayObject, param4:Boolean, param5:uint = 0) : void
      {
         var _loc6_:Label = null;
         if(param3 is Label)
         {
            _loc6_ = param3 as Label;
            if(param1 is String || param1 == null)
            {
               _loc6_.text = param1;
            }
            else
            {
               _loc6_.text = param1.label;
            }
            this.updateBackground(_loc6_,param2,param4);
         }
         else
         {
            this._log.warn("Can\'t update, " + param3.name + " is not a Label component");
         }
      }
      
      public function getDataLength(param1:*, param2:Boolean) : uint
      {
         return 1;
      }
      
      public function remove(param1:DisplayObject) : void
      {
         var _loc2_:Label = null;
         if(param1 is Label)
         {
            _loc2_ = param1 as Label;
            if(_loc2_.parent)
            {
               _loc2_.parent.removeChild(param1);
            }
            _loc2_.removeEventListener(MouseEvent.MOUSE_OUT,this.onRollOut);
            _loc2_.removeEventListener(MouseEvent.MOUSE_OVER,this.onRollOver);
         }
      }
      
      public function destroy() : void
      {
         this._grid = null;
         this._shapeIndex = null;
      }
      
      public function renderModificator(param1:Array) : Array
      {
         return param1;
      }
      
      public function eventModificator(param1:Message, param2:String, param3:Array, param4:UIComponent) : String
      {
         return param2;
      }
      
      private function updateBackground(param1:Label, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Shape = null;
         if(!this._shapeIndex[param1])
         {
            (_loc4_ = new Shape()).graphics.beginFill(16777215);
            _loc4_.graphics.drawRect(0,0,this._grid.slotWidth,this._grid.slotHeight + 1);
            param1.getStrata(0).addChild(_loc4_);
            this._shapeIndex[param1] = {
               "trans":new Transform(_loc4_),
               "shape":_loc4_
            };
         }
         var _loc5_:ColorTransform = !!(param2 % 2)?this._bgColor1:this._bgColor2;
         if(param3 && this._selectedColor)
         {
            _loc5_ = this._selectedColor;
         }
         this._shapeIndex[param1].currentColor = _loc5_;
         DisplayObject(this._shapeIndex[param1].shape).visible = _loc5_ != null;
         if(_loc5_)
         {
            Transform(this._shapeIndex[param1].trans).colorTransform = _loc5_;
         }
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Label = param1.currentTarget as Label;
         if(this._overColor && _loc3_.text.length > 0)
         {
            _loc2_ = this._shapeIndex[_loc3_];
            if(_loc2_)
            {
               Transform(_loc2_.trans).colorTransform = this._overColor;
               DisplayObject(_loc2_.shape).visible = true;
            }
         }
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Label = param1.currentTarget as Label;
         if(_loc3_.text.length > 0)
         {
            _loc2_ = this._shapeIndex[_loc3_];
            if(_loc2_)
            {
               if(_loc2_.currentColor)
               {
                  Transform(_loc2_.trans).colorTransform = _loc2_.currentColor;
               }
               DisplayObject(_loc2_.shape).visible = _loc2_.currentColor != null;
            }
         }
      }
   }
}
