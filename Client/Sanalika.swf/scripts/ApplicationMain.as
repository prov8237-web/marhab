
{
   var _loc1_:Application = Application;
}

package
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import haxe.ds.StringMap;
   import lime.system.System;
   import lime.utils.AssetLibrary;
   import openfl.display.Application;
   import openfl.display.DefaultPreloader;
   import openfl.display.Preloader;
   import openfl.display.Window;
   
   public class ApplicationMain
   {
       
      
      public function ApplicationMain()
      {
      }
      
      public static function main() : void
      {
         System.__registerEntryPoint("Sanalika",ApplicationMain.create);
         ApplicationMain.create(null);
      }
      
      public static function create(param1:*) : void
      {
         var stage:Stage;
         var preloader:Preloader;
         var _loc7_:* = null as AssetLibrary;
         var _loc8_:* = null as String;
         var _loc2_:Application = new Application();
         ManifestResources.init(param1);
         var _loc3_:StringMap = _loc2_.meta;
         if("build" in StringMap.reserved)
         {
            _loc3_.setReserved("build","5");
         }
         else
         {
            _loc3_.h["build"] = "5";
         }
         _loc3_ = _loc2_.meta;
         if("company" in StringMap.reserved)
         {
            _loc3_.setReserved("company","OyunStudyosu");
         }
         else
         {
            _loc3_.h["company"] = "OyunStudyosu";
         }
         _loc3_ = _loc2_.meta;
         if("file" in StringMap.reserved)
         {
            _loc3_.setReserved("file","Sanalika");
         }
         else
         {
            _loc3_.h["file"] = "Sanalika";
         }
         _loc3_ = _loc2_.meta;
         if("name" in StringMap.reserved)
         {
            _loc3_.setReserved("name","Sanalika");
         }
         else
         {
            _loc3_.h["name"] = "Sanalika";
         }
         _loc3_ = _loc2_.meta;
         if("packageName" in StringMap.reserved)
         {
            _loc3_.setReserved("packageName","com.oyunstudyosu.sanalika");
         }
         else
         {
            _loc3_.h["packageName"] = "com.oyunstudyosu.sanalika";
         }
         _loc3_ = _loc2_.meta;
         if("version" in StringMap.reserved)
         {
            _loc3_.setReserved("version","1.0");
         }
         else
         {
            _loc3_.h["version"] = "1.0";
         }
         preloader = new Preloader(new DefaultPreloader());
         _loc2_.__preloader.onProgress.add(function(param1:int, param2:int):void
         {
            preloader.update(param1,param2);
         });
         _loc2_.__preloader.onComplete.add(function():void
         {
            preloader.start();
         });
         stage = _loc2_.__window.stage;
         var _loc4_:Function = function():void
         {
            ApplicationMain.start(stage);
         };
         preloader.onComplete.add(_loc4_);
         var _loc5_:int = 0;
         var _loc6_:Array = ManifestResources.preloadLibraries;
         while(_loc5_ < int(_loc6_.length))
         {
            _loc7_ = _loc6_[_loc5_];
            _loc5_++;
            _loc2_.__preloader.addLibrary(_loc7_);
         }
         _loc5_ = 0;
         _loc6_ = ManifestResources.preloadLibraryNames;
         while(_loc5_ < int(_loc6_.length))
         {
            _loc8_ = String(_loc6_[_loc5_]);
            _loc5_++;
            _loc2_.__preloader.addLibraryName(_loc8_);
         }
         _loc2_.__preloader.load();
         _loc5_ = _loc2_.exec();
      }
      
      public static function start(param1:Stage) : void
      {
         var _loc2_:DisplayObject = param1.getChildAt(0);
         if(_loc2_ == null || !(_loc2_ is DisplayObjectContainer))
         {
            _loc2_ = new MovieClip();
            param1.addChild(_loc2_);
         }
         new DocumentClass(_loc2_);
      }
   }
}
