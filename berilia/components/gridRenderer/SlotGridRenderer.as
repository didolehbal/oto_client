package com.ankamagames.berilia.components.gridRenderer
{
   import com.ankamagames.berilia.UIComponent;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Slot;
   import com.ankamagames.berilia.interfaces.IClonable;
   import com.ankamagames.berilia.interfaces.IGridRenderer;
   import com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.types.data.LinkedCursorData;
   import com.ankamagames.jerakine.interfaces.ICustomSecureObject;
   import com.ankamagames.jerakine.interfaces.ISlotData;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.Uri;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.utils.getQualifiedClassName;
   import gs.TweenMax;
   import gs.easing.Quart;
   import gs.events.TweenEvent;
   
   public class SlotGridRenderer implements IGridRenderer, ICustomSecureObject
   {
       
      
      protected var _log:Logger;
      
      private var _grid:Grid;
      
      private var _emptyTexture:Uri;
      
      private var _overTexture:Uri;
      
      private var _selectedTexture:Uri;
      
      private var _acceptDragTexture:Uri;
      
      private var _refuseDragTexture:Uri;
      
      private var _customTexture:Uri;
      
      private var _timerTexture:Uri;
      
      private var _cssUri:Uri;
      
      private var _allowDrop:Boolean;
      
      private var _isButton:Boolean;
      
      private var _hideQuantities:Boolean = false;
      
      private var _useTextureCache:Boolean = true;
      
      [Untrusted]
      public var dropValidatorFunction:Function;
      
      [Untrusted]
      public var processDropFunction:Function;
      
      [Untrusted]
      public var removeDropSourceFunction:Function;
      
      public function SlotGridRenderer(param1:String)
      {
         this._log = Log.getLogger(getQualifiedClassName(SlotGridRenderer));
         super();
         var _loc2_:Array = !!param1?param1.split(","):[];
         this._emptyTexture = _loc2_[0] && _loc2_[0].length?new Uri(_loc2_[0]):null;
         this._overTexture = _loc2_[1] && _loc2_[1].length?new Uri(_loc2_[1]):null;
         this._selectedTexture = _loc2_[2] && _loc2_[2].length?new Uri(_loc2_[2]):null;
         this._acceptDragTexture = _loc2_[3] && _loc2_[3].length?new Uri(_loc2_[3]):null;
         this._refuseDragTexture = _loc2_[4] && _loc2_[4].length?new Uri(_loc2_[4]):null;
         this._timerTexture = _loc2_[5] && _loc2_[5].length?new Uri(_loc2_[5]):null;
         this._cssUri = _loc2_[6] && _loc2_[6].length?new Uri(_loc2_[6]):null;
         this._allowDrop = _loc2_[7] && _loc2_[7].length?_loc2_[7] == "true":true;
         this._isButton = _loc2_[8] && _loc2_[8].length?_loc2_[8] == "true":false;
      }
      
      [Untrusted]
      public function set allowDrop(param1:Boolean) : void
      {
         this._allowDrop = param1;
      }
      
      public function get allowDrop() : Boolean
      {
         return this._allowDrop;
      }
      
      [Untrusted]
      public function set isButton(param1:Boolean) : void
      {
         this._isButton = param1;
      }
      
      public function get isButton() : Boolean
      {
         return this._isButton;
      }
      
      [Untrusted]
      public function set hideQuantities(param1:Boolean) : void
      {
         this._hideQuantities = param1;
      }
      
      public function get hideQuantities() : Boolean
      {
         return this._hideQuantities;
      }
      
      public function get acceptDragTexture() : Uri
      {
         return this._acceptDragTexture;
      }
      
      [Untrusted]
      public function set acceptDragTexture(param1:Uri) : void
      {
         this._acceptDragTexture = param1;
      }
      
      public function get refuseDragTexture() : Uri
      {
         return this._refuseDragTexture;
      }
      
      [Untrusted]
      public function set refuseDragTexture(param1:Uri) : void
      {
         this._refuseDragTexture = param1;
      }
      
      public function get customTexture() : Uri
      {
         return this._customTexture;
      }
      
      [Untrusted]
      public function set customTexture(param1:Uri) : void
      {
         this._customTexture = param1;
      }
      
      [Untrusted]
      public function set grid(param1:Grid) : void
      {
         this._grid = param1;
      }
      
      [Untrusted]
      public function set useTextureCache(param1:Boolean) : void
      {
         this._useTextureCache = param1;
      }
      
      public function get useTextureCache() : Boolean
      {
         return this._useTextureCache;
      }
      
      public function render(param1:*, param2:uint, param3:Boolean, param4:uint = 0) : DisplayObject
      {
         var _loc5_:* = SecureCenter.unsecure(param1);
         var _loc6_:Slot;
         (_loc6_ = new Slot()).name = this._grid.getUi().name + "::" + this._grid.name + "::item" + param2;
         _loc6_.mouseEnabled = true;
         _loc6_.emptyTexture = this._emptyTexture;
         _loc6_.highlightTexture = this._overTexture;
         _loc6_.timerTexture = this._timerTexture;
         _loc6_.selectedTexture = this._selectedTexture;
         _loc6_.acceptDragTexture = this._acceptDragTexture;
         _loc6_.refuseDragTexture = this._refuseDragTexture;
         _loc6_.customTexture = this._customTexture;
         _loc6_.css = this._cssUri;
         _loc6_.isButton = this._isButton;
         _loc6_.useTextureCache = this._useTextureCache;
         if(this._hideQuantities)
         {
            _loc6_.hideTopLabel = true;
         }
         else
         {
            _loc6_.hideTopLabel = false;
         }
         _loc6_.width = this._grid.slotWidth;
         _loc6_.height = this._grid.slotHeight;
         if(this._isButton)
         {
            _loc6_.selected = param3;
         }
         else
         {
            _loc6_.allowDrag = this._allowDrop;
         }
         _loc6_.data = _loc5_;
         _loc6_.processDrop = this._processDrop;
         _loc6_.removeDropSource = this._removeDropSourceFunction;
         _loc6_.dropValidator = this._dropValidatorFunction;
         _loc6_.finalize();
         return _loc6_;
      }
      
      public function _removeDropSourceFunction(param1:*) : void
      {
         var _loc2_:* = undefined;
         if(this.removeDropSourceFunction != null)
         {
            this.removeDropSourceFunction(param1);
            return;
         }
         var _loc3_:Array = new Array();
         var _loc4_:Boolean = true;
         for each(_loc2_ in this._grid.dataProvider)
         {
            if(_loc2_ != param1.data)
            {
               _loc3_.push(_loc2_);
            }
         }
         this._grid.dataProvider = _loc3_;
      }
      
      public function _dropValidatorFunction(param1:Object, param2:*, param3:Object) : Boolean
      {
         if(this.dropValidatorFunction != null)
         {
            return this.dropValidatorFunction(param1,param2,param3);
         }
         return true;
      }
      
      public function update(param1:*, param2:uint, param3:DisplayObject, param4:Boolean, param5:uint = 0) : void
      {
         var _loc6_:Slot = null;
         if(param3 is Slot)
         {
            (_loc6_ = Slot(param3)).data = SecureCenter.unsecure(param1) as ISlotData;
            if(!this._isButton)
            {
               _loc6_.selected = param4;
               _loc6_.allowDrag = this._allowDrop;
            }
            _loc6_.isButton = this._isButton;
            if(this._hideQuantities)
            {
               _loc6_.hideTopLabel = true;
            }
            else
            {
               _loc6_.hideTopLabel = false;
            }
            _loc6_.dropValidator = this._dropValidatorFunction;
            _loc6_.removeDropSource = this._removeDropSourceFunction;
            _loc6_.processDrop = this._processDrop;
         }
         else
         {
            this._log.warn("Can\'t update, " + param3.name + " is not a Slot component");
         }
      }
      
      public function getDataLength(param1:*, param2:Boolean) : uint
      {
         return 1;
      }
      
      public function remove(param1:DisplayObject) : void
      {
         if(param1 is Slot && param1.parent)
         {
            Slot(param1).remove();
         }
      }
      
      public function destroy() : void
      {
         this._grid = null;
         this._emptyTexture = null;
         this._overTexture = null;
         this._timerTexture = null;
         this._selectedTexture = null;
         this._acceptDragTexture = null;
         this._refuseDragTexture = null;
         this._customTexture = null;
         this._cssUri = null;
      }
      
      public function _processDrop(param1:*, param2:*, param3:*) : void
      {
         var _loc4_:LinkedCursorData = null;
         var _loc5_:Point = null;
         var _loc6_:DisplayObject = null;
         var _loc7_:Boolean = false;
         if(!this._allowDrop)
         {
            return;
         }
         if(this.processDropFunction != null)
         {
            this.processDropFunction(param1,param2,param3);
            return;
         }
         if(DisplayObject(param2.holder).parent != this._grid)
         {
            if(param2 is IClonable)
            {
               this._grid.dataProvider.push((param2 as IClonable).clone());
            }
            else
            {
               this._grid.dataProvider.push(param2);
            }
            this._grid.dataProvider = this._grid.dataProvider;
         }
         else
         {
            _loc7_ = true;
         }
         _loc4_ = LinkedCursorSpriteManager.getInstance().getItem(Slot.DRAG_AND_DROP_CURSOR_NAME);
         if(_loc7_ || !this._grid.indexIsInvisibleSlot(this._grid.dataProvider.length - 1))
         {
            _loc5_ = (_loc6_ = DisplayObject(param2.holder)).localToGlobal(new Point(_loc6_.x,_loc6_.y));
            TweenMax.to(_loc4_.sprite,0.5,{
               "x":_loc5_.x,
               "y":_loc5_.y,
               "alpha":0,
               "ease":Quart.easeOut,
               "onCompleteListener":this.onTweenEnd
            });
         }
         else
         {
            _loc5_ = this._grid.localToGlobal(new Point(this._grid.x,this._grid.y));
            _loc4_.sprite.stopDrag();
            TweenMax.to(_loc4_.sprite,0.5,{
               "x":_loc5_.x + this._grid.width / 2,
               "y":_loc5_.y + this._grid.height,
               "alpha":0,
               "scaleX":0.1,
               "scaleY":0.1,
               "ease":Quart.easeOut,
               "onCompleteListener":this.onTweenEnd
            });
         }
      }
      
      public function renderModificator(param1:Array) : Array
      {
         return param1;
      }
      
      public function eventModificator(param1:Message, param2:String, param3:Array, param4:UIComponent) : String
      {
         return param2;
      }
      
      private function onTweenEnd(param1:TweenEvent) : void
      {
         LinkedCursorSpriteManager.getInstance().removeItem(Slot.DRAG_AND_DROP_CURSOR_NAME);
      }
   }
}
