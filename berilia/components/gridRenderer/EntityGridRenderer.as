package com.ankamagames.berilia.components.gridRenderer
{
   import com.ankamagames.berilia.UIComponent;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.interfaces.IGridRenderer;
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.Uri;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.utils.getQualifiedClassName;
   
   public class EntityGridRenderer implements IGridRenderer
   {
       
      
      protected var _log:Logger;
      
      private var _grid:Grid;
      
      private var _emptyTexture:Uri;
      
      private var _mask:Sprite;
      
      public function EntityGridRenderer(param1:String)
      {
         this._log = Log.getLogger(getQualifiedClassName(EntityGridRenderer));
         super();
         var _loc2_:Array = !!param1?param1.split(","):[];
         this._emptyTexture = _loc2_[0] && _loc2_[0].length?new Uri(_loc2_[0]):null;
         this._mask = new Sprite();
      }
      
      public function set grid(param1:Grid) : void
      {
         this._grid = param1;
      }
      
      public function render(param1:*, param2:uint, param3:Boolean, param4:uint = 0) : DisplayObject
      {
         var _loc5_:EntityDisplayer = null;
         var _loc6_:GraphicContainer;
         (_loc6_ = new GraphicContainer()).mouseEnabled = true;
         var _loc7_:Texture;
         (_loc7_ = new Texture()).width = this._grid.slotWidth;
         _loc7_.height = this._grid.slotHeight;
         _loc7_.uri = this._emptyTexture;
         _loc7_.finalize();
         _loc6_.addChild(_loc7_);
         _loc6_.width = this._grid.slotWidth;
         _loc6_.height = this._grid.slotHeight;
         if(param1)
         {
            (_loc5_ = new EntityDisplayer()).name = "entity";
            _loc5_.width = this._grid.slotWidth;
            _loc5_.height = this._grid.slotHeight;
            _loc5_.direction = 3;
            _loc5_.entityScale = 2;
            _loc5_.yOffset = 20;
            _loc5_.look = param1.entityLook;
            _loc6_.addChild(_loc5_);
            this._mask = new Sprite();
            this._mask.graphics.beginFill(16711680);
            this._mask.graphics.drawRoundRect(3,3,_loc6_.width - 6,_loc6_.height - 6,6,6);
            this._mask.graphics.endFill();
            _loc6_.addChild(this._mask);
            _loc5_.mask = this._mask;
         }
         return _loc6_;
      }
      
      public function update(param1:*, param2:uint, param3:DisplayObject, param4:Boolean, param5:uint = 0) : void
      {
         var _loc6_:GraphicContainer = null;
         var _loc7_:EntityDisplayer = null;
         var _loc8_:EntityDisplayer = null;
         if(param3 is GraphicContainer)
         {
            (_loc6_ = GraphicContainer(param3)).mouseEnabled = true;
            _loc7_ = _loc6_.getChildByName("entity") as EntityDisplayer;
            if(param1)
            {
               if(_loc7_)
               {
                  if(_loc7_.look.toString() == param1.entityLook.toString())
                  {
                     return;
                  }
                  _loc7_.look = SecureCenter.unsecure(param1.entityLook);
               }
               else
               {
                  (_loc8_ = new EntityDisplayer()).name = "entity";
                  _loc8_.width = this._grid.slotWidth;
                  _loc8_.height = this._grid.slotHeight;
                  _loc8_.look = SecureCenter.unsecure(param1.entityLook);
                  _loc8_.direction = 3;
                  _loc8_.entityScale = 2;
                  _loc8_.yOffset = 20;
                  _loc6_.addChild(_loc8_);
                  this._mask = new Sprite();
                  this._mask.graphics.beginFill(255);
                  this._mask.graphics.drawRoundRect(3,3,_loc6_.width - 6,_loc6_.height - 6,6,6);
                  this._mask.graphics.endFill();
                  _loc6_.addChild(this._mask);
                  _loc8_.mask = this._mask;
               }
            }
            else if(_loc7_)
            {
               _loc6_.removeChild(_loc7_);
               if(this._mask && _loc6_.getChildByName(this._mask.name))
               {
                  _loc6_.removeChild(this._mask);
               }
               _loc7_.remove();
            }
         }
      }
      
      public function getDataLength(param1:*, param2:Boolean) : uint
      {
         return param1 % 2;
      }
      
      public function remove(param1:DisplayObject) : void
      {
         var _loc2_:EntityDisplayer = null;
         var _loc3_:DisplayObject = null;
         if(param1 is GraphicContainer)
         {
            _loc2_ = GraphicContainer(param1).getChildByName("entity") as EntityDisplayer;
            if(_loc2_)
            {
               _loc2_.remove();
            }
            _loc3_ = GraphicContainer(param1).getChildByName(this._mask.name);
            if(_loc3_)
            {
               GraphicContainer(param1).removeChild(_loc3_);
            }
            GraphicContainer(param1).remove();
         }
      }
      
      public function destroy() : void
      {
         this._grid = null;
         this._emptyTexture = null;
         this._mask = null;
      }
      
      public function renderModificator(param1:Array) : Array
      {
         return param1;
      }
      
      public function eventModificator(param1:Message, param2:String, param3:Array, param4:UIComponent) : String
      {
         return param2;
      }
   }
}
