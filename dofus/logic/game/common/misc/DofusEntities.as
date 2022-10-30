package com.ankamagames.dofus.logic.game.common.misc
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.getQualifiedClassName;
   
   public class DofusEntities
   {
      
      private static const LOCALIZER_DEBUG:Boolean = true;
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(DofusEntities));
      
      private static var _atouin:Atouin = Atouin.getInstance();
      
      private static var _localizers:Vector.<IEntityLocalizer> = new Vector.<IEntityLocalizer>();
       
      
      public function DofusEntities()
      {
         super();
      }
      
      public static function getEntity(param1:int) : IEntity
      {
         var _loc2_:IEntityLocalizer = null;
         var _loc3_:IEntity = null;
         for each(_loc2_ in _localizers)
         {
            _loc3_ = _loc2_.getEntity(param1);
            if(_loc3_)
            {
               return _loc3_;
            }
         }
         return _atouin.getEntity(param1);
      }
      
      public static function registerLocalizer(param1:IEntityLocalizer) : void
      {
         var _loc2_:IEntityLocalizer = null;
         var _loc4_:String = null;
         var _loc3_:String = getQualifiedClassName(param1);
         for each(_loc2_ in _localizers)
         {
            if((_loc4_ = getQualifiedClassName(_loc2_)) == _loc3_)
            {
               throw new Error("There\'s more than one " + _loc4_ + " localizer added to DofusEntites. Nope, that won\'t work.");
            }
         }
         _localizers.push(param1);
      }
      
      public static function reset() : void
      {
         var _loc1_:IEntityLocalizer = null;
         var _loc2_:int = 0;
         while(_loc2_ < _localizers.length)
         {
            _loc1_ = _localizers[_loc2_];
            _loc1_.unregistered();
            _loc2_++;
         }
         _localizers = new Vector.<IEntityLocalizer>();
      }
   }
}
