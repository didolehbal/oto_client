package com.ankamagames.dofus.types.entities
{
   import com.ankamagames.tiphon.types.ISkinModifier;
   import com.ankamagames.tiphon.types.Skin;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   
   public class BreedSkinModifier implements ISkinModifier
   {
       
      
      public function BreedSkinModifier()
      {
         super();
      }
      
      public function getModifiedSkin(param1:Skin, param2:String, param3:TiphonEntityLook) : String
      {
         var _loc4_:String = null;
         if(!param3 || !param3.skins || !param2 || !param1)
         {
            return param2;
         }
         var _loc5_:Array = param2.split("_");
         var _loc6_:int = param3.skins.length - 1;
         while(_loc6_ >= 0)
         {
            _loc4_ = _loc5_[0] + "_" + param3.skins[_loc6_] + "_" + _loc5_[1];
            if(param1.getPart(_loc4_) != null)
            {
               return _loc4_;
            }
            _loc6_--;
         }
         return param2;
      }
   }
}
