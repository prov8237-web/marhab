package com.oyunstudyosu.air.native
{
   import com.distriqt.extension.core.Core;
   import flash.Boot;
   import flash.display.NativeWindow;
   import flash.display.Stage;
   
   public class NativeExtensionModel
   {
       
      
      public var stage:Stage;
      
      public var nativeWindow:NativeWindow;
      
      public var googleAuthenticationModel:GoogleAuthenticationModel;
      
      public var facebokAuthenticationModel:FacebookAuthenticationModel;
      
      public function NativeExtensionModel(param1:Stage = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         stage = param1;
         Core.init();
         facebokAuthenticationModel = new FacebookAuthenticationModel();
         googleAuthenticationModel = new GoogleAuthenticationModel();
      }
   }
}
