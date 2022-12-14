package com.ankamagames.atouin.managers
{
   import cmodule.as3_jpeg_wrapper.CLibInit;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.data.map.Map;
   import com.ankamagames.atouin.enums.GroundCache;
   import com.ankamagames.atouin.utils.GroundMapLoader;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.CustomSharedObject;
   import com.ankamagames.jerakine.utils.benchmark.monitoring.FpsManager;
   import flash.display.BitmapData;
   import flash.errors.IOError;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class DataGroundMapManager
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(DataGroundMapManager));
      
      private static const MAPS_DIRECTORY:String = "./maps";
      
      private static const JPEG_HIGH_QUALITY:uint = 80;
      
      private static const JPEG_MEDIUM_QUALITY:uint = 70;
      
      private static const JPEG_LOW_QUALITY:uint = 60;
      
      private static const INITIAL_ENCODER_QUALITY:int = -1;
      
      private static var _currentQuality:uint;
      
      private static var _currentDiskUsed:Number = 0;
      
      private static var _jpegWrapperInit:CLibInit = new CLibInit();
      
      private static var _jpegWrapperLib:Object = _jpegWrapperInit.init();
      
      private static var _currentOutputFileStream:FileStream;
      
      private static var _bitmapDataList:Array = new Array();
      
      private static var _processing:Boolean = false;
      
      private static var _directory:File;
      
      private static var _currentMapId:int = -1;
      
      private static var buffer:BitmapData;
      
      private static var _m:Matrix = new Matrix();
       
      
      public function DataGroundMapManager()
      {
         super();
      }
      
      public static function mapsCurrentlyRendered() : int
      {
         return _bitmapDataList.length;
      }
      
      public static function getCurrentDiskUsed() : Number
      {
         var _loc1_:Number = NaN;
         var _loc2_:File = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:File = null;
         if(_currentDiskUsed)
         {
            return _currentDiskUsed;
         }
         _loc1_ = 0;
         _loc2_ = new File(CustomSharedObject.getCustomSharedObjectDirectory() + MAPS_DIRECTORY);
         if(!_loc2_.exists || !_loc2_.isDirectory)
         {
            return 0;
         }
         _loc3_ = _loc2_.getDirectoryListing();
         _loc4_ = _loc3_.length;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            _loc1_ = _loc1_ + _loc6_.size;
            _loc5_++;
         }
         _currentDiskUsed = _loc1_;
         return _loc1_;
      }
      
      public static function clearGroundCache() : void
      {
         var _loc1_:File = new File(CustomSharedObject.getCustomSharedObjectDirectory() + MAPS_DIRECTORY);
         if(_loc1_.exists && _loc1_.isDirectory)
         {
            _loc1_.deleteDirectory(true);
            _directory = null;
            _currentDiskUsed = 0;
         }
      }
      
      public static function saveGroundMap(param1:BitmapData, param2:Map) : void
      {
         var _loc3_:Point = null;
         _m.identity();
         switch(param2.groundCacheCurrentlyUsed)
         {
            case GroundCache.GROUND_CACHE_LOW_QUALITY:
               _loc3_ = AtouinConstants.RESOLUTION_LOW_QUALITY;
               _m.scale(0.5,0.5);
               break;
            case GroundCache.GROUND_CACHE_MEDIUM_QUALITY:
               _loc3_ = AtouinConstants.RESOLUTION_MEDIUM_QUALITY;
               _m.scale(0.75,0.75);
               break;
            case GroundCache.GROUND_CACHE_HIGH_QUALITY:
               _loc3_ = AtouinConstants.RESOLUTION_HIGH_QUALITY;
         }
         FpsManager.getInstance().startTracking("groundMap",10621692);
         if(param1.width != _loc3_.x || param1.height != _loc3_.y)
         {
            if(buffer == null || buffer.width != _loc3_.x || buffer.height != _loc3_.y)
            {
               buffer = new BitmapData(_loc3_.x,_loc3_.y,false,16711680);
            }
            buffer.draw(param1,_m);
            _bitmapDataList.push(buffer,param2);
         }
         else
         {
            _bitmapDataList.push(param1,param2);
         }
         process();
         FpsManager.getInstance().stopTracking("groundMap");
      }
      
      public static function loadGroundMap(param1:Map, param2:Function, param3:Function) : int
      {
         var numMap:int = 0;
         var i:int = 0;
         var waitingMap:Map = null;
         var file:File = null;
         var fileStream:FileStream = null;
         var fileCRC:int = 0;
         var map:Map = param1;
         var callBack:Function = param2;
         var errorCallBack:Function = param3;
         try
         {
            FpsManager.getInstance().startTracking("groundMap",10621692);
            if(!_directory)
            {
               _directory = new File(CustomSharedObject.getCustomSharedObjectDirectory() + MAPS_DIRECTORY);
               if(!_directory.exists)
               {
                  _directory.createDirectory();
               }
            }
            if(_currentMapId == map.id)
            {
               return GroundCache.GROUND_CACHE_SKIP;
            }
            numMap = _bitmapDataList.length;
            i = 0;
            while(i < numMap)
            {
               waitingMap = _bitmapDataList[i + 1];
               if(waitingMap.id == map.id)
               {
                  return GroundCache.GROUND_CACHE_SKIP;
               }
               i = i + 2;
            }
            if(_directory.spaceAvailable <= AtouinConstants.MIN_DISK_SPACE_AVAILABLE)
            {
               _log.info("On ne fait rien, il n\'y a plus assez d\'espace disque.");
               return GroundCache.GROUND_CACHE_ERROR;
            }
            file = new File(CustomSharedObject.getCustomSharedObjectDirectory() + MAPS_DIRECTORY + "/" + map.id + ".bg");
            if(file.exists)
            {
               fileStream = new FileStream();
               try
               {
                  fileStream.open(file,FileMode.READ);
                  if(fileStream.readInt() == AtouinConstants.GROUND_MAP_VERSION)
                  {
                     if(fileStream.readByte() <= map.groundCacheCurrentlyUsed)
                     {
                        fileCRC = fileStream.readInt();
                        if(fileCRC == map.groundCRC)
                        {
                           GroundMapLoader.loadGroundMap(map,file,callBack,errorCallBack);
                           return GroundCache.GROUND_CACHE_AVAILABLE;
                        }
                     }
                  }
                  fileStream.close();
               }
               catch(e:IOError)
               {
                  _log.error(e);
                  return GroundCache.GROUND_CACHE_SKIP;
               }
            }
            FpsManager.getInstance().stopTracking("groundMap");
         }
         catch(e:Error)
         {
            _log.fatal(e.getStackTrace());
            return GroundCache.GROUND_CACHE_ERROR;
         }
         return GroundCache.GROUND_CACHE_NOT_AVAILABLE;
      }
      
      private static function process() : void
      {
         var bitmapData:BitmapData = null;
         var map:Map = null;
         var file:File = null;
         var t:uint = 0;
         var baSource:ByteArray = null;
         var encodedData:ByteArray = null;
         if(!_processing && _bitmapDataList.length)
         {
            _processing = true;
            bitmapData = _bitmapDataList.shift();
            map = _bitmapDataList.shift();
            _currentMapId = map.id;
            initEncoder(map.groundCacheCurrentlyUsed);
            try
            {
               file = new File(CustomSharedObject.getCustomSharedObjectDirectory() + MAPS_DIRECTORY + "/" + map.id + ".bg");
               _currentOutputFileStream = new FileStream();
               _currentOutputFileStream.open(file,FileMode.WRITE);
            }
            catch(e:Error)
            {
               _log.info("Le fichier est lock?? " + file.nativePath);
            }
            t = getTimer();
            baSource = bitmapData.getPixels(bitmapData.rect);
            baSource.position = 0;
            encodedData = _jpegWrapperLib.write_jpeg_file(baSource,bitmapData.width,bitmapData.height,3,2,_currentQuality);
            encodedData.position = 0;
            _log.debug("Encoded as JPEG a " + bitmapData.width + " x " + bitmapData.height + " ground map bitmap (mapId " + map.id + ") in " + (getTimer() - t) + " ms (" + encodedData.bytesAvailable + " bytes)");
            baSource.clear();
            jpgGenerated(encodedData,map);
         }
      }
      
      private static function initEncoder(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(INITIAL_ENCODER_QUALITY != param1)
         {
            switch(true)
            {
               case param1 == GroundCache.GROUND_CACHE_HIGH_QUALITY:
                  _loc2_ = JPEG_HIGH_QUALITY;
                  break;
               case param1 == GroundCache.GROUND_CACHE_MEDIUM_QUALITY:
                  _loc2_ = JPEG_MEDIUM_QUALITY;
                  break;
               case param1 == GroundCache.GROUND_CACHE_LOW_QUALITY:
                  _loc2_ = JPEG_LOW_QUALITY;
                  break;
               default:
                  _loc2_ = JPEG_MEDIUM_QUALITY;
                  _log.error("Attention Enum d\'encodage pour la qualit?? JPG non valide, utisation d\'une qualit?? moyenne");
            }
            _currentQuality = _loc2_;
         }
      }
      
      private static function jpgGenerated(param1:ByteArray, param2:Map) : void
      {
         var rawJPG:ByteArray = param1;
         var map:Map = param2;
         try
         {
            _currentOutputFileStream.writeInt(AtouinConstants.GROUND_MAP_VERSION);
            _currentOutputFileStream.writeByte(map.groundCacheCurrentlyUsed);
            _currentOutputFileStream.writeInt(map.groundCRC);
            _currentDiskUsed = _currentDiskUsed + rawJPG.length;
            _currentOutputFileStream.writeBytes(rawJPG);
            rawJPG.clear();
            _processing = false;
            _currentMapId = -1;
         }
         catch(e:IOError)
         {
            _log.error("Impossible de sauvegarder le background de la map ");
         }
         try
         {
            _currentOutputFileStream.close();
         }
         catch(e:Error)
         {
         }
         process();
      }
   }
}
