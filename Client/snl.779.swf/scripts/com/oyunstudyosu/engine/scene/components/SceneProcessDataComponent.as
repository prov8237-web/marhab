package com.oyunstudyosu.engine.scene.components
{
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.assets.AssetRequest;
   import com.oyunstudyosu.assets.AssetRequestQueue;
   import com.oyunstudyosu.engine.IScene;
   import com.oyunstudyosu.engine.IntPoint;
   import com.oyunstudyosu.engine.character.Character;
   import com.oyunstudyosu.engine.core.IsoElement;
   import com.oyunstudyosu.engine.core.MapEntry;
   import com.oyunstudyosu.engine.core.Vector3d;
   import com.oyunstudyosu.engine.pool.GamePool;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.GameEvent;
   import com.oyunstudyosu.events.OSProgressEvent;
   import com.oyunstudyosu.map.property.MapProperty;
   import com.oyunstudyosu.map.property.SoundProperty;
   import com.oyunstudyosu.map.property.YoutubeScreenProperty;
   import com.oyunstudyosu.progress.ProgressVo;
   import com.oyunstudyosu.utils.DefinitionUtils;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.User;
   import flash.display.MovieClip;
   import flash.system.LoaderContext;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import org.oyunstudyosu.assets.clips.BotPlaceHolder;
   
   public class SceneProcessDataComponent extends BaseSceneComponent implements ISceneProcessDataComponent
   {
      
      private static var MapPropertyClassList:Dictionary;
       
      
      private var mapPropertyList:Array;
      
      private var roomContext:LoaderContext;
      
      private var furnitureContextList:Vector.<LoaderContext>;
      
      private var assetRequestQueue:AssetRequestQueue;
      
      protected var requests:Array;
      
      public function SceneProcessDataComponent(param1:IScene)
      {
         requests = [];
         super(param1);
         mapPropertyList = [];
         furnitureContextList = new Vector.<LoaderContext>();
         roomContext = Sanalika.instance.domainModel.generateContext("ModuleType.ROOM");
         if(MapPropertyClassList == null)
         {
            MapPropertyClassList = new Dictionary();
            MapPropertyClassList[17] = YoutubeScreenProperty;
            MapPropertyClassList[21] = SoundProperty;
         }
         trace("SceneProcessDataComponent initialized for scene");
      }
      
      public function load() : void
      {
         var _loc8_:int = 0;
         var _loc4_:MapEntry = null;
         var _loc3_:AssetRequest = null;
         var _loc2_:String = null;
         var _loc6_:String = null;
         var _loc1_:LoaderContext = null;
         trace("════════════════════════════════════════════════════════");
         trace("🔧 SceneProcessDataComponent.load()");
         trace("📁 Room Key: " + Sanalika.instance.roomModel.key);
         trace("📊 Map loaded successfully");
         scene.map = Sanalika.instance.roomModel.getMap();
         scene.processMap(scene.map);
         scene.processGrid();
         scene.gridManager.doFixedObjectOperations();
         var _loc7_:Array = [];
         _loc8_ = 0;
         while(_loc8_ < scene.mapEntries.length)
         {
            _loc4_ = scene.mapEntries[_loc8_];
            if(_loc4_.id != "0" || _loc4_.ext)
            {
               trace("📦 Processing MapEntry: " + _loc4_.definition + " (Type: " + _loc4_.entryType + ")");
               _loc7_.push(_loc4_);
            }
            _loc8_++;
         }
         for each(var _loc5_ in _loc7_)
         {
            _loc2_ = String(_loc5_.definition);
            _loc6_ = "";
            if(_loc5_.version > 0)
            {
               _loc6_ = "." + _loc5_.version;
            }
            _loc3_ = new AssetRequest();
            _loc1_ = Sanalika.instance.domainModel.generateContext("ModuleType.FURNITURE");
            furnitureContextList.push(_loc1_);
            _loc3_.context = _loc1_;
            _loc3_.assetId = Sanalika.instance.moduleModel.getPath(_loc2_ + _loc6_,"ModuleType.FURNITURE");
            _loc3_.type = "ModuleType.FURNITURE";
            _loc3_.priority = 99;
            trace("🪑 Loading furniture: " + _loc2_ + " -> " + _loc3_.assetId);
            requests.push(_loc3_);
         }
         _loc3_ = new AssetRequest();
         _loc3_.context = roomContext;
         var roomKey:String = Sanalika.instance.roomModel.key;
         var swfUrl:String = "";
         switch(roomKey)
         {
            case "street01":
            case "st01":
               swfUrl = "https://fs.sanalika.com/global/dynamic/rooms/st01.1.swf";
               trace("📍 Using standard room SWF: st01.1.swf");
               break;
            case "realEstate":
               swfUrl = "https://fs.sanalika.com/global/dynamic/rooms/realEstate.swf";
               trace("🏠 Using realEstate SWF");
               break;
            case "restaurant":
               swfUrl = "https://fs.sanalika.com/global/dynamic/rooms/restaurant.swf";
               trace("🍽️ Using restaurant SWF");
               break;
            default:
               swfUrl = Sanalika.instance.moduleModel.getPath(roomKey,"ModuleType.ROOM");
               if(swfUrl == null || swfUrl == "" || swfUrl.indexOf("null") != -1)
               {
                  swfUrl = "https://fs.sanalika.com/global/dynamic/rooms/st01.1.swf";
                  trace("⚠️ No valid SWF path found, using default: " + swfUrl);
               }
               else
               {
                  trace("📄 Using ModuleModel path: " + swfUrl);
               }
         }
         if(swfUrl.indexOf("https://") == 0)
         {
            var httpUrl:String = swfUrl.replace("https://","http://");
            trace("🔄 Also available via HTTP: " + httpUrl);
         }
         _loc3_.assetId = swfUrl;
         _loc3_.type = "ModuleType.ROOM";
         _loc3_.priority = 100;
         _loc3_.context.checkPolicyFile = true;
         _loc3_.context.securityDomain = null;
         _loc3_.root = "";
         trace("🏢 Loading room SWF: " + _loc3_.assetId);
         requests.push(_loc3_);
         addEssentialAssets();
         assetRequestQueue = new AssetRequestQueue(requests);
         assetRequestQueue.progress = onProgress;
         assetRequestQueue.callback = onLoaded;
         trace("🚀 Starting asset loading queue with " + requests.length + " requests");
         Sanalika.instance.assetModel.requestQueue(assetRequestQueue);
         trace("════════════════════════════════════════════════════════");
      }
      
      private function addEssentialAssets() : void
      {
         trace("📋 Essential assets check complete");
      }
      
      protected function onProgress(param1:AssetRequestQueue) : void
      {
         var _loc2_:ProgressVo = ProgressVo.ROOM_FILES;
         _loc2_.percent = param1.percent;
         trace("📊 Loading progress: " + _loc2_.percent + "%");
         Dispatcher.dispatchEvent(new OSProgressEvent("LOADING_PROGRESS",_loc2_));
      }
      
      protected function onLoaded(param1:AssetRequestQueue) : void
      {
         var sceneBackgroundRequest:Array;
         var alertvo:AlertVo;
         var extensions:Array;
         var extMap:Dictionary;
         var extension:Object;
         var assetRequestQueue:AssetRequestQueue;
         var errorRequest:AssetRequest;
         trace("════════════════════════════════════════════════════════");
         trace("✅ SceneProcessDataComponent.onLoaded()");
         trace("📦 Total requests loaded: " + param1.queue.length);
         assetRequestQueue = param1;
         sceneBackgroundRequest = assetRequestQueue.queue.filter(function(param1:AssetRequest, param2:int, param3:Array):Boolean
         {
            return param1.type == "ModuleType.ROOM";
         });
         if(sceneBackgroundRequest.length > 0 && sceneBackgroundRequest[0].error)
         {
            errorRequest = sceneBackgroundRequest[0];
            trace("❌ ERROR loading room SWF: " + errorRequest.error);
            errorRequest.dispose();
            attemptFallbackLoad();
            return;
         }
         if(sceneBackgroundRequest.length > 0)
         {
            trace("🎉 Room SWF loaded successfully: " + sceneBackgroundRequest[0].assetId);
         }
         if(Sanalika.instance.roomModel.currentRoom.containsVariable("extensions"))
         {
            try
            {
               extensions = JSON.parse(Sanalika.instance.roomModel.currentRoom.getVariable("extensions").getStringValue()) as Array;
               trace("🔌 Room has " + extensions.length + " extension(s)");
               if(extensions.length == 0)
               {
                  processSceneData();
               }
               else
               {
                  extMap = new Dictionary();
                  for each(extension in extensions)
                  {
                     trace("Loading extension: " + extension.source);
                     extMap[extension.source] = Sanalika.instance.domainModel.subContext;
                  }
                  Dispatcher.addEventListener("EXTENSIONS_LOADED",onExtensionsLoaded);
                  Sanalika.instance.extensionModel.loadExtensionList(extMap,1);
               }
            }
            catch(e:Error)
            {
               trace("⚠️ Error parsing extensions: " + e.message);
               processSceneData();
            }
         }
         else
         {
            trace("📭 No extensions for this room");
            processSceneData();
         }
         trace("════════════════════════════════════════════════════════");
      }
      
      private function attemptFallbackLoad() : void
      {
         trace("🔄 Attempting fallback SWF load...");
         Dispatcher.dispatchEvent(new GameEvent("PREVIOUS_ROOM"));
         alertvo = new AlertVo();
         alertvo.alertType = "Error";
         alertvo.description = "Cannot load room SWF. Trying alternative...";
         Dispatcher.dispatchEvent(new AlertEvent(alertvo));
         processSceneData();
      }
      
      private function onExtensionsLoaded(param1:GameEvent) : void
      {
         trace("🔌 Extensions loaded successfully");
         Dispatcher.removeEventListener("EXTENSIONS_LOADED",onExtensionsLoaded);
         processSceneData();
      }
      
      public function processSceneData() : void
      {
         var _loc10_:Vector3d = null;
         var _loc15_:Character = null;
         var _loc7_:Array = null;
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         trace("════════════════════════════════════════════════════════");
         trace("🔨 SceneProcessDataComponent.processSceneData()");
         if(!Sanalika.instance.serviceModel.sfs.isConnected)
         {
            trace("❌ Not connected to server, aborting scene processing");
            return;
         }
         var _loc8_:* = ProgressVo.ROOM_FILES;
         _loc8_.percent = 100;
         Dispatcher.dispatchEvent(new OSProgressEvent("LOADING_PROGRESS",_loc8_));
         var _loc11_:SceneDoorComponent = scene.getComponent(SceneDoorComponent) as SceneDoorComponent;
         if(_loc11_ != null)
         {
            trace("🚪 Processing doors and ceiling");
            _loc11_.processCeiling();
            _loc11_.processDoors();
         }
         trace("🎨 Processing background");
         scene.processBackground();
         var _loc13_:* = [];
         for each(var _loc9_ in scene.mapEntries)
         {
            if(processEntry(_loc9_))
            {
               _loc13_.push(_loc9_);
            }
         }
         var _loc5_:Vector.<MapEntry> = Vector.<MapEntry>(_loc13_);
         scene.mapEntries = _loc5_;
         trace("🗺️ Processed " + _loc5_.length + " map entries");
         var _loc14_:SceneBotComponent = scene.getComponent(SceneBotComponent) as SceneBotComponent;
         if(_loc14_ != null)
         {
            trace("🤖 Processing bots");
            _loc14_.processBotsForEntry();
         }
         trace("📍 Positioning scene elements");
         for each(var _loc4_ in scene.sceneElements)
         {
            _loc10_ = scene.getScenePositionFromTile(_loc4_.currentTile.x,_loc4_.currentTile.y);
            _loc4_.moveTo(_loc10_.x,_loc10_.y,_loc10_.z);
         }
         scene.gridManager.doFixedObjectOperations();
         var _loc6_:Room = Sanalika.instance.roomModel.currentRoom;
         var _loc12_:User = Sanalika.instance.serviceModel.sfs.mySelf;
         var _loc1_:SceneCharacterComponent = scene.getComponent(SceneCharacterComponent) as SceneCharacterComponent;
         if(_loc1_ != null && !Sanalika.instance.roomModel.disableAddChar)
         {
            trace("👤 Creating player character");
            _loc15_ = new Character();
            _loc15_.isSpectator = _loc6_.spectatorList.indexOf(_loc12_) != -1;
            _loc15_.isMe = true;
            if(_loc12_.containsVariable("roles"))
            {
               _loc15_.setRoles(_loc12_.getVariable("roles").getStringValue());
            }
            _loc15_.init(Sanalika.instance.avatarModel.avatarId,scene,0,Sanalika.instance.avatarModel.gender,Sanalika.instance.avatarModel.clothesOn);
            _loc15_.id = Sanalika.instance.avatarModel.avatarId;
            _loc15_.speed = !!_loc12_.containsVariable("speed") ? _loc12_.getVariable("speed").getDoubleValue() : 1;
            _loc15_.avatarName = Sanalika.instance.avatarModel.avatarName;
            _loc15_.avatarSize = Sanalika.instance.avatarModel.avatarSize;
            if(_loc12_.containsVariable("smiley"))
            {
               _loc15_.setSmiley(_loc12_.getVariable("smiley").getStringValue());
            }
            if(_loc12_.containsVariable("hand"))
            {
               _loc15_.useHandItem(_loc12_.getVariable("hand").getStringValue());
            }
            if(_loc12_.containsVariable("avatarSize"))
            {
               _loc15_.avatarSize = _loc12_.getVariable("avatarSize").getDoubleValue();
            }
            _loc7_ = Sanalika.instance.avatarModel.position.split(",");
            _loc3_ = int(parseInt(_loc7_[0]));
            _loc2_ = int(parseInt(_loc7_[1]));
            if(!_loc15_.isSpectator)
            {
               _loc15_.reLocate(_loc3_,_loc2_,Sanalika.instance.avatarModel.direction);
            }
            _loc1_.addChar(_loc15_);
            _loc1_.myChar = _loc15_;
            trace("✅ Player character created: " + _loc15_.avatarName);
         }
         else
         {
            trace("👻 Character creation disabled for this room");
         }
         Dispatcher.dispatchEvent(new GameEvent("SCENE_READY"));
         trace("🎬 Scene is ready! Sending roomjoincomplete request");
         Sanalika.instance.serviceModel.requestData("roomjoincomplete",{},null);
         if(assetRequestQueue != null)
         {
            assetRequestQueue.dispose();
            assetRequestQueue = null;
         }
         trace("✅ Scene processing complete!");
         trace("════════════════════════════════════════════════════════");
      }
      
      public function processEntry(param1:MapEntry) : Boolean
      {
         var _loc7_:MapProperty = null;
         var _loc6_:* = undefined;
         var _loc4_:* = undefined;
         var _loc3_:* = undefined;
         var _loc2_:* = undefined;
         var _loc5_:* = 0;
         trace("🔧 Processing MapEntry: " + param1.definition + " (Type: " + param1.entryType + ")");
         if(MapPropertyClassList[param1.entryType] != null)
         {
            trace("📋 Using MapProperty class for entry type: " + param1.entryType);
            _loc7_ = new (MapPropertyClassList[param1.entryType] as Class)();
            _loc7_.entry = param1;
            _loc7_.data = param1.getEntryData();
            _loc7_.execute();
            mapPropertyList.push(_loc7_);
            return false;
         }
         if(param1.check4Errors())
         {
            trace("❌ MapEntry has errors: " + param1);
            return false;
         }
         if(param1.definition != null)
         {
            if(param1.entryType == 4)
            {
               trace("🎮 Creating GamePool element");
               _loc6_ = new GamePool();
               GamePool(_loc6_).setValues(param1.x,param1.z,param1.y,param1.width,param1.height,param1.gameType);
               _loc6_.name = param1.gameZoneId;
               if(param1.maskDefinition != null)
               {
                  _loc4_ = scene.getMovieClip(param1.maskDefinition);
                  _loc3_ = scene.getPosFromGrid(param1.x,param1.z);
                  _loc4_.x = _loc3_.x;
                  _loc4_.y = _loc3_.y;
                  scene.elementsContainer.addChild(_loc4_);
                  _loc6_.mask = _loc4_;
               }
            }
            else
            {
               trace("🎬 Getting movie clip: " + param1.definition);
               _loc6_ = scene.getMovieClip(param1.definition);
            }
            if(_loc6_ == null)
            {
               trace("⚠️ Could not create movie clip for: " + param1.definition);
               return false;
            }
            param1.clip = _loc6_;
            if(param1.entryType == 8)
            {
               scene.floorContainer.addChild(_loc6_);
               trace("🏠 Added to floor container");
            }
            else
            {
               scene.elementsContainer.addChild(_loc6_);
               trace("🎪 Added to elements container");
            }
            _loc2_ = new IsoElement();
            _loc2_.create(null,_loc6_,scene);
            _loc2_.id = param1.definition;
            _loc2_.currentTile = new IntPoint(param1.x,param1.z);
            scene.sceneElements.push(_loc2_);
            param1.element = _loc2_;
            trace("📍 IsoElement created at tile: " + param1.x + "," + param1.z);
         }
         param1.init(scene);
         if(param1.interactive)
         {
            trace("🔄 Loading JSON data for interactive element");
            Sanalika.instance.entryModel.loadJSON(param1.property,param1.getEntryData());
         }
         _loc5_ = 0;
         while(_loc5_ < param1.clip.currentLabels.length)
         {
            if(param1.clip.currentLabels[_loc5_].name == Sanalika.instance.gameModel.language)
            {
               param1.clip.gotoAndStop(Sanalika.instance.gameModel.language);
               trace("🌐 Set language to: " + Sanalika.instance.gameModel.language);
               break;
            }
            _loc5_++;
         }
         try
         {
            processThemes(param1);
            trace("🎨 Themes processed successfully");
         }
         catch(e:Error)
         {
            trace("⚠️ Error processing themes: " + e.message);
         }
         trace("✅ MapEntry processed successfully");
         return true;
      }
      
      private function processThemes(param1:MapEntry) : void
      {
         var clip:MovieClip = param1.clip;
         var themes:Array = Sanalika.instance.gameModel.roomTheme;
         if(clip.snow)
         {
            clip.snow.visible = false;
            if(themes.indexOf("snow") > -1)
            {
               clip.snow.visible = true;
               trace("❄️ Snow theme activated");
            }
         }
         if(clip.christmas)
         {
            clip.christmas.visible = false;
            if(themes.indexOf("christmas") > -1)
            {
               clip.christmas.visible = true;
               trace("🎄 Christmas theme activated");
            }
         }
         if(clip.fest)
         {
            clip.fest.visible = false;
            if(themes.indexOf("fest") > -1 || themes.indexOf("ramadan") > -1)
            {
               clip.fest.visible = true;
               trace("🎉 Festival theme activated");
            }
         }
         if(clip.halloween)
         {
            clip.halloween.visible = false;
            if(themes.indexOf("halloween") > -1)
            {
               clip.halloween.visible = true;
               trace("🎃 Halloween theme activated");
            }
         }
         if(clip.snowMain)
         {
            clip.snowMain.visible = themes.indexOf("snow") > -1;
            if(clip.snowMain.visible)
            {
               clip.snow && (clip.snow.visible = false);
               clip.christmas && (clip.christmas.visible = false);
               clip.halloween && (clip.halloween.visible = false);
               clip.hide && (clip.hide.visible = false);
               trace("❄️❄️ Main Snow theme activated");
            }
         }
         if(clip.christmasMain)
         {
            clip.christmasMain.visible = themes.indexOf("christmas") > -1;
            if(clip.christmasMain.visible)
            {
               clip.snow && (clip.snow.visible = false);
               clip.christmas && (clip.christmas.visible = false);
               clip.halloween && (clip.halloween.visible = false);
               clip.hide && (clip.hide.visible = false);
               trace("🎄🎄 Main Christmas theme activated");
            }
         }
         if(clip.halloweenMain)
         {
            clip.halloweenMain.visible = themes.indexOf("halloween") > -1;
            if(clip.halloweenMain.visible)
            {
               clip.snow && (clip.snow.visible = false);
               clip.christmas && (clip.christmas.visible = false);
               clip.halloween && (clip.halloween.visible = false);
               clip.hide && (clip.hide.visible = false);
               trace("🎃🎃 Main Halloween theme activated");
            }
         }
      }
      
      public function getMovieClip(param1:String) : MovieClip
      {
         var _loc4_:*;
         var _loc2_:Class;
         var _loc5_:MovieClip;
         var tf:TextField;
         var _loc6_:Class = null;
         var _loc7_:* = null;
         var _loc3_:* = null;
         trace("🔍 Looking for movie clip: " + param1);
         for each(_loc4_ in furnitureContextList)
         {
            if(_loc4_ && _loc4_.applicationDomain)
            {
               _loc6_ = DefinitionUtils.getClass(_loc4_.applicationDomain,param1,Sanalika.instance.gameModel.weather);
               if(_loc6_)
               {
                  trace("✅ Found in furniture context: " + param1);
                  return new _loc6_();
               }
            }
         }
         _loc2_ = DefinitionUtils.getClass(roomContext.applicationDomain,param1,Sanalika.instance.gameModel.weather);
         if(_loc2_)
         {
            trace("✅ Found in room context: " + param1);
            return new _loc2_();
         }
         trace("⚠️ Movie clip not found: " + param1 + ", creating placeholder");
         _loc5_ = new MovieClip();
         _loc5_.addChild(new BotPlaceHolder());
         _loc5_.name = "Placeholder_" + param1;
         try
         {
            tf = new TextField();
            tf.text = param1;
            tf.textColor = 16777215;
            tf.background = true;
            tf.backgroundColor = 16711680;
            tf.width = 200;
            tf.height = 30;
            _loc5_.addChild(tf);
         }
         catch(e:Error)
         {
         }
         return _loc5_;
      }
      
      override public function dispose() : void
      {
         var _loc3_:* = undefined;
         var _loc2_:MapProperty = null;
         trace("🗑️ SceneProcessDataComponent.dispose() - Cleaning up");
         Dispatcher.removeEventListener("EXTENSIONS_LOADED",onExtensionsLoaded);
         _loc3_ = 0;
         while(_loc3_ < mapPropertyList.length)
         {
            _loc2_ = mapPropertyList[_loc3_];
            _loc2_.dispose();
            _loc3_++;
         }
         mapPropertyList = [];
         if(assetRequestQueue != null)
         {
            assetRequestQueue.dispose();
            assetRequestQueue = null;
            trace("📦 Asset request queue disposed");
         }
         for each(var _loc1_ in furnitureContextList)
         {
            if(_loc1_)
            {
               _loc1_.applicationDomain = null;
            }
         }
         furnitureContextList = new Vector.<LoaderContext>();
         if(roomContext != null)
         {
            roomContext.applicationDomain = null;
            roomContext = null;
         }
         requests = [];
         isDisposed = true;
         trace("✅ SceneProcessDataComponent disposed successfully");
      }
   }
}
