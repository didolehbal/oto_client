package com.ankamagames.dofus
{
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.jerakine.types.Version;
   
   public final class BuildInfos
   {
      
      public static var BUILD_VERSION:Version = new Version(2,29,2);
      
      public static var BUILD_TYPE:uint = BuildTypeEnum.RELEASE;
      
      public static var BUILD_REVISION:int = 96911;
      
      public static var BUILD_PATCH:int = 0;
      
      public static const BUILD_DATE:String = "Aug 3, 2015 - 16:35:38 CEST";
       
      
      public function BuildInfos()
      {
         super();
      }
   }
}
