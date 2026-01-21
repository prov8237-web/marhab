package com.oyunstudyosu.air.commands
{
   import flash.Boot;
   
   public class StartGameCommand extends Command
   {
       
      
      public function StartGameCommand()
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         super();
      }
      
      override public function execute() : void
      {
         SanalikaClient.instance.loaderModel.load();
         complete();
      }
   }
}
