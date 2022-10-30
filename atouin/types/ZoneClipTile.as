package com.ankamagames.atouin.types
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.EntitiesDisplayManager;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.jerakine.entities.behaviours.IDisplayBehavior;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.interfaces.ITransparency;
   import com.ankamagames.jerakine.resources.adapters.impl.AdvancedSwfAdapter;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.system.ApplicationDomain;
   
   public class ZoneClipTile extends Sprite implements IDisplayable, ITransparency
   {
      
      private static var clips:Array = new Array();
      
      private static var loader:IResourceLoader;
      
      private static var no_z_render_strata:Sprite = new Sprite();
      
      private static const BORDER_CLIP:String = "BlocageMvt";
       
      
      private var _uri:Uri;
      
      private var _clipName:String;
      
      private var _needBorders:Boolean;
      
      private var _borderSprites:Array;
      
      private var _borderBitmapData:BitmapData;
      
      private var _displayMe:Boolean = false;
      
      private var _currentRessource:LoadedTile;
      
      private var _displayBehavior:IDisplayBehavior;
      
      protected var _displayed:Boolean;
      
      private var _currentCell:Point;
      
      private var _cellId:uint;
      
      public var strata:uint = 0;
      
      protected var _cellInstance:Sprite;
      
      public function ZoneClipTile(param1:Uri, param2:String = "Bloc", param3:Boolean = false)
      {
         var _loc4_:LoadedTile = null;
         this._borderSprites = new Array();
         super();
         mouseEnabled = false;
         mouseChildren = false;
         this._needBorders = param3;
         this._uri = param1;
         this._clipName = param2;
         this._currentRessource = getRessource(param1.fileName);
         if(this._currentRessource == null || loader == null && this._currentRessource == null)
         {
            (_loc4_ = new LoadedTile(this._uri.fileName)).addClip(this._clipName);
            clips.push(_loc4_);
            this._currentRessource = _loc4_;
            loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SINGLE_LOADER);
            loader.addEventListener(ResourceLoadedEvent.LOADED,this.onClipLoaded);
            loader.load(this._uri,null,AdvancedSwfAdapter);
         }
         else if(this._currentRessource.getClip(this._clipName) == null || this._currentRessource.getClip(this._clipName).clip == null)
         {
            if(!this._currentRessource.appDomain)
            {
               loader.addEventListener(ResourceLoadedEvent.LOADED,this.onClipLoaded);
            }
            else
            {
               this._currentRessource.addClip(this._clipName,this._currentRessource.appDomain.getDefinition(this._clipName));
               this.display();
            }
         }
         else
         {
            this.display();
         }
      }
      
      private static function getRessource(param1:String) : LoadedTile
      {
         var _loc2_:int = 0;
         var _loc3_:int = clips.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(clips[_loc2_].fileName == param1)
            {
               return clips[_loc2_] as LoadedTile;
            }
            _loc2_ = _loc2_ + 1;
         }
         return null;
      }
      
      public static function getTile(param1:String, param2:String) : Sprite
      {
         var _loc3_:LoadedTile = getRessource(param1);
         return new _loc3_.getClip(param2).clip();
      }
      
      private function onClipLoaded(param1:ResourceLoadedEvent) : void
      {
         loader.removeEventListener(ResourceLoadedEvent.LOADED,this.onClipLoaded);
         var _loc2_:ApplicationDomain = param1.resource.applicationDomain;
         var _loc3_:LoadedTile = getRessource(param1.uri.fileName);
         if(_loc3_ == null)
         {
            _loc3_ = new LoadedTile(param1.uri.fileName);
            _loc3_.addClip(this._clipName,_loc2_.getDefinition(this._clipName));
            clips.push(_loc3_);
         }
         else if(_loc3_.getClip(this._clipName) == null || _loc3_.getClip(this._clipName).clip == null)
         {
            _loc3_.addClip(this._clipName,_loc2_.getDefinition(this._clipName));
         }
         if(!_loc3_.appDomain)
         {
            _loc3_.appDomain = _loc2_;
         }
         this._currentRessource = _loc3_;
         if(this._displayMe)
         {
            this._displayMe = false;
            this.display();
         }
      }
      
      public function display(param1:uint = 0) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Sprite = null;
         var _loc4_:* = false;
         var _loc5_:* = false;
         var _loc6_:* = false;
         var _loc7_:Sprite = null;
         var _loc8_:Sprite = null;
         var _loc9_:Sprite = null;
         if(this._currentRessource == null || this._currentRessource.getClip(this._clipName) == null || this._currentRessource.getClip(this._clipName).clip == null)
         {
            this._displayMe = true;
         }
         else
         {
            _loc2_ = this._currentRessource.getClip(this._clipName);
            if(_loc2_.clip != null)
            {
               this._cellInstance = new _loc2_.clip();
               addChild(this._cellInstance);
            }
            if(this._needBorders)
            {
               this._borderSprites = new Array();
               _loc4_ = this.cellId % 14 == 0;
               _loc5_ = (this.cellId + 1) % 14 == 0;
               _loc6_ = Math.floor(this.cellId / 14) % 2 == 0;
               if(_loc4_ && _loc6_)
               {
                  _loc3_ = this.getFakeTile();
                  _loc3_.x = -AtouinConstants.CELL_HALF_WIDTH;
                  _loc3_.y = -AtouinConstants.CELL_HALF_HEIGHT;
                  this._borderSprites.push(_loc3_);
                  addChildAt(_loc3_,0);
               }
               else if(_loc5_ && !_loc6_)
               {
                  _loc3_ = this.getFakeTile();
                  _loc3_.x = AtouinConstants.CELL_HALF_WIDTH;
                  _loc3_.y = -AtouinConstants.CELL_HALF_HEIGHT;
                  this._borderSprites.push(_loc3_);
                  addChildAt(_loc3_,0);
               }
               if(this.cellId < 14)
               {
                  _loc3_ = this.getFakeTile();
                  _loc3_.x = AtouinConstants.CELL_HALF_WIDTH;
                  _loc3_.y = -AtouinConstants.CELL_HALF_HEIGHT;
                  this._borderSprites.push(_loc3_);
                  addChildAt(_loc3_,0);
               }
               else if(this.cellId > 545)
               {
                  _loc3_ = this.getFakeTile();
                  _loc3_.x = -AtouinConstants.CELL_HALF_WIDTH;
                  _loc3_.y = AtouinConstants.CELL_HALF_HEIGHT;
                  this._borderSprites.push(_loc3_);
                  addChild(_loc3_);
               }
               if(this.cellId == 532)
               {
                  (_loc7_ = this.getFakeTile()).x = -AtouinConstants.CELL_HALF_WIDTH;
                  _loc7_.y = AtouinConstants.CELL_HALF_HEIGHT;
                  this._borderSprites.push(_loc7_);
                  addChild(_loc7_);
               }
               else if(this.cellId == 559)
               {
                  (_loc8_ = this.getFakeTile()).x = AtouinConstants.CELL_HALF_WIDTH;
                  _loc8_.y = AtouinConstants.CELL_HALF_HEIGHT;
                  this._borderSprites.push(_loc8_);
                  addChild(_loc8_);
               }
            }
            if(this.strata != PlacementStrataEnums.STRATA_NO_Z_ORDER)
            {
               EntitiesDisplayManager.getInstance().displayEntity(this,MapPoint.fromCellId(this.cellId),this.strata);
            }
            else
            {
               _loc9_ = InteractiveCellManager.getInstance().getCell(MapPoint.fromCellId(this.cellId).cellId);
               this.x = _loc9_.x + _loc9_.width / 2;
               this.y = _loc9_.y + _loc9_.height / 2;
               no_z_render_strata.addChild(this);
               if(Atouin.getInstance().selectionContainer != null && !Atouin.getInstance().selectionContainer.contains(no_z_render_strata))
               {
                  Atouin.getInstance().selectionContainer.addChildAt(no_z_render_strata,0);
               }
            }
            this._displayed = true;
         }
      }
      
      public function get displayBehaviors() : IDisplayBehavior
      {
         return this._displayBehavior;
      }
      
      public function set displayBehaviors(param1:IDisplayBehavior) : void
      {
         this._displayBehavior = param1;
      }
      
      public function get currentCellPosition() : Point
      {
         return this._currentCell;
      }
      
      public function set currentCellPosition(param1:Point) : void
      {
         this._currentCell = param1;
      }
      
      public function get displayed() : Boolean
      {
         return this._displayed;
      }
      
      public function get absoluteBounds() : IRectangle
      {
         return this._displayBehavior.getAbsoluteBounds(this);
      }
      
      public function get cellId() : uint
      {
         return this._cellId;
      }
      
      public function set cellId(param1:uint) : void
      {
         this._cellId = param1;
      }
      
      public function remove() : void
      {
         var _loc1_:Sprite = null;
         this._displayed = false;
         if(this._borderSprites.length)
         {
            while(_loc1_ = this._borderSprites.pop())
            {
               removeChild(_loc1_);
            }
         }
         if(this._cellInstance != null)
         {
            removeChild(this._cellInstance);
         }
         if(this.strata != PlacementStrataEnums.STRATA_NO_Z_ORDER)
         {
            EntitiesDisplayManager.getInstance().removeEntity(this);
         }
         else
         {
            if(no_z_render_strata.contains(this))
            {
               no_z_render_strata.removeChild(this);
            }
            if(no_z_render_strata.numChildren <= 0 && Atouin.getInstance().selectionContainer && Atouin.getInstance().selectionContainer.contains(no_z_render_strata))
            {
               Atouin.getInstance().selectionContainer.removeChild(no_z_render_strata);
            }
         }
      }
      
      public function getIsTransparencyAllowed() : Boolean
      {
         return true;
      }
      
      public function get uri() : Uri
      {
         return this._uri;
      }
      
      public function get clipName() : String
      {
         return this._clipName;
      }
      
      public function getFakeTile() : Sprite
      {
         var _loc1_:Shape = null;
         if(this._borderBitmapData == null)
         {
            _loc1_ = new Shape();
            _loc1_.graphics.beginFill(16711680);
            _loc1_.graphics.moveTo(86 / 2,0);
            _loc1_.graphics.lineTo(86,43 / 2);
            _loc1_.graphics.lineTo(86 / 2,43);
            _loc1_.graphics.lineTo(0,43 / 2);
            _loc1_.graphics.endFill();
            this._borderBitmapData = new BitmapData(86,43,true,16711680);
            this._borderBitmapData.draw(_loc1_);
         }
         var _loc2_:Bitmap = new Bitmap(this._borderBitmapData);
         _loc2_.x = -86 / 2;
         _loc2_.y = -43 / 2;
         var _loc3_:Sprite = new Sprite();
         _loc3_.addChild(_loc2_);
         return _loc3_;
      }
   }
}

import flash.system.ApplicationDomain;

class LoadedTile
{
    
   
   public var fileName:String;
   
   public var appDomain:ApplicationDomain;
   
   private var _clips:Array;
   
   function LoadedTile(param1:String)
   {
      super();
      this.fileName = param1;
      this._clips = new Array();
   }
   
   public function addClip(param1:String, param2:Object = null) : void
   {
      var _loc3_:Object = this.getClip(param1);
      if(_loc3_ == null)
      {
         _loc3_ = new Object();
         _loc3_.clipName = param1;
         _loc3_.clip = param2;
         this._clips.push(_loc3_);
      }
      else
      {
         _loc3_.clip = param2;
      }
   }
   
   public function getClip(param1:String) : Object
   {
      var _loc2_:Object = null;
      for each(_loc2_ in this._clips)
      {
         if(_loc2_.clipName == param1)
         {
            return _loc2_;
         }
      }
      return null;
   }
}
