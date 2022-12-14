package com.ankamagames.dofus.logic.game.common.actions.externalGame
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GetComicRequestAction implements Action
   {
       
      
      public var remoteId:String;
      
      public var language:String;
      
      public var previewOnly:Boolean;
      
      public function GetComicRequestAction()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:Boolean) : GetComicRequestAction
      {
         var _loc4_:GetComicRequestAction;
         (_loc4_ = new GetComicRequestAction()).remoteId = param1;
         _loc4_.language = param2;
         _loc4_.previewOnly = param3;
         return _loc4_;
      }
   }
}
