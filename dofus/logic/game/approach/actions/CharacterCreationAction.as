package com.ankamagames.dofus.logic.game.approach.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class CharacterCreationAction implements Action
   {
       
      
      public var name:String;
      
      public var breed:uint;
      
      public var head:int;
      
      public var sex:Boolean;
      
      public var colors:Array;
      
      public function CharacterCreationAction()
      {
         super();
      }
      
      public static function create(param1:String, param2:uint, param3:Boolean, param4:Array, param5:int) : CharacterCreationAction
      {
         var _loc6_:CharacterCreationAction;
         (_loc6_ = new CharacterCreationAction()).name = param1;
         _loc6_.breed = param2;
         _loc6_.sex = param3;
         _loc6_.colors = param4;
         _loc6_.head = param5;
         return _loc6_;
      }
   }
}
