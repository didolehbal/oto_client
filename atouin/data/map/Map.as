package com.ankamagames.atouin.data.map
{
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.data.DataFormatError;
   import com.ankamagames.atouin.data.elements.Elements;
   import com.ankamagames.atouin.data.elements.GraphicalElementData;
   import com.ankamagames.atouin.data.elements.subtypes.NormalGraphicalElementData;
   import com.ankamagames.atouin.data.map.elements.BasicElement;
   import com.ankamagames.atouin.data.map.elements.GraphicalElement;
   import com.ankamagames.atouin.enums.ElementTypesEnum;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.errors.IllegalOperationError;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.getQualifiedClassName;
   
   public class Map
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Map));
       
      
      public var mapClass:Class;
      
      public var mapVersion:int;
      
      public var encrypted:Boolean;
      
      public var encryptionVersion:uint;
      
      public var groundCRC:int;
      
      public var zoomScale:Number = 1;
      
      public var zoomOffsetX:int;
      
      public var zoomOffsetY:int;
      
      public var groundCacheCurrentlyUsed:int = 0;
      
      public var id:int;
      
      public var relativeId:int;
      
      public var mapType:int;
      
      public var backgroundsCount:int;
      
      public var backgroundFixtures:Array;
      
      public var foregroundsCount:int;
      
      public var foregroundFixtures:Array;
      
      public var subareaId:int;
      
      public var shadowBonusOnEntities:int;
      
      public var backgroundColor:uint;
      
      public var backgroundRed:int;
      
      public var backgroundGreen:int;
      
      public var backgroundBlue:int;
      
      public var topNeighbourId:int;
      
      public var bottomNeighbourId:int;
      
      public var leftNeighbourId:int;
      
      public var rightNeighbourId:int;
      
      public var useLowPassFilter:Boolean;
      
      public var useReverb:Boolean;
      
      public var presetId:int;
      
      public var cellsCount:int;
      
      public var layersCount:int;
      
      public var isUsingNewMovementSystem:Boolean = false;
      
      public var layers:Array;
      
      public var cells:Array;
      
      public var topArrowCell:Array;
      
      public var leftArrowCell:Array;
      
      public var bottomArrowCell:Array;
      
      public var rightArrowCell:Array;
      
      private var _parsed:Boolean;
      
      private var _failed:Boolean;
      
      private var _gfxList:Array;
      
      private var _gfxCount:Array;
      
      public function Map()
      {
         this.mapClass = Map;
         this.topArrowCell = [];
         this.leftArrowCell = [];
         this.bottomArrowCell = [];
         this.rightArrowCell = [];
         super();
      }
      
      public function get parsed() : Boolean
      {
         return this._parsed;
      }
      
      public function get failed() : Boolean
      {
         return this._failed;
      }
      
      public function getGfxList(param1:Boolean = false) : Array
      {
         if(!this._gfxList)
         {
            this.computeGfxList(param1);
         }
         return this._gfxList;
      }
      
      public function getGfxCount(param1:uint) : uint
      {
         if(!this._gfxList)
         {
            this.computeGfxList();
         }
         return this._gfxCount[param1];
      }
      
      public function fromRaw(param1:IDataInput, param2:ByteArray = null) : void
      {
         var i:int = 0;
         var header:int = 0;
         var bg:Fixture = null;
         var la:Layer = null;
         var _oldMvtSystem:uint = 0;
         var cd:CellData = null;
         var dataLen:uint = 0;
         var encryptedData:ByteArray = null;
         var fg:Fixture = null;
         var raw:IDataInput = param1;
         var decryptionKey:ByteArray = param2;
         try
         {
            header = raw.readByte();
            if(header != 77)
            {
               throw new DataFormatError("Unknown file format");
            }
            this.mapVersion = raw.readByte();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("Map version : " + this.mapVersion);
            }
            this.id = raw.readUnsignedInt();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("Map id : " + this.id);
            }
            if(this.mapVersion >= 7)
            {
               this.encrypted = raw.readBoolean();
               this.encryptionVersion = raw.readByte();
               dataLen = raw.readInt();
               if(this.encrypted)
               {
                  if(!decryptionKey)
                  {
                     throw new IllegalOperationError("Map decryption key is empty");
                  }
                  encryptedData = new ByteArray();
                  raw.readBytes(encryptedData,0,dataLen);
                  i = 0;
                  while(i < encryptedData.length)
                  {
                     encryptedData[i] = encryptedData[i] ^ decryptionKey[i % decryptionKey.length];
                     i = i + 1;
                  }
                  encryptedData.position = 0;
                  raw = encryptedData;
               }
            }
            this.relativeId = raw.readUnsignedInt();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("Map relativeId: " + this.relativeId);
            }
            this.mapType = raw.readByte();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("Map type : " + this.mapType);
            }
            this.subareaId = raw.readInt();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("Subarea id : " + this.subareaId);
            }
            this.topNeighbourId = raw.readInt();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("topNeighbourId : " + this.topNeighbourId);
            }
            this.bottomNeighbourId = raw.readInt();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("bottomNeighbourId : " + this.bottomNeighbourId);
            }
            this.leftNeighbourId = raw.readInt();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("leftNeighbourId : " + this.leftNeighbourId);
            }
            this.rightNeighbourId = raw.readInt();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("rightNeighbourId : " + this.rightNeighbourId);
            }
            this.shadowBonusOnEntities = raw.readInt();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("ShadowBonusOnEntities : " + this.shadowBonusOnEntities);
            }
            if(this.mapVersion >= 3)
            {
               this.backgroundRed = raw.readByte();
               this.backgroundGreen = raw.readByte();
               this.backgroundBlue = raw.readByte();
               this.backgroundColor = (this.backgroundRed & 255) << 16 | (this.backgroundGreen & 255) << 8 | this.backgroundBlue & 255;
               if(AtouinConstants.DEBUG_FILES_PARSING)
               {
                  _log.debug("BackgroundColor : " + this.backgroundRed + "," + this.backgroundGreen + "," + this.backgroundBlue);
               }
            }
            if(this.mapVersion >= 4)
            {
               this.zoomScale = raw.readUnsignedShort() / 100;
               this.zoomOffsetX = raw.readShort();
               this.zoomOffsetY = raw.readShort();
               if(this.zoomScale < 1)
               {
                  this.zoomScale = 1;
                  this.zoomOffsetX = this.zoomOffsetY = 0;
               }
               if(AtouinConstants.DEBUG_FILES_PARSING)
               {
                  _log.debug("Zoom auto : " + this.zoomScale + "," + this.zoomOffsetX + "," + this.zoomOffsetY);
               }
            }
            this.useLowPassFilter = raw.readByte() == 1;
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("useLowPassFilter : " + this.useLowPassFilter);
            }
            this.useReverb = raw.readByte() == 1;
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("useReverb : " + this.useReverb);
            }
            if(this.useReverb)
            {
               this.presetId = raw.readInt();
            }
            else
            {
               this.presetId = -1;
            }
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("presetId : " + this.presetId);
            }
            this.backgroundsCount = raw.readByte();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("Backgrounds count : " + this.backgroundsCount);
            }
            this.backgroundFixtures = new Array();
            i = 0;
            while(i < this.backgroundsCount)
            {
               bg = new Fixture(this);
               if(AtouinConstants.DEBUG_FILES_PARSING)
               {
                  _log.debug("Background at index " + i + " :");
               }
               bg.fromRaw(raw);
               this.backgroundFixtures.push(bg);
               i = i + 1;
            }
            this.foregroundsCount = raw.readByte();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("Foregrounds count : " + this.foregroundsCount);
            }
            this.foregroundFixtures = new Array();
            i = 0;
            while(i < this.foregroundsCount)
            {
               fg = new Fixture(this);
               if(AtouinConstants.DEBUG_FILES_PARSING)
               {
                  _log.debug("Foreground at index " + i + " :");
               }
               fg.fromRaw(raw);
               this.foregroundFixtures.push(fg);
               i = i + 1;
            }
            this.cellsCount = AtouinConstants.MAP_CELLS_COUNT;
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("Cells count : " + this.cellsCount);
            }
            raw.readInt();
            this.groundCRC = raw.readInt();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("groundCRC : " + this.groundCRC);
            }
            this.layersCount = raw.readByte();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("Layers count : " + this.layersCount);
            }
            this.layers = new Array();
            i = 0;
            while(i < this.layersCount)
            {
               la = new Layer(this);
               if(AtouinConstants.DEBUG_FILES_PARSING)
               {
                  _log.debug("Layer at index " + i + " :");
               }
               la.fromRaw(raw,this.mapVersion);
               this.layers.push(la);
               i = i + 1;
            }
            this.cells = new Array();
            i = 0;
            while(i < this.cellsCount)
            {
               cd = new CellData(this,i);
               if(AtouinConstants.DEBUG_FILES_PARSING)
               {
                  _log.debug("Cell data at index " + i + " :");
               }
               cd.fromRaw(raw);
               if(!_oldMvtSystem)
               {
                  _oldMvtSystem = cd.moveZone;
               }
               if(cd.moveZone != _oldMvtSystem)
               {
                  this.isUsingNewMovementSystem = true;
               }
               this.cells.push(cd);
               i = i + 1;
            }
            if(!AtouinConstants.DEBUG_FILES_PARSING)
            {
            }
            this._parsed = true;
         }
         catch(e:*)
         {
            _failed = true;
            throw e;
         }
      }
      
      private function computeGfxList(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:Layer = null;
         var _loc10_:Cell = null;
         var _loc11_:BasicElement = null;
         var _loc12_:int = 0;
         var _loc13_:GraphicalElementData = null;
         var _loc14_:NormalGraphicalElementData = null;
         var _loc15_:* = null;
         var _loc16_:Elements = Elements.getInstance();
         var _loc17_:Array = new Array();
         this._gfxCount = new Array();
         var _loc18_:int = this.layers.length;
         _loc2_ = 0;
         while(_loc2_ < _loc18_)
         {
            _loc9_ = this.layers[_loc2_];
            if(!(param1 && _loc2_ == 0))
            {
               _loc6_ = (_loc5_ = _loc9_.cells).length;
               _loc3_ = 0;
               while(_loc3_ < _loc6_)
               {
                  _loc8_ = (_loc7_ = (_loc10_ = _loc5_[_loc3_]).elements).length;
                  _loc4_ = 0;
                  while(_loc4_ < _loc8_)
                  {
                     if((_loc11_ = _loc7_[_loc4_]).elementType == ElementTypesEnum.GRAPHICAL)
                     {
                        _loc12_ = GraphicalElement(_loc11_).elementId;
                        if((_loc13_ = _loc16_.getElementData(_loc12_)) == null)
                        {
                           _log.error("Unknown graphical element ID " + _loc12_);
                        }
                        else if(_loc13_ is NormalGraphicalElementData)
                        {
                           _loc14_ = _loc13_ as NormalGraphicalElementData;
                           _loc17_[_loc14_.gfxId] = _loc14_;
                           if(this._gfxCount[_loc14_.gfxId])
                           {
                              ++this._gfxCount[_loc14_.gfxId];
                           }
                           else
                           {
                              this._gfxCount[_loc14_.gfxId] = 1;
                           }
                        }
                     }
                     _loc4_++;
                  }
                  _loc3_++;
               }
            }
            _loc2_++;
         }
         this._gfxList = new Array();
         for(_loc15_ in _loc17_)
         {
            this._gfxList.push(_loc17_[_loc15_]);
         }
      }
   }
}
