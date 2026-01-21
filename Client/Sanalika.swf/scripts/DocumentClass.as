package
{
   import flash.Boot;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   
   public class DocumentClass extends SanalikaClient
   {
       
      
      public function DocumentClass(param1:DisplayObjectContainer = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         param1.addChild(this);
         super();
         dispatchEvent(new Event(Event.ADDED_TO_STAGE,false,false));
      }
   }
}
