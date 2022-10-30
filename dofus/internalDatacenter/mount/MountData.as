package com.ankamagames.dofus.internalDatacenter.mount
{
   import com.ankamagames.dofus.datacenter.mounts.Mount;
   import com.ankamagames.dofus.datacenter.mounts.MountBehavior;
   import com.ankamagames.dofus.misc.ObjectEffectAdapter;
   import com.ankamagames.dofus.network.types.game.mount.MountClientData;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.utils.Dictionary;
   
   public class MountData implements IDataCenter
   {
      
      private static var _dictionary_cache:Dictionary = new Dictionary();
       
      
      public var id:Number = 0;
      
      public var model:uint = 0;
      
      public var name:String = "";
      
      public var description:String = "";
      
      public var entityLook:TiphonEntityLook;
      
      public var colors:Array;
      
      public var sex:Boolean = false;
      
      public var level:uint = 0;
      
      public var ownerId:uint = 0;
      
      public var experience:Number = 0;
      
      public var experienceForLevel:Number = 0;
      
      public var experienceForNextLevel:Number = 0;
      
      public var xpRatio:uint;
      
      public var maxPods:uint = 0;
      
      public var isRideable:Boolean = false;
      
      public var isWild:Boolean = false;
      
      public var borning:Boolean = false;
      
      public var energy:uint = 0;
      
      public var energyMax:uint = 0;
      
      public var stamina:uint = 0;
      
      public var staminaMax:uint = 0;
      
      public var maturity:uint = 0;
      
      public var maturityForAdult:uint = 0;
      
      public var serenity:int = 0;
      
      public var serenityMax:uint = 0;
      
      public var aggressivityMax:int = 0;
      
      public var love:uint = 0;
      
      public var loveMax:uint = 0;
      
      public var fecondationTime:int = 0;
      
      public var isFecondationReady:Boolean;
      
      public var reproductionCount:int = 0;
      
      public var reproductionCountMax:uint = 0;
      
      public var boostLimiter:uint = 0;
      
      public var boostMax:Number = 0;
      
      public var effectList:Array;
      
      public var ancestor:Object;
      
      public var ability:Array;
      
      public function MountData()
      {
         this.effectList = new Array();
         this.ability = new Array();
         super();
      }
      
      public static function makeMountData(param1:MountClientData, param2:Boolean = true, param3:uint = 0) : MountData
      {
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:MountData = new MountData();
         if(_dictionary_cache[param1.id] && param2)
         {
            _loc7_ = getMountFromCache(param1.id);
         }
         var _loc8_:Mount = Mount.getMountById(param1.model);
         if(!param1.name)
         {
            _loc7_.name = I18n.getUiText("ui.common.noName");
         }
         else
         {
            _loc7_.name = param1.name;
         }
         _loc7_.id = param1.id;
         _loc7_.model = param1.model;
         _loc7_.description = _loc8_.name;
         _loc7_.sex = param1.sex;
         _loc7_.ownerId = param1.ownerId;
         _loc7_.level = param1.level;
         _loc7_.experience = param1.experience;
         _loc7_.experienceForLevel = param1.experienceForLevel;
         _loc7_.experienceForNextLevel = param1.experienceForNextLevel;
         _loc7_.xpRatio = param3;
         try
         {
            _loc7_.entityLook = TiphonEntityLook.fromString(_loc8_.look);
            _loc7_.colors = _loc7_.entityLook.getColors();
         }
         catch(e:Error)
         {
         }
         var _loc9_:Vector.<uint>;
         (_loc9_ = param1.ancestor.concat()).unshift(param1.model);
         _loc7_.ancestor = makeParent(_loc9_,0,-1,0);
         _loc7_.ability = new Array();
         for each(_loc4_ in param1.behaviors)
         {
            _loc7_.ability.push(MountBehavior.getMountBehaviorById(_loc4_));
         }
         _loc7_.effectList = new Array();
         _loc5_ = param1.effectList.length;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_.effectList.push(ObjectEffectAdapter.fromNetwork(param1.effectList[_loc6_]));
            _loc6_++;
         }
         _loc7_.maxPods = param1.maxPods;
         _loc7_.isRideable = param1.isRideable;
         _loc7_.isWild = param1.isWild;
         _loc7_.energy = param1.energy;
         _loc7_.energyMax = param1.energyMax;
         _loc7_.stamina = param1.stamina;
         _loc7_.staminaMax = param1.staminaMax;
         _loc7_.maturity = param1.maturity;
         _loc7_.maturityForAdult = param1.maturityForAdult;
         _loc7_.serenity = param1.serenity;
         _loc7_.serenityMax = param1.serenityMax;
         _loc7_.aggressivityMax = param1.aggressivityMax;
         _loc7_.love = param1.love;
         _loc7_.loveMax = param1.loveMax;
         _loc7_.fecondationTime = param1.fecondationTime;
         _loc7_.isFecondationReady = param1.isFecondationReady;
         _loc7_.reproductionCount = param1.reproductionCount;
         _loc7_.reproductionCountMax = param1.reproductionCountMax;
         _loc7_.boostLimiter = param1.boostLimiter;
         _loc7_.boostMax = param1.boostMax;
         if(!_dictionary_cache[param1.id] || !param2)
         {
            _dictionary_cache[_loc7_.id] = _loc7_;
         }
         return _loc7_;
      }
      
      public static function getMountFromCache(param1:uint) : MountData
      {
         return _dictionary_cache[param1];
      }
      
      private static function makeParent(param1:Vector.<uint>, param2:uint, param3:int, param4:uint) : Object
      {
         var _loc5_:uint;
         var _loc6_:uint = (_loc5_ = param3 + Math.pow(2,param2 - 1)) + param4;
         if(param1.length <= _loc6_)
         {
            return null;
         }
         var _loc7_:Mount;
         if(!(_loc7_ = Mount.getMountById(param1[_loc6_])))
         {
            return null;
         }
         return {
            "mount":_loc7_,
            "mother":makeParent(param1,param2 + 1,_loc5_,0 + 2 * (_loc6_ - _loc5_)),
            "father":makeParent(param1,param2 + 1,_loc5_,1 + 2 * (_loc6_ - _loc5_)),
            "entityLook":TiphonEntityLook.fromString(_loc7_.look)
         };
      }
   }
}
