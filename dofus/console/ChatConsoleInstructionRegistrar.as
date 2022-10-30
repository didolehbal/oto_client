package com.ankamagames.dofus.console
{
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.console.chat.EmoteInstructionHandler;
   import com.ankamagames.dofus.console.chat.FightInstructionHandler;
   import com.ankamagames.dofus.console.chat.InfoInstructionHandler;
   import com.ankamagames.dofus.console.chat.MessagingInstructionHandler;
   import com.ankamagames.dofus.console.chat.OptionsInstructionHandler;
   import com.ankamagames.dofus.console.chat.SocialInstructionHandler;
   import com.ankamagames.dofus.console.chat.StatusInstructionHandler;
   import com.ankamagames.dofus.console.common.LatencyInstructionHandler;
   import com.ankamagames.dofus.console.debug.MiscInstructionHandler;
   import com.ankamagames.dofus.console.debug.UiHandlerInstructionHandler;
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.console.ConsoleInstructionRegistar;
   import com.ankamagames.jerakine.data.I18n;
   
   public class ChatConsoleInstructionRegistrar implements ConsoleInstructionRegistar
   {
       
      
      public function ChatConsoleInstructionRegistrar()
      {
         super();
      }
      
      public function registerInstructions(param1:ConsoleHandler) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Array = new Array();
         for each(_loc2_ in Emoticon.getEmoticons())
         {
            _loc3_.push(_loc2_.shortcut);
         }
         param1.addHandler(["whois","version","about","whoami","mapid","cellid","time"],new InfoInstructionHandler());
         param1.addHandler(["aping","ping"],new LatencyInstructionHandler());
         param1.addHandler(["f","ignore","invite"],new SocialInstructionHandler());
         param1.addHandler(["w","whisper","msg","t","g","p","a","r","b","m"],new MessagingInstructionHandler());
         param1.addHandler(["s","spectator","list","players","kick"],new FightInstructionHandler());
         param1.addHandler(_loc3_,new EmoteInstructionHandler());
         param1.addHandler(["tab","clear"],new OptionsInstructionHandler());
         param1.addHandler(["fps"],new UiHandlerInstructionHandler());
         if(BuildInfos.BUILD_TYPE != BuildTypeEnum.RELEASE)
         {
            param1.addHandler(["savereplaylog","sd","shieldmax","shieldmed","shieldmin"],new MiscInstructionHandler());
         }
         else
         {
            param1.addHandler(["savereplaylog","shieldmax","shieldmed","shieldmin"],new MiscInstructionHandler());
         }
         param1.addHandler(["away",I18n.getUiText("ui.chat.status.away").toLocaleLowerCase(),I18n.getUiText("ui.chat.status.solo").toLocaleLowerCase(),I18n.getUiText("ui.chat.status.private").toLocaleLowerCase(),I18n.getUiText("ui.chat.status.availiable").toLocaleLowerCase(),"release"],new StatusInstructionHandler());
      }
   }
}
