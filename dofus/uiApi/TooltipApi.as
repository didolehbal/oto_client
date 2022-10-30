package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.factories.TooltipsFactory;
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.interfaces.ITooltipMaker;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.berilia.types.data.ChunkData;
   import com.ankamagames.berilia.types.data.UiData;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.event.UiRenderEvent;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.berilia.types.tooltip.Tooltip;
   import com.ankamagames.berilia.types.tooltip.TooltipBlock;
   import com.ankamagames.berilia.types.tooltip.TooltipPlacer;
   import com.ankamagames.berilia.types.tooltip.TooltipRectangle;
   import com.ankamagames.berilia.utils.errors.ApiError;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.logic.game.common.frames.PlayedCharacterUpdatesFrame;
   import com.ankamagames.dofus.modules.utils.ItemTooltipSettings;
   import com.ankamagames.dofus.modules.utils.SpellTooltipSettings;
   import com.ankamagames.dofus.types.data.ItemTooltipInfo;
   import com.ankamagames.dofus.types.data.SpellTooltipInfo;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.misc.CheckCompatibility;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class TooltipApi implements IApi
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(TooltipApi));
       
      
      private var _module:UiModule;
      
      private var _currentUi:UiRootContainer;
      
      private var _ttCallbacks:Dictionary;
      
      public function TooltipApi()
      {
         this._ttCallbacks = new Dictionary();
         super();
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      [ApiData(name="currentUi")]
      public function set currentUi(param1:UiRootContainer) : void
      {
         this._currentUi = param1;
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._module = null;
         this._currentUi = null;
      }
      
      [Untrusted]
      public function setDefaultTooltipUiScript(param1:String, param2:String) : void
      {
         var _loc3_:UiModule = UiModuleManager.getInstance().getModule(param1);
         if(!_loc3_)
         {
            throw new ApiError("Module " + param1 + " doesn\'t exist");
         }
         var _loc4_:UiData;
         if(!(_loc4_ = _loc3_.getUi(param2)))
         {
            throw new ApiError("UI " + param2 + " doesn\'t exist in module " + param1);
         }
         TooltipManager.defaultTooltipUiScript = _loc4_.uiClass;
      }
      
      [NoBoxing]
      [Untrusted]
      public function createTooltip(param1:String, param2:String, param3:String = null) : Tooltip
      {
         var _loc4_:Tooltip = null;
         if(param1.substr(-4,4) != ".txt")
         {
            throw new ApiError("ChunkData support only [.txt] file, found " + param1);
         }
         if(param2.substr(-4,4) != ".txt")
         {
            throw new ApiError("ChunkData support only [.txt] file, found " + param2);
         }
         if(param3)
         {
            if(param3.substr(-4,4) != ".txt")
            {
               throw new ApiError("ChunkData support only [.txt] file, found " + param3);
            }
            _loc4_ = new Tooltip(new Uri(this._module.rootPath + "/" + param1),new Uri(this._module.rootPath + "/" + param2),new Uri(this._module.rootPath + "/" + param3));
         }
         else
         {
            _loc4_ = new Tooltip(new Uri(this._module.rootPath + "/" + param1),new Uri(this._module.rootPath + "/" + param2));
         }
         return _loc4_;
      }
      
      [NoBoxing]
      [Untrusted]
      public function createTooltipBlock(param1:Function, param2:Function) : TooltipBlock
      {
         var _loc3_:TooltipBlock = new TooltipBlock();
         _loc3_.onAllChunkLoadedCallback = param1;
         _loc3_.contentGetter = param2;
         return _loc3_;
      }
      
      [Untrusted]
      public function registerTooltipAssoc(param1:*, param2:String) : void
      {
         TooltipsFactory.registerAssoc(param1,param2);
      }
      
      [Untrusted]
      public function registerTooltipMaker(param1:String, param2:Class, param3:Class = null) : void
      {
         if(CheckCompatibility.isCompatible(ITooltipMaker,param2))
         {
            TooltipsFactory.registerMaker(param1,param2,param3);
            return;
         }
         throw new ApiError(param1 + " maker class is not compatible with ITooltipMaker");
      }
      
      [NoBoxing]
      [Untrusted]
      public function createChunkData(param1:String, param2:String) : ChunkData
      {
         var _loc3_:Uri = new Uri(this._module.rootPath + "/" + param2);
         if(_loc3_.fileType.toLowerCase() != "txt")
         {
            throw new ApiError("ChunkData support only [.txt] file, found " + param2);
         }
         return new ChunkData(param1,_loc3_);
      }
      
      [Untrusted]
      public function place(param1:*, param2:uint = 6, param3:uint = 0, param4:int = 3, param5:Boolean = false, param6:int = -1, param7:Boolean = true) : void
      {
         if(param1 && CheckCompatibility.isCompatible(IRectangle,param1))
         {
            if(this._currentUi.ready)
            {
               this.placeTooltip(this._currentUi,param1,param2,param3,param4,param5,param6,param7);
            }
            else
            {
               this._currentUi.removeEventListener(UiRenderEvent.UIRenderComplete,this.onTooltipReady);
               this._ttCallbacks[this._currentUi] = new Callback(this.placeTooltip,this._currentUi,param1,param2,param3,param4,param5,param6,param7);
               this._currentUi.addEventListener(UiRenderEvent.UIRenderComplete,this.onTooltipReady);
            }
         }
      }
      
      private function placeTooltip(param1:UiRootContainer, param2:*, param3:uint, param4:uint, param5:int, param6:Boolean, param7:int, param8:Boolean) : void
      {
         TooltipPlacer.place(param1,param2,param3,param4,param5,param8);
         if(param6 && param7 != -1)
         {
            TooltipPlacer.addTooltipPosition(param1,param2,param7);
         }
      }
      
      [Untrusted]
      public function placeArrow(param1:*) : Object
      {
         if(param1 && CheckCompatibility.isCompatible(IRectangle,param1))
         {
            return TooltipPlacer.placeWithArrow(this._currentUi,param1);
         }
         return null;
      }
      
      [Untrusted]
      public function getSpellTooltipInfo(param1:SpellWrapper, param2:String = null) : Object
      {
         return new SpellTooltipInfo(param1,param2);
      }
      
      [Untrusted]
      public function getItemTooltipInfo(param1:ItemWrapper, param2:String = null) : Object
      {
         return new ItemTooltipInfo(param1,param2);
      }
      
      [Untrusted]
      public function getSpellTooltipCache() : int
      {
         return PlayedCharacterUpdatesFrame.SPELL_TOOLTIP_CACHE_NUM;
      }
      
      [Untrusted]
      public function resetSpellTooltipCache() : void
      {
         ++PlayedCharacterUpdatesFrame.SPELL_TOOLTIP_CACHE_NUM;
      }
      
      [NoBoxing]
      [Untrusted]
      public function createTooltipRectangle(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0) : TooltipRectangle
      {
         return new TooltipRectangle(param1,param2,param3,param4);
      }
      
      [Trusted]
      public function createSpellSettings() : SpellTooltipSettings
      {
         return new SpellTooltipSettings();
      }
      
      [Trusted]
      public function createItemSettings() : ItemTooltipSettings
      {
         return new ItemTooltipSettings();
      }
      
      [Untrusted]
      public function adjustTooltipPositions(param1:Array, param2:String, param3:int = 0) : void
      {
         var _loc4_:UiRootContainer = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:UiRootContainer = null;
         var _loc9_:Array = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Array = new Array();
         var _loc13_:UiRootContainer = Berilia.getInstance().getUi(param2);
         for each(_loc5_ in param1)
         {
            if(_loc4_ = Berilia.getInstance().getUi(_loc5_))
            {
               _loc12_.push(_loc4_);
            }
         }
         _loc6_ = 0;
         _loc7_ = true;
         _loc9_ = new Array();
         _loc10_ = 0;
         _loc11_ = 0;
         for each(_loc4_ in _loc12_)
         {
            if(_loc6_ == 0)
            {
               if(param1.length == 1)
               {
                  if(_loc13_.x - _loc4_.width - param3 >= 0)
                  {
                     this.placeTooltip(_loc4_,_loc13_,LocationEnum.POINT_TOPRIGHT,LocationEnum.POINT_TOPLEFT,param3,false,0,true);
                     _loc4_.x = _loc4_.x - param3 * 2;
                  }
                  else
                  {
                     this.placeTooltip(_loc4_,_loc13_,LocationEnum.POINT_TOPLEFT,LocationEnum.POINT_TOPRIGHT,param3,false,0,true);
                  }
                  if(_loc4_.y - 41 >= 0)
                  {
                     _loc4_.y = _loc4_.y - 41;
                  }
                  return;
               }
               if(_loc13_.x - _loc4_.width - param3 >= 0)
               {
                  this.placeTooltip(_loc4_,_loc13_,LocationEnum.POINT_RIGHT,LocationEnum.POINT_LEFT,param3,false,0,true);
                  _loc4_.x = _loc4_.x - param3 * 2;
               }
               else
               {
                  this.placeTooltip(_loc4_,_loc13_,LocationEnum.POINT_LEFT,LocationEnum.POINT_RIGHT,param3,false,0,true);
               }
               _loc10_ = _loc10_ + (_loc4_.height + param3);
               _loc9_.push(_loc4_);
               _loc11_ = _loc4_.y;
            }
            else if(_loc6_ < 4)
            {
               if(_loc7_ && _loc8_.y - _loc4_.height - param3 < 0)
               {
                  _loc7_ = false;
                  _loc8_ = _loc12_[0];
               }
               if(_loc7_)
               {
                  this.placeTooltip(_loc4_,_loc8_,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,param3,false,0,false);
                  _loc11_ = _loc4_.y;
               }
               else
               {
                  this.placeTooltip(_loc4_,_loc8_,LocationEnum.POINT_TOP,LocationEnum.POINT_BOTTOM,param3,false,0,false);
               }
               _loc4_.x = _loc8_.x;
               _loc10_ = _loc10_ + (_loc4_.height + param3);
               _loc9_.push(_loc4_);
            }
            else
            {
               if(_loc7_ && _loc8_.y - _loc4_.height - param3 < 0)
               {
                  _loc7_ = false;
                  _loc8_ = _loc13_;
               }
               if(_loc7_)
               {
                  this.placeTooltip(_loc4_,_loc8_,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,param3,false,0,true);
               }
               else
               {
                  this.placeTooltip(_loc4_,_loc8_,LocationEnum.POINT_TOP,LocationEnum.POINT_BOTTOM,param3,false,0,true);
               }
               _loc4_.x = _loc8_.x;
            }
            _loc8_ = _loc4_;
            if(++_loc6_ == 4)
            {
               _loc7_ = true;
               _loc8_ = _loc13_;
            }
         }
         if(_loc11_ + _loc10_ > StageShareManager.startHeight)
         {
            param3 = _loc11_ + _loc10_ - StageShareManager.startHeight;
            for each(_loc4_ in _loc9_)
            {
               _loc4_.y = _loc4_.y - param3;
            }
         }
      }
      
      private function onTooltipReady(param1:UiRenderEvent) : void
      {
         var _loc2_:UiRootContainer = param1.currentTarget as UiRootContainer;
         _loc2_.removeEventListener(UiRenderEvent.UIRenderComplete,this.onTooltipReady);
         (this._ttCallbacks[_loc2_] as Callback).exec();
         delete this._ttCallbacks[_loc2_];
      }
   }
}
