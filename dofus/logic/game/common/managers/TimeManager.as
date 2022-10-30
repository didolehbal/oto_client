package com.ankamagames.dofus.logic.game.common.managers
{
   import com.ankamagames.dofus.datacenter.misc.Month;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDestroyable;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.utils.pattern.PatternDecoder;
   import flash.utils.getQualifiedClassName;
   
   public class TimeManager implements IDestroyable
   {
      
      private static var _self:TimeManager;
       
      
      protected var _log:Logger;
      
      private var _bTextInit:Boolean = false;
      
      private var _nameYears:String;
      
      private var _nameMonths:String;
      
      private var _nameDays:String;
      
      private var _nameHours:String;
      
      private var _nameMinutes:String;
      
      private var _nameSeconds:String;
      
      private var _nameAnd:String;
      
      public var serverTimeLag:Number = 0;
      
      public var serverUtcTimeLag:Number = 0;
      
      public var timezoneOffset:Number = 0;
      
      public var dofusTimeYearLag:int = 0;
      
      public function TimeManager()
      {
         this._log = Log.getLogger(getQualifiedClassName(TimeManager));
         super();
         if(_self != null)
         {
            throw new SingletonError("TimeManager is a singleton and should not be instanciated directly.");
         }
      }
      
      public static function getInstance() : TimeManager
      {
         if(_self == null)
         {
            _self = new TimeManager();
         }
         return _self;
      }
      
      public function destroy() : void
      {
         _self = null;
      }
      
      public function reset() : void
      {
         this.serverTimeLag = 0;
         this.dofusTimeYearLag = 0;
         this.timezoneOffset = 0;
      }
      
      public function getTimestamp() : Number
      {
         var _loc1_:Date = new Date();
         return _loc1_.getTime() + this.serverTimeLag;
      }
      
      public function getUtcTimestamp() : Number
      {
         var _loc1_:Date = new Date();
         return _loc1_.getTime() + this.serverUtcTimeLag;
      }
      
      public function formatClock(param1:Number, param2:Boolean = false, param3:Boolean = false) : String
      {
         var _loc4_:Number = param1;
         if(param2 && _loc4_ > 0)
         {
            _loc4_ = _loc4_ - this.serverTimeLag;
         }
         var _loc6_:String = (_loc5_ = this.getDateFromTime(_loc4_,param3))[1] >= 10?_loc5_[1].toString():"0" + _loc5_[1];
         var _loc7_:String = _loc5_[0] >= 10?_loc5_[0].toString():"0" + _loc5_[0];
         return _loc6_ + ":" + _loc7_;
      }
      
      public function formatDateIRL(param1:Number, param2:Boolean = false, param3:Boolean = false) : String
      {
         var _loc4_:Number = param1;
         if(param3 && _loc4_ > 0)
         {
            _loc4_ = _loc4_ - this.serverTimeLag;
         }
         var _loc6_:String = (_loc5_ = this.getDateFromTime(_loc4_,param2))[2] > 9?_loc5_[2].toString():"0" + _loc5_[2];
         var _loc7_:String = _loc5_[3] > 9?_loc5_[3].toString():"0" + _loc5_[3];
         return I18n.getUiText("ui.time.dateNumbers",[_loc6_,_loc7_,_loc5_[4]]);
      }
      
      public function formatDateIG(param1:Number) : String
      {
         var _loc2_:Array = this.getDateFromTime(param1);
         var _loc3_:Number = _loc2_[4] + this.dofusTimeYearLag;
         var _loc4_:String = Month.getMonthById(_loc2_[3] - 1).name;
         return I18n.getUiText("ui.time.dateLetters",[_loc2_[2],_loc4_,_loc3_]);
      }
      
      public function getDateIG(param1:Number) : Array
      {
         var _loc2_:Array = this.getDateFromTime(param1);
         var _loc3_:Number = _loc2_[4] + this.dofusTimeYearLag;
         var _loc4_:String = Month.getMonthById(_loc2_[3] - 1).name;
         return [_loc2_[2],_loc4_,_loc3_];
      }
      
      public function getDuration(param1:Number, param2:Boolean = false, param3:Boolean = false) : String
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Number = NaN;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         if(!this._bTextInit)
         {
            this.initText();
         }
         var _loc12_:Date = new Date(param1);
         if(param3)
         {
            _loc8_ = _loc12_.getUTCSeconds();
         }
         var _loc13_:Number = _loc12_.getUTCMinutes();
         var _loc14_:Number = _loc12_.getUTCHours();
         var _loc15_:Number = _loc12_.getUTCDate() - 1;
         var _loc16_:Number = _loc12_.getUTCMonth();
         var _loc17_:Number = _loc12_.getUTCFullYear() - 1970;
         if(!param2)
         {
            if(param3)
            {
               _loc7_ = _loc8_ > 1?_loc8_ + " " + PatternDecoder.combine(this._nameSeconds,"f",false):_loc8_ + " " + PatternDecoder.combine(this._nameSeconds,"f",true);
            }
            _loc6_ = _loc13_ > 1?_loc13_ + " " + PatternDecoder.combine(this._nameMinutes,"f",false):_loc13_ + " " + PatternDecoder.combine(this._nameMinutes,"f",true);
            _loc5_ = _loc14_ > 1?_loc14_ + " " + PatternDecoder.combine(this._nameHours,"f",false):_loc14_ + " " + PatternDecoder.combine(this._nameHours,"f",true);
            _loc9_ = _loc15_ > 1?_loc15_ + " " + PatternDecoder.combine(this._nameDays,"f",false):_loc15_ + " " + PatternDecoder.combine(this._nameDays,"f",true);
            _loc10_ = _loc16_ > 1?_loc16_ + " " + PatternDecoder.combine(this._nameMonths,"f",false):_loc16_ + " " + PatternDecoder.combine(this._nameMonths,"f",true);
            _loc11_ = _loc17_ > 1?_loc17_ + " " + PatternDecoder.combine(this._nameYears,"f",false):_loc17_ + " " + PatternDecoder.combine(this._nameYears,"f",true);
            if(_loc17_ == 0)
            {
               if(_loc16_ == 0)
               {
                  if(_loc15_ == 0)
                  {
                     if(_loc14_ == 0)
                     {
                        if(param3)
                        {
                           if(_loc13_ == 0)
                           {
                              _loc4_ = _loc7_;
                           }
                           else
                           {
                              _loc4_ = _loc6_ + " " + this._nameAnd + " " + _loc7_;
                           }
                        }
                        else
                        {
                           _loc4_ = _loc6_;
                        }
                     }
                     else
                     {
                        _loc4_ = _loc5_ + " " + this._nameAnd + " " + _loc6_;
                     }
                  }
                  else
                  {
                     _loc4_ = _loc9_ + " " + this._nameAnd + " " + _loc5_;
                  }
               }
               else
               {
                  _loc4_ = _loc10_ + " " + this._nameAnd + " " + _loc9_;
               }
            }
            else
            {
               _loc4_ = _loc11_ + " " + this._nameAnd + " " + _loc10_;
            }
            return _loc4_;
         }
         _loc5_ = _loc14_ >= 10?_loc14_.toString():"0" + _loc14_;
         _loc6_ = _loc13_ >= 10?_loc13_.toString():"0" + _loc13_;
         if(param3)
         {
            _loc7_ = _loc8_ >= 10?_loc8_.toString():"0" + _loc8_;
            return _loc5_ + ":" + _loc6_ + ":" + _loc7_;
         }
         return _loc5_ + ":" + _loc6_;
      }
      
      public function getDateFromTime(param1:Number, param2:Boolean = false) : Array
      {
         var _loc3_:Date = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Date = null;
         if(param1 == 0)
         {
            _loc9_ = new Date();
            _loc3_ = new Date(_loc9_.getTime() + this.serverTimeLag);
         }
         else
         {
            _loc3_ = new Date(param1 + this.serverTimeLag);
         }
         if(param2)
         {
            _loc4_ = _loc3_.getDate();
            _loc5_ = _loc3_.getMonth() + 1;
            _loc6_ = _loc3_.getFullYear();
            _loc7_ = _loc3_.getHours();
            _loc8_ = _loc3_.getMinutes();
         }
         else
         {
            _loc4_ = _loc3_.getUTCDate();
            _loc5_ = _loc3_.getUTCMonth() + 1;
            _loc6_ = _loc3_.getUTCFullYear();
            _loc7_ = _loc3_.getUTCHours();
            _loc8_ = _loc3_.getUTCMinutes();
         }
         return [_loc8_,_loc7_,_loc4_,_loc5_,_loc6_];
      }
      
      private function initText() : void
      {
         this._nameYears = I18n.getUiText("ui.time.years");
         this._nameMonths = I18n.getUiText("ui.time.months");
         this._nameDays = I18n.getUiText("ui.time.days");
         this._nameHours = I18n.getUiText("ui.time.hours");
         this._nameMinutes = I18n.getUiText("ui.time.minutes");
         this._nameSeconds = I18n.getUiText("ui.time.seconds");
         this._nameAnd = I18n.getUiText("ui.common.and").toLowerCase();
         this._bTextInit = true;
      }
   }
}
