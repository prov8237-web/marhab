package
{
   import com.oyunstudyosu.air.commands.ClearCredentialsCommand;
   import com.oyunstudyosu.air.commands.ProcessUpdateCommandConfig;
   import com.oyunstudyosu.air.commands.RemoteConfigCommand;
   import com.oyunstudyosu.air.commands.SelectInstanceCommand;
   import com.oyunstudyosu.air.commands.SerialCommand;
   import com.oyunstudyosu.air.commands.StartGameCommand;
   import com.oyunstudyosu.air.events.Dispatcher;
   import com.oyunstudyosu.air.events.OSProgressEvent;
   import com.oyunstudyosu.air.model.AirModel;
   import com.oyunstudyosu.air.model.BrowserModel;
   import com.oyunstudyosu.air.model.CacheModel;
   import com.oyunstudyosu.air.model.LoaderModel;
   import com.oyunstudyosu.air.model.LocalizationModel;
   import com.oyunstudyosu.air.model.ScaleModel;
   import com.oyunstudyosu.air.native.NativeExtensionModel;
   import com.oyunstudyosu.air.progress.ProgressView;
   import com.oyunstudyosu.air.progress.ProgressVo;
   import com.oyunstudyosu.air.ui.Background;
   import flash.Boot;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class SanalikaClient extends Sprite
   {
      
      public static var instance:SanalikaClient;
       
      
      public var scaleModel:ScaleModel;
      
      public var progresView:ProgressView;
      
      public var nativeExtensionModel:NativeExtensionModel;
      
      public var localizationModel:LocalizationModel;
      
      public var loaderModel:LoaderModel;
      
      public var config:Object;
      
      public var cacheModel:CacheModel;
      
      public var browserModel:BrowserModel;
      
      public var background:Background;
      
      public var airModel:AirModel;
      
      public function SanalikaClient()
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         super();
         SanalikaClient.instance = this;
         stage.frameRate = 24;
         stage.quality = "best";
         stage.scaleMode = "noScale";
         addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
      }
      
      public function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
         airModel = new AirModel(stage);
         scaleModel = new ScaleModel(stage);
         background = new Background();
         addChild(background);
         progresView = new ProgressView();
         addChild(progresView);
         localizationModel = new LocalizationModel();
         var _loc2_:ProgressVo = new ProgressVo(0,localizationModel.translate("Initializing..."));
         Dispatcher.dispatchEvent(new OSProgressEvent("LOADING_PROGRESS",_loc2_));
         browserModel = new BrowserModel(stage);
         nativeExtensionModel = new NativeExtensionModel(stage);
         loaderModel = new LoaderModel(stage);
         cacheModel = new CacheModel();
         var _loc3_:SerialCommand = new SerialCommand();
         _loc3_.addCommand(new ClearCredentialsCommand());
         _loc3_.addCommand(new RemoteConfigCommand());
         _loc3_.addCommand(new ProcessUpdateCommandConfig());
         _loc3_.addCommand(new SelectInstanceCommand(stage));
         _loc3_.addCommand(new StartGameCommand());
         _loc3_.addEventListener(Event.COMPLETE,initCommandsCompleted);
         _loc3_.execute();
      }
      
      public function initCommandsCompleted(param1:Event) : void
      {
         removeChild(background);
      }
   }
}
