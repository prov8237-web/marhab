package com.oyunstudyosu.item
{
   import com.hurlant.crypto.Crypto;
   import com.hurlant.crypto.symmetric.ICipher;
   import com.hurlant.crypto.symmetric.IPad;
   import com.hurlant.crypto.symmetric.PKCS5;
   import com.hurlant.util.Base64;
   import com.hurlant.util.Hex;
   import flash.display.Sprite;
   import flash.utils.ByteArray;
   
   public final class CryptoCode extends Sprite
   {
      
      private static var type:String = "simple-des-ecb";
      
      private static var key:ByteArray;
      
      private static var pass:String = "o1p26]Co";
       
      
      public function CryptoCode()
      {
         super();
      }
      
      public static function encrypt(param1:ByteArray) : String
      {
         key = Hex.toArray(Hex.fromString(pass));
         var _loc2_:IPad = new PKCS5();
         var _loc3_:ICipher = Crypto.getCipher(type,key,_loc2_);
         _loc2_.setBlockSize(_loc3_.getBlockSize());
         _loc3_.encrypt(param1);
         return Base64.encodeByteArray(param1);
      }
      
      public static function decrypt(param1:ByteArray) : String
      {
         key = Hex.toArray(Hex.fromString(pass));
         var _loc2_:IPad = new PKCS5();
         var _loc3_:ICipher = Crypto.getCipher(type,key,_loc2_);
         _loc2_.setBlockSize(_loc3_.getBlockSize());
         _loc3_.decrypt(param1);
         return Hex.toString(Hex.fromArray(param1));
      }
      
      public static function encryptString(param1:String = "") : String
      {
         key = Hex.toArray(Hex.fromString(pass));
         var _loc3_:ByteArray = Hex.toArray(Hex.fromString(param1));
         var _loc2_:IPad = new PKCS5();
         var _loc4_:ICipher = Crypto.getCipher(type,key,_loc2_);
         _loc2_.setBlockSize(_loc4_.getBlockSize());
         _loc4_.encrypt(_loc3_);
         return Base64.encodeByteArray(_loc3_);
      }
      
      public static function decryptString(param1:String = "") : String
      {
         key = Hex.toArray(Hex.fromString(pass));
         var _loc3_:ByteArray = Base64.decodeToByteArray(param1);
         var _loc2_:IPad = new PKCS5();
         var _loc4_:ICipher = Crypto.getCipher(type,key,_loc2_);
         _loc2_.setBlockSize(_loc4_.getBlockSize());
         _loc4_.decrypt(_loc3_);
         return Hex.toString(Hex.fromArray(_loc3_));
      }
   }
}
