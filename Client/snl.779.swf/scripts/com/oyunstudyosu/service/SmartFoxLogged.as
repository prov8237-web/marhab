package com.oyunstudyosu.service
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.core.SFSEvent;
   import com.smartfoxserver.v2.requests.IRequest;
   import flash.events.Event;
   import flash.utils.getQualifiedClassName;
   
   public class SmartFoxLogged extends SmartFox
   {
       
      
      public var logger:Function;
      
      public var rawLogger:Function;
      
      public function SmartFoxLogged(debug:Boolean = false)
      {
         super(debug);
      }
      
      override public function send(request:IRequest) : void
      {
         var raw:String;
         var kind:String = null;
         var payload:Object = null;
         try
         {
            kind = getQualifiedClassName(request);
            payload = {};
            try
            {
               if("cmd" in request)
               {
                  payload["cmd"] = request["cmd"];
               }
            }
            catch(e0:Error)
            {
            }
            try
            {
               payload["toString"] = String(request);
            }
            catch(e1:Error)
            {
            }
            if(logger != null)
            {
               logger("OUT",kind,payload);
            }
            if(rawLogger != null)
            {
               try
               {
                  raw = String(request.toString());
                  rawLogger(raw,"OUT");
               }
               catch(e:Error)
               {
               }
            }
         }
         catch(e:Error)
         {
            trace("Error in SmartFoxLogged.send: " + e.message);
         }
         super.send(request);
      }
      
      override public function dispatchEvent(event:Event) : Boolean
      {
         var params:Object;
         var raw:String;
         var kind:String = null;
         var payload:Object = null;
         try
         {
            kind = event.type;
            payload = {};
            try
            {
               if(event is SFSEvent)
               {
                  payload["params"] = SFSEvent(event).params;
               }
            }
            catch(e0:Error)
            {
            }
            try
            {
               payload["toString"] = String(event);
            }
            catch(e1:Error)
            {
            }
            if(logger != null)
            {
               logger("IN",kind,payload);
            }
            if(rawLogger != null && event is SFSEvent)
            {
               try
               {
                  params = SFSEvent(event).params;
                  raw = JSON.stringify(params);
                  rawLogger(raw,"IN");
               }
               catch(e:Error)
               {
               }
            }
         }
         catch(e:Error)
         {
            trace("Error in SmartFoxLogged.dispatchEvent: " + e.message);
         }
         return super.dispatchEvent(event);
      }
   }
}
