package com.ankamagames.berilia.types.shortcut
{
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class Bind implements IDataCenter
   {
       
      
      public var key:String;
      
      public var targetedShortcut:String;
      
      public var alt:Boolean;
      
      public var ctrl:Boolean;
      
      public var shift:Boolean;
      
      public var disabled:Boolean;
      
      public function Bind(param1:String = null, param2:String = "", param3:Boolean = false, param4:Boolean = false, param5:Boolean = false)
      {
         super();
         if(param1)
         {
            this.targetedShortcut = param2;
            this.key = param1;
            this.alt = param3;
            this.ctrl = param4;
            this.shift = param5;
            this.disabled = false;
         }
      }
      
      public function toString() : String
      {
         var _loc1_:String = null;
         var _loc2_:* = "";
         if(this.key != null)
         {
            _loc2_ = !!this.alt?"Alt+":"";
            _loc2_ = _loc2_ + (!!this.ctrl?"Ctrl+":"");
            _loc2_ = _loc2_ + (!!this.shift?I18n.getUiText("ui.keyboard.shift") + "+":"");
            if(this.key.charAt(0) == "(" && this.key.charAt(this.key.length - 1) == ")")
            {
               _loc1_ = this.key.substr(1,this.key.length - 2);
            }
            else
            {
               _loc1_ = this.key;
            }
            if(I18n.hasUiText("ui.keyboard." + _loc1_.toLowerCase()))
            {
               _loc2_ = _loc2_ + I18n.getUiText("ui.keyboard." + _loc1_.toLowerCase());
            }
            else
            {
               _loc2_ = _loc2_ + (!!this.shift?_loc1_.toLowerCase():_loc1_);
            }
         }
         return _loc2_;
      }
      
      public function equals(param1:Bind) : Boolean
      {
         return param1 && (param1.key == null && this.key == null || this.key != null && param1.key != null && param1.key.toLocaleUpperCase() == this.key.toLocaleUpperCase()) && param1.alt == this.alt && param1.ctrl == this.ctrl && param1.shift == this.shift;
      }
      
      public function reset() : void
      {
         this.key = null;
         this.alt = false;
         this.ctrl = false;
         this.shift = false;
      }
      
      public function copy() : Bind
      {
         var _loc1_:Bind = new Bind(this.key,this.targetedShortcut,this.alt,this.ctrl,this.shift);
         _loc1_.disabled = this.disabled;
         return _loc1_;
      }
   }
}
