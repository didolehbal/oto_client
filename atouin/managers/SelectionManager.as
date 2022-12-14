package com.ankamagames.atouin.managers
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.renderers.ZoneDARenderer;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.atouin.utils.errors.AtouinError;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import flash.utils.getQualifiedClassName;
   
   public class SelectionManager
   {
      
      private static var _self:SelectionManager;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SelectionManager));
       
      
      private var _aSelection:Array;
      
      public function SelectionManager()
      {
         super();
         if(_self)
         {
            throw new AtouinError("SelectionManager is a singleton class. Please acces it through getInstance()");
         }
         this.init();
      }
      
      public static function getInstance() : SelectionManager
      {
         if(!_self)
         {
            _self = new SelectionManager();
         }
         return _self;
      }
      
      public function init() : void
      {
         this._aSelection = new Array();
         Atouin.getInstance().options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
      }
      
      public function addSelection(param1:Selection, param2:String, param3:uint = 561) : void
      {
         if(this._aSelection[param2])
         {
            Selection(this._aSelection[param2]).remove();
         }
         this._aSelection[param2] = param1;
         if(param3 != AtouinConstants.MAP_CELLS_COUNT + 1)
         {
            this.update(param2,param3);
         }
      }
      
      public function getSelection(param1:String) : Selection
      {
         return this._aSelection[param1];
      }
      
      public function update(param1:String, param2:uint = 0, param3:Boolean = false) : void
      {
         var _loc4_:Vector.<uint> = null;
         var _loc5_:Vector.<uint> = null;
         var _loc6_:Selection;
         if(!(_loc6_ = this.getSelection(param1)))
         {
            return;
         }
         if(_loc6_.zone)
         {
            _loc4_ = _loc6_.zone.getCells(param2);
            _loc5_ = !!_loc6_.cells?_loc6_.cells.concat():null;
            _loc6_.remove(_loc5_);
            _loc6_.cells = _loc4_;
            if(_loc6_.renderer)
            {
               _loc6_.update(param3);
            }
            else
            {
               _log.error("No renderer set for selection [" + param1 + "]");
            }
         }
         else
         {
            _log.error("No zone set for selection [" + param1 + "]");
         }
      }
      
      public function isInside(param1:uint, param2:String) : Boolean
      {
         var _loc3_:Selection = this.getSelection(param2);
         if(!_loc3_)
         {
            return false;
         }
         return _loc3_.isInside(param1);
      }
      
      private function onPropertyChanged(param1:PropertyChangeEvent) : void
      {
         var _loc2_:Selection = null;
         var _loc3_:ZoneDARenderer = null;
         if(param1.propertyName == "transparentOverlayMode")
         {
            for each(_loc2_ in this._aSelection)
            {
               _loc3_ = _loc2_.renderer as ZoneDARenderer;
               if(_loc3_ && _loc2_.visible && !_loc3_.fixedStrata)
               {
                  if(param1.propertyValue == true)
                  {
                     _loc3_.currentStrata = PlacementStrataEnums.STRATA_NO_Z_ORDER;
                  }
                  else
                  {
                     _loc3_.restoreStrata();
                  }
                  _loc2_.update(true);
               }
            }
         }
      }
      
      private function diff(param1:Vector.<uint>, param2:Vector.<uint>) : Vector.<uint>
      {
         var _loc3_:* = undefined;
         var _loc4_:Vector.<uint> = new Vector.<uint>();
         for each(_loc3_ in param2)
         {
            if(-1 == param1.indexOf(_loc3_))
            {
               _loc4_.push(_loc3_);
            }
         }
         return _loc4_;
      }
   }
}
