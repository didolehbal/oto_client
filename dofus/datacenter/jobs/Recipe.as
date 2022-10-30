package com.ankamagames.dofus.datacenter.jobs
{
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.misc.utils.GameDataQuery;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.I18nFileAccessor;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class Recipe implements IDataCenter
   {
      
      public static const MODULE:String = "Recipes";
      
      private static var _jobRecipes:Array;
       
      
      public var resultId:int;
      
      public var resultNameId:uint;
      
      public var resultTypeId:uint;
      
      public var resultLevel:uint;
      
      public var ingredientIds:Vector.<int>;
      
      public var quantities:Vector.<uint>;
      
      public var jobId:int;
      
      public var skillId:int;
      
      private var _result:ItemWrapper;
      
      private var _resultName:String;
      
      private var _ingredients:Vector.<ItemWrapper>;
      
      private var _job:Job;
      
      private var _skill:Skill;
      
      private var _words:String;
      
      public function Recipe()
      {
         super();
      }
      
      public static function getRecipeByResultId(param1:int) : Recipe
      {
         return GameData.getObject(MODULE,param1) as Recipe;
      }
      
      public static function getAllRecipesForSkillId(param1:uint, param2:uint) : Array
      {
         var _loc3_:Recipe = null;
         var _loc4_:int = 0;
         var _loc5_:Array = new Array();
         var _loc6_:Vector.<int> = Skill.getSkillById(param1).craftableItemIds;
         for each(_loc4_ in _loc6_)
         {
            _loc3_ = getRecipeByResultId(_loc4_);
            if(_loc3_)
            {
               if(_loc3_.resultLevel <= param2)
               {
                  _loc5_.push(_loc3_);
               }
            }
         }
         return _loc5_.sortOn("resultLevel",Array.NUMERIC | Array.DESCENDING);
      }
      
      public static function getAllRecipes() : Array
      {
         return GameData.getObjects(MODULE) as Array;
      }
      
      public static function getRecipesByJobId(param1:uint) : Array
      {
         var _loc5_:int = 0;
         if(param1 == 1)
         {
            return null;
         }
         if(!_jobRecipes)
         {
            _jobRecipes = new Array();
         }
         if(_jobRecipes[param1])
         {
            return _jobRecipes[param1];
         }
         var _loc2_:Array = new Array();
         var _loc3_:Vector.<uint> = GameDataQuery.queryEquals(Recipe,"jobId",param1);
         var _loc4_:int = _loc3_.length;
         while(_loc5_ < _loc3_.length)
         {
            _loc2_.push(GameData.getObject(MODULE,_loc3_[_loc5_]) as Recipe);
            _loc5_++;
         }
         _jobRecipes[param1] = _loc2_;
         return _loc2_;
      }
      
      public function get result() : ItemWrapper
      {
         if(!this._result)
         {
            this._result = ItemWrapper.create(0,0,this.resultId,0,null,false);
         }
         return this._result;
      }
      
      public function get resultName() : String
      {
         if(!this._resultName)
         {
            this._resultName = I18n.getText(this.resultNameId);
         }
         return this._resultName;
      }
      
      public function get ingredients() : Vector.<ItemWrapper>
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(!this._ingredients)
         {
            _loc1_ = this.ingredientIds.length;
            this._ingredients = new Vector.<ItemWrapper>(_loc1_,true);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               this._ingredients[_loc2_] = ItemWrapper.create(0,0,this.ingredientIds[_loc2_],this.quantities[_loc2_],null,false);
               _loc2_++;
            }
         }
         return this._ingredients;
      }
      
      public function get words() : String
      {
         var _loc1_:ItemWrapper = null;
         if(!this._words)
         {
            this._words = I18nFileAccessor.getInstance().getUnDiacriticalText(this.resultNameId);
            for each(_loc1_ in this.ingredients)
            {
               this._words = this._words + (" " + I18nFileAccessor.getInstance().getUnDiacriticalText(_loc1_.nameId));
            }
            this._words = this._words.toLowerCase();
         }
         return this._words;
      }
      
      public function get job() : Job
      {
         if(!this._job)
         {
            this._job = Job.getJobById(this.jobId);
         }
         return this._job;
      }
      
      public function get skill() : Skill
      {
         if(!this._skill)
         {
            this._skill = Skill.getSkillById(this.skillId);
         }
         return this._skill;
      }
   }
}
