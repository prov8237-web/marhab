package com.oyunstudyosu.commands.shortcut
{
   import com.greensock.TweenMax;
   import com.oyunstudyosu.commands.Command;
   import flash.display.MovieClip;
   
   public class FindMeCommand extends Command
   {
       
      
      public function FindMeCommand()
      {
         super();
      }
      
      override public function execute() : void
      {
         if(Sanalika.instance.engine == null || Sanalika.instance.engine.scene == null)
         {
            return;
         }
         var _loc1_:MovieClip = Sanalika.instance.engine.scene.myChar.container;
         if(_loc1_)
         {
            TweenMax.killTweensOf(_loc1_);
            TweenMax.to(_loc1_,0,{
               "glowFilter":{
                  "color":9561600,
                  "alpha":0,
                  "blurX":0,
                  "blurY":0
               },
               "scaleX":1,
               "scaleY":1
            });
            TweenMax.to(_loc1_,0.3,{
               "glowFilter":{
                  "color":16777011,
                  "alpha":1,
                  "blurX":15,
                  "blurY":15,
                  "strength":3
               },
               "repeat":9999,
               "yoyo":true
            });
         }
      }
   }
}
