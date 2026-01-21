package com.oyunstudyosu.engine.core
{
   public class Vector3d
   {
       
      
      public var x:Number = 0;
      
      public var y:Number = 0;
      
      public var z:Number = 0;
      
      public function Vector3d(param1:Number = 0, param2:Number = 0, param3:Number = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.z = param3;
      }
      
      public function clone() : Vector3d
      {
         return new Vector3d(x,y,z);
      }
      
      public function equals(param1:Vector3d) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         return Math.abs(param1.x - x) < 0.00001 && Math.abs(param1.z - z) < 0.00001;
      }
      
      public function toString() : String
      {
         return "[" + x + " : " + y + " : " + z + "]";
      }
      
      public function minus(param1:Vector3d) : void
      {
         x -= param1.x;
         y -= param1.y;
         z -= param1.z;
      }
   }
}
