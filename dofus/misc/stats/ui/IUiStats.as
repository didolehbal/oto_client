package com.ankamagames.dofus.misc.stats.ui
{
   import com.ankamagames.berilia.types.data.Hook;
   import com.ankamagames.dofus.misc.stats.IStatsClass;
   
   public interface IUiStats extends IStatsClass
   {
       
      
      function onHook(param1:Hook, param2:Array) : void;
   }
}
