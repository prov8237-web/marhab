package com.oyunstudyosu.air.commands
{
   import com.junkbyte.console.Cc;
   import com.oyunstudyosu.air.alert.AlertResponse;
   import com.oyunstudyosu.air.alert.AlertVo;
   import com.oyunstudyosu.air.alert.views.ErrorView;
   import com.oyunstudyosu.air.controller.DataStorageController;
   import flash.Boot;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import openfl.Lib;
   
   public class RemoteConfigCommand extends Command
   {
       
      
      public var loader:URLLoader;
      
      public function RemoteConfigCommand()
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         super();
      }
      
      public function retryCallback(param1:AlertResponse, param2:AlertVo) : void
      {
         execute();
      }
      
      public function onError(param1:Event) : void
      {
         loader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
         loader.removeEventListener(Event.COMPLETE,onComplete);
         var _loc2_:ErrorView = new ErrorView();
         _loc2_.vo = new AlertVo();
         _loc2_.vo.title = SanalikaClient.instance.localizationModel.translate("Error");
         _loc2_.vo.description = SanalikaClient.instance.localizationModel.translate("The config file download failed, please make sure you have an internet connection and try again");
         _loc2_.vo.callBack = retryCallback;
         _loc2_.init();
         _loc2_.btnOk.set_text(SanalikaClient.instance.localizationModel.translate("Retry"));
         Lib.get_current().stage.addChild(_loc2_);
      }
      
      public function onComplete(param1:Event) : void
      {
         var _loc3_:*;
         var _loc4_:* = null;
         var _loc5_:* = null as Error;
         loader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
         loader.removeEventListener(Event.COMPLETE,onComplete);
         _loc3_ = param1.target;
         try
         {
            _loc4_ = JSON.parse(_loc3_.data);
            SanalikaClient.instance.config = _loc4_;
         }
         catch(_loc_e_:Error)
         {
            _loc5_ = _loc_e_;
            onError(new IOErrorEvent(IOErrorEvent.IO_ERROR));
            return;
         }
         DataStorageController.set("lastConfig",_loc3_.data);
         complete();
      }
      
      override public function execute() : void
      {
         Cc.info("RemoteConfigCommand.execute()");
         var _loc1_:URLVariables = new URLVariables();
         _loc1_.ts = Date.now().getTime();
         var _loc2_:URLRequest = new URLRequest("http://127.0.0.1:8080/c.json");
         _loc2_.data = _loc1_;
         loader = new URLLoader();
         loader.addEventListener(IOErrorEvent.IO_ERROR,onError);
         loader.addEventListener(Event.COMPLETE,onComplete);
         loader.load(_loc2_);
      }
   }
}
