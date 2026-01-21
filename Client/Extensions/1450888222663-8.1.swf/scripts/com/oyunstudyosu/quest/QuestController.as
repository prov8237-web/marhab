package com.oyunstudyosu.quest
{
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.engine.ICharacter;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.GameEvent;
   import com.oyunstudyosu.ground.GroundObject;
   import com.oyunstudyosu.ground.GroundObjectData;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.interfaces.ISpeechable;
   import com.oyunstudyosu.service.IServiceModel;
   import flash.events.MouseEvent;
   import org.oyunstudyosu.assets.clips.BotMissionIcon;
   
   public class QuestController
   {
       
      
      private var serviceModel:IServiceModel;
      
      private var questModel:IQuestModel;
      
      private var botList:Array;
      
      private var groundVos:Array;
      
      private var groundObjects:Array;
      
      private var questIcon:BotMissionIcon;
      
      private var questBot:QuestBot;
      
      private var requiredHandItem:String;
      
      private var bot:ISpeechable;
      
      private var groundObject:GroundObject;
      
      private var char:ICharacter;
      
      public function QuestController()
      {
         super();
         serviceModel = Sanalika.instance.serviceModel;
         questModel = Sanalika.instance.questModel;
         botList = [];
         groundVos = [];
         groundObjects = [];
         Dispatcher.addEventListener("TERMINATE_SCENE",terminateScene);
         Dispatcher.addEventListener("SCENE_LOADED",sceneLoaded);
         Dispatcher.addEventListener("USER_POSITION_UPDATED",collectGroundObject);
      }
      
      private function terminateScene(param1:GameEvent) : void
      {
         botList = [];
         groundVos = [];
         groundObjects = [];
      }
      
      private function collectGroundObject(param1:GameEvent) : void
      {
         var _loc5_:int = 0;
         var _loc3_:Boolean = false;
         if(Sanalika.instance.serviceModel.sfs.mySelf.getVariable("position") == null)
         {
            return;
         }
         var _loc2_:Array = Sanalika.instance.serviceModel.sfs.mySelf.getVariable("position").getStringValue().split(",");
         _loc5_ = 0;
         while(_loc5_ < groundVos.length)
         {
            groundObject = groundObjects[_loc5_] as GroundObject;
            if(groundVos[_loc5_].posX == parseInt(_loc2_[0]) && groundVos[_loc5_].posY == parseInt(_loc2_[1]) || groundObject.container.hitTestObject(Sanalika.instance.engine.scene.myChar.container))
            {
               if(groundObject)
               {
                  if(requiredHandItem)
                  {
                     if(Sanalika.instance.engine.scene.myChar.getHandItem())
                     {
                        if(Sanalika.instance.engine.scene.myChar.getHandItem().clip == Sanalika.instance.avatarModel.gender + "_" + requiredHandItem)
                        {
                           _loc3_ = true;
                        }
                     }
                     if(Sanalika.instance.avatarModel.clothesOn.toString().indexOf(requiredHandItem) > -1)
                     {
                        _loc3_ = true;
                     }
                     if(_loc3_)
                     {
                        serviceModel.requestData("questaction",{"id":groundVos[_loc5_].questID},onOngoingResponse);
                        groundObject.collect();
                        groundVos.splice(_loc5_,1);
                        groundObjects.splice(_loc5_,1);
                        for each(var _loc4_ in groundVos)
                        {
                           trace("x:" + _loc4_.posX + " y:" + _loc4_.posY);
                        }
                        break;
                     }
                     questItemRequired(requiredHandItem);
                  }
               }
            }
            _loc5_++;
         }
      }
      
      protected function questItemGathered(param1:String) : void
      {
         var _loc2_:AlertVo = new AlertVo();
         _loc2_.alertType = "tooltip";
         _loc2_.description = $("questItemGathered") + ": " + param1;
         Dispatcher.dispatchEvent(new AlertEvent(_loc2_));
      }
      
      protected function questItemCompleted() : void
      {
         var _loc1_:AlertVo = new AlertVo();
         _loc1_.alertType = "tooltip";
         _loc1_.description = $("questItemCompleted");
         Dispatcher.dispatchEvent(new AlertEvent(_loc1_));
      }
      
      protected function questItemRequired(param1:String) : void
      {
         var _loc2_:AlertVo = new AlertVo();
         _loc2_.alertType = "tooltip";
         _loc2_.description = $("questItemRequired") + ": " + $("pro_" + param1);
         Dispatcher.dispatchEvent(new AlertEvent(_loc2_));
      }
      
      protected function onOngoingResponse(param1:Object) : void
      {
         var _loc2_:String = null;
         serviceModel.removeRequestData("questaction",onOngoingResponse);
         Sanalika.instance.soundModel.playSound("SoundKey.COLLECT",1,1);
         if(param1.curVal != param1.reqVal)
         {
            _loc2_ = param1.curVal + "/" + param1.reqVal;
            if(param1.curVal == 0)
            {
               questItemCompleted();
            }
            else
            {
               questItemGathered(_loc2_);
            }
         }
      }
      
      private function sceneLoaded(param1:GameEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Array = null;
         getQuestList();
         botList = [];
         groundVos = [];
         groundObjects = [];
         if(questModel.questlistroom[Sanalika.instance.roomModel.key])
         {
            _loc2_ = questModel.questlistroom[Sanalika.instance.roomModel.key];
         }
         if(_loc2_)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               var _loc4_:* = _loc2_[_loc3_].step.cn;
               if("CollectItemQuestProperty" !== _loc4_)
               {
                  bot = Sanalika.instance.engine.scene.getBotByName(_loc2_[_loc3_].step.botKey);
                  if(bot)
                  {
                     questIcon = new BotMissionIcon();
                     questIcon.visible = false;
                     questIcon.y = 0;
                     questIcon.x = 0 + bot.getClip().numChildren * 30;
                     questIcon.name = "questIcon_" + _loc2_[_loc3_].metaKey;
                     questIcon.questID = _loc2_[_loc3_].id;
                     questIcon.metaKey = _loc2_[_loc3_].metaKey;
                     questIcon.buttonMode = true;
                     questIcon.addEventListener("click",botStepClicked);
                     bot.getClip().addChildAt(questIcon,bot.getClip().numChildren);
                     trace("questIcon added: " + _loc2_[_loc3_].metaKey);
                  }
               }
               else
               {
                  if(_loc2_[_loc3_].step.reqItem)
                  {
                     requiredHandItem = _loc2_[_loc3_].step.reqItem;
                  }
                  addGroundItems(_loc2_[_loc3_].step.groundItem,_loc2_[_loc3_].id);
               }
               _loc3_++;
            }
         }
      }
      
      public function getQuestList() : void
      {
         if(!questModel.questlist)
         {
            serviceModel.requestData("questlist",{"showDetail":false},onQuestList);
         }
      }
      
      private function onQuestList(param1:*) : void
      {
         serviceModel.removeRequestData("questlist",onQuestList);
         questModel.questlist = param1;
      }
      
      protected function botStepClicked(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         var _loc2_:PanelVO = new PanelVO();
         _loc2_.params = {};
         _loc2_.params.questID = param1.target.questID;
         _loc2_.params.metaKey = param1.target.metaKey;
         trace("Gorev questID : " + _loc2_.params.questID);
         trace("Gorev metaKey : " + _loc2_.params.metaKey);
         switch(_loc2_.params.metaKey)
         {
            case "pinar2018":
               _loc2_.name = "QuestPanelPinar";
               break;
            case "kido201809":
               _loc2_.name = "Kido201809QuestPanel";
               break;
            case "yupoFeed":
            case "yupoGift":
            case "yupoCollect":
            case "yupoStep":
               _loc2_.name = "Yupo2019QuestPanel";
               break;
            case "isbank2019":
               _loc2_.name = "Isbank2019QuestPanel";
               break;
            default:
               _loc2_.name = "QuestPanel";
         }
         _loc2_.type = "core";
         Sanalika.instance.panelModel.openPanel(_loc2_);
      }
      
      private function addGroundItems(param1:Object, param2:String) : void
      {
         var _loc6_:GroundObjectData = null;
         var _loc5_:int = 0;
         var _loc3_:Array = param1.grids;
         var _loc4_:int = Math.random() * _loc3_.length;
         _loc4_ = int(_loc3_.length);
         groundVos = [];
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            (_loc6_ = new GroundObjectData()).questID = param2;
            _loc6_.posX = _loc3_[_loc5_].x;
            _loc6_.posY = _loc3_[_loc5_].y;
            _loc6_.clip = param1.clip;
            groundVos.push(_loc6_);
            addGroundObject(_loc6_);
            _loc5_++;
         }
      }
      
      private function addQuestBotResponse(param1:Object) : void
      {
         var _loc2_:IQuestBotVo = new QuestBotVo();
         _loc2_.questID = param1.questID;
         _loc2_.questStep = param1.questStep;
         _loc2_.botKey = param1.botKey;
         _loc2_.posX = param1.posX;
         _loc2_.posY = param1.posY;
         processBot(_loc2_);
      }
      
      private function processBot(param1:IQuestBotVo) : void
      {
         if(Sanalika.instance.engine.scene.myChar == null || Sanalika.instance.engine.scene.myChar.container == null)
         {
            botList.push(param1);
         }
         else
         {
            addBot(param1);
         }
      }
      
      private function addBot(param1:IQuestBotVo) : void
      {
         questBot = new QuestBot();
         questBot.initBot(param1);
      }
      
      private function addGroundObject(param1:GroundObjectData) : void
      {
         groundObject = new GroundObject();
         groundObject.init(param1);
         groundObjects.push(groundObject);
      }
      
      private function processGroundObject(param1:GroundObjectData) : void
      {
         if(Sanalika.instance.engine.scene.myChar == null || Sanalika.instance.engine.scene.myChar.container == null)
         {
            groundVos.push(param1);
         }
         else
         {
            addGroundObject(param1);
         }
      }
   }
}
