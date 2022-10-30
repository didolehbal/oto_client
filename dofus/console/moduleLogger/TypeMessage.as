package com.ankamagames.dofus.console.moduleLogger
{
   import com.ankamagames.berilia.types.data.Hook;
   import com.ankamagames.berilia.types.shortcut.Bind;
   import com.ankamagames.jerakine.handlers.messages.Action;
   import com.ankamagames.jerakine.logger.LogLevel;
   import com.ankamagames.jerakine.messages.Message;
   import flash.display.DisplayObject;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   
   public final class TypeMessage
   {
      
      public static const TYPE_HOOK:int = 0;
      
      public static const TYPE_UI:int = 1;
      
      public static const TYPE_ACTION:int = 2;
      
      public static const TYPE_SHORTCUT:int = 3;
      
      public static const TYPE_MODULE_LOG:int = 4;
      
      public static const LOG:int = 5;
      
      public static const LOG_CHAT:int = 17;
      
      public static const TAB:String = "                  • ";
       
      
      public var name:String = "";
      
      public var textInfo:String;
      
      public var type:int = -1;
      
      public var logType:int = -1;
      
      private var search1:RegExp;
      
      private var search2:RegExp;
      
      private var vectorExp:RegExp;
      
      public function TypeMessage(... rest)
      {
         var object:Object = null;
         var args:Array = rest;
         this.search1 = /</g;
         this.search2 = />/g;
         this.vectorExp = /Vector.<(.*)::(.*)>/g;
         super();
         try
         {
            object = args[0];
            if(object is String && args.length == 2)
            {
               this.displayLog(object as String,args[1]);
            }
            else if(object is String && args[1] == LOG_CHAT)
            {
               this.type = LOG_CHAT;
               this.textInfo = "<span class=\'" + args[2] + "\'>[" + this.getDate() + "] " + String(object) + "</span>";
            }
            else if(object is Hook)
            {
               this.displayHookInformations(object as Hook,args[1]);
            }
            else if(object is Action)
            {
               this.displayActionInformations(object as Action);
            }
            else if(object is Message)
            {
               this.displayInteractionMessage(object as Message,args[1]);
            }
            else if(object is Bind)
            {
               this.displayBind(object as Bind,args[1]);
            }
            else
            {
               this.name = "trace";
               this.textInfo = object as String;
               this.type = LOG;
            }
         }
         catch(e:Error)
         {
            if(!(object is String))
            {
               name = "trace";
               textInfo = "<span class=\'red\'>" + e.getStackTrace() + "</span>";
            }
         }
      }
      
      private function displayBind(param1:Bind, param2:Object) : void
      {
         this.type = TYPE_SHORTCUT;
         var _loc3_:String = "Shortcut : " + param1.key.toUpperCase() + " --&gt; \"" + param1.targetedShortcut + "\" " + (!!param1.alt?"Alt+":"") + (!!param1.ctrl?"Ctrl+":"") + (!!param1.shift?"Shift+":"");
         this.name = "Shortcut";
         this.textInfo = "<span class=\'gray\'>[" + this.getDate() + "]</span>" + "<span class=\'yellow\'> BIND   : <a href=\'event:@shortcut\'>" + _loc3_ + "</a></span>" + "\n<span class=\'gray+\'>" + TAB + "target : " + param2 + "</span>\n";
      }
      
      private function displayInteractionMessage(param1:Message, param2:DisplayObject) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         this.type = TYPE_UI;
         var _loc6_:String;
         if((_loc6_ = getQualifiedClassName(param1)).indexOf("::") != -1)
         {
            _loc6_ = _loc6_.split("::")[1];
         }
         this.name = _loc6_;
         var _loc7_:* = "<span class=\'gray\'>[" + this.getDate() + "]</span>" + "<span class=\'green\'> UI     : <a href=\'event:@" + this.name + "\'>" + this.name + "</a></span>" + "\n<span class=\'gray+\'>" + TAB + "target : " + param2.name + "</span><span class=\'gray\'>";
         var _loc8_:String;
         if((_loc8_ = String(param1)).indexOf("@") != -1)
         {
            _loc3_ = _loc8_.split("@");
            _loc4_ = _loc3_.length;
            _loc5_ = 1;
            while(_loc5_ < _loc4_)
            {
               _loc7_ = _loc7_ + ("\n" + TAB + _loc3_[_loc5_]);
               _loc5_++;
            }
         }
         this.textInfo = _loc7_ + "</span>\n";
      }
      
      private function displayHookInformations(param1:Hook, param2:Array) : void
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc8_:int = 0;
         this.type = TYPE_HOOK;
         this.name = param1.name;
         var _loc6_:* = "<span class=\'gray\'>[" + this.getDate() + "]</span>" + "<span class=\'blue\'> HOOK   : <a href=\'event:@" + this.name + "\'>" + this.name + "</a></span>" + "<span class=\'gray\'>";
         var _loc7_:int = param2.length;
         while(_loc8_ < _loc7_)
         {
            _loc3_ = param2[_loc8_];
            if((_loc4_ = (_loc4_ = (_loc4_ = (_loc4_ = getQualifiedClassName(_loc3_)).replace(this.vectorExp,"Vector.<$2>")).replace(this.search1,"&lt;")).replace(this.search2,"&gt;")).indexOf("::") != -1)
            {
               _loc4_ = _loc4_.split("::")[1];
            }
            if(_loc3_ != null)
            {
               _loc5_ = (_loc5_ = (_loc5_ = _loc3_.toString()).replace(this.search1,"&lt;")).replace(this.search2,"&gt;");
            }
            _loc6_ = _loc6_ + ("\n" + TAB + "arg" + _loc8_ + ":" + _loc4_ + " = " + _loc5_);
            _loc8_++;
         }
         _loc6_ = _loc6_ + "</span>\n";
         this.textInfo = _loc6_;
      }
      
      private function displayLog(param1:String, param2:int) : void
      {
         var _loc3_:String = null;
         this.name = param1;
         if(param2 == LogLevel.DEBUG)
         {
            _loc3_ = "<span class=\'blue\'>";
         }
         else if(param2 == LogLevel.TRACE)
         {
            _loc3_ = "<span class=\'green\'>";
         }
         else if(param2 == LogLevel.INFO)
         {
            _loc3_ = "<span class=\'yellow\'>";
         }
         else if(param2 == LogLevel.WARN)
         {
            _loc3_ = "<span class=\'orange\'>";
         }
         else if(param2 == LogLevel.ERROR)
         {
            _loc3_ = "<span class=\'red\'>";
         }
         else if(param2 == LogLevel.FATAL)
         {
            _loc3_ = "<span class=\'red+\'>";
         }
         else if(param2 == LOG_CHAT)
         {
            this.logType = LOG_CHAT;
            _loc3_ = "<span class=\'white\'>";
         }
         else
         {
            _loc3_ = "<span class=\'gray\'>";
         }
         _loc3_ = _loc3_ + ("[" + this.getDate() + "] " + param1 + "</span>");
         this.textInfo = _loc3_;
      }
      
      private function displayActionInformations(param1:Action) : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         this.type = TYPE_ACTION;
         var _loc6_:String = getQualifiedClassName(param1).split("::")[1];
         this.name = _loc6_;
         var _loc7_:* = "<span class=\'gray\'>[" + this.getDate() + "]</span>" + "<span class=\'pink\'> ACTION : <a href=\'event:@" + this.name + "\'>" + this.name + "</a></span>" + "<span class=\'gray\'>";
         var _loc8_:XML;
         var _loc9_:XMLList = (_loc8_ = describeType(param1)).elements("variable");
         for each(_loc2_ in _loc9_)
         {
            _loc3_ = _loc2_.attribute("name");
            _loc4_ = (_loc4_ = (_loc4_ = _loc2_.attribute("type")).replace(this.search1,"&lt;")).replace(this.search2,"&gt;");
            _loc5_ = (_loc5_ = (_loc5_ = String(param1[_loc3_])).replace(this.search1,"&lt;")).replace(this.search2,"&gt;");
            _loc7_ = _loc7_ + ("\n" + TAB + _loc3_ + ":" + _loc4_ + " = " + _loc5_);
         }
         _loc7_ = _loc7_ + "</span>\n";
         this.textInfo = _loc7_;
      }
      
      private function getDate() : String
      {
         var _loc1_:Date = new Date();
         var _loc2_:int = _loc1_.hours;
         var _loc3_:int = _loc1_.minutes;
         var _loc4_:int = _loc1_.seconds;
         return (_loc2_ < 10?"0" + _loc2_:_loc2_) + ":" + (_loc3_ < 10?"0" + _loc3_:_loc3_) + ":" + (_loc4_ < 10?"0" + _loc4_:_loc4_);
      }
   }
}
