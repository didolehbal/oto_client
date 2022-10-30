package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.logic.game.common.managers.EntitiesLooksManager;
   import com.ankamagames.dofus.misc.utils.ParamsDecoder;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.misc.CallWithParameters;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.display.DisplayObject;
   import flash.geom.ColorTransform;
   import flash.globalization.Collator;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class UtilApi implements IApi
   {
       
      
      protected var _log:Logger;
      
      private var _module:UiModule;
      
      private var _stringSorter:Collator;
      
      public function UtilApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(UtilApi));
         super();
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._module = null;
      }
      
      [Untrusted]
      public function callWithParameters(param1:Function, param2:Array) : void
      {
         CallWithParameters.call(param1,param2);
      }
      
      [Untrusted]
      public function callConstructorWithParameters(param1:Class, param2:Array) : *
      {
         return CallWithParameters.callConstructor(param1,param2);
      }
      
      [Untrusted]
      public function callRWithParameters(param1:Function, param2:Array) : *
      {
         return CallWithParameters.callR(param1,param2);
      }
      
      [Untrusted]
      public function kamasToString(param1:Number, param2:String = "-") : String
      {
         return StringUtils.kamasToString(param1,param2);
      }
      
      [Untrusted]
      public function formateIntToString(param1:Number) : String
      {
         return StringUtils.formateIntToString(param1);
      }
      
      [Untrusted]
      public function stringToKamas(param1:String, param2:String = "-") : int
      {
         return StringUtils.stringToKamas(param1,param2);
      }
      
      [Untrusted]
      public function getTextWithParams(param1:int, param2:Array, param3:String = "%") : String
      {
         var _loc4_:String;
         if(_loc4_ = I18n.getText(param1))
         {
            return ParamsDecoder.applyParams(_loc4_,param2,param3);
         }
         return "";
      }
      
      [Untrusted]
      public function applyTextParams(param1:String, param2:Array, param3:String = "%") : String
      {
         return ParamsDecoder.applyParams(param1,param2,param3);
      }
      
      [Trusted]
      public function noAccent(param1:String) : String
      {
         return StringUtils.noAccent(param1);
      }
      
      [Untrusted]
      public function changeColor(param1:Object, param2:Number, param3:int, param4:Boolean = false) : void
      {
         var _loc5_:ColorTransform = null;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc9_:ColorTransform = null;
         if(param1 != null)
         {
            if(param4)
            {
               _loc5_ = new ColorTransform(1,1,1,1,0,0,0);
               if(param1 is Texture)
               {
                  Texture(param1).colorTransform(_loc5_,param3);
               }
               else if(param1 is DisplayObject)
               {
                  DisplayObject(param1).transform.colorTransform = _loc5_;
               }
            }
            else
            {
               _loc6_ = param2 >> 16 & 255;
               _loc7_ = param2 >> 8 & 255;
               _loc8_ = param2 >> 0 & 255;
               _loc9_ = new ColorTransform(0,0,0,1,_loc6_,_loc7_,_loc8_);
               if(param1 is Texture)
               {
                  Texture(param1).colorTransform(_loc9_,param3);
               }
               else if(param1 is DisplayObject)
               {
                  DisplayObject(param1).transform.colorTransform = _loc9_;
               }
            }
         }
      }
      
      [Untrusted]
      public function sortOnString(param1:*, param2:String = "", param3:Boolean = true) : void
      {
         var list:* = param1;
         var field:String = param2;
         var ascending:Boolean = param3;
         if(!(list is Array) && !(list is Vector.<*>))
         {
            this._log.error("Tried to sort something different than an Array or a Vector!");
            return;
         }
         if(!this._stringSorter)
         {
            this._stringSorter = new Collator(XmlConfig.getInstance().getEntry("config.lang.current"));
         }
         if(field)
         {
            list.sort(function(param1:*, param2:*):int
            {
               var _loc3_:int = _stringSorter.compare(param1[field],param2[field]);
               return !!ascending?int(_loc3_):int(_loc3_ * -1);
            });
         }
         else
         {
            list.sort(this._stringSorter.compare);
         }
      }
      
      [Untrusted]
      public function sort(param1:*, param2:String, param3:Boolean = true, param4:Boolean = false) : *
      {
         var sup:int = 0;
         var inf:int = 0;
         var target:* = param1;
         var field:String = param2;
         var ascendand:Boolean = param3;
         var isNumeric:Boolean = param4;
         var result:* = undefined;
         if(target is Array)
         {
            result = (target as Array).concat();
            result.sortOn(field,(!!ascendand?0:Array.DESCENDING) | (!!isNumeric?Array.NUMERIC:Array.CASEINSENSITIVE));
            return result;
         }
         if(target is Vector.<*>)
         {
            result = target.concat();
            sup = !!ascendand?1:-1;
            inf = !!ascendand?-1:1;
            if(isNumeric)
            {
               result.sort(function(param1:*, param2:*):int
               {
                  if(param1[field] > param2[field])
                  {
                     return sup;
                  }
                  if(param1[field] < param2[field])
                  {
                     return inf;
                  }
                  return 0;
               });
            }
            else
            {
               result.sort(function(param1:*, param2:*):int
               {
                  var _loc3_:String = param1[field].toLocaleLowerCase();
                  var _loc4_:String = param2[field].toLocaleLowerCase();
                  if(_loc3_ > _loc4_)
                  {
                     return sup;
                  }
                  if(_loc3_ < _loc4_)
                  {
                     return inf;
                  }
                  return 0;
               });
            }
            return result;
         }
         return null;
      }
      
      [Untrusted]
      public function filter(param1:*, param2:*, param3:String) : *
      {
         var _loc4_:String = null;
         var _loc7_:uint = 0;
         if(!param1)
         {
            return null;
         }
         var _loc5_:* = new (param1.constructor as Class)();
         var _loc6_:uint = param1.length;
         if(param2 is String)
         {
            _loc4_ = String(param2).toLowerCase();
            while(_loc7_ < _loc6_)
            {
               if(String(param1[_loc7_][param3]).toLowerCase().indexOf(_loc4_) != -1)
               {
                  _loc5_.push(param1[_loc7_]);
               }
               _loc7_++;
            }
         }
         else
         {
            while(_loc7_ < _loc6_)
            {
               if(param1[_loc7_][param3] == param2)
               {
                  _loc5_.push(param1[_loc7_]);
               }
               _loc7_++;
            }
         }
         return _loc5_;
      }
      
      [Untrusted]
      public function getTiphonEntityLook(param1:int) : TiphonEntityLook
      {
         return EntitiesLooksManager.getInstance().getTiphonEntityLook(param1);
      }
      
      [Untrusted]
      public function getRealTiphonEntityLook(param1:int, param2:Boolean = false) : TiphonEntityLook
      {
         return EntitiesLooksManager.getInstance().getRealTiphonEntityLook(param1,param2);
      }
      
      [Untrusted]
      public function getLookFromContext(param1:int, param2:Boolean = false) : TiphonEntityLook
      {
         return EntitiesLooksManager.getInstance().getLookFromContext(param1,param2);
      }
      
      [Untrusted]
      public function getLookFromContextInfos(param1:GameContextActorInformations, param2:Boolean = false) : TiphonEntityLook
      {
         return EntitiesLooksManager.getInstance().getLookFromContextInfos(param1,param2);
      }
      
      [Untrusted]
      public function isCreature(param1:int) : Boolean
      {
         return EntitiesLooksManager.getInstance().isCreature(param1);
      }
      
      [Untrusted]
      public function isCreatureFromLook(param1:TiphonEntityLook) : Boolean
      {
         return EntitiesLooksManager.getInstance().isCreatureFromLook(param1);
      }
      
      [Untrusted]
      public function isIncarnation(param1:int) : Boolean
      {
         return EntitiesLooksManager.getInstance().isIncarnation(param1);
      }
      
      [Untrusted]
      public function isIncarnationFromLook(param1:TiphonEntityLook) : Boolean
      {
         return EntitiesLooksManager.getInstance().isIncarnationFromLook(param1);
      }
      
      [Untrusted]
      public function isCreatureMode() : Boolean
      {
         return EntitiesLooksManager.getInstance().isCreatureMode();
      }
      
      [Untrusted]
      public function getCreatureLook(param1:int) : TiphonEntityLook
      {
         return EntitiesLooksManager.getInstance().getCreatureLook(param1);
      }
      
      [Untrusted]
      public function getSecureObjectIndex(param1:*, param2:*) : int
      {
         var _loc3_:* = SecureCenter.unsecure(param2);
         if(param1 is Array || param1 is Vector.<*>)
         {
            return param1.indexOf(_loc3_);
         }
         return -1;
      }
   }
}
