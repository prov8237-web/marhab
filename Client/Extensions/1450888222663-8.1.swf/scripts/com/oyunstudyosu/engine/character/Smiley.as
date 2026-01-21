package com.oyunstudyosu.engine.character
{
   import com.oyunstudyosu.assets.AssetRequest;
   import com.oyunstudyosu.assets.IAssetRequest;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.net.URLRequest;
   
   public class Smiley extends MovieClip
   {
       
      
      public var key:String;
      
      private var loader:Loader;
      
      private var urlRequest:URLRequest;
      
      public var classType:Class;
      
      public var loadedInstance:DisplayObject;
      
      private var request:IAssetRequest;
      
      public function Smiley(param1:String)
      {
         super();
         this.key = param1;
         load();
      }
      
      private function load() : void
      {
         request = new AssetRequest();
         request.name = key;
         request.assetId = Sanalika.instance.moduleModel.getPath(key,"ModuleType.SMILEY");
         request.type = "ModuleType.SMILEY";
         request.loadedFunction = onLoaded;
         request.context = Sanalika.instance.domainModel.subContext;
         Sanalika.instance.assetModel.request(request);
      }
      
      private function onLoaded(param1:IAssetRequest) : void
      {
         var _loc2_:MovieClip = param1.display as MovieClip;
         loadedInstance = _loc2_;
         loadedInstance.y = -loadedInstance.height - 4;
         loadedInstance.x = -loadedInstance.width / 2;
         this.addChild(loadedInstance);
      }
   }
}
