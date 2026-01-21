package com.oyunstudyosu.barter
{
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.enums.LanguageKeys;
   import com.oyunstudyosu.events.BarterEvent;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.service.IServiceModel;
   import com.printfas3.printf;
   
   public class BarterController
   {
       
      
      private var serviceModel:IServiceModel;
      
      private var vo:AlertVo;
      
      private var barterID:String;
      
      private var senderID:String;
      
      private var barterReqWaiting:Boolean;
      
      public function BarterController()
      {
         super();
         serviceModel = Sanalika.instance.serviceModel;
         Dispatcher.addEventListener("BarterEvent.BARTER_START_REQUEST",startBarterRequest);
         Dispatcher.addEventListener("BarterEvent.BARTER_CANCEL",cancelBarterRequest);
         serviceModel.listenExtension("respondBarterRequest",respondBarterRequest);
         serviceModel.listenExtension("barterStarted",newBarterStarted);
      }
      
      private function newBarterStarted(param1:Object) : void
      {
         senderID = param1.avatarID;
         barterID = param1.barterID;
         var _loc2_:PanelVO = new PanelVO("BarterPanel");
         _loc2_.type = "static";
         _loc2_.params = param1;
         Sanalika.instance.panelModel.openPanel(_loc2_);
      }
      
      private function respondBarterRequest(param1:Object) : void
      {
         if(barterReqWaiting || !Sanalika.instance.avatarModel.settings.tradeRequests)
         {
            return;
         }
         barterID = param1.barterID;
         senderID = param1.senderID;
         barterReqWaiting = true;
         vo = new AlertVo();
         vo.alertType = "Confirm";
         vo.callBack = barterRequestAnswer;
         vo.description = printf(LanguageKeys.BARTER_START_REQUEST,Sanalika.instance.engine.scene.getAvatarById(senderID).avatarName);
         Dispatcher.dispatchEvent(new AlertEvent(vo));
      }
      
      private function barterRequestAnswer(param1:int) : void
      {
         if(param1 == 2)
         {
            serviceModel.requestData("barterresponse",{
               "barterID":barterID,
               "response":"ACCEPTED"
            },null);
         }
         else
         {
            serviceModel.requestData("barterresponse",{
               "barterID":barterID,
               "response":"REJECTED"
            },null);
         }
         barterReqWaiting = false;
      }
      
      private function startBarterRequest(param1:BarterEvent) : void
      {
         serviceModel.requestData("barterrequest",{"avatarID":param1.avatarID},null);
      }
      
      private function cancelBarterRequest(param1:BarterEvent) : void
      {
         if(barterID || param1.avatarID == senderID)
         {
            serviceModel.requestData("bartercancel",{"barterID":barterID},null);
         }
         barterReqWaiting = false;
      }
   }
}
