package com.ankamagames.jerakine.resources.protocols
{
   import com.ankamagames.jerakine.resources.IResourceObserver;
   import com.ankamagames.jerakine.resources.adapters.AdapterFactory;
   import com.ankamagames.jerakine.resources.adapters.IAdapter;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.errors.AbstractMethodCallError;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class AbstractProtocol
   {
      
      public static var MEMORY_LOG:Dictionary = new Dictionary(true);
       
      
      protected var _observer:IResourceObserver;
      
      protected var _adapter:IAdapter;
      
      public function AbstractProtocol()
      {
         super();
         MEMORY_LOG[this] = 1;
      }
      
      public function free() : void
      {
         this.release();
         this._observer = null;
         this._adapter = null;
      }
      
      public function cancel() : void
      {
      }
      
      protected function release() : void
      {
         throw new AbstractMethodCallError("AbstractProtocol childs must override the release method in order to free their resources.");
      }
      
      protected function loadDirectly(param1:Uri, param2:IResourceObserver, param3:Boolean, param4:Class) : void
      {
         this.getAdapter(param1,param4);
         this._adapter.loadDirectly(param1,param1.path,param2,param3);
      }
      
      protected function loadFromData(param1:Uri, param2:ByteArray, param3:IResourceObserver, param4:Boolean, param5:Class) : void
      {
         this.getAdapter(param1,param5);
         this._adapter.loadFromData(param1,param2,param3,param4);
      }
      
      protected function getAdapter(param1:Uri, param2:Class) : void
      {
         if(param2 == null)
         {
            this._adapter = AdapterFactory.getAdapter(param1);
         }
         else
         {
            this._adapter = new param2();
         }
      }
   }
}
