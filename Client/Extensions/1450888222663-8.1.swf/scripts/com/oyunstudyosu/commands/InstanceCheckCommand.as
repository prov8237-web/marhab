package com.oyunstudyosu.commands
{
   import com.hurlant.util.Base64;
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.enums.LanguageKeys;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.GameEvent;
   import flash.events.AsyncErrorEvent;
   import flash.events.StatusEvent;
   import flash.external.ExternalInterface;
   import flash.net.LocalConnection;
   
   public class InstanceCheckCommand extends Command
   {
       
      
      private var connection:LocalConnection;
      
      protected var list:Array;
      
      public function InstanceCheckCommand()
      {
         list = ["c2FuYWxpa2EuY29t","ZmFjZWJvb2suY29t","bWFyaGFiLmNvbQ==","b3l1bnN0dWR5b3N1LmNvbQ=="];
         super();
      }
      
      override public function execute() : void
      {
         complete();
      }
      
      public function check() : void
      {
         log("Check trigerred.");
      }
      
      public function lock() : Boolean
      {
         var _loc2_:Array = null;
         var _loc1_:String = null;
         var _loc3_:String = ExternalInterface.call(Base64.decode("U2FuYWxpa2EuZ2V0SG9zdA=="));
         if(_loc3_)
         {
            _loc2_ = _loc3_.split(".");
            _loc3_ = _loc2_[_loc2_.length - 2] + "." + _loc2_[_loc2_.length - 1];
            _loc1_ = String(Base64.encode(_loc3_));
            if(list.indexOf(_loc1_) > -1)
            {
               return true;
            }
         }
         alertHim();
         Dispatcher.dispatchEvent(new GameEvent("INVALID_DOMAIN_DETECTED"));
         return false;
      }
      
      protected function onStatus(param1:StatusEvent) : void
      {
         switch(param1.level)
         {
            case "status":
               connection.removeEventListener("asyncError",onError);
               connection.removeEventListener("securityError",onError);
               connection.removeEventListener("status",onStatus);
               alertHim();
               log("Instance found.");
               Dispatcher.dispatchEvent(new GameEvent("INSTANCE_DETECTED"));
               break;
            case "error":
               connection.client = this;
               connection.allowDomain("*");
               connection.connect("_sanalika");
               log("Trying to connect.");
               Dispatcher.dispatchEvent(new GameEvent("NO_INSTANCE_DETECTED"));
               complete();
         }
      }
      
      private function log(param1:String) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("console.info",param1);
         }
      }
      
      protected function onError(param1:AsyncErrorEvent) : void
      {
         log("Async error.");
      }
      
      private function alertHim() : void
      {
         var _loc1_:AlertVo = new AlertVo();
         _loc1_.alertType = "Error";
         _loc1_.description = LanguageKeys.INSTANCE_CHECK_ERROR;
         Dispatcher.dispatchEvent(new AlertEvent(_loc1_));
      }
   }
}
