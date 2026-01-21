package lime.system._ThreadPool
{
   import flash.Boot;
   
   public final class ThreadPoolMessageType
   {
      
      public static var COMPLETE:ThreadPoolMessageType;
      
      public static var ERROR:ThreadPoolMessageType;
      
      public static var EXIT:ThreadPoolMessageType;
      
      public static var PROGRESS:ThreadPoolMessageType;
      
      public static var WORK:ThreadPoolMessageType;
      
      public static var __constructs__:Array;
      
      public static const __isenum:Boolean = true;
       
      
      public var tag:String;
      
      public var index:int;
      
      public var params:Array;
      
      public const __enum__:Boolean = true;
      
      public function ThreadPoolMessageType(param1:String, param2:int, param3:Array)
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
