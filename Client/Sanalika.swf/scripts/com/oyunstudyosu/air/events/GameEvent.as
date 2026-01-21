package com.oyunstudyosu.air.events
{
   import flash.Boot;
   import flash.events.Event;
   
   public class GameEvent extends Event
   {
      
      public static var INSTANCE_SELECTED:String;
      
      public static var INITIALIZE:String;
      
      public static var INSTANCE_DETECTED:String;
      
      public static var NO_INSTANCE_DETECTED:String;
      
      public static var NO_CONTAINER_DETECTED:String;
      
      public static var INVALID_DOMAIN_DETECTED:String;
      
      public static var EXTENSIONS_LOADED:String;
      
      public static var ITEM_INFO_FILE_LOADED:String;
      
      public static var VERSION_FILE_LOADED:String;
      
      public static var LOGOUT_COMPLETE:String;
      
      public static var INITCOMMAND:String;
      
      public static var SCENE_LOADED:String;
      
      public static var SCENE_DATA_LOADED:String;
      
      public static var TERMINATE_PROVISION:String;
      
      public static var TERMINATE_SCENE:String;
      
      public static var TERMINATE_GAME:String;
      
      public static var STOP_RAIN:String;
      
      public static var RESIZE:String;
      
      public static var RELOAD:String;
      
      public static var USER_LEAVE_ROOM:String;
      
      public static var USER_ENTER_ROOM:String;
      
      public static var USER_POSITION_UPDATED:String;
      
      public static var TRANSITION_IN:String;
      
      public static var TRANSITION_IN_COMPLETE:String;
      
      public static var TRANSITION_OUT:String;
      
      public static var TRANSITION_OUT_COMPLETE:String;
      
      public static var TRANSFER_ITEM:String;
      
      public static var ACTIVE_GRID_CHANGED:String;
      
      public static var SAVE_AVATAR_IMAGE:String;
      
      public static var SAVE_ROOM_IMAGE:String;
      
      public static var SAVE_TEMP_IMAGE:String;
      
      public static var SS_IMAGE:String;
      
      public static var STAGE_IMAGE:String;
      
      public static var PLAYBACK_ALLOW:String;
      
      public static var ROOM_IMAGE_SAVED:String;
      
      public static var ROOM_MAP_INITIALIZED:String;
      
      public static var PREVIOUS_ROOM:String;
      
      public static var CANVAS_HEIGHT_CHANGED:String;
      
      public static var FACEBOOK_AUTHENTICATION:String;
      
      public static var GOOGLE_AUTHENTICATION:String;
       
      
      public var lang:String;
      
      public var id:String;
      
      public var data:*;
      
      public function GameEvent(param1:String = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         super(param1,true,false);
      }
      
      override public function clone() : Event
      {
         var _loc1_:GameEvent = new GameEvent(type);
         _loc1_.id = id;
         _loc1_.data = data;
         return _loc1_;
      }
   }
}
