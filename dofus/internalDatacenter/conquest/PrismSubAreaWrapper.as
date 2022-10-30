package com.ankamagames.dofus.internalDatacenter.conquest
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.AllianceFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.misc.lists.PrismHookList;
   import com.ankamagames.dofus.network.types.game.prism.AllianceInsiderPrismInformation;
   import com.ankamagames.dofus.network.types.game.prism.AlliancePrismInformation;
   import com.ankamagames.dofus.network.types.game.prism.PrismGeolocalizedInformation;
   import com.ankamagames.dofus.network.types.game.prism.PrismSubareaEmptyInfo;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import flash.utils.Dictionary;
   
   public class PrismSubAreaWrapper implements IDataCenter
   {
      
      private static var _ref:Dictionary = new Dictionary();
      
      private static var _cache:Array = new Array();
       
      
      private var _subAreaId:uint;
      
      private var _mapId:int = -1;
      
      private var _worldX:int = 0;
      
      private var _worldY:int = 0;
      
      private var _prismType:uint = 0;
      
      private var _state:uint = 0;
      
      private var _nextVulnerabilityDate:uint = 0;
      
      private var _placementDate:uint = 0;
      
      private var _alliance:AllianceWrapper = null;
      
      private var _timeSlotHour:uint = 0;
      
      private var _timeSlotQuarter:uint = 0;
      
      private var _lastTimeSlotModificationDate:uint = 0;
      
      private var _lastTimeSlotModificationAuthorGuildId:uint = 0;
      
      private var _lastTimeSlotModificationAuthorId:uint = 0;
      
      private var _lastTimeSlotModificationAuthorName:String = "";
      
      private var _isVillage:int = -1;
      
      private var _subAreaName:String = "";
      
      private var _rewardTokenCount:uint;
      
      private var _modulesItemIds:Vector.<uint>;
      
      public function PrismSubAreaWrapper()
      {
         this._modulesItemIds = new Vector.<uint>();
         super();
      }
      
      public static function reset() : void
      {
         _ref = new Dictionary();
      }
      
      public static function get prismList() : Dictionary
      {
         return _ref;
      }
      
      public static function getFromNetwork(param1:PrismSubareaEmptyInfo, param2:AllianceWrapper = null) : PrismSubAreaWrapper
      {
         var _loc3_:int = 0;
         var _loc4_:PrismGeolocalizedInformation = null;
         var _loc5_:Date = null;
         var _loc6_:AllianceInsiderPrismInformation = null;
         if(!_ref[param1.subAreaId] || Object(param1).constructor == PrismSubareaEmptyInfo)
         {
            _ref[param1.subAreaId] = new PrismSubAreaWrapper();
         }
         var _loc7_:PrismSubAreaWrapper;
         (_loc7_ = _ref[param1.subAreaId])._subAreaId = param1.subAreaId;
         if(_loc7_._alliance)
         {
            _loc3_ = _loc7_._alliance.prismIds.indexOf(param1.subAreaId);
            if(_loc3_ != -1)
            {
               _loc7_._alliance.prismIds.splice(_loc3_,1);
            }
         }
         if(param1 is PrismGeolocalizedInformation)
         {
            _loc4_ = param1 as PrismGeolocalizedInformation;
            _loc7_._mapId = _loc4_.mapId;
            _loc7_._worldX = _loc4_.worldX;
            _loc7_._worldY = _loc4_.worldY;
            _loc7_._state = _loc4_.prism.state;
            _loc7_._prismType = _loc4_.prism.typeId;
            _loc7_._placementDate = _loc4_.prism.placementDate;
            _loc7_._nextVulnerabilityDate = _loc4_.prism.nextVulnerabilityDate;
            _loc7_._rewardTokenCount = _loc4_.prism.rewardTokenCount;
            (_loc5_ = new Date()).time = _loc7_.nextVulnerabilityDate * 1000 + TimeManager.getInstance().timezoneOffset;
            _loc7_._timeSlotHour = _loc5_.hoursUTC;
            _loc7_._timeSlotQuarter = Math.round(_loc5_.minutesUTC / 15);
            if(_loc4_.prism is AllianceInsiderPrismInformation)
            {
               _loc6_ = _loc4_.prism as AllianceInsiderPrismInformation;
               param2.prismIds.push(param1.subAreaId);
               _loc7_._alliance = param2;
               _loc7_._lastTimeSlotModificationDate = _loc6_.lastTimeSlotModificationDate;
               _loc7_._lastTimeSlotModificationAuthorId = _loc6_.lastTimeSlotModificationAuthorId;
               _loc7_._lastTimeSlotModificationAuthorName = _loc6_.lastTimeSlotModificationAuthorName;
               _loc7_._lastTimeSlotModificationAuthorGuildId = _loc6_.lastTimeSlotModificationAuthorGuildId;
               _loc7_._modulesItemIds = _loc6_.modulesItemIds;
            }
            else
            {
               _loc7_._lastTimeSlotModificationDate = 0;
               _loc7_._lastTimeSlotModificationAuthorId = 0;
               _loc7_._lastTimeSlotModificationAuthorName = null;
               _loc7_._lastTimeSlotModificationAuthorGuildId = 0;
               _loc7_._modulesItemIds = new Vector.<uint>();
               if(_loc4_.prism is AlliancePrismInformation)
               {
                  _loc7_._alliance = AllianceWrapper.getFromNetwork(AlliancePrismInformation(_loc4_.prism).alliance);
                  _loc7_._alliance.prismIds.push(param1.subAreaId);
               }
               else
               {
                  _loc7_._alliance = null;
               }
            }
         }
         else if(param1.allianceId != 0)
         {
            _loc7_._alliance = (Kernel.getWorker().getFrame(AllianceFrame) as AllianceFrame).getAllianceById(param1.allianceId);
         }
         if(PlayedCharacterManager.getInstance().currentSubArea && _loc7_.subAreaId == PlayedCharacterManager.getInstance().currentSubArea.id)
         {
            KernelEventsManager.getInstance().processCallback(PrismHookList.KohState,_loc7_);
         }
         return _loc7_;
      }
      
      public function get subAreaId() : uint
      {
         return this._subAreaId;
      }
      
      public function get mapId() : int
      {
         return this._mapId;
      }
      
      public function get worldX() : int
      {
         return this._worldX;
      }
      
      public function get worldY() : int
      {
         return this._worldY;
      }
      
      public function get prismType() : uint
      {
         return this._prismType;
      }
      
      public function get state() : uint
      {
         return this._state;
      }
      
      public function get rewardTokenCount() : uint
      {
         return this._rewardTokenCount;
      }
      
      public function get modulesItemIds() : Vector.<uint>
      {
         return this._modulesItemIds;
      }
      
      public function get nextVulnerabilityDate() : uint
      {
         return this._nextVulnerabilityDate;
      }
      
      public function get timeSlotHour() : uint
      {
         return this._timeSlotHour;
      }
      
      public function get timeSlotQuarter() : uint
      {
         return this._timeSlotQuarter;
      }
      
      public function get placementDate() : uint
      {
         return this._placementDate;
      }
      
      public function get alliance() : AllianceWrapper
      {
         return this._alliance;
      }
      
      public function get lastTimeSlotModificationDate() : uint
      {
         return this._lastTimeSlotModificationDate;
      }
      
      public function get lastTimeSlotModificationAuthorGuildId() : uint
      {
         return this._lastTimeSlotModificationAuthorGuildId;
      }
      
      public function get lastTimeSlotModificationAuthorId() : uint
      {
         return this._lastTimeSlotModificationAuthorId;
      }
      
      public function get lastTimeSlotModificationAuthorName() : String
      {
         return this._lastTimeSlotModificationAuthorName;
      }
      
      public function get isVillage() : Boolean
      {
         if(this._isVillage == -1)
         {
            if(!SubArea.getSubAreaById(this.subAreaId))
            {
               return false;
            }
            this._isVillage = int(SubArea.getSubAreaById(this.subAreaId).isConquestVillage);
         }
         return this._isVillage == 1;
      }
      
      public function get subAreaName() : String
      {
         if(this._subAreaName == "")
         {
            this._subAreaName = SubArea.getSubAreaById(this.subAreaId).name + " (" + SubArea.getSubAreaById(this.subAreaId).area.name + ")";
         }
         return this._subAreaName;
      }
      
      public function get vulnerabilityHourString() : String
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:* = "";
         if(this._nextVulnerabilityDate != 0)
         {
            _loc1_ = this._timeSlotHour.toString();
            if(_loc1_.length == 1)
            {
               _loc1_ = "0" + _loc1_;
            }
            _loc2_ = (this._timeSlotQuarter * 15).toString();
            if(_loc2_.length == 1)
            {
               _loc2_ = "0" + _loc2_;
            }
            _loc3_ = _loc1_ + ":" + _loc2_;
         }
         return _loc3_;
      }
   }
}
