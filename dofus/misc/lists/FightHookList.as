package com.ankamagames.dofus.misc.lists
{
   import com.ankamagames.berilia.types.data.Hook;
   
   public class FightHookList
   {
      
      public static const BuffUpdate:Hook = new Hook("BuffUpdate",false);
      
      public static const BuffRemove:Hook = new Hook("BuffRemove",false);
      
      public static const BuffDispell:Hook = new Hook("BuffDispell",false);
      
      public static const BuffAdd:Hook = new Hook("BuffAdd",false);
      
      public static const FighterSelected:Hook = new Hook("FighterSelected",false);
      
      public static const ChallengeInfoUpdate:Hook = new Hook("ChallengeInfoUpdate",false);
      
      public static const RemindTurn:Hook = new Hook("RemindTurn",false);
      
      public static const SpectatorWantLeave:Hook = new Hook("SpectatorWantLeave",false);
      
      public static const FightResultClosed:Hook = new Hook("FightResultClosed",false);
      
      public static const GameEntityDisposition:Hook = new Hook("GameEntityDisposition",false);
      
      public static const FighterInfoUpdate:Hook = new Hook("FighterInfoUpdate",false);
      
      public static const ReadyToFight:Hook = new Hook("ReadyToFight",false);
      
      public static const NotReadyToFight:Hook = new Hook("NotReadyToFight",false);
      
      public static const DematerializationChanged:Hook = new Hook("DematerializationChanged",false);
      
      public static const AfkModeChanged:Hook = new Hook("AfkModeChanged",false);
      
      public static const TurnCountUpdated:Hook = new Hook("TurnCountUpdated",false);
      
      public static const UpdatePreFightersList:Hook = new Hook("UpdatePreFightersList",false);
      
      public static const SlaveStatsList:Hook = new Hook("SlaveStatsList",false);
      
      public static const ShowMonsterArtwork:Hook = new Hook("ShowMonsterArtwork",false);
      
      public static const WaveUpdated:Hook = new Hook("WaveUpdated",false);
      
      public static const SpectateUpdate:Hook = new Hook("SpectateUpdate",false);
      
      public static const ShowSwapPositionRequestMenu:Hook = new Hook("ShowSwapPositionRequestMenu",false);
      
      public static const IdolFightPreparationUpdate:Hook = new Hook("IdolFightPreparationUpdate",false);
      
      public static const FightIdolList:Hook = new Hook("FightIdolList",false);
       
      
      public function FightHookList()
      {
         super();
      }
   }
}
