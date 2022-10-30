package com.ankamagames.berilia.components.gridRenderer
{
   import com.ankamagames.berilia.UIComponent;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.interfaces.IGridRenderer;
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.berilia.types.uiDefinition.BasicElement;
   import com.ankamagames.berilia.types.uiDefinition.ButtonElement;
   import com.ankamagames.berilia.types.uiDefinition.ContainerElement;
   import com.ankamagames.berilia.types.uiDefinition.StateContainerElement;
   import com.ankamagames.berilia.uiRender.UiRenderer;
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   import com.ankamagames.jerakine.messages.Message;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class MultiGridRenderer implements IGridRenderer
   {
       
      
      protected var _grid:Grid;
      
      protected var _cptNameReferences:Dictionary;
      
      protected var _componentReferences:Dictionary;
      
      protected var _componentReferencesByInstance:Dictionary;
      
      protected var _elemID:uint;
      
      protected var _containerCache:Dictionary;
      
      protected var _uiRenderer:UiRenderer;
      
      protected var _containerDefinition:Dictionary;
      
      protected var _bgColor1:ColorTransform;
      
      protected var _bgColor2:ColorTransform;
      
      protected var _color1:Number = -1;
      
      protected var _color2:Number = -1;
      
      protected var _bgAlpha:Number = 1;
      
      protected var _updateFunctionName:String;
      
      protected var _getLineTypeFunctionName:String;
      
      protected var _defaultLineType:String;
      
      protected var _getDataLengthFunctionName:String;
      
      public function MultiGridRenderer(param1:String)
      {
         var _loc2_:Array = null;
         super();
         if(param1)
         {
            _loc2_ = param1.split(",");
            this._updateFunctionName = _loc2_[0];
            this._getLineTypeFunctionName = _loc2_[1];
            this._getDataLengthFunctionName = _loc2_[2];
            if(_loc2_[3])
            {
               this._bgColor1 = new ColorTransform();
               this._color1 = parseInt(_loc2_[3],16);
               this._bgColor1.color = this._color1;
            }
            if(_loc2_[4])
            {
               this._bgColor2 = new ColorTransform();
               this._color2 = parseInt(_loc2_[4],16);
               this._bgColor2.color = this._color2;
            }
            if(_loc2_[5])
            {
               this._bgAlpha = parseInt(_loc2_[5]);
            }
         }
         this._cptNameReferences = new Dictionary();
         this._componentReferences = new Dictionary();
         this._containerDefinition = new Dictionary();
         this._componentReferencesByInstance = new Dictionary(true);
         this._uiRenderer = new UiRenderer();
         this._containerCache = new Dictionary();
      }
      
      public function set grid(param1:Grid) : void
      {
         if(!this._grid)
         {
            this._grid = param1;
         }
         param1.mouseEnabled = true;
         var _loc2_:UiRootContainer = this._grid.getUi();
         this._uiRenderer.postInit(_loc2_);
      }
      
      public function render(param1:*, param2:uint, param3:Boolean, param4:uint = 0) : DisplayObject
      {
         var _loc5_:GraphicContainer;
         (_loc5_ = new GraphicContainer()).setUi(this._grid.getUi(),SecureCenter.ACCESS_KEY);
         this.update(param1,param2,_loc5_,param3,param4);
         return _loc5_;
      }
      
      public function update(param1:*, param2:uint, param3:DisplayObject, param4:Boolean, param5:uint = 0) : void
      {
         var _loc6_:Sprite = null;
         var _loc7_:UiRootContainer;
         if(!(_loc7_ = this._grid.getUi()).uiClass.hasOwnProperty(this._getLineTypeFunctionName) && !this._defaultLineType || !_loc7_.uiClass.hasOwnProperty(this._updateFunctionName))
         {
            throw new BeriliaError("GetLineType function or update function is not define.");
         }
         var _loc8_:String = !!this._defaultLineType?this._defaultLineType:_loc7_.uiClass[this._getLineTypeFunctionName](SecureCenter.secure(param1),param5);
         if(param3.name != _loc8_)
         {
            this.buildLine(param3 as Sprite,_loc8_);
         }
         if(param3 is Sprite)
         {
            _loc6_ = param3 as Sprite;
            if(param2 % 2 == 0)
            {
               _loc6_.graphics.clear();
               if(this._color1)
               {
                  _loc6_.graphics.beginFill(this._color1,this._bgAlpha);
                  _loc6_.graphics.drawRect(0,0,this._grid.slotWidth,this._grid.slotHeight);
                  _loc6_.graphics.endFill();
               }
            }
            if(param2 % 2 == 1)
            {
               _loc6_.graphics.clear();
               if(this._color2)
               {
                  _loc6_.graphics.beginFill(this._color2,this._bgAlpha);
                  _loc6_.graphics.drawRect(0,0,this._grid.slotWidth,this._grid.slotHeight);
                  _loc6_.graphics.endFill();
               }
            }
         }
         this.uiUpdate(_loc7_,param3,param1,param4,param5);
      }
      
      protected function uiUpdate(param1:UiRootContainer, param2:DisplayObject, param3:*, param4:Boolean, param5:uint) : void
      {
         var _loc6_:* = undefined;
         if(DisplayObjectContainer(param2).numChildren)
         {
            (_loc6_ = param1.uiClass)[this._updateFunctionName](SecureCenter.secure(param3),this._cptNameReferences[DisplayObjectContainer(param2).getChildAt(0)],param4,param5);
         }
      }
      
      public function remove(param1:DisplayObject) : void
      {
         param1.visible = false;
      }
      
      public function destroy() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         for each(_loc1_ in this._componentReferences)
         {
            _loc2_ = SecureCenter.unsecure(_loc1_);
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_ is GraphicContainer)
               {
                  _loc3_.remove();
               }
            }
         }
         this._componentReferences = null;
         this._componentReferencesByInstance = null;
         this._grid = null;
      }
      
      public function getDataLength(param1:*, param2:Boolean) : uint
      {
         var _loc3_:UiRootContainer = this._grid.getUi();
         if(_loc3_.uiClass.hasOwnProperty(this._getDataLengthFunctionName))
         {
            return _loc3_.uiClass[this._getDataLengthFunctionName](param1,param2);
         }
         return 1;
      }
      
      public function renderModificator(param1:Array) : Array
      {
         var _loc2_:ContainerElement = null;
         for each(_loc2_ in param1)
         {
            this._containerDefinition[_loc2_.name] = _loc2_;
         }
         return [];
      }
      
      public function eventModificator(param1:Message, param2:String, param3:Array, param4:UIComponent) : String
      {
         return param2;
      }
      
      protected function buildLine(param1:Sprite, param2:String) : void
      {
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         if(param1.name == param2)
         {
            return;
         }
         if(!this._containerCache[param2])
         {
            this._containerCache[param2] = [];
         }
         if(this._containerDefinition[param1.name])
         {
            if(!this._containerCache[param1.name])
            {
               this._containerCache[param1.name] = [];
            }
            if(param1.numChildren)
            {
               this._containerCache[param1.name].push(param1.getChildAt(0));
               param1.removeChildAt(0);
            }
         }
         param1.name = !!param2?param2:"#########EMPTY";
         if(!param2)
         {
            return;
         }
         if(this._containerCache[param2].length)
         {
            param1.addChild(this._containerCache[param2].pop());
            return;
         }
         var _loc6_:GraphicContainer;
         (_loc6_ = new GraphicContainer()).setUi(this._grid.getUi(),SecureCenter.ACCESS_KEY);
         _loc6_.mouseEnabled = false;
         param1.addChild(_loc6_);
         var _loc7_:Array = [];
         this._uiRenderer.makeChilds([this.copyElement(this._containerDefinition[param2],_loc7_)],_loc6_,true);
         this._grid.getUi().render();
         var _loc8_:Object = {};
         var _loc9_:UiRootContainer = this._grid.getUi();
         for(_loc3_ in _loc7_)
         {
            _loc4_ = _loc3_.indexOf("_m_");
            _loc5_ = _loc3_;
            if(_loc4_ != -1)
            {
               _loc5_ = _loc5_.substr(0,_loc4_);
            }
            _loc8_[_loc5_] = SecureCenter.secure(_loc9_.getElement(_loc7_[_loc3_]),SecureCenter.ACCESS_KEY);
         }
         this._cptNameReferences[_loc6_] = _loc8_;
         ++this._elemID;
      }
      
      protected function copyElement(param1:BasicElement, param2:Object) : BasicElement
      {
         var _loc3_:Array = null;
         var _loc4_:BasicElement = null;
         var _loc5_:StateContainerElement = null;
         var _loc6_:StateContainerElement = null;
         var _loc7_:Array = null;
         var _loc8_:uint = 0;
         var _loc9_:* = null;
         var _loc10_:* = null;
         var _loc11_:BasicElement = new (getDefinitionByName(getQualifiedClassName(param1)) as Class)();
         param1.copy(_loc11_);
         if(_loc11_.name)
         {
            _loc11_.setName(_loc11_.name + "_m_" + this._grid.name + "_" + this._elemID);
            param2[param1.name] = _loc11_.name;
         }
         else
         {
            _loc11_.setName("elem_m_" + this._grid.name + "_" + BasicElement.ID++);
         }
         if(_loc11_ is ContainerElement)
         {
            _loc3_ = new Array();
            for each(_loc4_ in ContainerElement(param1).childs)
            {
               _loc3_.push(this.copyElement(_loc4_,param2));
            }
            ContainerElement(_loc11_).childs = _loc3_;
         }
         if(_loc11_ is StateContainerElement)
         {
            _loc5_ = _loc11_ as StateContainerElement;
            _loc6_ = param1 as StateContainerElement;
            _loc7_ = new Array();
            for(_loc9_ in _loc6_.stateChangingProperties)
            {
               _loc8_ = parseInt(_loc9_);
               for(_loc10_ in _loc6_.stateChangingProperties[_loc8_])
               {
                  if(!_loc7_[_loc8_])
                  {
                     _loc7_[_loc8_] = [];
                  }
                  _loc7_[_loc8_][_loc10_ + "_m_" + this._grid.name + "_" + this._elemID] = _loc6_.stateChangingProperties[_loc8_][_loc10_];
               }
            }
            _loc5_.stateChangingProperties = _loc7_;
         }
         if(_loc11_ is ButtonElement)
         {
            if(_loc11_.properties["linkedTo"])
            {
               _loc11_.properties["linkedTo"] = _loc11_.properties["linkedTo"] + "_m_" + this._grid.name + "_" + this._elemID;
            }
         }
         return _loc11_;
      }
   }
}
