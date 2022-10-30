package com.ankamagames.atouin.managers
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.types.GraphicCell;
   import com.ankamagames.atouin.utils.errors.AtouinError;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.interfaces.ITransparency;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.utils.display.Rectangle2;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class EntitiesDisplayManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(EntitiesDisplayManager));
      
      private static var _self:EntitiesDisplayManager;
       
      
      public var _dStrataRef:Dictionary;
      
      public function EntitiesDisplayManager()
      {
         this._dStrataRef = new Dictionary(true);
         super();
         if(_self)
         {
            throw new SingletonError("Warning : MobilesManager is a singleton class and shoulnd\'t be instancied directly!");
         }
      }
      
      public static function getInstance() : EntitiesDisplayManager
      {
         if(!_self)
         {
            _self = new EntitiesDisplayManager();
         }
         return _self;
      }
      
      public function displayEntity(param1:IDisplayable, param2:MapPoint, param3:uint = 0) : void
      {
         var displayObject:DisplayObject = null;
         var cellSprite:Sprite = null;
         var oEntity:IDisplayable = param1;
         var cellCoords:MapPoint = param2;
         var strata:uint = param3;
         try
         {
            displayObject = oEntity as DisplayObject;
         }
         catch(te:TypeError)
         {
            throw new AtouinError("Entities implementing IDisplayable should extends DisplayObject.");
         }
         if(this._dStrataRef[oEntity] != null)
         {
            strata = this._dStrataRef[oEntity];
         }
         else
         {
            this._dStrataRef[oEntity] = strata;
         }
         if(!cellCoords)
         {
            return;
         }
         cellSprite = InteractiveCellManager.getInstance().getCell(cellCoords.cellId);
         displayObject.x = cellSprite.x + cellSprite.width / 2;
         displayObject.y = cellSprite.y + cellSprite.height / 2;
         if(strata == PlacementStrataEnums.STRATA_NO_Z_ORDER)
         {
            if(Atouin.getInstance().options.transparentOverlayMode)
            {
               if(displayObject is ITransparency && ITransparency(displayObject).getIsTransparencyAllowed())
               {
                  displayObject.alpha = displayObject.alpha != 1?Number(displayObject.alpha):Number(AtouinConstants.OVERLAY_MODE_ALPHA);
               }
               else
               {
                  displayObject.alpha = 1;
               }
               Atouin.getInstance().gfxContainer.addChild(displayObject);
            }
            else
            {
               displayObject.alpha = 1;
               Atouin.getInstance().selectionContainer.addChild(displayObject);
            }
         }
         else if(strata == PlacementStrataEnums.STRATA_FOREGROUND)
         {
            Atouin.getInstance().gfxContainer.addChild(displayObject);
         }
         else
         {
            this.orderEntity(displayObject,cellSprite);
         }
      }
      
      public function refreshAlphaEntity(param1:IDisplayable, param2:MapPoint, param3:uint = 0) : void
      {
         var displayObject:DisplayObject = null;
         var cellSprite:Sprite = null;
         var oEntity:IDisplayable = param1;
         var cellCoords:MapPoint = param2;
         var strata:uint = param3;
         try
         {
            displayObject = oEntity as DisplayObject;
         }
         catch(te:TypeError)
         {
            throw new AtouinError("Entities implementing IDisplayable should extends DisplayObject.");
         }
         if(cellCoords)
         {
            cellSprite = InteractiveCellManager.getInstance().getCell(cellCoords.cellId);
            this.orderEntity(displayObject,cellSprite);
         }
         else
         {
            _log.error("refreshAlphaEntity  can\'t handle null position");
         }
      }
      
      public function removeEntity(param1:IDisplayable) : void
      {
         var displayObject:DisplayObject = null;
         var oEntity:IDisplayable = param1;
         try
         {
            displayObject = oEntity as DisplayObject;
         }
         catch(te:TypeError)
         {
            throw new AtouinError("Entities implementing IDisplayable should extends DisplayObject.");
         }
         if(displayObject.parent)
         {
            displayObject.parent.removeChild(displayObject);
         }
      }
      
      public function orderEntity(param1:DisplayObject, param2:Sprite) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:DisplayObjectContainer = null;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc11_:uint = 0;
         var _loc7_:TiphonSprite;
         if((_loc7_ = param1 as TiphonSprite) && _loc7_.parentSprite)
         {
            _loc6_ = true;
         }
         if(Atouin.getInstance().options.transparentOverlayMode && param1 is ITransparency && ITransparency(param1).getIsTransparencyAllowed())
         {
            param1.alpha = param1.alpha != 1?Number(param1.alpha):Number(AtouinConstants.OVERLAY_MODE_ALPHA);
            if(_loc6_)
            {
               return;
            }
            _loc5_ = (_loc4_ = Atouin.getInstance().overlayContainer).numChildren;
            while(_loc11_ < _loc5_)
            {
               _loc3_ = _loc4_.getChildAt(_loc11_);
               if(param1.y < _loc3_.y)
               {
                  break;
               }
               _loc11_++;
            }
            if(_loc4_.contains(param1) && _loc11_ > 0)
            {
               _loc4_.addChildAt(param1,_loc11_ - 1);
            }
            else
            {
               _loc4_.addChildAt(param1,_loc11_);
            }
            return;
         }
         if(Math.round(param1.alpha * 10) == AtouinConstants.OVERLAY_MODE_ALPHA * 10)
         {
            param1.alpha = 1;
         }
         if(_loc6_)
         {
            return;
         }
         if(!param2 || !param2.parent)
         {
            return;
         }
         var _loc8_:uint = param2.parent.getChildIndex(param2);
         var _loc9_:int = param2.parent.numChildren;
         var _loc10_:Boolean = true;
         _loc11_ = _loc8_ + 1;
         while(_loc11_ < _loc9_)
         {
            _loc3_ = param2.parent.getChildAt(_loc11_);
            if(_loc3_ is GraphicCell)
            {
               break;
            }
            if(this._dStrataRef[param1] < this._dStrataRef[_loc3_])
            {
               break;
            }
            if(_loc3_ !== param2 && _loc3_ != param1)
            {
               _loc8_++;
            }
            _loc10_ = false;
            _loc11_++;
         }
         param2.parent.addChildAt(param1,_loc8_ + 1);
      }
      
      public function getAbsoluteBounds(param1:IDisplayable) : IRectangle
      {
         var _loc2_:DisplayObject = param1 as DisplayObject;
         var _loc3_:Rectangle2 = new Rectangle2();
         var _loc4_:Rectangle = _loc2_.getBounds(StageShareManager.stage);
         _loc3_.x = _loc4_.x;
         _loc3_.width = _loc4_.width;
         _loc3_.height = _loc4_.height;
         _loc3_.y = _loc4_.y;
         return _loc3_;
      }
   }
}
