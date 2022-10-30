package com.ankamagames.dofus.kernel.sound.parser
{
   import com.ankamagames.jerakine.types.SoundEventParamWrapper;
   
   public class XMLSoundParser
   {
      
      private static const _IDS_UNLOCALIZED:Array = new Array("20","17","16");
       
      
      private var _xmlBreed:XML;
      
      public function XMLSoundParser()
      {
         super();
      }
      
      public static function parseXMLSoundFile(param1:XML, param2:Vector.<uint>) : SoundEventParamWrapper
      {
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         var _loc5_:Vector.<SoundEventParamWrapper> = null;
         var _loc6_:XMLList = null;
         var _loc7_:Vector.<SoundEventParamWrapper> = null;
         var _loc8_:XML = null;
         var _loc9_:uint = 0;
         var _loc10_:String = null;
         var _loc11_:Array = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:uint = 0;
         var _loc15_:SoundEventParamWrapper = null;
         var _loc16_:XMLList = param1.elements();
         var _loc17_:RegExp = /^\s*(.*?)\s*$/g;
         for each(_loc4_ in _loc16_)
         {
            if(_loc3_ == null)
            {
               _loc11_ = (_loc10_ = _loc4_.@skin).split(",");
               for each(_loc12_ in _loc11_)
               {
                  _loc13_ = _loc12_.replace(_loc17_,"$1");
                  for each(_loc14_ in param2)
                  {
                     if(_loc13_ == _loc14_.toString())
                     {
                        _loc3_ = _loc4_;
                     }
                  }
               }
            }
         }
         _loc5_ = new Vector.<SoundEventParamWrapper>();
         _loc6_ = _loc3_.elements();
         _loc7_ = new Vector.<SoundEventParamWrapper>();
         for each(_loc8_ in _loc6_)
         {
            (_loc15_ = new SoundEventParamWrapper(_loc8_.Id,_loc8_.Volume,_loc8_.RollOff)).berceauDuree = _loc8_.BerceauDuree;
            _loc15_.berceauVol = _loc8_.BerceauVol;
            _loc15_.berceauFadeIn = _loc8_.BerceauFadeIn;
            _loc15_.berceauFadeOut = _loc8_.BerceauFadeOut;
            _loc5_.push(_loc15_);
         }
         _loc9_ = uint(Math.random() * Math.floor(_loc5_.length - 1));
         return _loc5_[_loc9_];
      }
      
      public static function isLocalized(param1:String) : Boolean
      {
         var _loc2_:String = null;
         for each(_loc2_ in _IDS_UNLOCALIZED)
         {
            if(param1.split(_loc2_)[0] == "")
            {
               return false;
            }
         }
         return true;
      }
   }
}
