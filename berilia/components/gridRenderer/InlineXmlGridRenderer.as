package com.ankamagames.berilia.components.gridRenderer
{
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.geom.ColorTransform;
   
   public class InlineXmlGridRenderer extends MultiGridRenderer
   {
       
      
      public function InlineXmlGridRenderer(param1:String)
      {
         super(null);
         var _loc2_:Array = param1.split(",");
         _updateFunctionName = _loc2_[0];
         if(_loc2_[1])
         {
            _bgColor1 = new ColorTransform();
            _color1 = parseInt(_loc2_[1],16);
            _bgColor1.color = _color1;
         }
         if(_loc2_[2])
         {
            _bgColor2 = new ColorTransform();
            _color2 = parseInt(_loc2_[2],16);
            _bgColor2.color = _color2;
         }
         if(_loc2_[3])
         {
            _bgAlpha = Number(_loc2_[3]);
         }
         _defaultLineType = "default";
      }
      
      override public function update(param1:*, param2:uint, param3:DisplayObject, param4:Boolean, param5:uint = 0) : void
      {
         super.update(param1,param2,param3,param4,param5);
      }
      
      override protected function uiUpdate(param1:UiRootContainer, param2:DisplayObject, param3:*, param4:Boolean, param5:uint) : void
      {
         var _loc6_:* = undefined;
         if(DisplayObjectContainer(param2).numChildren)
         {
            (_loc6_ = param1.uiClass)[_updateFunctionName](SecureCenter.secure(param3),_cptNameReferences[DisplayObjectContainer(param2).getChildAt(0)],param4);
         }
      }
      
      override public function renderModificator(param1:Array) : Array
      {
         _containerDefinition["default"] = param1[0];
         return [];
      }
   }
}
