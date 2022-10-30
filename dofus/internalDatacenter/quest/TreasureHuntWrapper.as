package com.ankamagames.dofus.internalDatacenter.quest
{
   import avmplus.getQualifiedClassName;
   import com.ankamagames.dofus.network.types.game.context.roleplay.treasureHunt.TreasureHuntFlag;
   import com.ankamagames.dofus.network.types.game.context.roleplay.treasureHunt.TreasureHuntStep;
   import com.ankamagames.dofus.network.types.game.context.roleplay.treasureHunt.TreasureHuntStepFight;
   import com.ankamagames.dofus.network.types.game.context.roleplay.treasureHunt.TreasureHuntStepFollowDirection;
   import com.ankamagames.dofus.network.types.game.context.roleplay.treasureHunt.TreasureHuntStepFollowDirectionToHint;
   import com.ankamagames.dofus.network.types.game.context.roleplay.treasureHunt.TreasureHuntStepFollowDirectionToPOI;
   import com.ankamagames.dofus.types.enums.TreasureHuntStepTypeEnum;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   
   public class TreasureHuntWrapper implements IDataCenter
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(TreasureHuntWrapper));
       
      
      public var questType:uint;
      
      public var checkPointCurrent:uint;
      
      public var checkPointTotal:uint;
      
      public var totalStepCount:uint;
      
      public var availableRetryCount:int;
      
      public var stepList:Vector.<TreasureHuntStepWrapper>;
      
      public function TreasureHuntWrapper()
      {
         this.stepList = new Vector.<TreasureHuntStepWrapper>();
         super();
      }
      
      public static function create(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:int, param7:Vector.<TreasureHuntStep>, param8:Vector.<TreasureHuntFlag>) : TreasureHuntWrapper
      {
         var _loc9_:TreasureHuntStep = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc14_:int = 0;
         var _loc12_:TreasureHuntWrapper;
         (_loc12_ = new TreasureHuntWrapper()).questType = param1;
         _loc12_.checkPointCurrent = param3;
         _loc12_.checkPointTotal = param4;
         _loc12_.totalStepCount = param5;
         _loc12_.availableRetryCount = param6;
         var _loc13_:TreasureHuntStepWrapper = TreasureHuntStepWrapper.create(TreasureHuntStepTypeEnum.START,0,0,param2,0);
         _loc12_.stepList.push(_loc13_);
         for each(_loc9_ in param7)
         {
            _loc10_ = 0;
            _loc11_ = -1;
            if(param8 && param8.length > _loc14_ && param8[_loc14_])
            {
               _loc10_ = param8[_loc14_].mapId;
               _loc11_ = param8[_loc14_].state;
            }
            if(_loc9_ is TreasureHuntStepFollowDirectionToPOI)
            {
               _loc12_.stepList.push(TreasureHuntStepWrapper.create(TreasureHuntStepTypeEnum.DIRECTION_TO_POI,_loc14_,(_loc9_ as TreasureHuntStepFollowDirectionToPOI).direction,_loc10_,(_loc9_ as TreasureHuntStepFollowDirectionToPOI).poiLabelId,_loc11_));
            }
            if(_loc9_ is TreasureHuntStepFollowDirection)
            {
               _loc12_.stepList.push(TreasureHuntStepWrapper.create(TreasureHuntStepTypeEnum.DIRECTION,_loc14_,(_loc9_ as TreasureHuntStepFollowDirection).direction,_loc10_,0,_loc11_,(_loc9_ as TreasureHuntStepFollowDirection).mapCount));
            }
            if(_loc9_ is TreasureHuntStepFollowDirectionToHint)
            {
               _loc12_.stepList.push(TreasureHuntStepWrapper.create(TreasureHuntStepTypeEnum.DIRECTION_TO_HINT,_loc14_,(_loc9_ as TreasureHuntStepFollowDirectionToHint).direction,_loc10_,0,_loc11_,(_loc9_ as TreasureHuntStepFollowDirectionToHint).npcId));
            }
            _loc14_++;
         }
         while(_loc12_.stepList.length <= param5)
         {
            _loc12_.stepList.push(TreasureHuntStepWrapper.create(TreasureHuntStepTypeEnum.UNKNOWN,63,0,0,0));
         }
         _loc12_.stepList.push(TreasureHuntStepWrapper.create(TreasureHuntStepTypeEnum.FIGHT,63,0,0,0));
         return _loc12_;
      }
      
      public function update(param1:uint, param2:uint, param3:uint, param4:uint, param5:int, param6:Vector.<TreasureHuntStep>, param7:Vector.<TreasureHuntFlag>) : void
      {
         var _loc8_:TreasureHuntStep = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc12_:int = 0;
         this.questType = param1;
         this.checkPointCurrent = param3;
         this.checkPointTotal = param4;
         this.totalStepCount = param4;
         this.availableRetryCount = param5;
         this.stepList = new Vector.<TreasureHuntStepWrapper>();
         var _loc11_:TreasureHuntStepWrapper = TreasureHuntStepWrapper.create(TreasureHuntStepTypeEnum.START,0,0,param2,0);
         this.stepList.push(_loc11_);
         for each(_loc8_ in param6)
         {
            _loc9_ = 0;
            _loc10_ = -1;
            if(param7 && param7.length > _loc12_ && param7[_loc12_])
            {
               _loc9_ = param7[_loc12_].mapId;
               _loc10_ = param7[_loc12_].state;
            }
            if(_loc8_ is TreasureHuntStepFollowDirectionToPOI)
            {
               this.stepList.push(TreasureHuntStepWrapper.create(TreasureHuntStepTypeEnum.DIRECTION_TO_POI,_loc12_,(_loc8_ as TreasureHuntStepFollowDirectionToPOI).direction,_loc9_,(_loc8_ as TreasureHuntStepFollowDirectionToPOI).poiLabelId,_loc10_));
            }
            else if(_loc8_ is TreasureHuntStepFollowDirectionToHint)
            {
               this.stepList.push(TreasureHuntStepWrapper.create(TreasureHuntStepTypeEnum.DIRECTION_TO_HINT,_loc12_,(_loc8_ as TreasureHuntStepFollowDirectionToHint).direction,_loc9_,0,_loc10_));
            }
            else if(_loc8_ is TreasureHuntStepFight)
            {
               this.stepList.push(TreasureHuntStepWrapper.create(TreasureHuntStepTypeEnum.FIGHT,63,0,0,0));
            }
            _loc12_++;
         }
      }
   }
}
