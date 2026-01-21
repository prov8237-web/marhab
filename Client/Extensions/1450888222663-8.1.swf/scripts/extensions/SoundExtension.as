package extensions
{
   import com.oyunstudyosu.extension.BaseExtension;
   import com.oyunstudyosu.utils.DefinitionUtils;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   
   public class SoundExtension extends BaseExtension
   {
       
      
      public var SOUNDS:Class;
      
      private var domain:ApplicationDomain;
      
      public function SoundExtension()
      {
         SOUNDS = §sounds_swf$0926a90a5edf8224120d1167c60439d4-786561917§;
         super();
         trace("####### SOUND #####");
      }
      
      public function getSoundClass(param1:String) : Class
      {
         var _loc2_:Class = DefinitionUtils.getClass(domain,param1);
         if(_loc2_)
         {
            return _loc2_;
         }
         return null;
      }
      
      override public function init(param1:Object = null) : void
      {
         super.init();
         var _loc3_:Object = new SOUNDS();
         var _loc2_:Loader = Loader((_loc3_ as DisplayObjectContainer).getChildAt(0));
         _loc2_.contentLoaderInfo.addEventListener("complete",onComplete);
      }
      
      protected function onComplete(param1:Event) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.target);
         _loc2_.removeEventListener("complete",onComplete);
         domain = _loc2_.applicationDomain;
         Sanalika.instance.soundModel.addSound("SoundKey.ALERT","",getSoundClass("Alert"));
         Sanalika.instance.soundModel.addSound("SoundKey.SANIL","",getSoundClass("Sanil"));
         Sanalika.instance.soundModel.addSound("SoundKey.BUTTON_CLICK","",getSoundClass("ButtonClick"));
         Sanalika.instance.soundModel.addSound("SoundKey.BUTTON_OVER","",getSoundClass("ButtonOver"));
         Sanalika.instance.soundModel.addSound("SoundKey.HUD_CLICK","",getSoundClass("HudClick"));
         Sanalika.instance.soundModel.addSound("SoundKey.COLLECT","",getSoundClass("Collect"));
         Sanalika.instance.soundModel.addSound("SoundKey.TADA","",getSoundClass("TaDa"));
         Sanalika.instance.soundModel.addSound("SoundKey.SAD","",getSoundClass("Sad"));
      }
      
      override public function dispose() : void
      {
         super.dispose();
         domain = null;
      }
   }
}
