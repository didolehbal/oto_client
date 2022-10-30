package com.ankamagames.jerakine.utils.parser
{
   import com.ankamagames.jerakine.types.SoundEventParamWrapper;
   
   public class FLAEventLabelParser
   {
      
      private static var BALISE_PARAM_DELIMITER:String = ";";
      
      private static var BALISE_PARAM_ASSIGN:String = "=";
      
      private static var BALISE_PARAM_NEXT_PARAM:String = ",";
      
      private static var PARAM_ID:String = "id";
      
      private static var PARAM_VOLUME:String = "vol";
      
      private static var PARAM_ROLLOFF:String = "rollOff";
      
      private static var PARAM_BERCEAU_DUREE:String = "berceauDuree";
      
      private static var PARAM_BERCEAU_VOL:String = "berceauVol";
      
      private static var PARAM_BERCEAU_FADE_IN:String = "berceauFadeIn";
      
      private static var PARAM_BERCEAU_FADE_OUT:String = "berceauFadeOut";
      
      private static var PARAM_NO_CUT_SILENCE:String = "noCutSilence";
       
      
      public function FLAEventLabelParser()
      {
         super();
      }
      
      public static function parseSoundLabel(param1:String) : Array
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc8_:RegExp = null;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         var _loc11_:String = null;
         var _loc12_:uint = 0;
         var _loc13_:SoundEventParamWrapper = null;
         var _loc19_:Boolean = false;
         var _loc20_:uint = 0;
         var _loc22_:uint = 0;
         var _loc14_:Array = new Array();
         var _loc15_:Array;
         var _loc16_:uint = (_loc15_ = param1.split(BALISE_PARAM_DELIMITER)).length;
         var _loc17_:Vector.<String> = new Vector.<String>();
         var _loc18_:Vector.<uint> = new Vector.<uint>();
         for(; _loc20_ < _loc16_; _loc20_++)
         {
            _loc7_ = _loc15_[_loc20_].split(BALISE_PARAM_ASSIGN)[0];
            _loc8_ = /^\s*(.*?)\s*$/g;
            _loc7_ = _loc7_.replace(_loc8_,"$1");
            _loc10_ = (_loc9_ = _loc15_[_loc20_].split(BALISE_PARAM_ASSIGN)[1]).split(BALISE_PARAM_NEXT_PARAM);
            switch(_loc7_.toUpperCase())
            {
               case PARAM_ID.toUpperCase():
                  for each(_loc11_ in _loc10_)
                  {
                     _loc11_ = _loc11_.replace(_loc8_,"$1");
                     _loc17_.push(_loc11_);
                  }
                  continue;
               case PARAM_VOLUME.toUpperCase():
                  for each(_loc12_ in _loc10_)
                  {
                     _loc18_.push(_loc12_);
                  }
                  continue;
               case PARAM_ROLLOFF.toUpperCase():
                  _loc2_ = _loc10_[0];
                  continue;
               case PARAM_BERCEAU_DUREE.toUpperCase():
                  _loc3_ = _loc10_[0];
                  continue;
               case PARAM_BERCEAU_VOL.toUpperCase():
                  _loc4_ = _loc10_[0];
                  continue;
               case PARAM_BERCEAU_FADE_IN.toUpperCase():
                  _loc5_ = _loc10_[0];
                  continue;
               case PARAM_BERCEAU_FADE_OUT.toUpperCase():
                  _loc6_ = _loc10_[0];
                  continue;
               case PARAM_NO_CUT_SILENCE.toUpperCase():
                  if(String(_loc10_[0]).match("false"))
                  {
                     _loc19_ = false;
                  }
                  else
                  {
                     _loc19_ = true;
                  }
                  continue;
               default:
                  continue;
            }
         }
         var _loc21_:uint = _loc17_.length;
         if(_loc17_.length != _loc18_.length)
         {
            throw new Error("The number of sound id and volume are differents");
         }
         while(_loc22_ < _loc21_)
         {
            (_loc13_ = new SoundEventParamWrapper(_loc17_[_loc22_],_loc18_[_loc22_],_loc2_)).berceauDuree = _loc3_;
            _loc13_.berceauVol = _loc4_;
            _loc13_.berceauFadeIn = _loc5_;
            _loc13_.berceauFadeOut = _loc6_;
            _loc13_.noCutSilence = _loc19_;
            _loc14_.push(_loc13_);
            _loc22_++;
         }
         return _loc14_;
      }
      
      public static function buildSoundLabel(param1:Vector.<SoundEventParamWrapper>) : String
      {
         var _loc2_:SoundEventParamWrapper = null;
         var _loc3_:String = null;
         var _loc4_:Vector.<String> = new Vector.<String>();
         var _loc5_:Vector.<uint> = new Vector.<uint>();
         if(!param1 || param1.length == 0)
         {
            return null;
         }
         for each(_loc2_ in param1)
         {
            _loc4_.push(_loc2_.id);
            _loc5_.push(_loc2_.volume);
         }
         return PARAM_ID + "=" + _loc4_.join(",") + "; " + PARAM_VOLUME + "=" + _loc5_.join(",") + "; " + PARAM_ROLLOFF + "=" + param1[0].rollOff + "; " + PARAM_BERCEAU_DUREE + "=" + param1[0].berceauDuree + "; " + PARAM_BERCEAU_VOL + "=" + param1[0].berceauVol + "; " + PARAM_BERCEAU_FADE_IN + "=" + param1[0].berceauFadeIn + "; " + PARAM_BERCEAU_FADE_OUT + "=" + param1[0].berceauFadeOut + "; " + PARAM_NO_CUT_SILENCE + "=" + param1[0].noCutSilence;
      }
   }
}
