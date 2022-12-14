package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.berilia.components.messages.SelectItemMessage;
   import com.ankamagames.berilia.enums.SelectMethodEnum;
   import com.ankamagames.berilia.enums.StatesEnum;
   import com.ankamagames.berilia.types.graphic.GraphicElement;
   import com.ankamagames.jerakine.handlers.FocusHandler;
   import com.ankamagames.jerakine.handlers.messages.keyboard.KeyboardKeyUpMessage;
   import com.ankamagames.jerakine.handlers.messages.keyboard.KeyboardMessage;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.Uri;
   import flash.ui.Keyboard;
   
   public class InputComboBox extends ComboBox implements FinalizableUIComponent
   {
       
      
      private var _origDataProvider;
      
      public function InputComboBox()
      {
         super();
         _mainContainer = new Input();
         _dataNameField = "";
      }
      
      public function get input() : Input
      {
         if(!_mainContainer)
         {
            return null;
         }
         return _mainContainer as Input;
      }
      
      public function set maxChars(param1:uint) : void
      {
         (_mainContainer as Input).maxChars = param1;
      }
      
      public function set restrictChars(param1:String) : void
      {
         (_mainContainer as Input).restrictChars = param1;
      }
      
      public function get restrictChars() : String
      {
         return (_mainContainer as Input).restrictChars;
      }
      
      public function set cssClass(param1:String) : void
      {
         (_mainContainer as Input).cssClass = param1;
      }
      
      public function get cssClass() : String
      {
         return (_mainContainer as Input).cssClass;
      }
      
      public function get css() : Uri
      {
         return (_mainContainer as Input).css;
      }
      
      public function set css(param1:Uri) : void
      {
         (_mainContainer as Input).css = param1;
      }
      
      override public function get dataProvider() : *
      {
         return _list.dataProvider;
      }
      
      override public function set dataProvider(param1:*) : void
      {
         this._origDataProvider = param1;
         super.dataProvider = param1;
         if(!this._origDataProvider || this._origDataProvider.length == 0)
         {
            this.showList(false);
            _button.visible = false;
         }
         else
         {
            _button.visible = true;
         }
      }
      
      override public function finalize() : void
      {
         _button.width = width;
         _button.height = height;
         _button.visible = false;
         _bgTexture.width = width;
         _bgTexture.height = height;
         _bgTexture.autoGrid = true;
         _bgTexture.finalize();
         _button.addChild(_bgTexture);
         getUi().registerId(_bgTexture.name,new GraphicElement(_bgTexture,new Array(),_bgTexture.name));
         var _loc1_:Array = new Array();
         _loc1_[StatesEnum.STATE_OVER] = new Array();
         _loc1_[StatesEnum.STATE_OVER][_mainContainer.name] = new Array();
         _loc1_[StatesEnum.STATE_OVER][_mainContainer.name]["gotoAndStop"] = StatesEnum.STATE_OVER_STRING.toLocaleLowerCase();
         _loc1_[StatesEnum.STATE_CLICKED] = new Array();
         _loc1_[StatesEnum.STATE_CLICKED][_mainContainer.name] = new Array();
         _loc1_[StatesEnum.STATE_CLICKED][_mainContainer.name]["gotoAndStop"] = StatesEnum.STATE_CLICKED_STRING.toLocaleLowerCase();
         _button.changingStateData = _loc1_;
         _button.finalize();
         _list.width = width - listSizeOffset;
         _list.width = width - listSizeOffset;
         _list.slotWidth = _list.width;
         _list.slotHeight = height - 4;
         _list.x = 2;
         _list.y = height + 2;
         _list.finalize();
         _listTexture.width = _list.width + 4;
         _listTexture.autoGrid = true;
         _listTexture.y = height - 2;
         _listTexture.finalize();
         addChild(_button);
         addChild(_listTexture);
         addChild(_list);
         _listTexture.mouseEnabled = false;
         _list.mouseEnabled = false;
         _mainContainer.x = _list.x;
         _mainContainer.width = _list.width;
         _mainContainer.height = height;
         if(autoCenter)
         {
            _mainContainer.y = (height - _mainContainer.height) / 2;
         }
         addChild(_mainContainer);
         _finalized = true;
         getUi().iAmFinalized(this);
      }
      
      override public function process(param1:Message) : Boolean
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:* = undefined;
         switch(true)
         {
            case param1 is KeyboardKeyUpMessage:
               _loc2_ = KeyboardMessage(param1).keyboardEvent.keyCode;
               if(_loc2_ == Keyboard.ENTER)
               {
                  if(_list.visible)
                  {
                     _loc3_ = _list.selectedIndex;
                     _list.setSelectedIndex(_loc3_,SelectMethodEnum.AUTO);
                     this.input.text = _list.selectedItem;
                     this.input.setSelection(this.input.text.length,this.input.text.length);
                     this.showList(false);
                     return true;
                  }
               }
               else if(_loc2_ == Keyboard.TAB)
               {
                  this.showList(false);
               }
               else if(handleKey(_loc2_) && FocusHandler.getInstance().getFocus() == this.input.textfield)
               {
                  if((_loc4_ = this.cleanString(this.input.text)) != "")
                  {
                     if(_dpString.indexOf(_loc4_) == -1)
                     {
                        this.showList(false);
                     }
                     else
                     {
                        _loc6_ = new Array();
                        for each(_loc5_ in this._origDataProvider)
                        {
                           if(_loc5_.indexOf(_loc4_) == 0)
                           {
                              _loc6_.push(_loc5_);
                           }
                        }
                        super.dataProvider = _loc6_;
                        if(!_list.visible)
                        {
                           super.showList(true);
                        }
                     }
                  }
                  else if(_loc4_ != "\b" && this._origDataProvider && this._origDataProvider.length > 0)
                  {
                     this.showList(true);
                  }
               }
               break;
            case param1 is SelectItemMessage:
               switch(SelectItemMessage(param1).selectMethod)
               {
                  case SelectMethodEnum.CLICK:
                     if(!((_loc7_ = _list.selectedItem) is String) && _loc7_ != null)
                     {
                        _loc7_ = _loc7_[_dataNameField];
                     }
                     (_mainContainer as Input).text = _loc7_;
                     if(closeOnClick)
                     {
                        this.showList(false);
                     }
                     break;
                  case SelectMethodEnum.UP_ARROW:
                  case SelectMethodEnum.DOWN_ARROW:
                  case SelectMethodEnum.RIGHT_ARROW:
                  case SelectMethodEnum.LEFT_ARROW:
                  case SelectMethodEnum.SEARCH:
                  case SelectMethodEnum.AUTO:
                  case SelectMethodEnum.MANUAL:
                  case SelectMethodEnum.FIRST_ITEM:
                  case SelectMethodEnum.LAST_ITEM:
                     break;
                  default:
                     this.showList(false);
               }
               break;
            default:
               super.process(param1);
         }
         return false;
      }
      
      override protected function showList(param1:Boolean) : void
      {
         super.dataProvider = this._origDataProvider;
         super.showList(param1);
      }
      
      override protected function cleanString(param1:String) : String
      {
         var _loc2_:RegExp = /\b/g;
         if(param1.search(_loc2_) != -1)
         {
            return "";
         }
         return param1;
      }
   }
}
