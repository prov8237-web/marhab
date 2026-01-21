package com.oyunstudyosu.model
{
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.SoftKeyboardEvent;
   import flash.display.Stage;
   import flash.events.SoftKeyboardEvent;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class SoftKeyboardModel
   {
       
      
      public var isSupported:Boolean = false;
      
      public var measureKeyboard:* = null;
      
      public var measureKeyboardInstance:* = null;
      
      private var intervalID:uint = 0;
      
      private var targetObject:Object;
      
      public function SoftKeyboardModel(param1:Stage)
      {
         super();
         if(Sanalika.instance.stage.loaderInfo.applicationDomain.hasDefinition("com.freshplanet.ane.KeyboardSize.MeasureKeyboard") == false || Sanalika.instance.stage.loaderInfo.applicationDomain.getDefinition("com.freshplanet.ane.KeyboardSize.MeasureKeyboard").isSupported == false)
         {
            return;
         }
         measureKeyboard = Sanalika.instance.stage.loaderInfo.applicationDomain.getDefinition("com.freshplanet.ane.KeyboardSize.MeasureKeyboard");
         measureKeyboardInstance = measureKeyboard.getInstance();
         param1.addEventListener("softKeyboardActivate",onSoftKeyboardActive);
         param1.addEventListener("softKeyboardDeactivate",onSoftKeyboardDeactive);
         isSupported = true;
      }
      
      private function onSoftKeyboardActive(param1:flash.events.SoftKeyboardEvent) : void
      {
         targetObject = param1.target;
         clearInterval(intervalID);
         intervalID = setInterval(detectResponse,100);
      }
      
      private function detectResponse() : void
      {
         var _loc1_:Number = Number(measureKeyboardInstance.getKeyboardHeight());
         if(_loc1_ != 0)
         {
            clearInterval(intervalID);
            Dispatcher.dispatchEvent(new com.oyunstudyosu.events.SoftKeyboardEvent("SOFT_KEYBOARD_ACTIVATE",_loc1_,measureKeyboardInstance.getKeyboardY(),targetObject));
         }
      }
      
      private function onSoftKeyboardDeactive(param1:flash.events.SoftKeyboardEvent) : void
      {
         clearInterval(intervalID);
         Dispatcher.dispatchEvent(new com.oyunstudyosu.events.SoftKeyboardEvent("SOFT_KEYBOARD_DEACTIVATE"));
      }
   }
}
