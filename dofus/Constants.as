package com.ankamagames.dofus
{
   import com.ankamagames.jerakine.cache.Cache;
   import com.ankamagames.jerakine.types.DataStoreType;
   import com.ankamagames.jerakine.types.enums.DataStoreEnum;
   
   public class Constants
   {
      
      public static const SIGNATURE_KEY_DATA:String = "AA5Eb2Z1c1B1YmxpY0tleQIAQUM0RUFGQjJDOEVFRENBNkUyOTMxMEUxRTg0RjM4OURCQTBBQTQ0NDAyNEJFNENFMjNENDRFMEYzMDQ0MjU3NUU0RUY3QzVFM0NEQkVEMjM4MUI4RDA2MzdGMUJBNDUxRTg4RjAxQUM0QzI1MzA5NzJEMEVCRDcxRkY1MTdFNDE5MTkyODY5QjY2RDY4NDA0MEE4MEFENjNBNUREMTA3QjcyNzFFOUUwMjhFNTFDQ0MzMjQ4QTAzQTJFNDMyMDkzREUyMTY0QjVCQUUwQjYzOTk3OEVGN0ZGNkU2OTRDQTJDQTFCMENGMjhBQkVGNUNDN0VFRDVFMjJBQkJEODA3RjVERjMzMjc0RUY1NDIyMDA1MjgzQUE5M0I3MjE1RENFMTQyNjMyMDczRUNGOUU5NzhCQjc5NDMyMUZDMEUwRDVCQjAxOTc2ODI1MjVFRTlFQTEyMDMwMEJDQTVGNzI0MzVBMDk1QzY2NTBFQzFEMTMxRkU0MTYwNTcxRDc5NUM4ODIxRTYzM0FFODE1NzdBNTUxOTA0OEQ0NTc4ODQxNUJBM0YwMENBRDBFNUI2OEI1RDVERkMwQ0VGMzg4MEZBODQ3NUMwMEY3MDU0QzBBNjdFQ0U2NTMyOERFQ0JDRjJCMTgzQThDMUQ2RjU5RjBENzY3RUVBRTExMkFCN0Q5RUYABTEwMDAx";
      
      public static const LOG_UPLOAD_MODE:Boolean = false;
      
      public static var EVENT_MODE:Boolean = true;
      
      public static var EVENT_MODE_PARAM:String = "";
      
      public static var CHARACTER_CREATION_ALLOWED:Boolean = true;
      
      public static var FORCE_MAXIMIZED_WINDOW:Boolean = true;
      
      public static const DATASTORE_COMPUTER_OPTIONS:DataStoreType = new DataStoreType("Dofus_ComputerOptions",true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_ACCOUNT);
      
      public static const DATASTORE_LANG_VERSION:DataStoreType = new DataStoreType("lastLangVersion",true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_ACCOUNT);
      
      public static const DATASTORE_CONSOLE_CMD:DataStoreType = new DataStoreType("Dofus_ConsoleCmd",true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_COMPUTER);
      
      public static const DATASTORE_MODULE_DEBUG:DataStoreType = new DataStoreType("Dofus_ModuleDebug",true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_COMPUTER);
      
      public static const DATASTORE_TCHAT:DataStoreType = new DataStoreType("Dofus_Tchat",true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_ACCOUNT);
      
      public static const DATASTORE_TCHAT_PRIVATE:DataStoreType = new DataStoreType("Dofus_TchatPrivate",true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_ACCOUNT);
      
      public static const SCRIPT_CACHE:Cache = new Cache(Cache.CHECK_OBJECT_COUNT,100,80);
      
      public static const PRE_GAME_MODULE:Array = new Array("Ankama_Connection");
      
      public static const COMMON_GAME_MODULE:Array = new Array("Ankama_Common","Ankama_Config","Ankama_Tooltips","Ankama_Console","Ankama_ContextMenu");
      
      public static const ADMIN_MODULE:Array = new Array("Ankama_Admin");
      
      public static const DETERMINIST_TACKLE:Boolean = true;
       
      
      public function Constants()
      {
         super();
      }
   }
}
