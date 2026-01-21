package com.oyunstudyosu.air.components
{
   import flash.Boot;
   
   public class CloseButton extends BaseAssetButton
   {
       
      
      public function CloseButton()
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         super();
         center();
      }
   }
}
