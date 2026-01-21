package com.oyunstudyosu.air.commands
{
   import com.junkbyte.console.Cc;
   import com.oyunstudyosu.air.controller.DataStorageController;
   import com.oyunstudyosu.air.events.Dispatcher;
   import com.oyunstudyosu.air.events.GameEvent;
   import com.oyunstudyosu.air.ui.InstanceSelector;
   import flash.Boot;
   import flash.display.Stage;
   
   public class SelectInstanceCommand extends Command
   {
       
      
      public var stage:Stage;
      
      public var instanceSelector:InstanceSelector;
      
      public function SelectInstanceCommand(param1:Stage = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         super();
         stage = param1;
      }
      
      public function onInstanceSelected(param1:GameEvent) : void
      {
         Dispatcher.removeEventListener("INSTANCE_SELECTED",onInstanceSelected);
         SanalikaClient.instance.loaderModel.setInstance(param1.data);
         complete();
      }
      
      override public function execute() : void
      {
         var _loc3_:* = null as GameEvent;
         Cc.info("SelectInstanceCommand.execute()");
         SanalikaClient.instance.progresView.visible = false;
         Dispatcher.addEventListener("INSTANCE_SELECTED",onInstanceSelected);
         var _loc1_:String = DataStorageController.get("instance","");
         var _loc2_:String = DataStorageController.get("token","");
         if(_loc1_ == "" || _loc2_ == "")
         {
            DataStorageController.set("instance","");
            DataStorageController.set("token","");
            instanceSelector = new InstanceSelector();
            instanceSelector.init();
            SanalikaClient.instance.addChild(instanceSelector);
            instanceSelector.onResize();
         }
         else
         {
            _loc3_ = new GameEvent("INSTANCE_SELECTED");
            _loc3_.data = _loc1_;
            Dispatcher.dispatchEvent(_loc3_);
         }
      }
      
      override public function dispose() : void
      {
         SanalikaClient.instance.progresView.visible = true;
         if(instanceSelector != null)
         {
            instanceSelector.dispose();
            SanalikaClient.instance.removeChild(instanceSelector);
         }
         super.dispose();
      }
   }
}
