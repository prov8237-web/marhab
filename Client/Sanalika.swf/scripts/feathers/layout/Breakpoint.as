package feathers.layout
{
   import flash.Boot;
   
   public final class Breakpoint
   {
      
      public static var LG:Breakpoint;
      
      public static var MD:Breakpoint;
      
      public static var SM:Breakpoint;
      
      public static var XL:Breakpoint;
      
      public static var XS:Breakpoint;
      
      public static var XXL:Breakpoint;
      
      public static var __constructs__:Array;
      
      public static const __isenum:Boolean = true;
       
      
      public var tag:String;
      
      public var index:int;
      
      public var params:Array;
      
      public const __enum__:Boolean = true;
      
      public function Breakpoint(param1:String, param2:int, param3:Array)
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
