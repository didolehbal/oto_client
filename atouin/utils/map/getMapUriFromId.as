package com.ankamagames.atouin.utils.map
{
   import com.ankamagames.atouin.Atouin;
   
   public function getMapUriFromId(param1:int) : String
   {
      return Atouin.getInstance().options.mapsPath + param1 % 10 + "/" + param1 + ".dlm";
   }
}
