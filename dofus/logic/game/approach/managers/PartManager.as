package com.ankamagames.dofus.logic.game.approach.managers
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.misc.Pack;
   import com.ankamagames.dofus.kernel.updater.UpdaterConnexionHandler;
   import com.ankamagames.dofus.logic.game.approach.utils.DownloadMonitoring;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.enums.PartStateEnum;
   import com.ankamagames.dofus.network.messages.updater.parts.DownloadPartMessage;
   import com.ankamagames.dofus.network.messages.updater.parts.GetPartsListMessage;
   import com.ankamagames.dofus.network.types.updater.ContentPart;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class PartManager
   {
      
      public static const STATE_WAITING:int = 0;
      
      public static const STATE_DOWNLOADING:int = 1;
      
      public static const STATE_FINISHED:int = 2;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(PartManager));
      
      private static var _singleton:PartManager;
       
      
      private var _parts:Dictionary = null;
      
      private var _firstParts:Dictionary = null;
      
      private var _downloadList:Array;
      
      private var _downloadingPart:String = null;
      
      private var _downloadCount:int = 0;
      
      private var _downloadSuccess:int = 0;
      
      private var _state:int = 0;
      
      public function PartManager()
      {
         this._downloadList = new Array();
         super();
         DownloadMonitoring.getInstance().initialize();
      }
      
      public static function getInstance() : PartManager
      {
         if(!_singleton)
         {
            _singleton = new PartManager();
         }
         return _singleton;
      }
      
      public function initialize() : void
      {
         var _loc1_:GetPartsListMessage = new GetPartsListMessage();
         _loc1_.initGetPartsListMessage();
         UpdaterConnexionHandler.getConnection().send(_loc1_);
      }
      
      public function receiveParts(param1:Vector.<ContentPart>) : void
      {
         var _loc2_:ContentPart = null;
         var _loc3_:* = null;
         this._parts = new Dictionary();
         for each(_loc2_ in param1)
         {
            this.updatePart(_loc2_);
         }
         if(!this._firstParts)
         {
            this._firstParts = new Dictionary();
            for(_loc3_ in this._parts)
            {
               this._firstParts[_loc3_] = this._parts[_loc3_];
            }
         }
      }
      
      public function checkAndDownload(param1:String) : void
      {
         var _loc2_:String = null;
         if(!this._parts)
         {
            _log.warn("checkAndDownload \'" + param1 + "\' but can\'t got part list (updater is down ?)");
            return;
         }
         if(!this._parts.hasOwnProperty(param1))
         {
            _log.error("Unknow part id : " + param1);
            return;
         }
         if(this._parts[param1].state == PartStateEnum.PART_NOT_INSTALLED)
         {
            for each(_loc2_ in this._downloadList)
            {
               if(_loc2_ == param1)
               {
                  return;
               }
            }
            ++this._downloadCount;
            this.download(param1);
         }
      }
      
      public function updatePart(param1:ContentPart) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:ContentPart = null;
         var _loc4_:String = null;
         if(!this._parts)
         {
            _log.error("updatePart \'" + param1.id + "\' but can\'t got part liste (updater is down ?)");
            return;
         }
         var _loc5_:ContentPart = this._parts[param1.id];
         this._parts[param1.id] = param1;
         switch(param1.state)
         {
            case PartStateEnum.PART_BEING_UPDATER:
               DownloadMonitoring.getInstance().start();
               if(param1.id != this._downloadingPart)
               {
                  if(this._downloadingPart)
                  {
                     _log.error("On re??oit des informations de t??l??chargement d\'une partie de contenu " + param1.id + ", alors qu\'on a pour demande de r??cup??rer " + this._downloadingPart + ". Ce t??l??chargement risque de provoquer un conflit (t??l??chargements simultan??s");
                  }
                  else
                  {
                     this._downloadingPart = param1.id;
                  }
               }
               return;
            case PartStateEnum.PART_UP_TO_DATE:
               if(param1.id == this._downloadingPart)
               {
                  _loc2_ = false;
                  for each(_loc3_ in this._parts)
                  {
                     if(_loc3_.state == PartStateEnum.PART_BEING_UPDATER)
                     {
                        _loc2_ = true;
                        _log.error(_loc3_.id + " en cours de t??l??chargement alors qu\'une autre part vient juste de se terminer...");
                        throw new Error(_loc3_.id + " en cours de t??l??chargement alors qu\'une autre part vient juste de se terminer...");
                     }
                  }
                  if(!_loc2_)
                  {
                     ++this._downloadSuccess;
                     _log.info("Updater download is terminated.");
                     this._downloadingPart = null;
                     if(this._downloadList.length == 0)
                     {
                        DownloadMonitoring.getInstance().stop();
                        this._state = STATE_FINISHED;
                        KernelEventsManager.getInstance().processCallback(HookList.AllDownloadTerminated);
                     }
                     else
                     {
                        _loc4_ = this._downloadList.pop();
                        _log.info(_loc4_ + " found in download queue");
                        this.download(_loc4_);
                     }
                  }
               }
               return;
            default:
               return;
         }
      }
      
      public function getServerPartList() : Vector.<uint>
      {
         var _loc1_:Pack = null;
         var _loc2_:Boolean = false;
         var _loc3_:ContentPart = null;
         var _loc4_:uint = 0;
         if(this._firstParts == null)
         {
            return null;
         }
         var _loc5_:Array = Pack.getAllPacks();
         var _loc6_:Vector.<uint> = new Vector.<uint>();
         for each(_loc1_ in _loc5_)
         {
            if(_loc1_.hasSubAreas)
            {
               _loc4_++;
               _loc2_ = false;
               for each(_loc3_ in this._firstParts)
               {
                  if(_loc3_.id == _loc1_.name && _loc3_.state == 2)
                  {
                     _loc2_ = true;
                     break;
                  }
               }
               if(_loc2_)
               {
                  _loc6_.push(_loc1_.id);
               }
            }
         }
         if(_loc6_.length == _loc4_)
         {
            return null;
         }
         return _loc6_;
      }
      
      public function getPart(param1:String) : ContentPart
      {
         var _loc2_:ContentPart = null;
         for each(_loc2_ in this._parts)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function createEmptyPartList() : void
      {
         this._parts = new Dictionary();
      }
      
      public function getDownloadPercent(param1:int) : int
      {
         var _loc2_:int = 100 * this._downloadSuccess / this._downloadCount + param1 / this._downloadCount;
         if(_loc2_ < 0)
         {
            return 0;
         }
         if(_loc2_ > 100)
         {
            return 100;
         }
         return _loc2_;
      }
      
      public function get isDownloading() : Boolean
      {
         return this._state == STATE_DOWNLOADING;
      }
      
      public function get isFinished() : Boolean
      {
         return this._state == STATE_FINISHED;
      }
      
      private function download(param1:String) : void
      {
         var _loc2_:DownloadPartMessage = null;
         this._state = STATE_DOWNLOADING;
         if(this._parts[param1].state == PartStateEnum.PART_NOT_INSTALLED)
         {
            if(!this._downloadingPart)
            {
               _log.info("Send download request for " + param1 + " to updater");
               _loc2_ = new DownloadPartMessage();
               _loc2_.initDownloadPartMessage(param1);
               UpdaterConnexionHandler.getConnection().send(_loc2_);
               this._downloadingPart = param1;
            }
            else if(this._downloadList.indexOf(param1) == -1)
            {
               _log.info("A download is running. Add " + param1 + " to download queue");
               this._downloadList.push(param1);
            }
         }
      }
   }
}
