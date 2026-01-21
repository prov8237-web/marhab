package com.oyunstudyosu.commands.shortcut
{
   import com.oyunstudyosu.commands.Command;
   
   public class HandItemCommand extends Command
   {
       
      
      public function HandItemCommand()
      {
         super();
      }
      
      override public function execute() : void
      {
         if(Sanalika.instance.engine.scene.myChar.getHandItem())
         {
            Sanalika.instance.engine.scene.myChar.useHandItem("0");
         }
         else
         {
            trace("HandItemCommand execute");
            Sanalika.instance.engine.scene.myChar.useHandItem(Sanalika.instance.avatarModel.lastHoldedItem);
         }
      }
   }
}
