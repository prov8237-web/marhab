package extensions
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import com.greensock.easing.Quad;
   import com.oyunstudyosu.engine.IScene;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.GameEvent;
   import com.oyunstudyosu.extension.BaseExtension;
   import com.oyunstudyosu.pooling.OPM;
   import com.oyunstudyosu.sanalika.interfaces.update.IUpdate;
   import flash.display.MovieClip;
   import org.oyunstudyosu.assets.clips.SnowFlake;
   
   public class SnowExtension extends BaseExtension implements IUpdate
   {
       
      
      private var MAX_SNOWFLAKE_COUNT:int = 50;
      
      private var _snowflakeDensity:Number = 0.0005;
      
      private var _snowflakeCount:int;
      
      private var _drops:Vector.<MovieClip>;
      
      private var _isActive:Boolean = false;
      
      private var _screenWidth:int;
      
      private var _screenHeight:int;
      
      public var windBegin:int;
      
      public var wind:Object;
      
      public var windForceMin:int;
      
      public var nWind:int;
      
      public var nAlpha:Number;
      
      public var windTimeMin:int;
      
      public var snowSize:Number;
      
      public var windForceMax:int;
      
      public var margin:int;
      
      public var windTimeMax:int;
      
      public var snowAlphaMin:Number;
      
      public var snowAlphaMax:Number;
      
      public var gravity:int;
      
      public var snowZmin:Number;
      
      public var snowZmax:Number;
      
      public var windDirection:String;
      
      public var fade:Boolean;
      
      public var speed:int = 0;
      
      private var sizeRatio:Number;
      
      public function SnowExtension()
      {
         super();
      }
      
      override public function init(param1:Object = null) : void
      {
         var _loc2_:IScene = null;
         trace("initSnow");
         trace("snowDATA:" + param1);
         if(param1)
         {
            trace("snowDATA");
            if(param1.speed)
            {
               speed = int(param1.speed);
               if(Sanalika.instance.airModel.isMobile())
               {
                  MAX_SNOWFLAKE_COUNT = 20;
               }
               MAX_SNOWFLAKE_COUNT *= speed;
               _snowflakeDensity *= speed;
               trace("SNOW SPEED SET:" + speed);
               _loc2_ = Sanalika.instance.engine.scene;
               if(_loc2_ && _loc2_.initialized && !_isActive)
               {
                  sceneLoaded(null);
               }
               Dispatcher.addEventListener("SCENE_LOADED",sceneLoaded);
               Dispatcher.addEventListener("TERMINATE_SCENE",terminateScene);
               Dispatcher.addEventListener("TERMINATE_GAME",terminateGame);
               Dispatcher.addEventListener("STOP_RAIN",startStop);
            }
         }
         super.init();
      }
      
      private function terminateScene(param1:GameEvent) : void
      {
         trace("terminateScene");
         Dispatcher.addEventListener("SCENE_LOADED",sceneLoaded);
         destroy();
      }
      
      private function terminateGame(param1:GameEvent) : void
      {
         trace("terminateScene");
         Dispatcher.removeEventListener("SCENE_LOADED",sceneLoaded);
         Dispatcher.removeEventListener("TERMINATE_SCENE",terminateScene);
         Dispatcher.removeEventListener("TERMINATE_GAME",terminateGame);
         Dispatcher.removeEventListener("STOP_RAIN",startStop);
         this.speed = 0;
         dispose();
      }
      
      private function startStop(param1:GameEvent) : void
      {
         if(Sanalika.instance.avatarModel.settings.rainOn)
         {
            sceneLoaded(param1);
         }
         else
         {
            destroy();
            deactivate();
         }
      }
      
      private function sceneLoaded(param1:GameEvent) : void
      {
         Dispatcher.removeEventListener("SCENE_LOADED",sceneLoaded);
         if(Sanalika.instance.roomModel.groupId != "OUTDOOR" || speed == 0 || !Sanalika.instance.avatarModel.settings.rainOn)
         {
            return;
         }
         _drops = new Vector.<MovieClip>();
         _screenWidth = Sanalika.instance.roomModel.width;
         _screenHeight = Sanalika.instance.roomModel.height;
         _screenWidth / Sanalika.instance.gameModel.minimumCanvasWidth < 2.5 ? (sizeRatio = _screenWidth / Sanalika.instance.gameModel.minimumCanvasWidth) : (sizeRatio = 2.5);
         _snowflakeCount = limit(_screenWidth * _screenHeight * _snowflakeDensity,1,MAX_SNOWFLAKE_COUNT) * sizeRatio;
         if(!OPM.hasType(SnowFlake))
         {
            OPM.addType(SnowFlake,_snowflakeCount);
         }
         readConfig();
         initSnow();
         activate();
      }
      
      private function readConfig(param1:Object = null) : void
      {
         fade = true;
         snowSize = 0.75;
         snowZmin = 0;
         snowZmax = 10;
         snowAlphaMin = 0.2;
         snowAlphaMax = 1;
         gravity = 200 * speed / 2;
         windBegin = 400 * speed;
         windForceMin = 100;
         windForceMax = 500;
         windDirection = "left";
         windTimeMin = 1;
         windTimeMax = 6;
         margin = 200;
         wind = {};
         wind.max = windForceMax;
         wind.min = windForceMin;
         wind.dir = windDirection;
         if(wind.dir == "right")
         {
            wind.force = windBegin;
         }
         else if(wind.dir == "left")
         {
            wind.force = -windBegin;
         }
         else
         {
            wind.force = windBegin;
         }
         windRandom();
         nAlpha = 1;
      }
      
      public function initSnow() : void
      {
         var _loc1_:int = 0;
         trace("initSnow");
         while(_loc1_ < _snowflakeCount)
         {
            createSnow(_loc1_);
            _loc1_++;
         }
      }
      
      public function windRandom() : void
      {
         if(wind.dir == "right")
         {
            nWind = Math.random() * (wind.max - wind.min) + wind.min;
         }
         else if(wind.dir == "left")
         {
            nWind = -Math.random() * (wind.max - wind.min) - wind.min;
         }
         else
         {
            nWind = Math.random() * (wind.max * 2 - wind.min) - wind.min - wind.max;
         }
         TweenLite.to(wind,Math.random() * 3 + 1,{
            "force":nWind,
            "delay":Math.random() * (windTimeMax - windTimeMin) + windTimeMin,
            "onComplete":windRandom
         });
      }
      
      public function update(param1:uint, param2:uint) : void
      {
      }
      
      private function deactivate() : void
      {
         if(_isActive == true)
         {
            _isActive = false;
         }
      }
      
      private function activate() : void
      {
         if(_isActive == false)
         {
            _isActive = true;
         }
      }
      
      private function createSnow(param1:int) : void
      {
         var _loc2_:SnowFlake = new SnowFlake();
         _loc2_.y = Math.random() * (_screenHeight + margin * 2) - margin * 2;
         _loc2_.x = Math.random() * (_screenWidth + margin * 2) - margin * 2;
         _loc2_.rotation = Math.random() * 360;
         _loc2_.depth = Math.random() * (snowZmax * 2 - snowZmin) + snowZmin;
         _loc2_.scaleY = Math.max(0.4,(1 / Math.max(0,_loc2_.depth) - 0.5) * snowSize);
         _loc2_.scaleX = Math.max(0.4,(1 / Math.max(0,_loc2_.depth) - 0.5) * snowSize);
         if(fade == true)
         {
            _loc2_.alpha = 0;
         }
         else
         {
            _loc2_.alpha = newAlpha(_loc2_);
         }
         _loc2_.mouseChildren = _loc2_.mouseEnabled = false;
         _drops.push(_loc2_);
         Sanalika.instance.engine.scene.ceilingContainer.addChild(_loc2_);
         snowX(_loc2_);
         snowY(_loc2_);
      }
      
      public function newAlpha(param1:SnowFlake) : Number
      {
         if(param1.scaleX < 2 * snowSize)
         {
            nAlpha = Math.random() * (snowAlphaMax - snowAlphaMin) + snowAlphaMin;
         }
         else if(param1.scaleX > 2 * snowSize && param1.scaleX < 4 * snowSize)
         {
            nAlpha = (Math.random() * (snowAlphaMax - snowAlphaMin) + snowAlphaMin) * 0.6;
         }
         else if(param1.scaleX > 4 * snowSize)
         {
            nAlpha = (Math.random() * (snowAlphaMax - snowAlphaMin) + snowAlphaMin) * 0.4;
         }
         return nAlpha;
      }
      
      public function snowY(param1:SnowFlake) : void
      {
         yReset(param1);
         TweenLite.to(param1,Math.random() * 3 + 1,{
            "y":param1.y + (Math.random() * (gravity / 2) + gravity / 2) * param1.scaleX * 3,
            "onComplete":snowY,
            "onCompleteParams":[param1],
            "ease":Linear.easeInOut,
            "overwrite":false
         });
      }
      
      public function snowX(param1:SnowFlake) : void
      {
         xReset(param1);
         TweenLite.to(param1,Math.random() * 3 + 1,{
            "alpha":newAlpha(param1),
            "x":param1.x + (Math.random() * 80 - 40 + wind.force) * param1.scaleX,
            "rotation":Math.random() * 360,
            "onComplete":snowX,
            "onCompleteParams":[param1],
            "ease":Quad.easeInOut,
            "overwrite":false
         });
      }
      
      public function xReset(param1:SnowFlake) : void
      {
         if(param1.x > _screenWidth + margin)
         {
            param1.x = Math.random() * -margin;
         }
         else if(param1.x < -margin)
         {
            param1.x = _screenWidth + Math.random() * margin;
         }
      }
      
      public function yReset(param1:SnowFlake) : void
      {
         if(param1.y > _screenHeight + margin)
         {
            param1.y = Math.random() * -margin;
         }
         else if(param1.y < -margin)
         {
            param1.y = _screenHeight + Math.random() * margin;
         }
      }
      
      public function limit(param1:Number, param2:Number, param3:Number) : Number
      {
         if(param1 < param2)
         {
            return param2;
         }
         if(param1 > param3)
         {
            return param3;
         }
         return param1;
      }
      
      public function destroy() : void
      {
         trace("snowDestroy");
         var _loc1_:int = 0;
         while(_loc1_ < _snowflakeCount)
         {
            TweenLite.killTweensOf(_drops[_loc1_]);
            try
            {
               if(Sanalika.instance.engine.scene.ceilingContainer.contains(_drops[_loc1_]))
               {
                  Sanalika.instance.engine.scene.ceilingContainer.removeChild(_drops[_loc1_]);
               }
            }
            catch(e:Error)
            {
            }
            _loc1_++;
         }
      }
      
      override public function dispose() : void
      {
         deactivate();
         trace("SnowExtensionDispose");
         Dispatcher.removeEventListener("SCENE_LOADED",sceneLoaded);
         Dispatcher.removeEventListener("TERMINATE_SCENE",terminateScene);
         Dispatcher.removeEventListener("STOP_RAIN",startStop);
         destroy();
         speed = 0;
      }
   }
}
