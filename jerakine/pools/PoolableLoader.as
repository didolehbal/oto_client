package com.ankamagames.jerakine.pools
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.display.Loader;
   import flash.utils.getQualifiedClassName;
   
   public class PoolableLoader extends Loader implements Poolable
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(PoolableLoader));
       
      
      public function PoolableLoader()
      {
         super();
      }
      
      public function free() : void
      {
         unload();
      }
   }
}
