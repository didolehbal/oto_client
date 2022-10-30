package com.ankamagames.dofus.datacenter.misc
{
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.connection.managers.AuthentificationManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.managers.OptionManager;
   import flash.net.URLVariables;
   
   public class Url implements IDataCenter
   {
      
      public static const MODULE:String = "Url";
       
      
      public var id:int;
      
      public var browserId:int;
      
      public var url:String;
      
      public var param:String;
      
      public var method:String;
      
      public function Url()
      {
         super();
      }
      
      public static function getUrlById(param1:int) : Url
      {
         return GameData.getObject(MODULE,param1) as Url;
      }
      
      public static function getAllUrl() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public function get variables() : Object
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         var _loc3_:URLVariables = new URLVariables();
         var _loc4_:Array = this.param.split(",");
         for each(_loc2_ in _loc4_)
         {
            if(!(_loc2_ == null || _loc2_ == "null"))
            {
               _loc1_ = _loc2_.split(":");
               if(_loc1_[1].charAt(0) == "#")
               {
                  switch(String(_loc1_[1]).toUpperCase().substr(1))
                  {
                     case "TOKEN":
                        _loc1_[1] = AuthentificationManager.getInstance().ankamaPortalKey;
                        break;
                     case "LOGIN":
                        _loc1_[1] = AuthentificationManager.getInstance().username;
                        break;
                     case "NICKNAME":
                        _loc1_[1] = PlayerManager.getInstance().nickname;
                        break;
                     case "GAME":
                        _loc1_[1] = 1;
                        break;
                     case "ACCOUNT_ID":
                        _loc1_[1] = PlayerManager.getInstance().accountId;
                        break;
                     case "PLAYER_ID":
                        _loc1_[1] = PlayedCharacterManager.getInstance().id;
                        break;
                     case "SERVER_ID":
                        _loc1_[1] = PlayerManager.getInstance().server.id;
                        break;
                     case "LANG":
                        _loc1_[1] = XmlConfig.getInstance().getEntry("config.lang.current");
                        break;
                     case "THEME":
                        _loc1_[1] = OptionManager.getOptionManager("dofus").switchUiSkin;
                  }
               }
               _loc3_[_loc1_[0]] = _loc1_[1];
            }
         }
         return _loc3_;
      }
   }
}
