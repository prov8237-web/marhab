package extensions
{
   import com.oyunstudyosu.extension.BaseExtension;
   import com.oyunstudyosu.sanalika.interfaces.ICursorExtension;
   import com.oyunstudyosu.utils.DefinitionUtils;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.system.ApplicationDomain;
   import flash.ui.Mouse;
   import flash.ui.MouseCursorData;
   
   public class CursorExtension extends BaseExtension implements ICursorExtension
   {
       
      
      public var CURSORS:Class;
      
      private var domain:ApplicationDomain;
      
      public function CursorExtension()
      {
         CURSORS = §cursors_swf$4c30b4daf1ae1575d55166ac5067d9c6-1980222646§;
         super();
      }
      
      public function getCursorClip(param1:String) : MovieClip
      {
         var _loc2_:Class = DefinitionUtils.getClass(domain,param1);
         if(_loc2_)
         {
            return new _loc2_();
         }
         return null;
      }
      
      override public function init(param1:Object = null) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Loader = null;
         super.init();
         if(Mouse.supportsNativeCursor)
         {
            _loc3_ = new CURSORS();
            _loc2_ = Loader((_loc3_ as DisplayObjectContainer).getChildAt(0));
            _loc2_.contentLoaderInfo.addEventListener("complete",onComplete);
         }
         else
         {
            dispose();
         }
      }
      
      protected function onComplete(param1:Event) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.target);
         _loc2_.removeEventListener("complete",onComplete);
         domain = _loc2_.applicationDomain;
         loadMouseCursor("interaction");
         loadMouseCursor("doorarrow0");
         loadMouseCursor("doorarrow1");
         loadMouseCursor("doorarrow3");
         loadMouseCursor("doorarrow5");
         loadMouseCursor("doorarrow7");
         loadMouseCursor("loading");
      }
      
      private function loadMouseCursor(param1:String) : void
      {
         var _loc2_:MovieClip = getCursorClip(param1);
         if(_loc2_ == null)
         {
            return;
         }
         addMouseCursor(param1,_loc2_);
      }
      
      public function addMouseCursor(param1:String, param2:MovieClip) : void
      {
         var _loc6_:BitmapData = null;
         var _loc7_:int = 0;
         if(param2 == null)
         {
            return;
         }
         var _loc4_:Vector.<BitmapData> = new Vector.<BitmapData>();
         var _loc5_:int = param2.totalFrames;
         _loc7_ = 0;
         while(_loc7_ < _loc5_)
         {
            param2.gotoAndStop(_loc7_);
            (_loc6_ = new BitmapData(32,32,true,0)).draw(param2);
            _loc4_.push(_loc6_);
            _loc7_++;
         }
         var _loc3_:MouseCursorData = new MouseCursorData();
         _loc3_.hotSpot = new Point(16,16);
         _loc3_.data = _loc4_;
         if(_loc5_ > 1)
         {
            _loc3_.frameRate = 24;
         }
         Mouse.registerCursor(param1,_loc3_);
      }
      
      public function removeMouseCursor(param1:String) : void
      {
         Mouse.unregisterCursor(param1);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeMouseCursor("interaction");
         removeMouseCursor("doorarrow0");
         removeMouseCursor("doorarrow1");
         removeMouseCursor("doorarrow3");
         removeMouseCursor("doorarrow5");
         removeMouseCursor("doorarrow7");
         removeMouseCursor("loading");
         domain = null;
      }
   }
}
