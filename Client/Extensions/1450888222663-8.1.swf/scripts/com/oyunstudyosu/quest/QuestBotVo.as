package com.oyunstudyosu.quest
{
   public class QuestBotVo implements IQuestBotVo
   {
       
      
      private var _questID:String;
      
      private var _questStep:int;
      
      private var _botKey:String;
      
      private var _posX:int;
      
      private var _posY:int;
      
      public function QuestBotVo()
      {
         super();
      }
      
      public function get questID() : String
      {
         return _questID;
      }
      
      public function set questID(param1:String) : void
      {
         if(_questID == param1)
         {
            return;
         }
         _questID = param1;
      }
      
      public function get questStep() : int
      {
         return _questStep;
      }
      
      public function set questStep(param1:int) : void
      {
         if(_questStep == param1)
         {
            return;
         }
         _questStep = param1;
      }
      
      public function get botKey() : String
      {
         return _botKey;
      }
      
      public function set botKey(param1:String) : void
      {
         if(_botKey == param1)
         {
            return;
         }
         _botKey = param1;
      }
      
      public function get posX() : int
      {
         return _posX;
      }
      
      public function set posX(param1:int) : void
      {
         if(_posX == param1)
         {
            return;
         }
         _posX = param1;
      }
      
      public function get posY() : int
      {
         return _posY;
      }
      
      public function set posY(param1:int) : void
      {
         if(_posY == param1)
         {
            return;
         }
         _posY = param1;
      }
   }
}
