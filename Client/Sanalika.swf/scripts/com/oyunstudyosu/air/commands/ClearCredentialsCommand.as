package com.oyunstudyosu.air.commands
{
   import com.junkbyte.console.Cc;
   import com.oyunstudyosu.air.controller.DataStorageController;
   import com.oyunstudyosu.air.embed.EmbedConfigData;
   import flash.Boot;
   import haxe.Exception;
   import haxe.ds.StringMap;
   
   public class ClearCredentialsCommand extends Command
   {
       
      
      public function ClearCredentialsCommand()
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         super();
      }
      
      override public function execute() : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null as Exception;
         var _loc12_:* = null;
         var _loc13_:int = 0;
         var _loc14_:Boolean = false;
         var _loc15_:* = null as String;
         var _loc16_:* = null as String;
         Cc.info("ClearCredentialsCommand.execute()");
         try
         {
            DataStorageController.get("username","");
         }
         catch(_loc_e_:*)
         {
            Cc.info("ClearCredentialsCommand.execute devam");
            DataStorageController.get("password","");
            var _loc4_:StringMap = EmbedConfigData.instances;
            _loc2_ = _loc4_.h;
            var _loc5_:* = _loc4_.rh;
            var _loc6_:int = 0;
            var _loc7_:Boolean = false;
            var _loc8_:* = _loc2_;
            var _loc9_:int = _loc6_;
            var _loc10_:Boolean = §§hasnext(_loc8_,_loc9_);
            if(!_loc10_ && _loc5_ != null)
            {
               _loc2_ = _loc5_;
               _loc8_ = _loc2_;
               _loc6_ = 0;
               _loc9_ = _loc6_;
               _loc5_ = null;
               _loc7_ = true;
               _loc10_ = §§hasnext(_loc8_,_loc9_);
            }
            var _loc11_:int = _loc9_;
            while(true)
            {
               _loc12_ = _loc2_;
               _loc13_ = _loc6_;
               _loc14_ = §§hasnext(_loc12_,_loc13_);
               if(!_loc14_ && _loc5_ != null)
               {
                  _loc2_ = _loc5_;
                  _loc12_ = _loc2_;
                  _loc6_ = 0;
                  _loc13_ = _loc6_;
                  _loc5_ = null;
                  _loc7_ = true;
                  _loc14_ = §§hasnext(_loc12_,_loc13_);
               }
               _loc11_ = _loc13_;
               if(!_loc14_)
               {
                  break;
               }
               _loc15_ = §§nextname(_loc11_,_loc2_);
               _loc6_ = _loc11_;
               if(_loc7_)
               {
                  _loc15_ = _loc15_.substr(1);
               }
               _loc16_ = _loc15_;
               DataStorageController.set(_loc16_ + "_email","");
               DataStorageController.set(_loc16_ + "_password","");
            }
            complete();
            return;
         }
      }
   }
}
