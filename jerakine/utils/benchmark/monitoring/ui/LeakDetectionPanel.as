package com.ankamagames.jerakine.utils.benchmark.monitoring.ui
{
   import com.ankamagames.jerakine.utils.benchmark.monitoring.FpsManagerConst;
   import com.ankamagames.jerakine.utils.benchmark.monitoring.FpsManagerEvent;
   import com.ankamagames.jerakine.utils.benchmark.monitoring.FpsManagerUtils;
   import com.ankamagames.jerakine.utils.benchmark.monitoring.List;
   import com.ankamagames.jerakine.utils.benchmark.monitoring.MonitoredObject;
   import flash.display.Sprite;
   import flash.events.TextEvent;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   
   public class LeakDetectionPanel extends Sprite
   {
      
      private static const WIDTH:int = FpsManagerConst.BOX_WIDTH;
      
      private static const HEIGHT:int = 300;
       
      
      private var _listDataObject:Dictionary;
      
      private var _dataTf:TextField;
      
      public var dataToDisplay:Vector.<Number>;
      
      public function LeakDetectionPanel()
      {
         super();
         this._listDataObject = new Dictionary();
         this._dataTf = new TextField();
         this._dataTf.multiline = true;
         this._dataTf.thickness = 200;
         this._dataTf.autoSize = "left";
         this._dataTf.addEventListener(TextEvent.LINK,this.linkHandler);
         addChild(this._dataTf);
         this.drawBG();
      }
      
      private function drawBG() : void
      {
         graphics.clear();
         graphics.beginFill(FpsManagerConst.BOX_COLOR,0.7);
         graphics.lineStyle(2,FpsManagerConst.BOX_COLOR);
         graphics.drawRoundRect(0,0,WIDTH,this._dataTf.textHeight + 8,8,8);
         graphics.endFill();
      }
      
      public function watchObject(param1:Object, param2:uint, param3:Boolean = false) : void
      {
         var _loc4_:List = null;
         var _loc5_:List = null;
         var _loc6_:List = null;
         var _loc7_:XML = null;
         var _loc8_:String = null;
         var _loc9_:XML = null;
         var _loc10_:String = getQualifiedClassName(param1).split("::")[1];
         var _loc11_:MonitoredObject;
         if((_loc11_ = this._listDataObject[_loc10_]) == null)
         {
            if(param3)
            {
               _loc5_ = _loc4_ = new List(_loc10_);
               _loc7_ = describeType(param1);
               for each(_loc9_ in _loc7_.extendsClass)
               {
                  _loc8_ = _loc9_.@type.toString().split("::")[1];
                  if(this._listDataObject[_loc8_] != null)
                  {
                     _loc5_.next = this._listDataObject[_loc8_].extendsClass;
                     break;
                  }
                  _loc6_ = new List(_loc8_);
                  _loc5_.next = _loc6_;
                  _loc6_ = _loc5_;
               }
            }
            _loc11_ = new MonitoredObject(_loc10_,param2,_loc4_);
            this._listDataObject[_loc10_] = _loc11_;
            if(param3 && _loc4_ != null)
            {
               this.updateParents(_loc4_,_loc11_);
            }
         }
         else if(_loc11_.color == 16777215)
         {
            _loc11_.color = param2;
         }
         _loc11_.addNewValue(param1);
      }
      
      private function updateParents(param1:List, param2:Object) : void
      {
         var _loc3_:List = param1;
         if(_loc3_ != null)
         {
            do
            {
               if(_loc3_.value != null)
               {
                  this.updateParent(_loc3_.value.toString(),param2,_loc3_.next);
               }
            }
            while((_loc3_ = _loc3_.next) != null);
            
         }
      }
      
      private function updateParent(param1:String, param2:Object, param3:List) : void
      {
         var _loc4_:MonitoredObject;
         if((_loc4_ = this._listDataObject[param1]) == null)
         {
            _loc4_ = new MonitoredObject(param1,16777215,param3);
            this._listDataObject[param1] = _loc4_;
         }
         _loc4_.addNewValue(param2);
      }
      
      public function updateData() : void
      {
         var _loc1_:MonitoredObject = null;
         var _loc2_:* = "";
         for each(_loc1_ in this._listDataObject)
         {
            _loc1_.update();
            _loc2_ = _loc2_ + ("<font face=\'Verdana\' size=\'15\' color=\'#" + _loc1_.color.toString(16) + "\' >");
            if(_loc1_.selected)
            {
               _loc2_ = _loc2_ + "(*) ";
            }
            _loc2_ = _loc2_ + ("<a href=\'event:" + _loc1_.name + "\'>[" + _loc1_.name + "]</a> : " + FpsManagerUtils.countKeys(_loc1_.list));
            _loc2_ = _loc2_ + "</font>\n";
         }
         this._dataTf.htmlText = _loc2_;
         this._dataTf.width = this._dataTf.textWidth + 10;
         this.drawBG();
      }
      
      private function linkHandler(param1:TextEvent) : void
      {
         var _loc2_:MonitoredObject = this._listDataObject[param1.text];
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:FpsManagerEvent = new FpsManagerEvent("follow");
         _loc3_.data = _loc2_;
         dispatchEvent(_loc3_);
      }
   }
}
