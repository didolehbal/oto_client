package com.ankamagames.berilia.types.data
{
   public class TreeData
   {
       
      
      public var value;
      
      public var label:String;
      
      public var expend:Boolean;
      
      public var children:Vector.<TreeData>;
      
      public var parent:TreeData;
      
      public function TreeData(param1:*, param2:String, param3:Boolean = false, param4:Vector.<TreeData> = null, param5:TreeData = null)
      {
         super();
         this.value = param1;
         this.label = param2;
         this.expend = param3;
         this.children = param4;
         this.parent = param5;
      }
      
      public static function fromArray(param1:Object) : Vector.<TreeData>
      {
         var _loc2_:TreeData = new TreeData(null,null,true);
         _loc2_.children = _fromArray(param1,_loc2_);
         return _loc2_.children;
      }
      
      private static function _fromArray(param1:Object, param2:TreeData) : Vector.<TreeData>
      {
         var _loc3_:TreeData = null;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:Vector.<TreeData> = new Vector.<TreeData>();
         for each(_loc5_ in param1)
         {
            if(Object(_loc5_).hasOwnProperty("children"))
            {
               _loc4_ = _loc5_.children;
            }
            else
            {
               _loc4_ = null;
            }
            _loc3_ = new TreeData(_loc5_,_loc5_.label,!!Object(_loc5_).hasOwnProperty("expend")?Boolean(Object(_loc5_).expend):false);
            _loc3_.parent = param2;
            _loc3_.children = _fromArray(_loc4_,_loc3_);
            _loc6_.push(_loc3_);
         }
         return _loc6_;
      }
      
      public function get depth() : uint
      {
         if(this.parent)
         {
            return this.parent.depth + 1;
         }
         return 0;
      }
   }
}
