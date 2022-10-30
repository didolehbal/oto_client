package com.ankamagames.dofus.misc
{
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.network.types.game.look.SubEntity;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   
   public class EntityLookAdapter
   {
       
      
      public function EntityLookAdapter()
      {
         super();
      }
      
      public static function fromNetwork(param1:EntityLook) : TiphonEntityLook
      {
         var _loc2_:uint = 0;
         var _loc3_:SubEntity = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc7_:uint = 0;
         var _loc6_:TiphonEntityLook;
         (_loc6_ = new TiphonEntityLook()).lock();
         _loc6_.setBone(param1.bonesId);
         for each(_loc2_ in param1.skins)
         {
            _loc6_.addSkin(_loc2_);
         }
         if(param1.bonesId == 1 || param1.bonesId == 2)
         {
            _loc6_.defaultSkin = 1965;
         }
         while(_loc7_ < param1.indexedColors.length)
         {
            _loc4_ = param1.indexedColors[_loc7_] >> 24 & 255;
            _loc5_ = param1.indexedColors[_loc7_] & 16777215;
            _loc6_.setColor(_loc4_,_loc5_);
            _loc7_++;
         }
         if(param1.scales.length == 1)
         {
            _loc6_.setScales(param1.scales[0] / 100,param1.scales[0] / 100);
         }
         else if(param1.scales.length == 2)
         {
            _loc6_.setScales(param1.scales[0] / 100,param1.scales[1] / 100);
         }
         for each(_loc3_ in param1.subentities)
         {
            _loc6_.addSubEntity(_loc3_.bindingPointCategory,_loc3_.bindingPointIndex,EntityLookAdapter.fromNetwork(_loc3_.subEntityLook));
         }
         _loc6_.unlock(true);
         return _loc6_;
      }
      
      public static function toNetwork(param1:TiphonEntityLook) : EntityLook
      {
         var _loc2_:* = null;
         var _loc3_:Array = null;
         var _loc4_:* = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:* = null;
         var _loc10_:uint = 0;
         var _loc11_:SubEntity = null;
         var _loc12_:EntityLook;
         (_loc12_ = new EntityLook()).bonesId = param1.getBone();
         _loc12_.skins = param1.getSkins(false,false);
         var _loc13_:Array = param1.getColors(true);
         for(_loc2_ in _loc13_)
         {
            _loc5_ = parseInt(_loc2_);
            _loc6_ = _loc13_[_loc2_];
            _loc7_ = (_loc5_ & 255) << 24 | _loc6_ & 16777215;
            _loc12_.indexedColors.push(_loc7_);
         }
         _loc12_.scales.push(uint(param1.getScaleX() * 100));
         _loc12_.scales.push(uint(param1.getScaleY() * 100));
         _loc3_ = param1.getSubEntities(true);
         for(_loc4_ in _loc3_)
         {
            _loc8_ = parseInt(_loc4_);
            for(_loc9_ in _loc3_[_loc4_])
            {
               _loc10_ = parseInt(_loc9_);
               (_loc11_ = new SubEntity()).initSubEntity(_loc8_,_loc10_,EntityLookAdapter.toNetwork(_loc3_[_loc4_][_loc9_]));
               _loc12_.subentities.push(_loc11_);
            }
         }
         return _loc12_;
      }
      
      public static function tiphonizeLook(param1:*) : TiphonEntityLook
      {
         var _loc2_:TiphonEntityLook = null;
         param1 = SecureCenter.unsecure(param1);
         if(param1 is TiphonEntityLook)
         {
            _loc2_ = param1 as TiphonEntityLook;
         }
         if(param1 is EntityLook)
         {
            _loc2_ = fromNetwork(param1);
         }
         if(param1 is String)
         {
            _loc2_ = TiphonEntityLook.fromString(param1);
         }
         return _loc2_;
      }
      
      public static function getRiderLook(param1:*) : TiphonEntityLook
      {
         param1 = SecureCenter.unsecure(param1);
         var _loc2_:TiphonEntityLook = tiphonizeLook(param1);
         var _loc3_:TiphonEntityLook = _loc2_.clone();
         var _loc4_:TiphonEntityLook;
         if(_loc4_ = _loc3_.getSubEntity(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0))
         {
            if(_loc4_.getBone() == 2)
            {
               _loc4_.setBone(1);
            }
            _loc3_ = _loc4_;
         }
         return _loc3_;
      }
   }
}
