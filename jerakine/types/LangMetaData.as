package com.ankamagames.jerakine.types
{
   import com.ankamagames.jerakine.utils.files.FileUtils;
   
   public class LangMetaData
   {
       
      
      private var _nFileCount:uint = 0;
      
      public var loadAllFile:Boolean = false;
      
      public var clearAllFile:Boolean = false;
      
      public var clearOnlyNotUpToDate:Boolean = true;
      
      public var clearFile:Array;
      
      public function LangMetaData()
      {
         this.clearFile = new Array();
         super();
      }
      
      public static function fromXml(param1:String, param2:String, param3:Function) : LangMetaData
      {
         var _loc4_:XML = null;
         var _loc7_:Boolean = false;
         var _loc5_:XML = new XML(param1);
         var _loc6_:LangMetaData = new LangMetaData();
         if(_loc5_..filesActions..clearOnlyNotUpToDate.toString() == "true")
         {
            _loc6_.clearOnlyNotUpToDate = true;
         }
         if(_loc5_..filesActions..clearOnlyNotUpToDate.toString() == "false")
         {
            _loc6_.clearOnlyNotUpToDate = false;
         }
         if(_loc5_..filesActions..loadAllFile.toString() == "true")
         {
            _loc6_.loadAllFile = true;
         }
         if(_loc5_..filesActions..loadAllFile.toString() == "false")
         {
            _loc6_.loadAllFile = false;
         }
         if(_loc5_..filesActions..clearAllFile.toString() == "true")
         {
            _loc6_.clearAllFile = true;
         }
         if(_loc5_..filesActions..clearAllFile.toString() == "false")
         {
            _loc6_.clearAllFile = false;
         }
         for each(_loc4_ in _loc5_..filesVersions..file)
         {
            _loc7_ = true;
            if(_loc6_.clearAllFile || !_loc6_.clearOnlyNotUpToDate || !param3(FileUtils.getFileStartName(param2) + "." + _loc4_..@name,_loc4_.toString()))
            {
               _loc6_.addFile(_loc4_..@name,_loc4_.toString());
            }
         }
         if(!_loc7_)
         {
            _loc6_.loadAllFile = true;
         }
         return _loc6_;
      }
      
      public function addFile(param1:String, param2:String) : void
      {
         ++this._nFileCount;
         this.clearFile[param1] = param2;
      }
      
      public function get clearFileCount() : uint
      {
         return this._nFileCount;
      }
   }
}
