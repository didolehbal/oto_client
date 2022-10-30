package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.jobs.Job;
   import com.ankamagames.dofus.datacenter.jobs.Recipe;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.jobs.KnownJobWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.AveragePricesFrame;
   import com.ankamagames.dofus.logic.game.common.frames.JobsFrame;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.dofus.network.ProtocolConstantsEnum;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobDescription;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElementSkill;
   import com.ankamagames.dofus.network.types.game.interactive.skill.SkillActionDescription;
   import com.ankamagames.dofus.network.types.game.interactive.skill.SkillActionDescriptionCollect;
   import com.ankamagames.dofus.network.types.game.interactive.skill.SkillActionDescriptionCraft;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import flash.globalization.Collator;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class JobsApi implements IApi
   {
       
      
      protected var _log:Logger;
      
      private var _module:UiModule;
      
      private var _stringSorter:Collator;
      
      public function JobsApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(JobsApi));
         super();
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      private function get jobsFrame() : JobsFrame
      {
         return Kernel.getWorker().getFrame(JobsFrame) as JobsFrame;
      }
      
      private function get averagePricesFrame() : AveragePricesFrame
      {
         return Kernel.getWorker().getFrame(AveragePricesFrame) as AveragePricesFrame;
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._module = null;
      }
      
      [Untrusted]
      public function getJobSkills(param1:int) : Array
      {
         var _loc2_:SkillActionDescription = null;
         var _loc5_:uint = 0;
         var _loc6_:* = undefined;
         var _loc3_:JobDescription = this.getJobDescription(param1);
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:Array = new Array(_loc3_.skills.length);
         for each(_loc2_ in _loc3_.skills)
         {
            _loc6_ = _loc5_++;
            _loc4_[_loc6_] = Skill.getSkillById(_loc2_.skillId);
         }
         return _loc4_;
      }
      
      [Untrusted]
      public function getJobSkillType(param1:int, param2:Skill) : String
      {
         var _loc3_:JobDescription = this.getJobDescription(param1);
         if(!_loc3_)
         {
            return "unknown";
         }
         var _loc4_:SkillActionDescription;
         if(!(_loc4_ = this.getSkillActionDescription(_loc3_,param2.id)))
         {
            return "unknown";
         }
         switch(true)
         {
            case _loc4_ is SkillActionDescriptionCollect:
               return "collect";
            case _loc4_ is SkillActionDescriptionCraft:
               return "craft";
            default:
               this._log.warn("Unknown SkillActionDescription type : " + _loc4_);
               return "unknown";
         }
      }
      
      [Untrusted]
      public function getJobCollectSkillInfos(param1:int, param2:Skill) : Object
      {
         var _loc3_:JobDescription = this.getJobDescription(param1);
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:SkillActionDescription;
         if(!(_loc4_ = this.getSkillActionDescription(_loc3_,param2.id)))
         {
            return null;
         }
         if(!(_loc4_ is SkillActionDescriptionCollect))
         {
            return null;
         }
         var _loc5_:SkillActionDescriptionCollect = _loc4_ as SkillActionDescriptionCollect;
         var _loc6_:Object;
         (_loc6_ = new Object()).time = _loc5_.time / 10;
         _loc6_.minResources = _loc5_.min;
         _loc6_.maxResources = _loc5_.max;
         _loc6_.resourceItem = Item.getItemById(param2.gatheredRessourceItem);
         return _loc6_;
      }
      
      [Untrusted]
      public function getMaxSlotsByJobId(param1:int) : int
      {
         return 8;
      }
      
      [Untrusted]
      public function getJobExperience(param1:int) : Object
      {
         if(param1 == 1)
         {
            return null;
         }
         var _loc2_:KnownJobWrapper = PlayedCharacterManager.getInstance().jobs[param1];
         if(!_loc2_)
         {
            return null;
         }
         var _loc3_:Object = new Object();
         _loc3_.currentLevel = _loc2_.jobLevel;
         _loc3_.currentExperience = _loc2_.jobXP;
         _loc3_.levelExperienceFloor = _loc2_.jobXpLevelFloor;
         _loc3_.levelExperienceCeil = _loc2_.jobXpNextLevelFloor;
         return _loc3_;
      }
      
      [Untrusted]
      public function getCraftXp(param1:ItemWrapper, param2:uint) : int
      {
         return param1.getCraftXpByJobLevel(param2);
      }
      
      [Untrusted]
      public function getSkillFromId(param1:int) : Skill
      {
         return Skill.getSkillById(param1);
      }
      
      [Untrusted]
      public function getRecipe(param1:uint) : Recipe
      {
         return Recipe.getRecipeByResultId(param1);
      }
      
      [Untrusted]
      public function getRecipesList(param1:uint) : Array
      {
         var _loc2_:Array = Item.getItemById(param1).recipes;
         if(_loc2_)
         {
            return _loc2_;
         }
         return new Array();
      }
      
      [Untrusted]
      public function getJobName(param1:uint) : String
      {
         var _loc2_:Job = Job.getJobById(param1);
         if(_loc2_)
         {
            return _loc2_.name;
         }
         this._log.error("We want the name of a non-existing job (id : " + param1 + ")");
         return "";
      }
      
      [Untrusted]
      public function getJob(param1:uint) : Object
      {
         return Job.getJobById(param1);
      }
      
      [Untrusted]
      public function getJobCrafterDirectorySettingsById(param1:uint) : Object
      {
         if(!this.jobsFrame || !this.jobsFrame.settings)
         {
            return null;
         }
         return this.jobsFrame.settings[param1];
      }
      
      [Untrusted]
      public function getUsableSkillsInMap(param1:int) : Array
      {
         var _loc2_:Boolean = false;
         var _loc3_:uint = 0;
         var _loc4_:InteractiveElement = null;
         var _loc5_:InteractiveElementSkill = null;
         var _loc6_:InteractiveElementSkill = null;
         var _loc7_:Array = new Array();
         var _loc8_:RoleplayContextFrame;
         var _loc9_:Vector.<InteractiveElement> = (_loc8_ = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame).entitiesFrame.interactiveElements;
         var _loc10_:Vector.<uint> = _loc8_.getMultiCraftSkills(param1);
         for each(_loc3_ in _loc10_)
         {
            _loc2_ = false;
            for each(_loc4_ in _loc9_)
            {
               for each(_loc5_ in _loc4_.enabledSkills)
               {
                  if(_loc3_ == _loc5_.skillId && _loc7_.indexOf(_loc5_.skillId) == -1)
                  {
                     _loc2_ = true;
                     break;
                  }
               }
               for each(_loc6_ in _loc4_.disabledSkills)
               {
                  if(_loc3_ == _loc6_.skillId && _loc7_.indexOf(_loc6_.skillId) == -1)
                  {
                     _loc2_ = true;
                     break;
                  }
               }
               if(_loc2_)
               {
                  break;
               }
            }
            if(_loc2_)
            {
               _loc7_.push(Skill.getSkillById(_loc3_));
            }
         }
         return _loc7_;
      }
      
      [Untrusted]
      public function getKnownJobs() : Array
      {
         var _loc1_:KnownJobWrapper = null;
         var _loc2_:Array = new Array();
         for each(_loc1_ in PlayedCharacterManager.getInstance().jobs)
         {
            if(_loc1_ != null)
            {
               _loc2_.push(_loc1_);
            }
         }
         return _loc2_;
      }
      
      [Trusted]
      public function getKnownJob(param1:uint) : KnownJobWrapper
      {
         var _loc2_:KnownJobWrapper = null;
         if(!PlayedCharacterManager.getInstance().jobs)
         {
            return null;
         }
         if(param1 == 1)
         {
            _loc2_ = new KnownJobWrapper();
            _loc2_.id = 1;
            _loc2_.jobLevel = 1;
         }
         else
         {
            _loc2_ = PlayedCharacterManager.getInstance().jobs[param1] as KnownJobWrapper;
         }
         if(!_loc2_)
         {
            return null;
         }
         return _loc2_;
      }
      
      [Untrusted]
      public function getRecipesByJob(param1:Dictionary, param2:int = 0, param3:int = 0, param4:Boolean = false, param5:int = 8) : Vector.<Recipe>
      {
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:Recipe = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Array = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:uint = 0;
         var _loc18_:uint = 0;
         var _loc19_:Vector.<Recipe> = new Vector.<Recipe>();
         if(param2 > 0)
         {
            _loc6_ = Recipe.getAllRecipesForSkillId(param2,ProtocolConstantsEnum.MAX_JOB_LEVEL);
         }
         else if(param3 > 0)
         {
            _loc6_ = Recipe.getRecipesByJobId(param3);
         }
         else
         {
            _loc6_ = Recipe.getAllRecipes();
         }
         var _loc20_:int = _loc6_.length;
         _loc7_ = 0;
         while(_loc7_ < _loc20_)
         {
            _loc9_ = (_loc8_ = _loc6_[_loc7_]).ingredientIds.length;
            if(!(!_loc8_.job || param3 == 0 && _loc8_.jobId == 1))
            {
               _loc10_ = 0;
               _loc11_ = 0;
               _loc12_ = 0;
               _loc13_ = 0;
               _loc14_ = new Array();
               _loc15_ = param5;
               _loc16_ = 0;
               while(_loc16_ < _loc9_)
               {
                  _loc10_ = _loc10_ + _loc8_.quantities[_loc16_];
                  if(param1[_loc8_.ingredientIds[_loc16_]])
                  {
                     _loc11_ = param1[_loc8_.ingredientIds[_loc16_]].totalQuantity;
                  }
                  else
                  {
                     _loc11_ = 0;
                  }
                  if(_loc11_)
                  {
                     if(_loc11_ >= _loc8_.quantities[_loc16_])
                     {
                        _loc14_.push(int(_loc11_ / _loc8_.quantities[_loc16_]));
                        _loc13_ = _loc13_ + _loc8_.quantities[_loc16_];
                        _loc12_++;
                     }
                     else
                     {
                        _loc14_.push(0);
                        _loc15_--;
                     }
                  }
                  else if(_loc15_ > 0)
                  {
                     _loc14_.push(0);
                     _loc15_--;
                  }
                  _loc16_++;
               }
               if(_loc12_ == _loc8_.ingredientIds.length && _loc13_ >= _loc10_ || param5 > 0 && _loc12_ + param5 >= _loc8_.ingredientIds.length)
               {
                  _loc19_.push(_loc8_);
                  _loc14_.sort(Array.NUMERIC);
                  if(!param1[_loc8_.resultId])
                  {
                     param1[_loc8_.resultId] = {"actualMaxOccurence":_loc14_[0]};
                  }
                  else
                  {
                     SecureCenter.unsecure(param1[_loc8_.resultId]).actualMaxOccurence = _loc14_[0];
                  }
                  if(param4)
                  {
                     _loc17_ = 0;
                     for each(_loc18_ in _loc14_)
                     {
                        if(_loc18_ != 0)
                        {
                           _loc17_ = _loc18_;
                           break;
                        }
                     }
                     SecureCenter.unsecure(param1[_loc8_.resultId]).potentialMaxOccurence = _loc17_;
                  }
               }
            }
            _loc7_++;
         }
         _loc19_.fixed = true;
         return _loc19_;
      }
      
      [Untrusted]
      public function getJobFilteredRecipes(param1:Object, param2:Array, param3:int = 1, param4:int = 1, param5:String = null, param6:int = 0) : Array
      {
         var _loc7_:Recipe = null;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:Array = new Array();
         if(param5)
         {
            param5 = StringUtils.noAccent(param5).toLowerCase();
         }
         for each(_loc7_ in param1)
         {
            if(_loc7_)
            {
               _loc8_ = false;
               _loc9_ = false;
               _loc10_ = false;
               if(param3 > 1 || param4 < ProtocolConstantsEnum.MAX_JOB_LEVEL)
               {
                  if(_loc7_.resultLevel >= param3 && _loc7_.resultLevel <= param4)
                  {
                     _loc8_ = true;
                  }
                  else
                  {
                     _loc8_ = false;
                  }
               }
               else
               {
                  _loc8_ = true;
               }
               if(param6 > 0)
               {
                  if(_loc7_.resultTypeId == param6)
                  {
                     _loc9_ = true;
                  }
                  else
                  {
                     _loc9_ = false;
                  }
               }
               else
               {
                  _loc9_ = true;
               }
               if(_loc8_ && _loc9_ && param5)
               {
                  if(_loc7_.words.indexOf(param5) != -1)
                  {
                     _loc10_ = true;
                  }
                  else
                  {
                     _loc10_ = false;
                  }
               }
               else
               {
                  _loc10_ = true;
               }
               if(_loc8_ && _loc10_)
               {
                  if(param2.indexOf(_loc7_.result.type) == -1)
                  {
                     param2.push(_loc7_.result.type);
                  }
                  if(_loc9_)
                  {
                     _loc11_.push(_loc7_);
                  }
               }
            }
         }
         return _loc11_;
      }
      
      [Untrusted]
      public function getInventoryData(param1:Boolean = false) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:Vector.<ItemWrapper> = null;
         var _loc4_:ItemWrapper = null;
         var _loc5_:Vector.<ItemWrapper> = null;
         var _loc9_:int = 0;
         var _loc6_:Array = new Array();
         var _loc7_:Vector.<Recipe> = new Vector.<Recipe>();
         if(param1)
         {
            _loc3_ = InventoryManager.getInstance().bankInventory.getView("bank").content;
         }
         else
         {
            _loc3_ = InventoryManager.getInstance().inventory.getView("storage").content;
         }
         var _loc8_:int = _loc3_.length;
         while(_loc9_ < _loc8_)
         {
            if(!(_loc4_ = _loc3_[_loc9_]).linked)
            {
               if(!_loc6_[_loc4_.objectGID])
               {
                  _loc6_[_loc4_.objectGID] = {
                     "totalQuantity":_loc4_.quantity,
                     "stackUidList":[_loc4_.objectUID],
                     "stackQtyList":[_loc4_.quantity],
                     "fromBag":[false],
                     "storageTotalQuantity":_loc4_.quantity
                  };
               }
               else
               {
                  _loc6_[_loc4_.objectGID].totalQuantity = _loc6_[_loc4_.objectGID].totalQuantity + _loc4_.quantity;
                  _loc6_[_loc4_.objectGID].stackUidList.push(_loc4_.objectUID);
                  _loc6_[_loc4_.objectGID].stackQtyList.push(_loc4_.quantity);
                  _loc6_[_loc4_.objectGID].fromBag.push(false);
                  _loc6_[_loc4_.objectGID].storageTotalQuantity = _loc6_[_loc4_.objectGID].storageTotalQuantity + _loc4_.quantity;
               }
            }
            _loc9_++;
         }
         if(param1)
         {
            _loc8_ = (_loc5_ = InventoryManager.getInstance().inventory.getView("storage").content).length;
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               if(!(_loc4_ = _loc5_[_loc9_]).linked)
               {
                  if(!_loc6_[_loc4_.objectGID])
                  {
                     _loc6_[_loc4_.objectGID] = {
                        "totalQuantity":_loc4_.quantity,
                        "stackUidList":[_loc4_.objectUID],
                        "stackQtyList":[_loc4_.quantity],
                        "fromBag":[true]
                     };
                  }
                  else
                  {
                     _loc6_[_loc4_.objectGID].totalQuantity = _loc6_[_loc4_.objectGID].totalQuantity + _loc4_.quantity;
                     _loc6_[_loc4_.objectGID].stackUidList.push(_loc4_.objectUID);
                     _loc6_[_loc4_.objectGID].stackQtyList.push(_loc4_.quantity);
                     _loc6_[_loc4_.objectGID].fromBag.push(true);
                  }
               }
               _loc9_++;
            }
         }
         return _loc6_;
      }
      
      [Untrusted]
      public function sortRecipesByCriteria(param1:Object, param2:String, param3:Boolean) : Object
      {
         this.sortRecipes(param1,param2,!!param3?1:-1);
         return param1;
      }
      
      private function sortRecipes(param1:Object, param2:String, param3:int = 1) : void
      {
         if(!this._stringSorter)
         {
            this._stringSorter = new Collator(XmlConfig.getInstance().getEntry("config.lang.current"));
         }
         switch(param2)
         {
            case "level":
               param1.sort(this.compareLevel(param3));
               return;
            case "price":
               param1.sort(this.comparePrice(param3));
               return;
            default:
               return;
         }
      }
      
      private function compareLevel(param1:int = 1) : Function
      {
         var way:int = param1;
         return function(param1:*, param2:*):Number
         {
            if(param1.resultLevel < param2.resultLevel)
            {
               return -way;
            }
            if(param1.resultLevel > param2.resultLevel)
            {
               return way;
            }
            return _stringSorter.compare(param1.resultName,param2.resultName);
         };
      }
      
      private function comparePrice(param1:int = 1) : Function
      {
         var way:int = param1;
         return function(param1:*, param2:*):Number
         {
            var _loc3_:* = averagePricesFrame.pricesData.items["item" + param1.resultId];
            var _loc4_:* = averagePricesFrame.pricesData.items["item" + param2.resultId];
            if(!_loc3_)
            {
               _loc3_ = way == 1?int.MAX_VALUE:0;
            }
            if(!_loc4_)
            {
               _loc4_ = way == 1?int.MAX_VALUE:0;
            }
            if(_loc3_ < _loc4_)
            {
               return -way;
            }
            if(_loc3_ > _loc4_)
            {
               return way;
            }
            return _stringSorter.compare(param1.resultName,param2.resultName);
         };
      }
      
      private function getJobDescription(param1:uint) : JobDescription
      {
         var _loc2_:KnownJobWrapper = this.getKnownJob(param1);
         if(!_loc2_)
         {
            return null;
         }
         return _loc2_.jobDescription;
      }
      
      private function getSkillActionDescription(param1:JobDescription, param2:uint) : SkillActionDescription
      {
         var _loc3_:SkillActionDescription = null;
         for each(_loc3_ in param1.skills)
         {
            if(_loc3_.skillId == param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
   }
}
