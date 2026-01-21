package com.oyunstudyosu.quest.commands
{
   import com.oyunstudyosu.bot.IBotVO;
   import com.oyunstudyosu.commands.Command;
   import com.oyunstudyosu.sanalika.interfaces.ISpeechable;
   
   public class HideTargetBotCommand extends Command
   {
       
      
      private var botVo:IBotVO;
      
      private var bot:ISpeechable;
      
      private var metaKey:String;
      
      public function HideTargetBotCommand(param1:String)
      {
         super();
         this.metaKey = param1;
      }
      
      override public function execute() : void
      {
         var _loc3_:int = 0;
         var _loc1_:int = int(Sanalika.instance.roomModel.botModel.count);
         var _loc2_:Array = Sanalika.instance.roomModel.botModel.keyList;
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            botVo = Sanalika.instance.roomModel.botModel.getBotByKey(_loc2_[_loc3_]);
            if(botVo && botVo.metaKey == metaKey)
            {
               bot = Sanalika.instance.engine.scene.getBotByName(botVo.metaKey);
               if(bot)
               {
                  bot.getClip().visible = false;
               }
            }
            _loc3_++;
         }
      }
   }
}
