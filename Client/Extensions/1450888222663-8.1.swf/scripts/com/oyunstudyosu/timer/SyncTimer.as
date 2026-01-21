package com.oyunstudyosu.timer
{
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class SyncTimer
   {
      
      private static var diff:int = 0;
      
      private static var _timestamp:int = 0;
      
      private static var timers:Array = [];
      
      private static var eventListenerInterval:uint;
       
      
      private var _timerID:String;
      
      public function SyncTimer(param1:int, param2:int = 1)
      {
         super();
         if(!inited)
         {
            throw new Error();
         }
         _timerID = create();
         var _loc3_:TimerVo = get(_timerID);
         _loc3_.second = param1;
         _loc3_.repeatCount = param2;
      }
      
      public static function get inited() : Boolean
      {
         if(_timestamp == 0 || diff == 0)
         {
            return false;
         }
         return true;
      }
      
      public static function get timestamp() : int
      {
         if(!inited)
         {
            return 0;
         }
         return _timestamp + deviceTimestamp - diff - 2;
      }
      
      public static function setTimestamp(param1:int) : void
      {
         _timestamp = param1;
         diff = deviceTimestamp;
         clearInterval(eventListenerInterval);
         eventListenerInterval = setInterval(check,1000);
      }
      
      private static function get deviceTimestamp() : int
      {
         var _loc2_:Date = new Date();
         var _loc1_:Number = _loc2_.getTime();
         return _loc1_ / 1000;
      }
      
      private static function create() : String
      {
         var _loc2_:TimerVo = new TimerVo();
         _loc2_.createTimestamp = timestamp;
         var _loc1_:String = "t_" + timestamp;
         timers[_loc1_] = _loc2_;
         return _loc1_;
      }
      
      private static function get(param1:String) : TimerVo
      {
         return timers[param1];
      }
      
      private static function remove(param1:String) : void
      {
         delete timers[param1];
      }
      
      private static function addCallback(param1:String, param2:Function) : void
      {
         var _loc3_:TimerVo = get(param1);
         if(_loc3_.callback == null)
         {
            _loc3_.callback = new Vector.<Function>();
         }
         _loc3_.callback.push(param2);
      }
      
      private static function check() : void
      {
         var _loc3_:TimerVo = null;
         for(var _loc1_ in timers)
         {
            _loc3_ = timers[_loc1_];
            if(_loc3_.started == false)
            {
               if(_loc3_.createTimestamp + 60 < timestamp)
               {
                  remove(_loc1_);
               }
            }
            else if(!(_loc3_.callback == null || _loc3_.callback.length == 0))
            {
               if(timestamp % _loc3_.second == 0)
               {
                  for each(var _loc2_ in _loc3_.callback)
                  {
                     _loc2_();
                  }
               }
            }
         }
      }
      
      public function get second() : int
      {
         var _loc1_:TimerVo = get(_timerID);
         return _loc1_.second;
      }
      
      public function set second(param1:int) : void
      {
         var _loc2_:TimerVo = get(_timerID);
         _loc2_.second = param1;
      }
      
      public function get repeatCount() : int
      {
         var _loc1_:TimerVo = get(_timerID);
         return _loc1_.repeatCount;
      }
      
      public function set repeatCount(param1:int) : void
      {
         var _loc2_:TimerVo = get(_timerID);
         _loc2_.repeatCount = param1;
      }
      
      public function addEventListener(param1:Function) : void
      {
         addCallback(_timerID,param1);
      }
      
      public function start() : void
      {
         var _loc1_:TimerVo = get(_timerID);
         _loc1_.started = true;
      }
      
      public function remove() : void
      {
      }
   }
}
