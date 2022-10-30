package com.ankamagames.dofus.types.entities
{
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceDice;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.fight.frames.FightSequenceFrame;
   import com.ankamagames.dofus.logic.game.fight.types.CastingSpell;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.engine.Tiphon;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.tiphon.types.BehaviorData;
   import com.ankamagames.tiphon.types.IAnimationModifier;
   import com.ankamagames.tiphon.types.ISubEntityBehavior;
   
   public class RiderBehavior implements ISubEntityBehavior
   {
       
      
      private var _subentity:TiphonSprite;
      
      private var _parentData:BehaviorData;
      
      private var _animation:String;
      
      private var _direction:int;
      
      public function RiderBehavior()
      {
         super();
      }
      
      public function updateFromParentEntity(param1:TiphonSprite, param2:BehaviorData) : void
      {
         var _loc3_:IAnimationModifier = null;
         var _loc4_:Boolean = false;
         var _loc5_:CastingSpell = null;
         var _loc6_:Vector.<EffectInstanceDice> = null;
         var _loc7_:EffectInstanceDice = null;
         this._subentity = param1;
         this._parentData = param2;
         this._direction = this._parentData.direction;
         if(param1.animationModifiers && param1.animationModifiers.length)
         {
            for each(_loc3_ in param1.animationModifiers)
            {
               this._animation = _loc3_.getModifiedAnimation(param2.animation,param1.look);
            }
         }
         else
         {
            this._animation = param2.animation;
         }
         switch(true)
         {
            case this._parentData.animation == AnimationEnum.ANIM_MARCHE:
            case this._parentData.animation == AnimationEnum.ANIM_COURSE:
               this._animation = AnimationEnum.ANIM_STATIQUE;
               break;
            case this._parentData.animation.indexOf("AnimEmoteRest") != -1:
            case this._parentData.animation.indexOf("AnimEmoteSit") != -1:
            case this._parentData.animation.indexOf("AnimEmoteRest") != -1:
            case this._parentData.animation.indexOf("AnimEmoteOups") != -1:
            case this._parentData.animation.indexOf("AnimEmoteShit") != -1:
               this._animation = AnimationEnum.ANIM_STATIQUE;
               break;
            case this._parentData.animation.indexOf("AnimArme") != -1:
               if(this._parentData.animation == "AnimArme0")
               {
                  this._animation = AnimationEnum.ANIM_STATIQUE;
               }
               else
               {
                  this._parentData.animation = AnimationEnum.ANIM_STATIQUE;
               }
               break;
            case this._parentData.animation.indexOf("AnimAttaque") != -1:
               this._parentData.animation = AnimationEnum.ANIM_STATIQUE;
               if(_loc5_ = FightSequenceFrame.lastCastingSpell)
               {
                  if(_loc6_ = _loc5_.spellRank.effects)
                  {
                     for each(_loc7_ in _loc6_)
                     {
                        if(_loc7_.category == 2)
                        {
                           _loc4_ = true;
                           break;
                        }
                     }
                  }
               }
               this._animation = "AnimAttaque" + (!!_loc4_?1:0);
               break;
            case this._parentData.animation.indexOf("AnimCueillir") != -1:
            case this._parentData.animation.indexOf("AnimFaucher") != -1:
            case this._parentData.animation.indexOf("AnimPioche") != -1:
            case this._parentData.animation.indexOf("AnimHache") != -1:
            case this._parentData.animation.indexOf("AnimPeche") != -1:
            case this._parentData.animation.indexOf("AnimConsulter") != -1:
               this._parentData.animation = AnimationEnum.ANIM_STATIQUE;
         }
         if(this._parentData.animation.indexOf("AnimEmote") != -1 && !Tiphon.skullLibrary.hasAnim(this._parentData.parent.look.getBone(),this._parentData.animation))
         {
            this._parentData.animation = AnimationEnum.ANIM_STATIQUE;
         }
         param2.parent.addEventListener(TiphonEvent.RENDER_FATHER_SUCCEED,this.onFatherRendered);
      }
      
      public function remove() : void
      {
         if(this._parentData && this._parentData.parent)
         {
            this._parentData.parent.removeEventListener(TiphonEvent.RENDER_FATHER_SUCCEED,this.onFatherRendered);
         }
         this._parentData = null;
         this._subentity = null;
      }
      
      private function onFatherRendered(param1:TiphonEvent) : void
      {
         var _loc2_:String = null;
         this._parentData.parent.removeEventListener(TiphonEvent.RENDER_FATHER_SUCCEED,this.onFatherRendered);
         var _loc3_:RoleplayEntitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         var _loc4_:Emoticon;
         if((_loc4_ = !!_loc3_?Emoticon.getEmoticonById(_loc3_.currentEmoticon):null) && _loc4_.persistancy && this._parentData.animation == AnimationEnum.ANIM_STATIQUE)
         {
            _loc2_ = _loc4_.getAnimName(this._subentity.look);
            if(this._subentity.getAnimation() == _loc2_.replace("_","_Statique_"))
            {
               this._animation = this._subentity.getAnimation();
            }
         }
         this._subentity.setAnimationAndDirection(this._animation,this._direction);
      }
   }
}
