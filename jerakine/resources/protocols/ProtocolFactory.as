package com.ankamagames.jerakine.resources.protocols
{
   import com.ankamagames.jerakine.resources.ResourceError;
   import com.ankamagames.jerakine.resources.protocols.impl.FileFlashProtocol;
   import com.ankamagames.jerakine.resources.protocols.impl.FileProtocol;
   import com.ankamagames.jerakine.resources.protocols.impl.HttpCacheProtocol;
   import com.ankamagames.jerakine.resources.protocols.impl.HttpProtocol;
   import com.ankamagames.jerakine.resources.protocols.impl.PakProtocol;
   import com.ankamagames.jerakine.resources.protocols.impl.PakProtocol2;
   import com.ankamagames.jerakine.resources.protocols.impl.UpdaterProtocol;
   import com.ankamagames.jerakine.resources.protocols.impl.ZipProtocol;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import flash.utils.Dictionary;
   
   public class ProtocolFactory
   {
      
      private static var _customProtocols:Dictionary = new Dictionary();
       
      
      public function ProtocolFactory()
      {
         super();
      }
      
      public static function getProtocol(param1:Uri) : IProtocol
      {
         var _loc2_:* = undefined;
         switch(param1.protocol)
         {
            case "http":
            case "https":
               return new HttpProtocol();
            case "httpc":
               return new HttpCacheProtocol();
            case "file":
               if(AirScanner.hasAir())
               {
                  return new FileProtocol();
               }
               return new FileFlashProtocol();
               break;
            case "zip":
               return new ZipProtocol();
            case "upd":
               return new UpdaterProtocol();
            case "pak":
            case "pak2":
            case "d2p":
               return new PakProtocol2();
            case "d2pOld":
               return new PakProtocol();
            default:
               var _loc3_:Class = _customProtocols[param1.protocol] as Class;
               if(_loc3_)
               {
                  _loc2_ = new _loc3_();
                  if(!(_loc2_ is IProtocol))
                  {
                     throw new ResourceError("Registered custom protocol for extension " + param1.protocol + " isn\'t an IProtocol class.");
                  }
                  return _loc2_;
               }
               throw new ArgumentError("Unknown protocol \'" + param1.protocol + "\' in the URI \'" + param1 + "\'.");
         }
      }
      
      public static function addProtocol(param1:String, param2:Class) : void
      {
         _customProtocols[param1] = param2;
      }
      
      public static function removeProtocol(param1:String) : void
      {
         delete _customProtocols[param1];
      }
   }
}
