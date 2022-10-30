package com.ankamagames.dofus.logic.game.common.misc
{
   import com.ankamagames.berilia.types.data.Hook;
   
   public class HookLock implements IHookLock
   {
       
      
      private var _hooks:Vector.<HookDef>;
      
      public function HookLock()
      {
         super();
         this._hooks = new Vector.<HookDef>();
      }
      
      public function addHook(param1:Hook, param2:Array) : void
      {
         var _loc3_:HookDef = null;
         var _loc4_:HookDef = new HookDef(param1,param2);
         for each(_loc3_ in this._hooks)
         {
            if(_loc4_.isEqual(_loc3_))
            {
               return;
            }
         }
         this._hooks.push(_loc4_);
      }
      
      public function release() : void
      {
         var _loc1_:HookDef = null;
         for each(_loc1_ in this._hooks)
         {
            _loc1_.run();
         }
         this._hooks.splice(0,this._hooks.length);
      }
   }
}

import com.ankamagames.berilia.managers.KernelEventsManager;
import com.ankamagames.berilia.types.data.Hook;

class HookDef
{
    
   
   private var _hook:Hook;
   
   private var _args:Array;
   
   function HookDef(param1:Hook, param2:Array)
   {
      super();
      this._hook = param1;
      this._args = param2;
   }
   
   public function get hook() : Hook
   {
      return this._hook;
   }
   
   public function get args() : Array
   {
      return this._args;
   }
   
   public function isEqual(param1:HookDef) : Boolean
   {
      var _loc2_:int = 0;
      if(this.hook != param1.hook)
      {
         return false;
      }
      if(this.args.length != param1.args.length)
      {
         return false;
      }
      while(_loc2_ < this.args.length)
      {
         if(this.args[_loc2_] != param1.args[_loc2_])
         {
            return false;
         }
         _loc2_++;
      }
      return true;
   }
   
   public function run() : void
   {
      switch(this.args.length)
      {
         case 0:
            KernelEventsManager.getInstance().processCallback(this.hook);
            return;
         case 1:
            KernelEventsManager.getInstance().processCallback(this.hook,this.args[0]);
            return;
         case 2:
            KernelEventsManager.getInstance().processCallback(this.hook,this.args[0],this.args[1]);
            return;
         case 3:
            KernelEventsManager.getInstance().processCallback(this.hook,this.args[0],this.args[1],this.args[2]);
            return;
         case 4:
            KernelEventsManager.getInstance().processCallback(this.hook,this.args[0],this.args[1],this.args[2],this.args[3]);
            return;
         case 5:
            KernelEventsManager.getInstance().processCallback(this.hook,this.args[0],this.args[1],this.args[2],this.args[3],this.args[4]);
            return;
         case 6:
            KernelEventsManager.getInstance().processCallback(this.hook,this.args[0],this.args[1],this.args[2],this.args[3],this.args[4],this.args[5]);
            return;
         case 7:
            KernelEventsManager.getInstance().processCallback(this.hook,this.args[0],this.args[1],this.args[2],this.args[3],this.args[4],this.args[5],this.args[6]);
            return;
         case 8:
            KernelEventsManager.getInstance().processCallback(this.hook,this.args[0],this.args[1],this.args[2],this.args[3],this.args[4],this.args[5],this.args[6],this.args[7]);
            return;
         case 9:
            KernelEventsManager.getInstance().processCallback(this.hook,this.args[0],this.args[1],this.args[2],this.args[3],this.args[4],this.args[5],this.args[6],this.args[7],this.args[8]);
            return;
         default:
            return;
      }
   }
}
