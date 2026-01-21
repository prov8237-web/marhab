package com.oyunstudyosu.bot
{
   import com.greensock.TweenMax;
   import com.oyunstudyosu.engine.ICharacter;
   import com.oyunstudyosu.engine.IsoScene;
   import com.oyunstudyosu.engine.character.Character;
   import com.oyunstudyosu.engine.scene.components.SceneCharacterComponent;
   import com.oyunstudyosu.events.CharacterEvent;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.GameEvent;
   import com.oyunstudyosu.local.$;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.utils.Timer;
   
   public class Davulcu
   {
       
      
      private var channel:SoundChannel;
      
      private var walkTimer:Timer;
      
      private var talkTimer:Timer;
      
      private var locations:Array;
      
      private var index:int = 0;
      
      private var bot:ICharacter;
      
      private var activeClothes:Array;
      
      private var _data:Object;
      
      private var botGender:String;
      
      private var vo:IBotVO;
      
      private var tileX:int;
      
      private var tileY:int;
      
      private var targetCell:int;
      
      private var isDisposed:Boolean;
      
      public function Davulcu(param1:Object)
      {
         super();
         isDisposed = false;
         _data = param1;
         Dispatcher.addEventListener("SCENE_DATA_LOADED",execute);
         Dispatcher.addEventListener("TERMINATE_SCENE",terminate);
      }
      
      public function execute(param1:GameEvent) : void
      {
         Dispatcher.removeEventListener("SCENE_DATA_LOADED",execute);
         TweenMax.delayedCall(5,ekle);
      }
      
      public function ekle() : void
      {
         activeClothes = ["davulcu_9"];
         botGender = "m";
         vo = new BotVO();
         vo.setProperty({
            "cn":"PaymentPanelProperty",
            "booth":_data.assetUrl
         });
         bot = new Character();
         bot.init($("TutorialCharName"),Sanalika.instance.engine.scene as IsoScene,0,botGender,activeClothes);
         newPoint();
         bot.reLocate(tileX,tileY,5);
         bot.avatarName = $("bot_ramadan");
         bot.isNPC = true;
         bot.container.addEventListener("click",botClicked);
         bot.container.addEventListener("rollOver",botOver);
         bot.container.addEventListener("rollOut",botOut);
         bot.container.mouseChildren = false;
         var _loc1_:SceneCharacterComponent = Sanalika.instance.engine.scene.getComponent(SceneCharacterComponent) as SceneCharacterComponent;
         if(_loc1_ != null)
         {
            _loc1_.characterList[bot.id] = bot;
         }
         Dispatcher.addEventListener("CharacterEvent.CHAR_STOPPED",charStopped);
         TweenMax.delayedCall(1,firstWalk);
      }
      
      protected function botOver(param1:MouseEvent) : void
      {
         if(bot)
         {
            TweenMax.to(bot.container,0,{"glowFilter":{
               "color":16777215,
               "alpha":1,
               "blurX":4,
               "blurY":4,
               "strength":4
            }});
         }
      }
      
      protected function botOut(param1:MouseEvent) : void
      {
         if(bot)
         {
            TweenMax.to(bot.container,0,{"glowFilter":{
               "color":16777215,
               "alpha":0,
               "blurX":0,
               "blurY":0,
               "strength":0
            }});
         }
      }
      
      protected function botClicked(param1:MouseEvent) : void
      {
         vo.property.execute("");
         param1.stopPropagation();
      }
      
      private function firstWalk() : void
      {
         bot.speed = 0.7;
         walkTimer = new Timer(2,1);
         walkTimer.addEventListener("timerComplete",walkTimer_timercomplete);
         walkTimer.start();
         talkk();
      }
      
      private function playMusic() : void
      {
         var _loc1_:Sound = new Sound();
         channel = _loc1_.play();
         channel.addEventListener("soundComplete",loopMusic);
      }
      
      public function loopMusic(param1:Event) : void
      {
         if(channel != null)
         {
            channel.removeEventListener("soundComplete",loopMusic);
            playMusic();
         }
      }
      
      private function talkk() : void
      {
         if(bot)
         {
            bot.talk($("bot_ramadanTalk" + int(Math.random() * 3)),5);
            TweenMax.delayedCall(Math.random() * 10 + 10,talkk);
         }
      }
      
      private function newPoint() : void
      {
         tileX = Math.random() * Sanalika.instance.roomModel.gridModel.width;
         tileY = Math.random() * Sanalika.instance.roomModel.gridModel.height;
         targetCell = Sanalika.instance.engine.scene.getCellTypeByGrid(tileX,0,tileY);
         while(targetCell != 0 && isDisposed == 0)
         {
            tileX = Math.random() * Sanalika.instance.roomModel.gridModel.width;
            tileY = Math.random() * Sanalika.instance.roomModel.gridModel.height;
            targetCell = Sanalika.instance.engine.scene.getCellTypeByGrid(tileX,0,tileY);
         }
      }
      
      private function walkTimer_timercomplete(param1:TimerEvent = null) : void
      {
         newPoint();
         bot.walk(tileX,tileY);
      }
      
      private function charStopped(param1:CharacterEvent) : void
      {
         if(param1.char != bot)
         {
            return;
         }
         walkTimer.start();
      }
      
      private function terminate(param1:Event) : void
      {
         isDisposed = true;
         TweenMax.killDelayedCallsTo(talkk);
         if(walkTimer)
         {
            walkTimer.removeEventListener("timerComplete",walkTimer_timercomplete);
            walkTimer.stop();
         }
         if(channel != null)
         {
            channel.stop();
            channel.removeEventListener("soundComplete",loopMusic);
         }
         Dispatcher.removeEventListener("TERMINATE_SCENE",terminate);
      }
   }
}
