package com.ankamagames.berilia.factories
{
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.types.tooltip.EmptyTooltip;
   import com.ankamagames.berilia.types.tooltip.Tooltip;
   import flash.utils.getQualifiedClassName;
   
   public class TooltipsFactory
   {
      
      private static var _registeredMaker:Array = new Array();
      
      private static var _makerAssoc:Array = new Array();
       
      
      public function TooltipsFactory()
      {
         super();
      }
      
      public static function registerMaker(param1:String, param2:Class, param3:Class = null) : void
      {
         _registeredMaker[param1] = new TooltipData(param2,param3);
      }
      
      public static function registerAssoc(param1:*, param2:String) : void
      {
         _makerAssoc[getQualifiedClassName(param1)] = param2;
      }
      
      public static function existRegisterMaker(param1:String) : Boolean
      {
         return !!_registeredMaker[param1]?true:false;
      }
      
      public static function existMakerAssoc(param1:*) : Boolean
      {
         return !!_makerAssoc[getQualifiedClassName(param1)]?true:false;
      }
      
      public static function unregister(param1:Class, param2:Class) : void
      {
         if(TooltipData(_registeredMaker[getQualifiedClassName(param1)]).maker === param2)
         {
            delete _registeredMaker[getQualifiedClassName(param1)];
         }
      }
      
      public static function create(param1:*, param2:String = null, param3:Class = null, param4:Object = null) : Tooltip
      {
         var _loc5_:* = undefined;
         var _loc6_:Tooltip = null;
         var _loc7_:Object = null;
         if(!param2)
         {
            param2 = _makerAssoc[getQualifiedClassName(param1)];
         }
         var _loc8_:TooltipData;
         if(_loc8_ = _registeredMaker[param2])
         {
            if((_loc7_ = (_loc5_ = new _loc8_.maker()).createTooltip(SecureCenter.secure(param1),param4)) == "")
            {
               return new EmptyTooltip();
            }
            if((_loc6_ = _loc7_ as Tooltip) == null)
            {
               return null;
            }
            if(TooltipManager.defaultTooltipUiScript == param3)
            {
               _loc6_.scriptClass = !!_loc8_.scriptClass?_loc8_.scriptClass:param3;
            }
            else
            {
               _loc6_.scriptClass = param3;
            }
            _loc6_.makerName = param2;
            return _loc6_;
         }
         return null;
      }
   }
}

class TooltipData
{
    
   
   public var maker:Class;
   
   public var scriptClass:Class;
   
   function TooltipData(param1:Class, param2:Class)
   {
      super();
      this.maker = param1;
      this.scriptClass = param2;
   }
}
