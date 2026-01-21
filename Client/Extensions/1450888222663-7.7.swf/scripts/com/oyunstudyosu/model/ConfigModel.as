package com.oyunstudyosu.model
{
   import flash.utils.Dictionary;
   
   public class ConfigModel
   {
       
      
      private var callbackList:Dictionary;
      
      private var configData:Dictionary;
      
      public function ConfigModel()
      {
         super();
         callbackList = new Dictionary();
         configData = new Dictionary();
         Sanalika.instance.serviceModel.listenExtension("config",onConfigData);
      }
      
      private function onConfigData(param1:Object) : void
      {
         var _loc4_:* = undefined;
         for(var _loc2_ in param1)
         {
            _loc4_ = param1[_loc2_];
            if(callbackList[_loc2_] != null && configData[_loc2_] != _loc4_)
            {
               for each(var _loc3_ in callbackList[_loc2_])
               {
                  _loc3_(_loc4_);
               }
            }
            configData[_loc2_] = _loc4_;
         }
      }
      
      public function getVariable(param1:String, param2:* = null) : *
      {
         var _loc3_:* = configData[param1];
         if(_loc3_ == null)
         {
            return param2;
         }
         return _loc3_;
      }
      
      public function listenVariable(param1:String, param2:*) : void
      {
         if(callbackList[param1] == null)
         {
            callbackList[param1] = [];
         }
         callbackList[param1].push(param2);
      }
   }
}
