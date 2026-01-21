package org.oyunstudyosu.air.assets.clips
{
   import flash.Boot;
   import flash.display.MovieClip;
   
   public class ProgressUI extends MovieClip
   {
       
      
      public var bar:MovieClip;
      
      public function ProgressUI()
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         super();
      }
   }
}
