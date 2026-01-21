package com.oyunstudyosu.air.alert
{
   import flash.Boot;
   
   public final class AlertResponse
   {
      
      public static var CANCEL:AlertResponse;
      
      public static var CLOSE:AlertResponse;
      
      public static var NO:AlertResponse;
      
      public static var OK:AlertResponse;
      
      public static var YES:AlertResponse;
      
      public static var __constructs__:Array;
      
      public static const __isenum:Boolean = true;
       
      
      public var tag:String;
      
      public var index:int;
      
      public var params:Array;
      
      public const __enum__:Boolean = true;
      
      public function AlertResponse(param1:String, param2:int, param3:Array)
      {
         tag = param1;
         index = param2;
         params = param3;
      }
      
      final public function toString() : String
      {
         return Boot.enum_to_string(this);
      }
   }
}
