package com.ankamagames.dofus.misc
{
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   
   public class BuildTypeParser
   {
       
      
      public function BuildTypeParser()
      {
         super();
      }
      
      public static function getTypeName(param1:uint) : String
      {
         switch(param1)
         {
            case BuildTypeEnum.RELEASE:
               return "RELEASE";
            case BuildTypeEnum.BETA:
               return "BETA";
            case BuildTypeEnum.ALPHA:
               return "ALPHA";
            case BuildTypeEnum.TESTING:
               return "TESTING";
            case BuildTypeEnum.INTERNAL:
               return "INTERNAL";
            case BuildTypeEnum.DEBUG:
               return "DEBUG";
            default:
               return "UNKNOWN";
         }
      }
      
      public static function getTypeColor(param1:uint) : uint
      {
         switch(param1)
         {
            case BuildTypeEnum.RELEASE:
               return 10079232;
            case BuildTypeEnum.BETA:
               return 16763904;
            case BuildTypeEnum.ALPHA:
               return 16750848;
            case BuildTypeEnum.TESTING:
               return 16737792;
            case BuildTypeEnum.INTERNAL:
               return 6724095;
            case BuildTypeEnum.DEBUG:
               return 10053375;
            default:
               return 16777215;
         }
      }
   }
}
