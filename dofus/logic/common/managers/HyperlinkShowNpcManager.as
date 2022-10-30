package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.atouin.types.GraphicCell;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class HyperlinkShowNpcManager
   {
       
      
      public function HyperlinkShowNpcManager()
      {
         super();
      }
      
      public static function showNpc(param1:int, param2:int = 0) : MovieClip
      {
         var _loc3_:Dictionary = null;
         var _loc4_:Object = null;
         var _loc5_:GraphicCell = null;
         var _loc6_:Rectangle = null;
         var _loc7_:RoleplayEntitiesFrame;
         if(_loc7_ = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame)
         {
            _loc3_ = _loc7_.getEntitiesDictionnary();
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_ is GameRolePlayNpcInformations && (_loc4_.npcId == param1 || param1 == -1))
               {
                  _loc6_ = (_loc5_ = InteractiveCellManager.getInstance().getCell(_loc4_.disposition.cellId)).getRect(Berilia.getInstance().docMain);
                  _loc6_.y = _loc6_.y - 80;
                  return HyperlinkDisplayArrowManager.showAbsoluteArrow(_loc6_,0,0,1,param2);
               }
            }
         }
         return null;
      }
   }
}
