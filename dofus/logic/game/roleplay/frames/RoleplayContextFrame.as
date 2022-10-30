package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.data.DefaultMap;
   import com.ankamagames.atouin.data.map.Map;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.atouin.messages.MapLoadedMessage;
   import com.ankamagames.atouin.messages.MapLoadingFailedMessage;
   import com.ankamagames.atouin.messages.MapsLoadingCompleteMessage;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.datacenter.documents.Comic;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.npcs.Npc;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorFirstname;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorName;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.world.Area;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.externalnotification.ExternalNotificationManager;
   import com.ankamagames.dofus.externalnotification.enums.ExternalNotificationTypeEnum;
   import com.ankamagames.dofus.internalDatacenter.communication.CraftSmileyItem;
   import com.ankamagames.dofus.internalDatacenter.guild.PaddockWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.world.WorldPointWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.kernel.net.DisconnectionReasonEnum;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.logic.common.actions.ChangeWorldInteractionAction;
   import com.ankamagames.dofus.logic.common.actions.ResetGameAction;
   import com.ankamagames.dofus.logic.game.approach.managers.PartManager;
   import com.ankamagames.dofus.logic.game.common.actions.InteractiveElementActivationAction;
   import com.ankamagames.dofus.logic.game.common.actions.PivotCharacterAction;
   import com.ankamagames.dofus.logic.game.common.actions.bid.LeaveBidHouseAction;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangePlayerMultiCraftRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangePlayerRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeRequestOnTaxCollectorAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeBuyAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeOnHumanVendorRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeRequestOnShopStockAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeSellAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeShopStockMouvmentAddAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeShopStockMouvmentRemoveAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeShowVendorTaxAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeStartAsVendorRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.LeaveShopStockAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.LeaveExchangeMountAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.treasureHunt.PortalUseRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.roleplay.GameRolePlayFreeSoulRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.taxCollector.GameRolePlayTaxCollectorFightRequestAction;
   import com.ankamagames.dofus.logic.game.common.frames.AllianceFrame;
   import com.ankamagames.dofus.logic.game.common.frames.BidHouseManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.ChatFrame;
   import com.ankamagames.dofus.logic.game.common.frames.CommonExchangeManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.CraftFrame;
   import com.ankamagames.dofus.logic.game.common.frames.EmoticonFrame;
   import com.ankamagames.dofus.logic.game.common.frames.ExchangeManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.HumanVendorManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.SocialFrame;
   import com.ankamagames.dofus.logic.game.common.frames.SpectatorManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.SpellForgetDialogFrame;
   import com.ankamagames.dofus.logic.game.common.frames.StackManagementFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.SpeakingItemManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.managers.TacticModeManager;
   import com.ankamagames.dofus.logic.game.roleplay.actions.DisplayContextualMenuAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.NpcGenericActionRequestAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.PlayerFightFriendlyAnswerAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.PlayerFightRequestAction;
   import com.ankamagames.dofus.logic.game.roleplay.managers.RoleplayManager;
   import com.ankamagames.dofus.logic.game.roleplay.messages.InteractiveElementActivationMessage;
   import com.ankamagames.dofus.logic.game.roleplay.types.RoleplaySpellCastProvider;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.CraftHookList;
   import com.ankamagames.dofus.misc.lists.ExchangeHookList;
   import com.ankamagames.dofus.misc.lists.ExternalGameHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.lists.MountHookList;
   import com.ankamagames.dofus.misc.lists.RoleplayHookList;
   import com.ankamagames.dofus.misc.lists.SocialHookList;
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.CraftResultEnum;
   import com.ankamagames.dofus.network.enums.DelayedActionTypeEnum;
   import com.ankamagames.dofus.network.enums.ExchangeErrorEnum;
   import com.ankamagames.dofus.network.enums.ExchangeTypeEnum;
   import com.ankamagames.dofus.network.enums.FighterRefusedReasonEnum;
   import com.ankamagames.dofus.network.enums.GameContextEnum;
   import com.ankamagames.dofus.network.enums.UpdatableMountBoostEnum;
   import com.ankamagames.dofus.network.messages.game.context.GameContextDestroyMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameMapChangeOrientationRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.display.DisplayNumericalValuePaddockMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.CurrentMapMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.ErrorMapNotFoundMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.death.GameRolePlayFreeSoulRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.delay.GameRolePlayDelayedActionMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.document.ComicReadingBeginMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.document.DocumentReadingBeginMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayAggressionMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayFightRequestCanceledMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayPlayerFightFriendlyAnswerMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayPlayerFightFriendlyAnsweredMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayPlayerFightFriendlyRequestedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayPlayerFightRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobAllowMultiCraftRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobMultiCraftAvailableSkillsMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.NpcDialogCreationMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.NpcGenericActionFailureMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.NpcGenericActionRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.paddock.PaddockPropertiesMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.paddock.PaddockSellBuyDialogMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.spell.SpellForgetUIMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.spell.SpellForgottenMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.PortalUseRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.visual.GameRolePlaySpellAnimMessage;
   import com.ankamagames.dofus.network.messages.game.dialog.LeaveDialogRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.ChallengeFightJoinRefusedMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GameRolePlayTaxCollectorFightRequestMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.zaap.TeleportDestinationsListMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.zaap.ZaapListMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBuyMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBuyOkMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeCraftInformationObjectMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeCraftResultMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeErrorMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectMoveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectMovePricedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeOkMultiCraftMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeOnHumanVendorRequestMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangePlayerMultiCraftRequestMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangePlayerRequestMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeReplyTaxVendorMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeRequestOnShopStockMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeRequestOnTaxCollectorMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeRequestedTradeMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeSellMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeSellOkMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeShopStockStartedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeShowVendorTaxMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartAsVendorMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkCraftWithInformationMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkHumanVendorMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkNpcShopMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkNpcTradeMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkRunesTradeMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedBidBuyerMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedBidSellerMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedMountStockMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectFoundWhileRecoltingMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObtainedItemMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObtainedItemWithBonusMessage;
   import com.ankamagames.dofus.network.messages.server.basic.SystemMessageDisplayMessage;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.GameRolePlayTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMutantInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNamedActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPortalInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPrismInformations;
   import com.ankamagames.dofus.network.types.game.prism.AlliancePrismInformation;
   import com.ankamagames.dofus.scripts.SpellScriptManager;
   import com.ankamagames.dofus.types.characteristicContextual.CharacteristicContextualManager;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.network.messages.ExpectedSocketClosureMessage;
   import com.ankamagames.jerakine.sequencer.ISequencable;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   import com.ankamagames.jerakine.utils.display.AngleToOrientation;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.ankamagames.tiphon.types.TiphonUtility;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.hurlant.util.Hex;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.text.TextFormat;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   
   public class RoleplayContextFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(RoleplayContextFrame));
      
      private static const ASTRUB_SUBAREA_IDS:Array = [143,92,95,96,97,98,99,100,101,173,318,306];
      
      private static const MOUNT_BOOSTS_ICONS_PATH:String = XmlConfig.getInstance().getEntry("config.content.path") + "gfx/characteristics/mount.swf|";
      
      private static var currentStatus:int = -1;
       
      
      private var _priority:int = 0;
      
      private var _entitiesFrame:RoleplayEntitiesFrame;
      
      private var _worldFrame:RoleplayWorldFrame;
      
      private var _interactivesFrame:RoleplayInteractivesFrame;
      
      private var _npcDialogFrame:NpcDialogFrame;
      
      private var _documentFrame:DocumentFrame;
      
      private var _zaapFrame:ZaapFrame;
      
      private var _paddockFrame:PaddockFrame;
      
      private var _emoticonFrame:EmoticonFrame;
      
      private var _exchangeManagementFrame:ExchangeManagementFrame;
      
      private var _humanVendorManagementFrame:HumanVendorManagementFrame;
      
      private var _spectatorManagementFrame:SpectatorManagementFrame;
      
      private var _bidHouseManagementFrame:BidHouseManagementFrame;
      
      private var _estateFrame:EstateFrame;
      
      private var _allianceFrame:AllianceFrame;
      
      private var _craftFrame:CraftFrame;
      
      private var _commonExchangeFrame:CommonExchangeManagementFrame;
      
      private var _movementFrame:RoleplayMovementFrame;
      
      private var _spellForgetDialogFrame:SpellForgetDialogFrame;
      
      private var _delayedActionFrame:DelayedActionFrame;
      
      private var _currentWaitingFightId:uint;
      
      private var _crafterId:uint;
      
      private var _customerID:uint;
      
      private var _playersMultiCraftSkill:Array;
      
      private var _currentPaddock:PaddockWrapper;
      
      private var _playerEntity:AnimatedCharacter;
      
      private var _interactionIsLimited:Boolean = false;
      
      private var _obtainedItemMsg:ObtainedItemMessage;
      
      private var _itemIcon:Texture;
      
      private var _itemBonusIcon:Texture;
      
      private var _obtainedItemTextFormat:TextFormat;
      
      private var _obtainedItemBonusTextFormat:TextFormat;
      
      private var _mountBoosTextFormat:TextFormat;
      
      public function RoleplayContextFrame()
      {
         super();
      }
      
      public function get crafterId() : uint
      {
         return this._crafterId;
      }
      
      public function get customerID() : uint
      {
         return this._customerID;
      }
      
      public function get priority() : int
      {
         return this._priority;
      }
      
      public function set priority(param1:int) : void
      {
         this._priority = param1;
      }
      
      public function get entitiesFrame() : RoleplayEntitiesFrame
      {
         return this._entitiesFrame;
      }
      
      private function get socialFrame() : SocialFrame
      {
         return Kernel.getWorker().getFrame(SocialFrame) as SocialFrame;
      }
      
      public function get hasWorldInteraction() : Boolean
      {
         return !this._interactionIsLimited;
      }
      
      public function get commonExchangeFrame() : CommonExchangeManagementFrame
      {
         return this._commonExchangeFrame;
      }
      
      public function get hasGuildedPaddock() : Boolean
      {
         return this._currentPaddock && this._currentPaddock.guildIdentity;
      }
      
      public function get currentPaddock() : PaddockWrapper
      {
         return this._currentPaddock;
      }
      
      public function pushed() : Boolean
      {
         this._entitiesFrame = new RoleplayEntitiesFrame();
         this._delayedActionFrame = new DelayedActionFrame();
         this._movementFrame = new RoleplayMovementFrame();
         this._worldFrame = new RoleplayWorldFrame();
         this._interactivesFrame = new RoleplayInteractivesFrame();
         Kernel.getWorker().addFrame(this._delayedActionFrame);
         this._npcDialogFrame = new NpcDialogFrame();
         this._documentFrame = new DocumentFrame();
         this._zaapFrame = new ZaapFrame();
         this._paddockFrame = new PaddockFrame();
         this._exchangeManagementFrame = new ExchangeManagementFrame();
         this._spectatorManagementFrame = new SpectatorManagementFrame();
         this._bidHouseManagementFrame = new BidHouseManagementFrame();
         this._estateFrame = new EstateFrame();
         this._craftFrame = new CraftFrame();
         this._humanVendorManagementFrame = new HumanVendorManagementFrame();
         this._spellForgetDialogFrame = new SpellForgetDialogFrame();
         Kernel.getWorker().addFrame(this._spectatorManagementFrame);
         if(!Kernel.getWorker().contains(EstateFrame))
         {
            Kernel.getWorker().addFrame(this._estateFrame);
         }
         this._allianceFrame = Kernel.getWorker().getFrame(AllianceFrame) as AllianceFrame;
         this._allianceFrame.pushRoleplay();
         if(!Kernel.getWorker().contains(EmoticonFrame))
         {
            this._emoticonFrame = new EmoticonFrame();
            Kernel.getWorker().addFrame(this._emoticonFrame);
         }
         else
         {
            this._emoticonFrame = Kernel.getWorker().getFrame(EmoticonFrame) as EmoticonFrame;
         }
         this._playersMultiCraftSkill = new Array();
         this._obtainedItemTextFormat = new TextFormat("Verdana",24,7615756,true);
         this._obtainedItemBonusTextFormat = new TextFormat("Verdana",24,16733440,true);
         this._itemIcon = new Texture();
         this._itemBonusIcon = new Texture();
         var _loc1_:GlowFilter = new GlowFilter(0,1,2,2,2,1);
         this._itemIcon.filters = [_loc1_];
         this._itemBonusIcon.filters = [_loc1_];
         this._mountBoosTextFormat = new TextFormat("Verdana",24,7615756,true);
         var _loc2_:StackManagementFrame = Kernel.getWorker().getFrame(StackManagementFrame) as StackManagementFrame;
         _loc2_.paused = false;
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:CurrentMapMessage = null;
         var _loc3_:SubArea = null;
         var _loc4_:WorldPointWrapper = null;
         var _loc5_:ByteArray = null;
         var _loc6_:Object = null;
         var _loc7_:MapPosition = null;
         var _loc8_:MapsLoadingCompleteMessage = null;
         var _loc9_:ChangeWorldInteractionAction = null;
         var _loc10_:Boolean = false;
         var _loc11_:StackManagementFrame = null;
         var _loc12_:NpcGenericActionRequestAction = null;
         var _loc13_:IEntity = null;
         var _loc14_:NpcGenericActionRequestMessage = null;
         var _loc15_:ExchangeRequestOnTaxCollectorAction = null;
         var _loc16_:ExchangeRequestOnTaxCollectorMessage = null;
         var _loc17_:IEntity = null;
         var _loc18_:GameRolePlayTaxCollectorFightRequestAction = null;
         var _loc19_:GameRolePlayTaxCollectorFightRequestMessage = null;
         var _loc20_:InteractiveElementActivationAction = null;
         var _loc21_:InteractiveElementActivationMessage = null;
         var _loc22_:DisplayContextualMenuAction = null;
         var _loc23_:GameContextActorInformations = null;
         var _loc24_:RoleplayInteractivesFrame = null;
         var _loc25_:NpcDialogCreationMessage = null;
         var _loc26_:Object = null;
         var _loc27_:PortalUseRequestAction = null;
         var _loc28_:PortalUseRequestMessage = null;
         var _loc29_:ExchangeShowVendorTaxMessage = null;
         var _loc30_:ExchangeReplyTaxVendorMessage = null;
         var _loc31_:ExchangeOnHumanVendorRequestAction = null;
         var _loc32_:ExchangeRequestOnShopStockMessage = null;
         var _loc33_:ExchangeOnHumanVendorRequestAction = null;
         var _loc34_:IEntity = null;
         var _loc35_:ExchangeOnHumanVendorRequestMessage = null;
         var _loc36_:ExchangeStartOkHumanVendorMessage = null;
         var _loc37_:ExchangeShopStockStartedMessage = null;
         var _loc38_:IEntity = null;
         var _loc39_:ExchangeStartAsVendorMessage = null;
         var _loc40_:ExpectedSocketClosureMessage = null;
         var _loc41_:ExchangeStartedMountStockMessage = null;
         var _loc42_:ExchangeStartOkNpcShopMessage = null;
         var _loc43_:ExchangeStartedMessage = null;
         var _loc44_:CommonExchangeManagementFrame = null;
         var _loc45_:ObjectFoundWhileRecoltingMessage = null;
         var _loc46_:Item = null;
         var _loc47_:uint = 0;
         var _loc48_:CraftSmileyItem = null;
         var _loc49_:uint = 0;
         var _loc50_:String = null;
         var _loc51_:String = null;
         var _loc52_:String = null;
         var _loc53_:ObtainedItemMessage = null;
         var _loc54_:RoleplayInteractivesFrame = null;
         var _loc55_:AnimatedCharacter = null;
         var _loc56_:Timer = null;
         var _loc57_:PlayerFightRequestAction = null;
         var _loc58_:GameRolePlayPlayerFightRequestMessage = null;
         var _loc59_:IEntity = null;
         var _loc60_:PlayerFightFriendlyAnswerAction = null;
         var _loc61_:GameRolePlayPlayerFightFriendlyAnswerMessage = null;
         var _loc62_:GameRolePlayPlayerFightFriendlyAnsweredMessage = null;
         var _loc63_:GameRolePlayFightRequestCanceledMessage = null;
         var _loc64_:GameRolePlayPlayerFightFriendlyRequestedMessage = null;
         var _loc65_:GameRolePlayFreeSoulRequestMessage = null;
         var _loc66_:LeaveDialogRequestMessage = null;
         var _loc67_:ExchangeErrorMessage = null;
         var _loc68_:String = null;
         var _loc69_:uint = 0;
         var _loc70_:GameRolePlayAggressionMessage = null;
         var _loc71_:LeaveDialogRequestMessage = null;
         var _loc72_:ExchangeShopStockMouvmentAddAction = null;
         var _loc73_:ExchangeObjectMovePricedMessage = null;
         var _loc74_:ExchangeShopStockMouvmentRemoveAction = null;
         var _loc75_:ExchangeObjectMoveMessage = null;
         var _loc76_:ExchangeBuyAction = null;
         var _loc77_:ExchangeBuyMessage = null;
         var _loc78_:ExchangeSellAction = null;
         var _loc79_:ExchangeSellMessage = null;
         var _loc80_:ExchangeBuyOkMessage = null;
         var _loc81_:ExchangeSellOkMessage = null;
         var _loc82_:ExchangePlayerRequestAction = null;
         var _loc83_:ExchangePlayerRequestMessage = null;
         var _loc84_:ExchangePlayerMultiCraftRequestAction = null;
         var _loc85_:ExchangePlayerMultiCraftRequestMessage = null;
         var _loc86_:JobAllowMultiCraftRequestMessage = null;
         var _loc87_:uint = 0;
         var _loc88_:SpellForgetUIMessage = null;
         var _loc89_:ChallengeFightJoinRefusedMessage = null;
         var _loc90_:SpellForgottenMessage = null;
         var _loc91_:ExchangeCraftResultMessage = null;
         var _loc92_:uint = 0;
         var _loc93_:ExchangeCraftInformationObjectMessage = null;
         var _loc94_:CraftSmileyItem = null;
         var _loc95_:GameRolePlayDelayedActionMessage = null;
         var _loc96_:DocumentReadingBeginMessage = null;
         var _loc97_:ComicReadingBeginMessage = null;
         var _loc98_:Comic = null;
         var _loc99_:PaddockSellBuyDialogMessage = null;
         var _loc100_:LeaveDialogRequestMessage = null;
         var _loc101_:DisplayNumericalValuePaddockMessage = null;
         var _loc102_:IEntity = null;
         var _loc103_:GameRolePlaySpellAnimMessage = null;
         var _loc104_:RoleplaySpellCastProvider = null;
         var _loc105_:int = 0;
         var _loc106_:String = null;
         var _loc107_:Object = null;
         var _loc108_:ErrorMapNotFoundMessage = null;
         var _loc109_:int = 0;
         var _loc110_:int = 0;
         var _loc111_:int = 0;
         var _loc112_:Map = null;
         var _loc113_:Boolean = false;
         var _loc114_:GameRolePlayNpcInformations = null;
         var _loc115_:TiphonEntityLook = null;
         var _loc116_:GameRolePlayTaxCollectorInformations = null;
         var _loc117_:GameRolePlayPrismInformations = null;
         var _loc118_:String = null;
         var _loc119_:GameRolePlayPortalInformations = null;
         var _loc120_:Area = null;
         var _loc121_:String = null;
         var _loc122_:LeaveDialogRequestMessage = null;
         var _loc123_:IRectangle = null;
         var _loc124_:uint = 0;
         var _loc125_:GameRolePlayCharacterInformations = null;
         var _loc126_:int = 0;
         var _loc127_:int = 0;
         var _loc128_:RoleplayContextFrame = null;
         var _loc129_:GameRolePlayActorInformations = null;
         var _loc130_:String = null;
         var _loc131_:GameContextActorInformations = null;
         var _loc132_:JobMultiCraftAvailableSkillsMessage = null;
         var _loc133_:MultiCraftEnableForPlayer = null;
         var _loc134_:Boolean = false;
         var _loc135_:MultiCraftEnableForPlayer = null;
         var _loc136_:uint = 0;
         var _loc137_:int = 0;
         var _loc138_:Item = null;
         var _loc139_:uint = 0;
         var _loc140_:IRectangle = null;
         var _loc141_:CraftSmileyItem = null;
         var _loc142_:uint = 0;
         var _loc143_:IRectangle = null;
         var _loc144_:Texture = null;
         var _loc145_:Uri = null;
         switch(true)
         {
            case param1 is CurrentMapMessage:
               _loc2_ = param1 as CurrentMapMessage;
               _loc3_ = SubArea.getSubAreaByMapId(_loc2_.mapId);
               PlayedCharacterManager.getInstance().currentSubArea = _loc3_;
               Kernel.getWorker().pause(null,[SystemMessageDisplayMessage]);
               ConnectionsHandler.pause();
               if(TacticModeManager.getInstance().tacticModeActivated)
               {
                  TacticModeManager.getInstance().hide();
               }
               KernelEventsManager.getInstance().processCallback(HookList.StartZoom,false);
               Atouin.getInstance().initPreDisplay(_loc4_);
               if(this._entitiesFrame && Kernel.getWorker().contains(RoleplayEntitiesFrame))
               {
                  Kernel.getWorker().removeFrame(this._entitiesFrame);
               }
               if(this._worldFrame && Kernel.getWorker().contains(RoleplayWorldFrame))
               {
                  Kernel.getWorker().removeFrame(this._worldFrame);
               }
               if(this._interactivesFrame && Kernel.getWorker().contains(RoleplayInteractivesFrame))
               {
                  Kernel.getWorker().removeFrame(this._interactivesFrame);
               }
               if(this._movementFrame && Kernel.getWorker().contains(RoleplayMovementFrame))
               {
                  Kernel.getWorker().removeFrame(this._movementFrame);
               }
               if(PlayedCharacterManager.getInstance().isInHouse)
               {
                  _loc4_ = new WorldPointWrapper(_loc2_.mapId,true,PlayedCharacterManager.getInstance().currentMap.outdoorX,PlayedCharacterManager.getInstance().currentMap.outdoorY);
               }
               else
               {
                  _loc4_ = new WorldPointWrapper(_loc2_.mapId);
               }
               PlayedCharacterManager.getInstance().currentMap = _loc4_;
               Atouin.getInstance().clearEntities();
               KernelEventsManager.getInstance().processCallback(HookList.MapFightCount,0);
               if(_loc2_.mapKey && _loc2_.mapKey.length)
               {
                  if(!(_loc106_ = XmlConfig.getInstance().getEntry("config.maps.encryptionKey")))
                  {
                     _loc106_ = _loc2_.mapKey;
                  }
                  _loc5_ = Hex.toArray(Hex.fromString(_loc106_));
               }
               Atouin.getInstance().display(_loc4_,_loc5_);
               TooltipManager.hideAll();
               (_loc6_ = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass).closeAllMenu();
               this._currentPaddock = null;
               if((_loc7_ = MapPosition.getMapPositionById(_loc2_.mapId)) && ASTRUB_SUBAREA_IDS.indexOf(_loc7_.subAreaId) != -1)
               {
                  PartManager.getInstance().checkAndDownload("all");
               }
               KernelEventsManager.getInstance().processCallback(HookList.CurrentMap,_loc2_.mapId);
               return true;
            case param1 is MapsLoadingCompleteMessage:
               _loc8_ = param1 as MapsLoadingCompleteMessage;
               if(!Kernel.getWorker().contains(RoleplayEntitiesFrame))
               {
                  Kernel.getWorker().addFrame(this._entitiesFrame);
               }
               TooltipManager.hideAll();
               KernelEventsManager.getInstance().processCallback(HookList.MapsLoadingComplete,_loc8_.mapPoint);
               if(!Kernel.getWorker().contains(RoleplayWorldFrame))
               {
                  Kernel.getWorker().addFrame(this._worldFrame);
               }
               if(!Kernel.getWorker().contains(RoleplayInteractivesFrame))
               {
                  Kernel.getWorker().addFrame(this._interactivesFrame);
               }
               if(!Kernel.getWorker().contains(RoleplayMovementFrame))
               {
                  Kernel.getWorker().addFrame(this._movementFrame);
               }
               SoundManager.getInstance().manager.setSubArea(_loc8_.mapData);
               Atouin.getInstance().updateCursor();
               Kernel.getWorker().resume();
               Kernel.getWorker().clearUnstoppableMsgClassList();
               ConnectionsHandler.resume();
               return true;
            case param1 is MapLoadingFailedMessage:
               switch(MapLoadingFailedMessage(param1).errorReason)
               {
                  case MapLoadingFailedMessage.NO_FILE:
                     (_loc107_ = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass).openPopup(I18n.getUiText("ui.popup.information"),I18n.getUiText("ui.popup.noMapdataFile"),[I18n.getUiText("ui.common.ok")]);
                     (_loc108_ = new ErrorMapNotFoundMessage()).initErrorMapNotFoundMessage(MapLoadingFailedMessage(param1).id);
                     ConnectionsHandler.getConnection().send(_loc108_);
                     MapDisplayManager.getInstance().fromMap(new DefaultMap(MapLoadingFailedMessage(param1).id));
                     return true;
                  default:
                     return false;
               }
               break;
            case param1 is MapLoadedMessage:
               if(MapDisplayManager.getInstance().isDefaultMap)
               {
                  _loc109_ = PlayedCharacterManager.getInstance().currentMap.x;
                  _loc110_ = PlayedCharacterManager.getInstance().currentMap.y;
                  _loc111_ = PlayedCharacterManager.getInstance().currentMap.worldId;
                  (_loc112_ = MapDisplayManager.getInstance().getDataMapContainer().dataMap).rightNeighbourId = WorldPoint.fromCoords(_loc111_,_loc109_ + 1,_loc110_).mapId;
                  _loc112_.leftNeighbourId = WorldPoint.fromCoords(_loc111_,_loc109_ - 1,_loc110_).mapId;
                  _loc112_.bottomNeighbourId = WorldPoint.fromCoords(_loc111_,_loc109_,_loc110_ + 1).mapId;
                  _loc112_.topNeighbourId = WorldPoint.fromCoords(_loc111_,_loc109_,_loc110_ - 1).mapId;
               }
               return true;
            case param1 is ChangeWorldInteractionAction:
               _loc9_ = param1 as ChangeWorldInteractionAction;
               _loc10_ = false;
               if(Kernel.getWorker().contains(BidHouseManagementFrame) && this._bidHouseManagementFrame.switching)
               {
                  _loc10_ = true;
               }
               this._interactionIsLimited = !_loc9_.enabled;
               switch(_loc9_.total)
               {
                  case true:
                     if(_loc9_.enabled)
                     {
                        if(!Kernel.getWorker().contains(RoleplayWorldFrame) && !_loc10_ && SystemApi.wordInteractionEnable)
                        {
                           _log.info("Enabling interaction with the roleplay world.");
                           Kernel.getWorker().addFrame(this._worldFrame);
                        }
                        this._worldFrame.cellClickEnabled = true;
                        this._worldFrame.allowOnlyCharacterInteraction = false;
                        this._worldFrame.pivotingCharacter = false;
                     }
                     else if(Kernel.getWorker().contains(RoleplayWorldFrame))
                     {
                        _log.info("Disabling interaction with the roleplay world.");
                        Kernel.getWorker().removeFrame(this._worldFrame);
                     }
                     break;
                  case false:
                     if(_loc9_.enabled)
                     {
                        if(!Kernel.getWorker().contains(RoleplayWorldFrame) && !_loc10_)
                        {
                           _log.info("Enabling total interaction with the roleplay world.");
                           Kernel.getWorker().addFrame(this._worldFrame);
                           this._worldFrame.cellClickEnabled = true;
                           this._worldFrame.allowOnlyCharacterInteraction = false;
                           this._worldFrame.pivotingCharacter = false;
                        }
                        if(!Kernel.getWorker().contains(RoleplayInteractivesFrame))
                        {
                           Kernel.getWorker().addFrame(this._interactivesFrame);
                        }
                     }
                     else if(Kernel.getWorker().contains(RoleplayWorldFrame))
                     {
                        _log.info("Disabling partial interactions with the roleplay world.");
                        this._worldFrame.allowOnlyCharacterInteraction = true;
                     }
               }
               _loc11_ = Kernel.getWorker().getFrame(StackManagementFrame) as StackManagementFrame;
               if(!(!this._interactionIsLimited && !SystemApi.wordInteractionEnable))
               {
                  _loc11_.paused = this._interactionIsLimited;
               }
               if(!_loc11_.paused && _loc11_.waitingMessage)
               {
                  this._worldFrame.process(_loc11_.waitingMessage);
                  _loc11_.waitingMessage = null;
               }
               return true;
            case param1 is NpcGenericActionRequestAction:
               _loc12_ = param1 as NpcGenericActionRequestAction;
               _loc13_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
               (_loc14_ = new NpcGenericActionRequestMessage()).initNpcGenericActionRequestMessage(_loc12_.npcId,_loc12_.actionId,PlayedCharacterManager.getInstance().currentMap.mapId);
               if((_loc13_ as IMovable).isMoving)
               {
                  (_loc13_ as IMovable).stop();
                  this._movementFrame.setFollowingMessage(_loc14_);
               }
               else
               {
                  ConnectionsHandler.getConnection().send(_loc14_);
               }
               return true;
            case param1 is ExchangeRequestOnTaxCollectorAction:
               _loc15_ = param1 as ExchangeRequestOnTaxCollectorAction;
               (_loc16_ = new ExchangeRequestOnTaxCollectorMessage()).initExchangeRequestOnTaxCollectorMessage(_loc15_.taxCollectorId);
               if(((_loc17_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id)) as IMovable).isMoving)
               {
                  this._movementFrame.setFollowingMessage(_loc16_);
                  (_loc17_ as IMovable).stop();
               }
               else
               {
                  ConnectionsHandler.getConnection().send(_loc16_);
               }
               return true;
            case param1 is GameRolePlayTaxCollectorFightRequestAction:
               _loc18_ = param1 as GameRolePlayTaxCollectorFightRequestAction;
               (_loc19_ = new GameRolePlayTaxCollectorFightRequestMessage()).initGameRolePlayTaxCollectorFightRequestMessage(_loc18_.taxCollectorId);
               ConnectionsHandler.getConnection().send(_loc19_);
               return true;
            case param1 is InteractiveElementActivationAction:
               _loc20_ = param1 as InteractiveElementActivationAction;
               _loc21_ = new InteractiveElementActivationMessage(_loc20_.interactiveElement,_loc20_.position,_loc20_.skillInstanceId);
               Kernel.getWorker().process(_loc21_);
               return true;
            case param1 is DisplayContextualMenuAction:
               _loc22_ = param1 as DisplayContextualMenuAction;
               if(_loc23_ = this.entitiesFrame.getEntityInfos(_loc22_.playerId))
               {
                  _loc113_ = RoleplayManager.getInstance().displayCharacterContextualMenu(_loc23_);
               }
               return false;
            case param1 is PivotCharacterAction:
               if((_loc24_ = Kernel.getWorker().getFrame(RoleplayInteractivesFrame) as RoleplayInteractivesFrame) && !_loc24_.usingInteractive)
               {
                  Kernel.getWorker().process(ChangeWorldInteractionAction.create(false));
                  this._worldFrame.pivotingCharacter = true;
                  this._playerEntity = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as AnimatedCharacter;
                  StageShareManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onListenOrientation);
                  StageShareManager.stage.addEventListener(MouseEvent.CLICK,this.onClickOrientation);
               }
               return true;
            case param1 is NpcGenericActionFailureMessage:
               KernelEventsManager.getInstance().processCallback(RoleplayHookList.NpcDialogCreationFailure);
               return true;
            case param1 is NpcDialogCreationMessage:
               _loc25_ = param1 as NpcDialogCreationMessage;
               _loc26_ = this._entitiesFrame.getEntityInfos(_loc25_.npcId);
               if(!Kernel.getWorker().contains(NpcDialogFrame))
               {
                  Kernel.getWorker().addFrame(this._npcDialogFrame);
               }
               Kernel.getWorker().process(ChangeWorldInteractionAction.create(false));
               TooltipManager.hideAll();
               if(_loc26_ is GameRolePlayNpcInformations)
               {
                  _loc114_ = _loc26_ as GameRolePlayNpcInformations;
                  _loc115_ = EntityLookAdapter.fromNetwork(_loc114_.look);
                  _loc115_ = TiphonUtility.getLookWithoutMount(_loc115_);
                  KernelEventsManager.getInstance().processCallback(RoleplayHookList.NpcDialogCreation,_loc25_.mapId,_loc114_.npcId,_loc115_);
               }
               else if(_loc26_ is GameRolePlayTaxCollectorInformations)
               {
                  _loc116_ = _loc26_ as GameRolePlayTaxCollectorInformations;
                  KernelEventsManager.getInstance().processCallback(RoleplayHookList.PonyDialogCreation,_loc25_.mapId,_loc116_.identification.firstNameId,_loc116_.identification.lastNameId,EntityLookAdapter.fromNetwork(_loc116_.look));
               }
               else if(_loc26_ is GameRolePlayPrismInformations)
               {
                  if((_loc117_ = _loc26_ as GameRolePlayPrismInformations).prism is AlliancePrismInformation)
                  {
                     if((_loc118_ = (_loc117_.prism as AlliancePrismInformation).alliance.allianceName) == "#NONAME#")
                     {
                        _loc118_ = I18n.getUiText("ui.guild.noName");
                     }
                  }
                  else if(AllianceFrame.getInstance().hasAlliance)
                  {
                     _loc118_ = AllianceFrame.getInstance().alliance.allianceName;
                  }
                  KernelEventsManager.getInstance().processCallback(RoleplayHookList.PrismDialogCreation,_loc25_.mapId,_loc118_,EntityLookAdapter.fromNetwork(_loc117_.look));
               }
               else if(_loc26_ is GameRolePlayPortalInformations)
               {
                  _loc119_ = _loc26_ as GameRolePlayPortalInformations;
                  if(!(_loc120_ = Area.getAreaById(_loc119_.portal.areaId)))
                  {
                     return true;
                  }
                  _loc121_ = _loc120_.name;
                  KernelEventsManager.getInstance().processCallback(RoleplayHookList.PortalDialogCreation,_loc25_.mapId,_loc121_,EntityLookAdapter.fromNetwork(_loc119_.look));
               }
               else
               {
                  _loc122_ = new LeaveDialogRequestMessage();
                  ConnectionsHandler.getConnection().send(_loc122_);
                  Kernel.getWorker().process(ChangeWorldInteractionAction.create(true));
               }
               return true;
            case param1 is PortalUseRequestAction:
               _loc27_ = param1 as PortalUseRequestAction;
               (_loc28_ = new PortalUseRequestMessage()).initPortalUseRequestMessage(_loc27_.portalId);
               ConnectionsHandler.getConnection().send(_loc28_);
               return true;
            case param1 is GameContextDestroyMessage:
               TooltipManager.hide();
               Kernel.getWorker().removeFrame(this);
               return true;
            case param1 is ExchangeStartedBidBuyerMessage:
               if(!Kernel.getWorker().contains(BidHouseManagementFrame))
               {
                  KernelEventsManager.getInstance().processCallback(HookList.CloseInventory);
               }
               this.addCommonExchangeFrame(ExchangeTypeEnum.BIDHOUSE_BUY);
               if(!Kernel.getWorker().contains(BidHouseManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._bidHouseManagementFrame);
               }
               this._bidHouseManagementFrame.processExchangeStartedBidBuyerMessage(param1 as ExchangeStartedBidBuyerMessage);
               return true;
            case param1 is ExchangeStartedBidSellerMessage:
               if(!Kernel.getWorker().contains(BidHouseManagementFrame))
               {
                  KernelEventsManager.getInstance().processCallback(HookList.CloseInventory);
               }
               this.addCommonExchangeFrame(ExchangeTypeEnum.BIDHOUSE_SELL);
               if(!Kernel.getWorker().contains(BidHouseManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._bidHouseManagementFrame);
               }
               this._bidHouseManagementFrame.processExchangeStartedBidSellerMessage(param1 as ExchangeStartedBidSellerMessage);
               return true;
            case param1 is ExchangeShowVendorTaxAction:
               (_loc29_ = new ExchangeShowVendorTaxMessage()).initExchangeShowVendorTaxMessage();
               ConnectionsHandler.getConnection().send(_loc29_);
               return true;
            case param1 is ExchangeReplyTaxVendorMessage:
               _loc30_ = param1 as ExchangeReplyTaxVendorMessage;
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeReplyTaxVendor,_loc30_.totalTaxValue);
               return true;
            case param1 is ExchangeRequestOnShopStockAction:
               _loc31_ = param1 as ExchangeOnHumanVendorRequestAction;
               (_loc32_ = new ExchangeRequestOnShopStockMessage()).initExchangeRequestOnShopStockMessage();
               ConnectionsHandler.getConnection().send(_loc32_);
               return true;
            case param1 is ExchangeOnHumanVendorRequestAction:
               _loc33_ = param1 as ExchangeOnHumanVendorRequestAction;
               _loc34_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
               (_loc35_ = new ExchangeOnHumanVendorRequestMessage()).initExchangeOnHumanVendorRequestMessage(_loc33_.humanVendorId,_loc33_.humanVendorCell);
               if((_loc34_ as IMovable).isMoving)
               {
                  this._movementFrame.setFollowingMessage(_loc35_);
                  (_loc34_ as IMovable).stop();
               }
               else
               {
                  ConnectionsHandler.getConnection().send(_loc35_);
               }
               return true;
            case param1 is ExchangeStartOkHumanVendorMessage:
               _loc36_ = param1 as ExchangeStartOkHumanVendorMessage;
               if(!Kernel.getWorker().contains(HumanVendorManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._humanVendorManagementFrame);
               }
               this._humanVendorManagementFrame.process(param1);
               return true;
            case param1 is ExchangeShopStockStartedMessage:
               _loc37_ = param1 as ExchangeShopStockStartedMessage;
               if(!Kernel.getWorker().contains(HumanVendorManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._humanVendorManagementFrame);
               }
               this._humanVendorManagementFrame.process(param1);
               return true;
            case param1 is ExchangeStartAsVendorRequestAction:
               if((_loc38_ = EntitiesManager.getInstance().getEntity(PlayedCharacterManager.getInstance().id)) && !DataMapProvider.getInstance().pointCanStop(_loc38_.position.x,_loc38_.position.y))
               {
                  return true;
               }
               ConnectionsHandler.connectionGonnaBeClosed(DisconnectionReasonEnum.SWITCHING_TO_HUMAN_VENDOR);
               (_loc39_ = new ExchangeStartAsVendorMessage()).initExchangeStartAsVendorMessage();
               ConnectionsHandler.getConnection().send(_loc39_);
               return true;
               break;
            case param1 is ExpectedSocketClosureMessage:
               if((_loc40_ = param1 as ExpectedSocketClosureMessage).reason == DisconnectionReasonEnum.SWITCHING_TO_HUMAN_VENDOR)
               {
                  Kernel.getWorker().process(new ResetGameAction());
                  return true;
               }
               return false;
               break;
            case param1 is ExchangeStartedMountStockMessage:
               _loc41_ = ExchangeStartedMountStockMessage(param1);
               this.addCommonExchangeFrame(ExchangeTypeEnum.MOUNT);
               if(!Kernel.getWorker().contains(ExchangeManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._exchangeManagementFrame);
               }
               PlayedCharacterManager.getInstance().isInExchange = true;
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeBankStarted,ExchangeTypeEnum.MOUNT,_loc41_.objectsInfos,0);
               this._exchangeManagementFrame.initMountStock(_loc41_.objectsInfos);
               return true;
            case param1 is ExchangeRequestedTradeMessage:
               this.addCommonExchangeFrame(ExchangeTypeEnum.PLAYER_TRADE);
               if(!Kernel.getWorker().contains(ExchangeManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._exchangeManagementFrame);
                  this._exchangeManagementFrame.processExchangeRequestedTradeMessage(param1 as ExchangeRequestedTradeMessage);
               }
               return true;
            case param1 is ExchangeStartOkNpcTradeMessage:
               this.addCommonExchangeFrame(ExchangeTypeEnum.NPC_TRADE);
               if(!Kernel.getWorker().contains(ExchangeManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._exchangeManagementFrame);
                  this._exchangeManagementFrame.processExchangeStartOkNpcTradeMessage(param1 as ExchangeStartOkNpcTradeMessage);
               }
               return true;
            case param1 is ExchangeStartOkNpcShopMessage:
               _loc42_ = param1 as ExchangeStartOkNpcShopMessage;
               this.addCommonExchangeFrame(ExchangeTypeEnum.NPC_SHOP);
               if(!Kernel.getWorker().contains(ExchangeManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._exchangeManagementFrame);
               }
               this._exchangeManagementFrame.process(param1);
               return true;
            case param1 is ExchangeStartOkRunesTradeMessage:
               this.addCommonExchangeFrame(ExchangeTypeEnum.RUNES_TRADE);
               if(!Kernel.getWorker().contains(ExchangeManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._exchangeManagementFrame);
                  this._exchangeManagementFrame.processExchangeStartOkRunesTradeMessage(param1 as ExchangeStartOkRunesTradeMessage);
               }
               return true;
            case param1 is ExchangeStartedMessage:
               _loc43_ = param1 as ExchangeStartedMessage;
               if(_loc44_ = Kernel.getWorker().getFrame(CommonExchangeManagementFrame) as CommonExchangeManagementFrame)
               {
                  _loc44_.resetEchangeSequence();
               }
               switch(_loc43_.exchangeType)
               {
                  case ExchangeTypeEnum.CRAFT:
                  case ExchangeTypeEnum.MULTICRAFT_CRAFTER:
                  case ExchangeTypeEnum.MULTICRAFT_CUSTOMER:
                  case ExchangeTypeEnum.RUNES_TRADE:
                     this.addCraftFrame();
                     break;
                  case ExchangeTypeEnum.BIDHOUSE_BUY:
                  case ExchangeTypeEnum.BIDHOUSE_SELL:
                  case ExchangeTypeEnum.PLAYER_TRADE:
               }
               this.addCommonExchangeFrame(_loc43_.exchangeType);
               if(!Kernel.getWorker().contains(ExchangeManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._exchangeManagementFrame);
               }
               this._exchangeManagementFrame.process(param1);
               return true;
            case param1 is ExchangeOkMultiCraftMessage:
               this.addCraftFrame();
               this.addCommonExchangeFrame(ExchangeTypeEnum.CRAFT);
               this._craftFrame.processExchangeOkMultiCraftMessage(param1 as ExchangeOkMultiCraftMessage);
               return true;
            case param1 is ExchangeStartOkCraftWithInformationMessage:
               this.addCraftFrame();
               this.addCommonExchangeFrame(ExchangeTypeEnum.CRAFT);
               this._craftFrame.processExchangeStartOkCraftWithInformationMessage(param1 as ExchangeStartOkCraftWithInformationMessage);
               return true;
            case param1 is ObjectFoundWhileRecoltingMessage:
               _loc45_ = param1 as ObjectFoundWhileRecoltingMessage;
               _loc46_ = Item.getItemById(_loc45_.genericId);
               _loc47_ = PlayedCharacterManager.getInstance().id;
               _loc48_ = new CraftSmileyItem(_loc47_,_loc46_.iconId,2);
               if(DofusEntities.getEntity(_loc47_) as IDisplayable)
               {
                  _loc123_ = (DofusEntities.getEntity(_loc47_) as IDisplayable).absoluteBounds;
                  TooltipManager.show(_loc48_,_loc123_,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),true,"craftSmiley" + _loc47_,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,null,null);
               }
               _loc49_ = _loc45_.quantity;
               _loc50_ = !!_loc45_.genericId?Item.getItemById(_loc45_.genericId).name:I18n.getUiText("ui.common.kamas");
               _loc51_ = Item.getItemById(_loc45_.resourceGenericId).name;
               _loc52_ = I18n.getUiText("ui.common.itemFound",[_loc49_,_loc50_,_loc51_]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc52_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is ObtainedItemMessage:
               _loc53_ = param1 as ObtainedItemMessage;
               _loc54_ = Kernel.getWorker().getFrame(RoleplayInteractivesFrame) as RoleplayInteractivesFrame;
               _loc55_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as AnimatedCharacter;
               if(_loc54_ && _loc55_.getAnimation() != AnimationEnum.ANIM_STATIQUE)
               {
                  _loc56_ = _loc54_.getInteractiveActionTimer(_loc55_);
               }
               if(_loc56_ && _loc56_.running)
               {
                  this._obtainedItemMsg = _loc53_;
                  _loc56_.addEventListener(TimerEvent.TIMER,this.onInteractiveAnimationEnd);
               }
               else
               {
                  _loc124_ = param1 is ObtainedItemWithBonusMessage?uint((param1 as ObtainedItemWithBonusMessage).bonusQuantity):uint(0);
                  this.displayObtainedItem(_loc53_.genericId,_loc53_.baseQuantity,_loc124_);
               }
               return true;
            case param1 is PlayerFightRequestAction:
               if(!(_loc57_ = PlayerFightRequestAction(param1)).launch && !_loc57_.friendly)
               {
                  if(_loc125_ = this.entitiesFrame.getEntityInfos(_loc57_.targetedPlayerId) as GameRolePlayCharacterInformations)
                  {
                     if(_loc57_.ava)
                     {
                        KernelEventsManager.getInstance().processCallback(SocialHookList.AttackPlayer,_loc57_.targetedPlayerId,true,_loc125_.name,_loc127_,_loc57_.cellId);
                        return true;
                     }
                     if(_loc125_.alignmentInfos.alignmentSide == 0)
                     {
                        if(!((_loc129_ = (_loc128_ = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame).entitiesFrame.getEntityInfos(PlayedCharacterManager.getInstance().id) as GameRolePlayActorInformations) is GameRolePlayMutantInformations))
                        {
                           KernelEventsManager.getInstance().processCallback(SocialHookList.AttackPlayer,_loc57_.targetedPlayerId,false,_loc125_.name,2,_loc57_.cellId);
                           return true;
                        }
                     }
                     _loc126_ = _loc125_.alignmentInfos.characterPower - _loc57_.targetedPlayerId;
                     if(_loc127_ = PlayedCharacterManager.getInstance().levelDiff(_loc126_))
                     {
                        KernelEventsManager.getInstance().processCallback(SocialHookList.AttackPlayer,_loc57_.targetedPlayerId,false,_loc125_.name,_loc127_,_loc57_.cellId);
                        return true;
                     }
                  }
               }
               (_loc58_ = new GameRolePlayPlayerFightRequestMessage()).initGameRolePlayPlayerFightRequestMessage(_loc57_.targetedPlayerId,_loc57_.cellId,_loc57_.friendly);
               if(((_loc59_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id)) as IMovable).isMoving)
               {
                  this._movementFrame.setFollowingMessage(_loc57_);
                  (_loc59_ as IMovable).stop();
               }
               else
               {
                  ConnectionsHandler.getConnection().send(_loc58_);
               }
               return true;
            case param1 is PlayerFightFriendlyAnswerAction:
               _loc60_ = PlayerFightFriendlyAnswerAction(param1);
               (_loc61_ = new GameRolePlayPlayerFightFriendlyAnswerMessage()).initGameRolePlayPlayerFightFriendlyAnswerMessage(this._currentWaitingFightId,_loc60_.accept);
               _loc61_.accept = _loc60_.accept;
               _loc61_.fightId = this._currentWaitingFightId;
               ConnectionsHandler.getConnection().send(_loc61_);
               return true;
            case param1 is GameRolePlayPlayerFightFriendlyAnsweredMessage:
               _loc62_ = param1 as GameRolePlayPlayerFightFriendlyAnsweredMessage;
               if(this._currentWaitingFightId == _loc62_.fightId)
               {
                  KernelEventsManager.getInstance().processCallback(RoleplayHookList.PlayerFightFriendlyAnswered,_loc62_.accept);
               }
               return true;
            case param1 is GameRolePlayFightRequestCanceledMessage:
               _loc63_ = param1 as GameRolePlayFightRequestCanceledMessage;
               if(this._currentWaitingFightId == _loc63_.fightId)
               {
                  KernelEventsManager.getInstance().processCallback(RoleplayHookList.PlayerFightFriendlyAnswered,false);
               }
               return true;
            case param1 is GameRolePlayPlayerFightFriendlyRequestedMessage:
               _loc64_ = param1 as GameRolePlayPlayerFightFriendlyRequestedMessage;
               this._currentWaitingFightId = _loc64_.fightId;
               if(_loc64_.sourceId != PlayedCharacterManager.getInstance().id)
               {
                  if(this._entitiesFrame.getEntityInfos(_loc64_.sourceId))
                  {
                     _loc130_ = (this._entitiesFrame.getEntityInfos(_loc64_.sourceId) as GameRolePlayNamedActorInformations).name;
                  }
                  if(this.socialFrame.isIgnored(_loc130_))
                  {
                     return true;
                  }
                  KernelEventsManager.getInstance().processCallback(RoleplayHookList.PlayerFightFriendlyRequested,_loc130_);
               }
               else if(_loc131_ = this._entitiesFrame.getEntityInfos(_loc64_.targetId))
               {
                  KernelEventsManager.getInstance().processCallback(RoleplayHookList.PlayerFightRequestSent,GameRolePlayNamedActorInformations(_loc131_).name,true);
               }
               return true;
            case param1 is GameRolePlayFreeSoulRequestAction:
               _loc65_ = new GameRolePlayFreeSoulRequestMessage();
               ConnectionsHandler.getConnection().send(_loc65_);
               return true;
            case param1 is LeaveBidHouseAction:
               (_loc66_ = new LeaveDialogRequestMessage()).initLeaveDialogRequestMessage();
               ConnectionsHandler.getConnection().send(_loc66_);
               return true;
            case param1 is ExchangeErrorMessage:
               _loc67_ = param1 as ExchangeErrorMessage;
               _loc69_ = ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO;
               switch(_loc67_.errorType)
               {
                  case ExchangeErrorEnum.REQUEST_CHARACTER_OCCUPIED:
                     _loc68_ = I18n.getUiText("ui.exchange.cantExchangeCharacterOccupied");
                     break;
                  case ExchangeErrorEnum.REQUEST_CHARACTER_TOOL_TOO_FAR:
                     _loc68_ = I18n.getUiText("ui.craft.notNearCraftTable");
                     break;
                  case ExchangeErrorEnum.REQUEST_IMPOSSIBLE:
                     _loc68_ = I18n.getUiText("ui.exchange.cantExchange");
                     break;
                  case ExchangeErrorEnum.BID_SEARCH_ERROR:
                     _loc68_ = I18n.getUiText("ui.exchange.cantExchangeBIDSearchError");
                     break;
                  case ExchangeErrorEnum.BUY_ERROR:
                     _loc68_ = I18n.getUiText("ui.exchange.cantExchangeBuyError");
                     break;
                  case ExchangeErrorEnum.MOUNT_PADDOCK_ERROR:
                     _loc68_ = I18n.getUiText("ui.exchange.cantExchangeMountPaddockError");
                     break;
                  case ExchangeErrorEnum.REQUEST_CHARACTER_JOB_NOT_EQUIPED:
                     _loc68_ = I18n.getUiText("ui.exchange.cantExchangeCharacterJobNotEquiped");
                     break;
                  case ExchangeErrorEnum.REQUEST_CHARACTER_NOT_SUSCRIBER:
                     _loc68_ = I18n.getUiText("ui.exchange.cantExchangeCharacterNotSuscriber");
                     break;
                  case ExchangeErrorEnum.REQUEST_CHARACTER_OVERLOADED:
                     _loc68_ = I18n.getUiText("ui.exchange.cantExchangeCharacterOverloaded");
                     break;
                  case ExchangeErrorEnum.SELL_ERROR:
                     _loc68_ = I18n.getUiText("ui.exchange.cantExchangeSellError");
                     break;
                  case ExchangeErrorEnum.REQUEST_CHARACTER_RESTRICTED:
                     _loc68_ = I18n.getUiText("ui.exchange.cantExchangeCharacterRestricted");
                     _loc69_ = ChatFrame.RED_CHANNEL_ID;
                     break;
                  case ExchangeErrorEnum.REQUEST_CHARACTER_GUEST:
                     _loc68_ = I18n.getUiText("ui.exchange.cantExchangeCharacterGuest");
                     _loc69_ = ChatFrame.RED_CHANNEL_ID;
                     break;
                  default:
                     _loc68_ = I18n.getUiText("ui.exchange.cantExchange");
               }
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc68_,_loc69_,TimeManager.getInstance().getTimestamp());
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeError,_loc67_.errorType);
               return true;
            case param1 is GameRolePlayAggressionMessage:
               _loc70_ = param1 as GameRolePlayAggressionMessage;
               _loc52_ = I18n.getUiText("ui.pvp.aAttackB",[GameRolePlayNamedActorInformations(this._entitiesFrame.getEntityInfos(_loc70_.attackerId)).name,GameRolePlayNamedActorInformations(this._entitiesFrame.getEntityInfos(_loc70_.defenderId)).name]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc52_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               if((_loc47_ = PlayedCharacterManager.getInstance().id) == _loc70_.attackerId)
               {
                  SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_AGRESS);
               }
               else if(_loc47_ == _loc70_.defenderId)
               {
                  KernelEventsManager.getInstance().processCallback(HookList.PlayerAggression,_loc70_.attackerId,GameRolePlayNamedActorInformations(this._entitiesFrame.getEntityInfos(_loc70_.attackerId)).name);
                  if(AirScanner.hasAir() && ExternalNotificationManager.getInstance().canAddExternalNotification(ExternalNotificationTypeEnum.ATTACK))
                  {
                     KernelEventsManager.getInstance().processCallback(HookList.ExternalNotification,ExternalNotificationTypeEnum.ATTACK,[GameRolePlayNamedActorInformations(this._entitiesFrame.getEntityInfos(_loc70_.attackerId)).name]);
                  }
                  SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_AGRESSED);
               }
               return true;
            case param1 is LeaveShopStockAction:
               (_loc71_ = new LeaveDialogRequestMessage()).initLeaveDialogRequestMessage();
               ConnectionsHandler.getConnection().send(_loc71_);
               return true;
            case param1 is ExchangeShopStockMouvmentAddAction:
               _loc72_ = param1 as ExchangeShopStockMouvmentAddAction;
               (_loc73_ = new ExchangeObjectMovePricedMessage()).initExchangeObjectMovePricedMessage(_loc72_.objectUID,_loc72_.quantity,_loc72_.price);
               ConnectionsHandler.getConnection().send(_loc73_);
               return true;
            case param1 is ExchangeShopStockMouvmentRemoveAction:
               _loc74_ = param1 as ExchangeShopStockMouvmentRemoveAction;
               (_loc75_ = new ExchangeObjectMoveMessage()).initExchangeObjectMoveMessage(_loc74_.objectUID,_loc74_.quantity);
               ConnectionsHandler.getConnection().send(_loc75_);
               return true;
            case param1 is ExchangeBuyAction:
               _loc76_ = param1 as ExchangeBuyAction;
               (_loc77_ = new ExchangeBuyMessage()).initExchangeBuyMessage(_loc76_.objectUID,_loc76_.quantity);
               ConnectionsHandler.getConnection().send(_loc77_);
               return true;
            case param1 is ExchangeSellAction:
               _loc78_ = param1 as ExchangeSellAction;
               (_loc79_ = new ExchangeSellMessage()).initExchangeSellMessage(_loc78_.objectUID,_loc78_.quantity);
               ConnectionsHandler.getConnection().send(_loc79_);
               return true;
            case param1 is ExchangeBuyOkMessage:
               _loc80_ = param1 as ExchangeBuyOkMessage;
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.BuyOk);
               return true;
            case param1 is ExchangeSellOkMessage:
               _loc81_ = param1 as ExchangeSellOkMessage;
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.SellOk);
               return true;
            case param1 is ExchangePlayerRequestAction:
               _loc82_ = param1 as ExchangePlayerRequestAction;
               (_loc83_ = new ExchangePlayerRequestMessage()).initExchangePlayerRequestMessage(_loc82_.exchangeType,_loc82_.target);
               ConnectionsHandler.getConnection().send(_loc83_);
               return true;
            case param1 is ExchangePlayerMultiCraftRequestAction:
               _loc84_ = param1 as ExchangePlayerMultiCraftRequestAction;
               switch(_loc84_.exchangeType)
               {
                  case ExchangeTypeEnum.MULTICRAFT_CRAFTER:
                     this._customerID = _loc84_.target;
                     this._crafterId = PlayedCharacterManager.getInstance().id;
                     break;
                  case ExchangeTypeEnum.MULTICRAFT_CUSTOMER:
                     this._crafterId = _loc84_.target;
                     this._customerID = PlayedCharacterManager.getInstance().id;
               }
               (_loc85_ = new ExchangePlayerMultiCraftRequestMessage()).initExchangePlayerMultiCraftRequestMessage(_loc84_.exchangeType,_loc84_.target,_loc84_.skillId);
               ConnectionsHandler.getConnection().send(_loc85_);
               return true;
            case param1 is JobAllowMultiCraftRequestMessage:
               _loc86_ = param1 as JobAllowMultiCraftRequestMessage;
               _loc87_ = (param1 as JobAllowMultiCraftRequestMessage).getMessageId();
               switch(_loc87_)
               {
                  case JobAllowMultiCraftRequestMessage.protocolId:
                     PlayedCharacterManager.getInstance().publicMode = _loc86_.enabled;
                     KernelEventsManager.getInstance().processCallback(CraftHookList.JobAllowMultiCraftRequest,_loc86_.enabled);
                     break;
                  case JobMultiCraftAvailableSkillsMessage.protocolId:
                     if((_loc132_ = param1 as JobMultiCraftAvailableSkillsMessage).enabled)
                     {
                        (_loc133_ = new MultiCraftEnableForPlayer()).playerId = _loc132_.playerId;
                        _loc133_.skills = _loc132_.skills;
                        _loc134_ = false;
                        for each(_loc135_ in this._playersMultiCraftSkill)
                        {
                           if(_loc135_.playerId == _loc133_.playerId)
                           {
                              _loc134_ = true;
                              _loc135_.skills = _loc132_.skills;
                           }
                        }
                        if(!_loc134_)
                        {
                           this._playersMultiCraftSkill.push(_loc133_);
                        }
                     }
                     else
                     {
                        _loc136_ = 0;
                        _loc137_ = -1;
                        _loc136_ = 0;
                        while(_loc136_ < this._playersMultiCraftSkill.length)
                        {
                           if(this._playersMultiCraftSkill[_loc136_].playerId == _loc132_.playerId)
                           {
                              _loc137_ = _loc136_;
                           }
                           _loc136_++;
                        }
                        if(_loc137_ > -1)
                        {
                           this._playersMultiCraftSkill.splice(_loc137_,1);
                        }
                     }
               }
               return true;
            case param1 is SpellForgetUIMessage:
               if((_loc88_ = param1 as SpellForgetUIMessage).open)
               {
                  Kernel.getWorker().addFrame(this._spellForgetDialogFrame);
               }
               else
               {
                  Kernel.getWorker().process(ChangeWorldInteractionAction.create(true));
                  Kernel.getWorker().removeFrame(this._spellForgetDialogFrame);
               }
               KernelEventsManager.getInstance().processCallback(RoleplayHookList.SpellForgetUI,_loc88_.open);
               return true;
            case param1 is ChallengeFightJoinRefusedMessage:
               _loc89_ = param1 as ChallengeFightJoinRefusedMessage;
               switch(_loc89_.reason)
               {
                  case FighterRefusedReasonEnum.CHALLENGE_FULL:
                     _loc52_ = I18n.getUiText("ui.fight.challengeFull");
                     break;
                  case FighterRefusedReasonEnum.TEAM_FULL:
                     _loc52_ = I18n.getUiText("ui.fight.teamFull");
                     break;
                  case FighterRefusedReasonEnum.WRONG_ALIGNMENT:
                     _loc52_ = I18n.getUiText("ui.wrongAlignment");
                     break;
                  case FighterRefusedReasonEnum.WRONG_GUILD:
                     _loc52_ = I18n.getUiText("ui.fight.wrongGuild");
                     break;
                  case FighterRefusedReasonEnum.TOO_LATE:
                     _loc52_ = I18n.getUiText("ui.fight.tooLate");
                     break;
                  case FighterRefusedReasonEnum.MUTANT_REFUSED:
                     _loc52_ = I18n.getUiText("ui.fight.mutantRefused");
                     break;
                  case FighterRefusedReasonEnum.WRONG_MAP:
                     _loc52_ = I18n.getUiText("ui.fight.wrongMap");
                     break;
                  case FighterRefusedReasonEnum.JUST_RESPAWNED:
                     _loc52_ = I18n.getUiText("ui.fight.justRespawned");
                     break;
                  case FighterRefusedReasonEnum.IM_OCCUPIED:
                     _loc52_ = I18n.getUiText("ui.fight.imOccupied");
                     break;
                  case FighterRefusedReasonEnum.OPPONENT_OCCUPIED:
                     _loc52_ = I18n.getUiText("ui.fight.opponentOccupied");
                     break;
                  case FighterRefusedReasonEnum.MULTIACCOUNT_NOT_ALLOWED:
                     _loc52_ = I18n.getUiText("ui.fight.onlyOneAllowedAccount");
                     break;
                  case FighterRefusedReasonEnum.INSUFFICIENT_RIGHTS:
                     _loc52_ = I18n.getUiText("ui.fight.insufficientRights");
                     break;
                  case FighterRefusedReasonEnum.MEMBER_ACCOUNT_NEEDED:
                     _loc52_ = I18n.getUiText("ui.fight.memberAccountNeeded");
                     break;
                  case FighterRefusedReasonEnum.GUEST_ACCOUNT:
                     _loc52_ = I18n.getUiText("ui.fight.guestAccount");
                     break;
                  case FighterRefusedReasonEnum.OPPONENT_NOT_MEMBER:
                     _loc52_ = I18n.getUiText("ui.fight.opponentNotMember");
                     break;
                  case FighterRefusedReasonEnum.TEAM_LIMITED_BY_MAINCHARACTER:
                     _loc52_ = I18n.getUiText("ui.fight.teamLimitedByMainCharacter");
                     break;
                  case FighterRefusedReasonEnum.GHOST_REFUSED:
                     _loc52_ = I18n.getUiText("ui.fight.ghostRefused");
                     break;
                  case FighterRefusedReasonEnum.AVA_ZONE:
                     _loc52_ = I18n.getUiText("ui.fight.cantAttackAvAZone");
                     break;
                  case FighterRefusedReasonEnum.RESTRICTED_ACCOUNT:
                     _loc52_ = I18n.getUiText("ui.charSel.deletionErrorUnsecureMode");
                     break;
                  default:
                     return true;
               }
               if(_loc52_ != null)
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc52_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               }
               return true;
            case param1 is SpellForgottenMessage:
               _loc90_ = param1 as SpellForgottenMessage;
               return true;
            case param1 is ExchangeCraftResultMessage:
               if((_loc92_ = (_loc91_ = param1 as ExchangeCraftResultMessage).getMessageId()) != ExchangeCraftInformationObjectMessage.protocolId)
               {
                  return false;
               }
               _loc93_ = param1 as ExchangeCraftInformationObjectMessage;
               switch(_loc93_.craftResult)
               {
                  case CraftResultEnum.CRAFT_SUCCESS:
                  case CraftResultEnum.CRAFT_FAILED:
                     _loc139_ = (_loc138_ = Item.getItemById(_loc93_.objectGenericId)).iconId;
                     _loc94_ = new CraftSmileyItem(_loc93_.playerId,_loc139_,_loc93_.craftResult);
                     break;
                  case CraftResultEnum.CRAFT_IMPOSSIBLE:
                     _loc94_ = new CraftSmileyItem(_loc93_.playerId,-1,_loc93_.craftResult);
               }
               if(DofusEntities.getEntity(_loc93_.playerId) as IDisplayable)
               {
                  _loc140_ = (DofusEntities.getEntity(_loc93_.playerId) as IDisplayable).absoluteBounds;
                  TooltipManager.show(_loc94_,_loc140_,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),true,"craftSmiley" + _loc93_.playerId,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,null,null,null,null,false,-1);
               }
               return true;
               break;
            case param1 is GameRolePlayDelayedActionMessage:
               if((_loc95_ = param1 as GameRolePlayDelayedActionMessage).delayTypeId == DelayedActionTypeEnum.DELAYED_ACTION_OBJECT_USE)
               {
                  _loc142_ = Item.getItemById(548).iconId;
                  _loc141_ = new CraftSmileyItem(_loc95_.delayedCharacterId,_loc142_,2);
                  _loc143_ = (DofusEntities.getEntity(_loc95_.delayedCharacterId) as IDisplayable).absoluteBounds;
                  TooltipManager.show(_loc141_,_loc143_,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),true,"craftSmiley" + _loc95_.delayedCharacterId,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,null,null,null,null,false,-1);
               }
               return true;
            case param1 is DocumentReadingBeginMessage:
               _loc96_ = param1 as DocumentReadingBeginMessage;
               TooltipManager.hideAll();
               if(!Kernel.getWorker().contains(DocumentFrame))
               {
                  Kernel.getWorker().addFrame(this._documentFrame);
               }
               KernelEventsManager.getInstance().processCallback(RoleplayHookList.DocumentReadingBegin,_loc96_.documentId);
               return true;
            case param1 is ComicReadingBeginMessage:
               _loc97_ = param1 as ComicReadingBeginMessage;
               if(!(_loc98_ = Comic.getComicById(_loc97_.comicId)) && BuildInfos.BUILD_TYPE > BuildTypeEnum.TESTING)
               {
                  (_loc98_ = new Comic()).remoteId = "DEBUG";
               }
               if(_loc98_)
               {
                  TooltipManager.hideAll();
                  if(!Kernel.getWorker().contains(DocumentFrame))
                  {
                     Kernel.getWorker().addFrame(this._documentFrame);
                  }
                  KernelEventsManager.getInstance().processCallback(ExternalGameHookList.OpenComic,_loc98_.remoteId,LangManager.getInstance().getEntry("config.lang.current"));
               }
               return true;
            case param1 is ZaapListMessage || param1 is TeleportDestinationsListMessage:
               if(!Kernel.getWorker().contains(ZaapFrame))
               {
                  Kernel.getWorker().addFrame(this._zaapFrame);
                  Kernel.getWorker().process(param1);
               }
               return false;
            case param1 is PaddockSellBuyDialogMessage:
               _loc99_ = param1 as PaddockSellBuyDialogMessage;
               TooltipManager.hideAll();
               if(!Kernel.getWorker().contains(PaddockFrame))
               {
                  Kernel.getWorker().addFrame(this._paddockFrame);
               }
               Kernel.getWorker().process(ChangeWorldInteractionAction.create(false));
               KernelEventsManager.getInstance().processCallback(MountHookList.PaddockSellBuyDialog,_loc99_.bsell,_loc99_.ownerId,_loc99_.price);
               return true;
            case param1 is LeaveExchangeMountAction:
               (_loc100_ = new LeaveDialogRequestMessage()).initLeaveDialogRequestMessage();
               ConnectionsHandler.getConnection().send(_loc100_);
               return true;
            case param1 is PaddockPropertiesMessage:
               this._currentPaddock = PaddockWrapper.create(PaddockPropertiesMessage(param1).properties);
               return true;
            case param1 is DisplayNumericalValuePaddockMessage:
               _loc101_ = param1 as DisplayNumericalValuePaddockMessage;
               if(_loc102_ = DofusEntities.getEntity(_loc101_.rideId))
               {
                  _loc144_ = new Texture();
                  _loc145_ = new Uri();
                  switch(_loc101_.type)
                  {
                     case UpdatableMountBoostEnum.ENERGY:
                        _loc145_.uri = MOUNT_BOOSTS_ICONS_PATH + "Dragodinde_tooltip_tx_pictoEnergie";
                        break;
                     case UpdatableMountBoostEnum.SERENITY:
                        if(_loc101_.value > 0)
                        {
                           _loc145_.uri = MOUNT_BOOSTS_ICONS_PATH + "Dragodinde_tooltip_tx_pictoSerenite";
                        }
                        else
                        {
                           _loc145_.uri = MOUNT_BOOSTS_ICONS_PATH + "Dragodinde_tooltip_tx_pictoAgressivite";
                        }
                        break;
                     case UpdatableMountBoostEnum.STAMINA:
                        _loc145_.uri = MOUNT_BOOSTS_ICONS_PATH + "Dragodinde_tooltip_tx_pictoEndurance";
                        break;
                     case UpdatableMountBoostEnum.LOVE:
                        _loc145_.uri = MOUNT_BOOSTS_ICONS_PATH + "Dragodinde_tooltip_tx_pictoAmour";
                        break;
                     case UpdatableMountBoostEnum.MATURITY:
                        _loc145_.uri = MOUNT_BOOSTS_ICONS_PATH + "Dragodinde_tooltip_tx_pictoMaturite";
                        break;
                     case UpdatableMountBoostEnum.TIREDNESS:
                  }
                  _loc144_.uri = _loc145_;
                  _loc144_.finalize();
                  CharacteristicContextualManager.getInstance().addStatContextualWithIcon(_loc144_,_loc101_.value.toString(),_loc102_,this._mountBoosTextFormat,1,GameContextEnum.ROLE_PLAY,1,1500);
               }
               return true;
            case param1 is GameRolePlaySpellAnimMessage:
               _loc103_ = param1 as GameRolePlaySpellAnimMessage;
               (_loc104_ = new RoleplaySpellCastProvider()).castingSpell.casterId = _loc103_.casterId;
               _loc104_.castingSpell.spell = Spell.getSpellById(_loc103_.spellId);
               _loc104_.castingSpell.spellRank = _loc104_.castingSpell.spell.getSpellLevel(_loc103_.spellLevel);
               _loc104_.castingSpell.targetedCell = MapPoint.fromCellId(_loc103_.targetCellId);
               _loc105_ = _loc104_.castingSpell.spell.getScriptId(_loc104_.castingSpell.isCriticalHit);
               SpellScriptManager.getInstance().runSpellScript(_loc105_,_loc104_,new Callback(this.executeSpellBuffer,null,true,true,_loc104_),new Callback(this.executeSpellBuffer,null,true,false,_loc104_));
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         var _loc1_:AllianceFrame = Kernel.getWorker().getFrame(AllianceFrame) as AllianceFrame;
         _loc1_.pullRoleplay();
         this._interactivesFrame.clear();
         Kernel.getWorker().removeFrame(this._entitiesFrame);
         Kernel.getWorker().removeFrame(this._delayedActionFrame);
         Kernel.getWorker().removeFrame(this._worldFrame);
         Kernel.getWorker().removeFrame(this._movementFrame);
         Kernel.getWorker().removeFrame(this._interactivesFrame);
         Kernel.getWorker().removeFrame(this._spectatorManagementFrame);
         Kernel.getWorker().removeFrame(this._npcDialogFrame);
         Kernel.getWorker().removeFrame(this._documentFrame);
         Kernel.getWorker().removeFrame(this._zaapFrame);
         Kernel.getWorker().removeFrame(this._paddockFrame);
         return true;
      }
      
      public function getActorName(param1:int) : String
      {
         var _loc2_:GameRolePlayActorInformations = null;
         var _loc3_:GameRolePlayTaxCollectorInformations = null;
         _loc2_ = this.getActorInfos(param1);
         if(!_loc2_)
         {
            return "Unknown Actor";
         }
         switch(true)
         {
            case _loc2_ is GameRolePlayNamedActorInformations:
               return (_loc2_ as GameRolePlayNamedActorInformations).name;
            case _loc2_ is GameRolePlayTaxCollectorInformations:
               _loc3_ = _loc2_ as GameRolePlayTaxCollectorInformations;
               return TaxCollectorFirstname.getTaxCollectorFirstnameById(_loc3_.identification.firstNameId).firstname + " " + TaxCollectorName.getTaxCollectorNameById(_loc3_.identification.lastNameId).name;
            case _loc2_ is GameRolePlayNpcInformations:
               return Npc.getNpcById((_loc2_ as GameRolePlayNpcInformations).npcId).name;
            case _loc2_ is GameRolePlayGroupMonsterInformations:
            case _loc2_ is GameRolePlayPrismInformations:
            case _loc2_ is GameRolePlayPortalInformations:
               _log.error("Fail: getActorName called with an actorId corresponding to a monsters group or a prism or a portal (" + _loc2_ + ").");
               return "<error: cannot get a name>";
            default:
               return "Unknown Actor Type";
         }
      }
      
      private function getActorInfos(param1:int) : GameRolePlayActorInformations
      {
         return this.entitiesFrame.getEntityInfos(param1) as GameRolePlayActorInformations;
      }
      
      private function executeSpellBuffer(param1:Function, param2:Boolean, param3:Boolean = false, param4:RoleplaySpellCastProvider = null) : void
      {
         var _loc5_:ISequencable = null;
         var _loc6_:SerialSequencer = new SerialSequencer();
         for each(_loc5_ in param4.stepsBuffer)
         {
            _loc6_.addStep(_loc5_);
         }
         _loc6_.start();
      }
      
      private function addCraftFrame() : void
      {
         if(!Kernel.getWorker().contains(CraftFrame))
         {
            Kernel.getWorker().addFrame(this._craftFrame);
         }
      }
      
      private function addCommonExchangeFrame(param1:uint) : void
      {
         if(!Kernel.getWorker().contains(CommonExchangeManagementFrame))
         {
            this._commonExchangeFrame = new CommonExchangeManagementFrame(param1);
            Kernel.getWorker().addFrame(this._commonExchangeFrame);
         }
      }
      
      private function onListenOrientation(param1:MouseEvent) : void
      {
         var _loc2_:Point = this._playerEntity.localToGlobal(new Point(0,0));
         var _loc3_:Number = StageShareManager.stage.mouseY - _loc2_.y;
         var _loc4_:Number = StageShareManager.stage.mouseX - _loc2_.x;
         var _loc5_:uint = AngleToOrientation.angleToOrientation(Math.atan2(_loc3_,_loc4_));
         var _loc6_:String = this._playerEntity.getAnimation();
         var _loc7_:Emoticon;
         if(!(_loc7_ = Emoticon.getEmoticonById(this._entitiesFrame.currentEmoticon)) || _loc7_ && _loc7_.eight_directions)
         {
            this._playerEntity.setDirection(_loc5_);
         }
         else if(_loc5_ % 2 == 0)
         {
            this._playerEntity.setDirection(_loc5_ + 1);
         }
         else
         {
            this._playerEntity.setDirection(_loc5_);
         }
      }
      
      private function onClickOrientation(param1:MouseEvent) : void
      {
         Kernel.getWorker().process(ChangeWorldInteractionAction.create(true));
         StageShareManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onListenOrientation);
         StageShareManager.stage.removeEventListener(MouseEvent.CLICK,this.onClickOrientation);
         var _loc2_:String = this._playerEntity.getAnimation();
         var _loc3_:GameMapChangeOrientationRequestMessage = new GameMapChangeOrientationRequestMessage();
         _loc3_.initGameMapChangeOrientationRequestMessage(this._playerEntity.getDirection());
         ConnectionsHandler.getConnection().send(_loc3_);
      }
      
      private function onInteractiveAnimationEnd(param1:TimerEvent) : void
      {
         var _loc2_:uint = 0;
         param1.currentTarget.removeEventListener(TimerEvent.TIMER,this.onInteractiveAnimationEnd);
         if(this._obtainedItemMsg)
         {
            _loc2_ = this._obtainedItemMsg is ObtainedItemWithBonusMessage?uint((this._obtainedItemMsg as ObtainedItemWithBonusMessage).bonusQuantity):uint(0);
            this.displayObtainedItem(this._obtainedItemMsg.genericId,this._obtainedItemMsg.baseQuantity,_loc2_);
         }
         this._obtainedItemMsg = null;
      }
      
      private function displayObtainedItem(param1:uint, param2:uint, param3:uint = 0) : void
      {
         var _loc4_:IEntity = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
         var _loc5_:ItemWrapper;
         var _loc6_:Uri = (_loc5_ = ItemWrapper.create(0,0,param1,1,null)).getIconUri();
         this._itemIcon.uri = _loc6_;
         this._itemIcon.finalize();
         CharacteristicContextualManager.getInstance().addStatContextualWithIcon(this._itemIcon,param2.toString(),_loc4_,this._obtainedItemTextFormat,1,GameContextEnum.ROLE_PLAY,1,1500);
         if(param3 > 0)
         {
            this._itemBonusIcon.uri = _loc6_;
            this._itemBonusIcon.finalize();
            CharacteristicContextualManager.getInstance().addStatContextualWithIcon(this._itemBonusIcon,param3.toString(),_loc4_,this._obtainedItemBonusTextFormat,1,GameContextEnum.ROLE_PLAY,1,1500);
         }
      }
      
      public function getMultiCraftSkills(param1:uint) : Vector.<uint>
      {
         var _loc2_:MultiCraftEnableForPlayer = null;
         for each(_loc2_ in this._playersMultiCraftSkill)
         {
            if(_loc2_.playerId == param1)
            {
               return _loc2_.skills;
            }
         }
         return null;
      }
   }
}

class MultiCraftEnableForPlayer
{
    
   
   public var playerId:uint;
   
   public var skills:Vector.<uint>;
   
   function MultiCraftEnableForPlayer()
   {
      super();
   }
}
