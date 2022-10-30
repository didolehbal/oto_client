package com.ankamagames.dofus.datacenter.items.criterion
{
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import flash.utils.getQualifiedClassName;
   
   public class GroupItemCriterion implements IItemCriterion, IDataCenter
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(GroupItemCriterion));
       
      
      private var _criteria:Vector.<IItemCriterion>;
      
      private var _operators:Vector.<String>;
      
      private var _criterionTextForm:String;
      
      private var _cleanCriterionTextForm:String;
      
      private var _malformated:Boolean = false;
      
      private var _singleOperatorType:Boolean = false;
      
      public function GroupItemCriterion(param1:String)
      {
         super();
         this._criterionTextForm = param1;
         this._cleanCriterionTextForm = this._criterionTextForm;
         if(!param1)
         {
            return;
         }
         this._cleanCriterionTextForm = StringUtils.replace(this._cleanCriterionTextForm," ","");
         var _loc2_:Vector.<String> = StringUtils.getDelimitedText(this._cleanCriterionTextForm,"(",")",true);
         if(_loc2_.length > 0 && _loc2_[0] == this._cleanCriterionTextForm)
         {
            this._cleanCriterionTextForm = this._cleanCriterionTextForm.slice(1);
            this._cleanCriterionTextForm = this._cleanCriterionTextForm.slice(0,this._cleanCriterionTextForm.length - 1);
         }
         this.split();
         this.createNewGroups();
      }
      
      public static function create(param1:Vector.<IItemCriterion>, param2:Vector.<String>) : GroupItemCriterion
      {
         var _loc3_:* = undefined;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc4_:uint = param1.length + param2.length;
         var _loc5_:* = "";
         while(_loc8_ < _loc4_)
         {
            _loc3_ = _loc8_ % 2;
            if(_loc3_ == 0)
            {
               _loc5_ = _loc5_ + (param1[_loc6_++] as IItemCriterion).basicText;
            }
            else
            {
               _loc5_ = _loc5_ + param2[_loc7_++];
            }
            _loc8_++;
         }
         return new GroupItemCriterion(_loc5_);
      }
      
      public function get criteria() : Vector.<IItemCriterion>
      {
         return this._criteria;
      }
      
      public function get inlineCriteria() : Vector.<IItemCriterion>
      {
         var _loc1_:IItemCriterion = null;
         var _loc2_:Vector.<IItemCriterion> = new Vector.<IItemCriterion>();
         for each(_loc1_ in this._criteria)
         {
            _loc2_ = _loc2_.concat(_loc1_.inlineCriteria);
         }
         return _loc2_;
      }
      
      public function get isRespected() : Boolean
      {
         var _loc1_:IItemCriterion = null;
         if(!this._criteria || this._criteria.length == 0)
         {
            return true;
         }
         var _loc2_:PlayedCharacterManager = PlayedCharacterManager.getInstance();
         if(!_loc2_ || !_loc2_.characteristics)
         {
            return true;
         }
         if(this._criteria && this._criteria.length == 1 && this._criteria[0] is ItemCriterion)
         {
            return (this._criteria[0] as ItemCriterion).isRespected;
         }
         if(this._operators[0] == "|")
         {
            for each(_loc1_ in this._criteria)
            {
               if(_loc1_.isRespected)
               {
                  return true;
               }
            }
            return false;
         }
         for each(_loc1_ in this._criteria)
         {
            if(!_loc1_.isRespected)
            {
               return false;
            }
         }
         return true;
      }
      
      public function get text() : String
      {
         var _loc1_:* = undefined;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc2_:* = "";
         if(this._criteria == null)
         {
            return _loc2_;
         }
         var _loc3_:uint = this._criteria.length + this._operators.length;
         while(_loc6_ < _loc3_)
         {
            _loc1_ = _loc6_ % 2;
            if(_loc1_ == 0)
            {
               _loc2_ = _loc2_ + (this._criteria[_loc4_++] as IItemCriterion).text + " ";
            }
            else
            {
               _loc2_ = _loc2_ + this._operators[_loc5_++] + " ";
            }
            _loc6_++;
         }
         return _loc2_;
      }
      
      public function get basicText() : String
      {
         return this._criterionTextForm;
      }
      
      public function clone() : IItemCriterion
      {
         return new GroupItemCriterion(this.basicText);
      }
      
      private function createNewGroups() : void
      {
         var _loc1_:IItemCriterion = null;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Vector.<IItemCriterion> = null;
         var _loc6_:Vector.<String> = null;
         var _loc7_:GroupItemCriterion = null;
         if(this._malformated || !this._criteria || this._criteria.length <= 2 || this._singleOperatorType)
         {
            return;
         }
         var _loc8_:Vector.<IItemCriterion> = new Vector.<IItemCriterion>();
         var _loc9_:Vector.<String> = new Vector.<String>();
         for each(_loc1_ in this._criteria)
         {
            _loc8_.push(_loc1_.clone());
         }
         for each(_loc2_ in this._operators)
         {
            _loc9_.push(_loc2_);
         }
         _loc3_ = 0;
         _loc4_ = false;
         while(!_loc4_)
         {
            if(_loc8_.length <= 2)
            {
               _loc4_ = true;
            }
            else
            {
               if(_loc9_[_loc3_] == "&")
               {
                  (_loc5_ = new Vector.<IItemCriterion>()).push(_loc8_[_loc3_]);
                  _loc5_.push(_loc8_[_loc3_ + 1]);
                  _loc6_ = Vector.<String>([_loc9_[_loc3_]]);
                  _loc7_ = GroupItemCriterion.create(_loc5_,_loc6_);
                  _loc8_.splice(_loc3_,2,_loc7_);
                  _loc9_.splice(_loc3_,1);
                  _loc3_--;
               }
               if(++_loc3_ >= _loc9_.length)
               {
                  _loc4_ = true;
               }
            }
         }
         this._criteria = _loc8_;
         this._operators = _loc9_;
         this._singleOperatorType = this.checkSingleOperatorType(this._operators);
      }
      
      private function split() : void
      {
         var _loc1_:IItemCriterion = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:IItemCriterion = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:uint = 0;
         var _loc14_:Boolean = false;
         if(!this._cleanCriterionTextForm)
         {
            return;
         }
         var _loc12_:uint = 1;
         var _loc13_:uint = _loc11_;
         var _loc15_:String = this._cleanCriterionTextForm;
         this._criteria = new Vector.<IItemCriterion>();
         this._operators = new Vector.<String>();
         var _loc16_:Array = StringUtils.getAllIndexOf("&",_loc15_);
         var _loc17_:Array = StringUtils.getAllIndexOf("|",_loc15_);
         if(_loc16_.length == 0 || _loc17_.length == 0)
         {
            this._singleOperatorType = true;
            while(!_loc14_)
            {
               _loc1_ = this.getFirstCriterion(_loc15_);
               if(!_loc1_)
               {
                  _loc2_ = _loc15_.indexOf("&");
                  if(_loc2_ == -1)
                  {
                     _loc2_ = _loc15_.indexOf("|");
                  }
                  if(_loc2_ == -1)
                  {
                     _loc15_ = "";
                  }
                  else
                  {
                     _loc15_ = _loc15_.slice(_loc2_ + 1);
                  }
               }
               else
               {
                  this._criteria.push(_loc1_);
                  _loc3_ = _loc15_.indexOf(_loc1_.basicText);
                  if(_loc4_ = _loc15_.slice(_loc3_ + _loc1_.basicText.length,_loc3_ + 1 + _loc1_.basicText.length))
                  {
                     this._operators.push(_loc4_);
                  }
                  _loc15_ = _loc15_.slice(_loc3_ + 1 + _loc1_.basicText.length);
               }
               if(!_loc15_)
               {
                  _loc14_ = true;
               }
            }
         }
         else
         {
            while(!_loc14_)
            {
               if(!_loc15_)
               {
                  _loc14_ = true;
               }
               else if(_loc13_ == _loc11_)
               {
                  if(!(_loc5_ = this.getFirstCriterion(_loc15_)))
                  {
                     if((_loc6_ = _loc15_.indexOf("&")) == -1)
                     {
                        _loc6_ = _loc15_.indexOf("|");
                     }
                     if(_loc6_ == -1)
                     {
                        _loc15_ = "";
                     }
                     else
                     {
                        _loc15_ = _loc15_.slice(_loc6_ + 1);
                     }
                  }
                  else
                  {
                     this._criteria.push(_loc5_);
                     _loc13_ = _loc12_;
                     _loc7_ = _loc15_.indexOf(_loc5_.basicText);
                     _loc8_ = _loc15_.slice(0,_loc7_);
                     _loc9_ = _loc15_.slice(_loc7_ + _loc5_.basicText.length);
                     _loc15_ = _loc8_ + _loc9_;
                  }
                  if(!_loc15_)
                  {
                     _loc14_ = true;
                  }
               }
               else if(!(_loc10_ = _loc15_.slice(0,1)))
               {
                  _loc14_ = true;
               }
               else
               {
                  this._operators.push(_loc10_);
                  _loc13_ = _loc11_;
                  _loc15_ = _loc15_.slice(1);
               }
            }
            this._singleOperatorType = this.checkSingleOperatorType(this._operators);
         }
         if(this._operators.length >= this._criteria.length && (this._operators.length > 0 && this._criteria.length > 0))
         {
            this._malformated = true;
         }
      }
      
      private function checkSingleOperatorType(param1:Vector.<String>) : Boolean
      {
         var _loc2_:String = null;
         if(param1.length > 0)
         {
            for each(_loc2_ in param1)
            {
               if(_loc2_ != param1[0])
               {
                  return false;
               }
            }
         }
         return true;
      }
      
      private function getFirstCriterion(param1:String) : IItemCriterion
      {
         var _loc2_:IItemCriterion = null;
         var _loc3_:Vector.<String> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(!param1)
         {
            return null;
         }
         param1 = StringUtils.replace(param1," ","");
         if(param1.slice(0,1) == "(")
         {
            _loc3_ = StringUtils.getDelimitedText(param1,"(",")",true);
            _loc2_ = new GroupItemCriterion(_loc3_[0]);
         }
         else
         {
            _loc4_ = param1.indexOf("&");
            _loc5_ = param1.indexOf("|");
            if(_loc4_ == -1 && _loc5_ == -1)
            {
               _loc2_ = ItemCriterionFactory.create(param1);
            }
            else if((_loc4_ < _loc5_ || _loc5_ == -1) && _loc4_ != -1)
            {
               _loc2_ = ItemCriterionFactory.create(param1.split("&")[0]);
            }
            else
            {
               _loc2_ = ItemCriterionFactory.create(param1.split("|")[0]);
            }
         }
         return _loc2_;
      }
      
      public function get operators() : Vector.<String>
      {
         return this._operators;
      }
   }
}
