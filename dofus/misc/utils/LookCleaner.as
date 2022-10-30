package com.ankamagames.dofus.misc.utils
{
   import com.ankamagames.dofus.datacenter.breeds.Breed;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   
   public class LookCleaner
   {
       
      
      public function LookCleaner()
      {
         super();
      }
      
      public static function clean(param1:TiphonEntityLook) : TiphonEntityLook
      {
         var _loc2_:Breed = null;
         var _loc3_:TiphonEntityLook = param1.clone();
         var _loc4_:TiphonEntityLook;
         if(_loc4_ = _loc3_.getSubEntity(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0))
         {
            if(_loc4_.getBone() == 2)
            {
               _loc4_.setBone(1);
            }
            return _loc4_;
         }
         for each(_loc2_ in Breed.getBreeds())
         {
            if(_loc2_.creatureBonesId == _loc3_.getBone())
            {
               _loc3_.setBone(1);
               break;
            }
         }
         return _loc3_;
      }
   }
}
