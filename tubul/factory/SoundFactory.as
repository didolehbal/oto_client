package com.ankamagames.tubul.factory
{
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.tubul.enum.EnumSoundType;
   import com.ankamagames.tubul.interfaces.ISound;
   import com.ankamagames.tubul.types.sounds.LocalizedSound;
   import com.ankamagames.tubul.types.sounds.UnlocalizedSound;
   import flash.filesystem.File;
   
   public class SoundFactory
   {
      
      private static var _id:uint = 0;
       
      
      public function SoundFactory()
      {
         super();
      }
      
      public static function getSound(param1:uint, param2:Uri) : ISound
      {
         var _loc3_:String = null;
         var _loc4_:File = null;
         var _loc5_:Boolean = false;
         var _loc6_:String;
         var _loc7_:String = (_loc6_ = param2.path).split("/")[_loc6_.split("/").length - 2];
         var _loc8_:* = _loc6_.substring(0,_loc6_.indexOf(param2.fileName)) + _loc7_ + "_mono";
         var _loc9_:File;
         if((_loc9_ = new File(File.applicationDirectory.nativePath + "/" + _loc8_)).exists)
         {
            _loc5_ = true;
            _loc3_ = _loc6_.substring(0,_loc6_.indexOf(param2.fileName)) + _loc7_ + "_mono/" + param2.fileName;
            if(!(_loc4_ = new File(File.applicationDirectory.nativePath + "/" + param2.path)).exists)
            {
               if((_loc4_ = new File(File.applicationDirectory.nativePath + "/" + _loc3_)).exists)
               {
                  param2 = new Uri(_loc3_);
                  _loc5_ = false;
               }
            }
         }
         switch(param1)
         {
            case EnumSoundType.LOCALIZED_SOUND:
               switch(param2.fileType.toUpperCase())
               {
                  case "MP3":
                     return new LocalizedSound(_id++,param2,_loc5_);
                  default:
                     throw new ArgumentError("Unknown type file " + param2.fileType.toUpperCase());
               }
               break;
            case EnumSoundType.UNLOCALIZED_SOUND:
               switch(param2.fileType.toUpperCase())
               {
                  case "MP3":
                     return new UnlocalizedSound(_id++,param2,_loc5_);
                  default:
                     throw new ArgumentError("Unknown type file " + param2.fileType.toUpperCase());
               }
               break;
            default:
               throw new ArgumentError("Unknown sound type " + param1 + ". See EnumSoundType");
         }
      }
   }
}
