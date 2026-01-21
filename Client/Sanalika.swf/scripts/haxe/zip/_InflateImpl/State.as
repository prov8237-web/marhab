package haxe.zip._InflateImpl
{
   import flash.Boot;
   
   public final class State
   {
      
      public static var Block:State;
      
      public static var CData:State;
      
      public static var Crc:State;
      
      public static var Dist:State;
      
      public static var DistOne:State;
      
      public static var Done:State;
      
      public static var Flat:State;
      
      public static var Head:State;
      
      public static var __constructs__:Array;
      
      public static const __isenum:Boolean = true;
       
      
      public var tag:String;
      
      public var index:int;
      
      public var params:Array;
      
      public const __enum__:Boolean = true;
      
      public function State(param1:String, param2:int, param3:Array)
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
