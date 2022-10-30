package com.ankamagames.tiphon.types
{
   import com.ankamagames.jerakine.data.CensoredContentManager;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.Swl;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.tiphon.TiphonConstants;
   import com.ankamagames.tiphon.engine.Tiphon;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.ProgressEvent;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class Skin extends EventDispatcher
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(Skin));
      
      private static var _censoredSkin:Dictionary;
      
      private static var _alternativeSkin:Dictionary = new Dictionary();
      
      public static var skinPartTransformProvider:ISkinPartTransformProvider;
       
      
      private var _ressourceCount:uint = 0;
      
      private var _ressourceLoading:uint = 0;
      
      private var _partToSwl:Dictionary;
      
      private var _skinParts:Array;
      
      private var _skinClass:Array;
      
      private var _aSkinPartOrdered:Array;
      
      private var _validate:Boolean = true;
      
      private var _partTransformData:Dictionary;
      
      private var _transformData:Dictionary;
      
      private var _baseSkins:Dictionary;
      
      public function Skin()
      {
         this._partTransformData = new Dictionary();
         this._transformData = new Dictionary();
         this._baseSkins = new Dictionary();
         super();
         this._partToSwl = new Dictionary();
         this._skinParts = new Array();
         this._skinClass = new Array();
         this._aSkinPartOrdered = new Array();
      }
      
      public static function addAlternativeSkin(param1:uint, param2:uint) : void
      {
         if(!_alternativeSkin[param1])
         {
            _alternativeSkin[param1] = new Array();
         }
         _alternativeSkin[param1].push(param2);
      }
      
      public function get skinList() : Array
      {
         return this._aSkinPartOrdered;
      }
      
      public function get complete() : Boolean
      {
         var _loc1_:uint = 0;
         if(!this._validate)
         {
            return false;
         }
         var _loc2_:Boolean = true;
         for each(_loc1_ in this._aSkinPartOrdered)
         {
            _loc2_ = _loc2_ && (Tiphon.skinLibrary.isLoaded(_loc1_) || Tiphon.skinLibrary.hasError(_loc1_));
         }
         return _loc2_;
      }
      
      public function get validate() : Boolean
      {
         return this._validate;
      }
      
      public function set validate(param1:Boolean) : void
      {
         this._validate = param1;
         if(param1 && this.complete)
         {
            this.processSkin();
         }
      }
      
      public function reprocess() : void
      {
         this.processSkin();
      }
      
      public function getSwlFromPart(param1:String) : uint
      {
         return this._partToSwl[param1];
      }
      
      public function add(param1:uint, param2:int = -1) : uint
      {
         var _loc5_:uint = 0;
         var _loc3_:int = -1;
         if(!_censoredSkin)
         {
            _censoredSkin = CensoredContentManager.getInstance().getCensoredIndex(2);
         }
         if(_censoredSkin[param1])
         {
            param1 = _censoredSkin[param1];
         }
         if(param2 != -1 && _alternativeSkin && _alternativeSkin[param1] && param2 < _alternativeSkin[param1].length)
         {
            _loc3_ = param1;
            param1 = _alternativeSkin[param1][param2];
            this._baseSkins[param1] = _loc3_;
         }
         var _loc4_:Array = new Array();
         while(_loc5_ < this._aSkinPartOrdered.length)
         {
            if(this._aSkinPartOrdered[_loc5_] != param1 && this._aSkinPartOrdered[_loc5_] != _loc3_)
            {
               _loc4_.push(this._aSkinPartOrdered[_loc5_]);
            }
            _loc5_++;
         }
         _loc4_.push(param1);
         if(this._aSkinPartOrdered.length != _loc4_.length)
         {
            this._aSkinPartOrdered = _loc4_;
            ++this._ressourceLoading;
            Tiphon.skinLibrary.addResource(param1,new Uri(TiphonConstants.SWF_SKIN_PATH + param1 + ".swl"));
            Tiphon.skinLibrary.askResource(param1,null,new Callback(this.onResourceLoaded,param1),new Callback(this.onResourceLoaded,param1));
         }
         else
         {
            this._aSkinPartOrdered = _loc4_;
         }
         return param1;
      }
      
      public function getTransformData(param1:String) : TransformData
      {
         return this._transformData[param1];
      }
      
      public function getPart(param1:String) : Sprite
      {
         var _loc2_:TransformData = null;
         var _loc3_:Sprite = null;
         _loc2_ = this._transformData[param1];
         if(_loc2_ && _loc2_.overrideClip)
         {
            if(_loc2_.overrideClip != param1)
            {
               return null;
            }
            param1 = _loc2_.originalClip;
         }
         _loc3_ = this._skinParts[param1];
         if(_loc3_ && !_loc3_.parent)
         {
            if(_loc2_)
            {
               _loc3_.x = _loc2_.x;
               _loc3_.y = _loc2_.y;
               _loc3_.scaleX = _loc2_.scaleX;
               _loc3_.scaleY = _loc2_.scaleY;
               _loc3_.rotation = _loc2_.rotation;
            }
            else
            {
               _loc3_.x = 0;
               _loc3_.y = 0;
               _loc3_.scaleX = 1;
               _loc3_.scaleY = 1;
               _loc3_.rotation = 0;
            }
            return _loc3_;
         }
         if(this._skinClass[param1])
         {
            _loc3_ = new this._skinClass[param1]();
            if(_loc2_ && _loc3_)
            {
               _loc3_.x = _loc2_.x;
               _loc3_.y = _loc2_.y;
               _loc3_.scaleX = _loc2_.scaleX;
               _loc3_.scaleY = _loc2_.scaleY;
               _loc3_.rotation = _loc2_.rotation;
            }
            this._skinParts[param1] = _loc3_;
            return _loc3_;
         }
         return null;
      }
      
      public function reset() : void
      {
         this._skinParts = new Array();
         this._skinClass = new Array();
         this._aSkinPartOrdered = new Array();
         this._baseSkins = new Dictionary();
      }
      
      public function addTransform(param1:String, param2:uint, param3:TransformData) : void
      {
         if(!this._partTransformData[param1])
         {
            this._partTransformData[param1] = new Dictionary();
         }
         this._partTransformData[param1][param2] = param3;
      }
      
      private function onResourceLoaded(param1:uint) : void
      {
         ++this._ressourceCount;
         --this._ressourceLoading;
         this.processSkin();
      }
      
      private function processSkin() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Swl = null;
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:* = null;
         var _loc6_:Dictionary = null;
         var _loc7_:int = 0;
         var _loc8_:TransformData = null;
         var _loc9_:uint = 0;
         while(_loc9_ < this._aSkinPartOrdered.length)
         {
            _loc1_ = this._aSkinPartOrdered[_loc9_];
            _loc2_ = Tiphon.skinLibrary.getResourceById(_loc1_);
            if(_loc2_)
            {
               _loc3_ = _loc2_.getDefinitions();
               for each(_loc4_ in _loc3_)
               {
                  this._skinClass[_loc4_] = _loc2_.getDefinition(_loc4_);
                  this._partToSwl[_loc4_] = _loc1_;
                  delete this._skinParts[_loc4_];
               }
            }
            _loc9_++;
         }
         if(this.complete)
         {
            this._partTransformData = new Dictionary();
            this._transformData = new Dictionary();
            if(skinPartTransformProvider)
            {
               skinPartTransformProvider.init(this);
               for(_loc5_ in this._skinClass)
               {
                  if(this._partTransformData[_loc5_])
                  {
                     _loc6_ = this._partTransformData[_loc5_];
                     _loc7_ = this._aSkinPartOrdered.length - 1;
                     while(_loc7_ >= -1)
                     {
                        _loc1_ = _loc7_ >= 0?uint(this._aSkinPartOrdered[_loc7_]):uint(0);
                        if(this._baseSkins[_loc1_] && this._baseSkins[_loc1_] != _loc1_)
                        {
                           _loc1_ = this._baseSkins[_loc1_];
                        }
                        if(_loc6_[_loc1_])
                        {
                           _loc8_ = _loc6_[_loc1_];
                           this._transformData[_loc5_] = _loc8_;
                           if(_loc8_.overrideClip)
                           {
                              this._transformData[_loc8_.overrideClip] = _loc8_;
                           }
                           break;
                        }
                        _loc7_--;
                     }
                  }
               }
            }
            dispatchEvent(new Event(Event.COMPLETE));
         }
         else
         {
            dispatchEvent(new Event(ProgressEvent.PROGRESS));
         }
      }
   }
}
