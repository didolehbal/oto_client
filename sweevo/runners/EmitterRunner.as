package com.ankamagames.sweevo.runners
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.script.ScriptErrorEnum;
   import com.ankamagames.jerakine.script.runners.IRunner;
   import com.ankamagames.jerakine.types.Callback;
   import flash.utils.getQualifiedClassName;
   import org.flintparticles.common.renderers.Renderer;
   
   public class EmitterRunner implements IRunner
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(EmitterRunner));
       
      
      private var _renderer:Renderer;
      
      private var _onRun:Callback;
      
      private var _scriptInstance;
      
      public function EmitterRunner(param1:Renderer, param2:Callback = null)
      {
         super();
         this._renderer = param1;
         this._onRun = param2;
      }
      
      public function get renderer() : Renderer
      {
         return this._renderer;
      }
      
      public function run(param1:Class) : uint
      {
         var script:Class = param1;
         this._scriptInstance = new script();
         var _local_3:* = this._scriptInstance;
         _local_3["__setRunner__"](this);
         try
         {
            this._scriptInstance.main();
         }
         catch(e:Error)
         {
            _log.error("Error while executing a script :");
            _log.error(e.getStackTrace());
         }
         if(this._onRun)
         {
            this._onRun.exec();
         }
         return ScriptErrorEnum.OK;
      }
   }
}
