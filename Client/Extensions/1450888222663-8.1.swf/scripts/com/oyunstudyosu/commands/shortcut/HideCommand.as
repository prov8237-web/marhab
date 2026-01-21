package com.oyunstudyosu.commands.shortcut
{
   import com.oyunstudyosu.commands.Command;
   import com.oyunstudyosu.engine.character.Character;
   
   public class HideCommand extends Command
   {
       
      
      public function HideCommand()
      {
         super();
      }
      
      override public function execute() : void
      {
         Sanalika.instance.avatarModel.isHideMode = !Sanalika.instance.avatarModel.isHideMode;
         process();
      }
      
      private function process() : void
      {
         if(Sanalika.instance.engine == null || Sanalika.instance.engine.scene == null)
         {
            return;
         }
         for each(var _loc1_ in Sanalika.instance.engine.scene.characterList)
         {
            if(!_loc1_.isMe)
            {
               _loc1_.hide = Sanalika.instance.avatarModel.isHideMode;
            }
         }
         Sanalika.instance.engine.scene.ceilingContainer.visible = !Sanalika.instance.avatarModel.isHideMode;
      }
   }
}
