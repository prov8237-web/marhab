package com.oyunstudyosu.property
{
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.auth.PermissionUtils;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.local.$;
   import com.printfas3.printf;
   
   public class PassageProperty extends Property
   {
       
      
      public function PassageProperty()
      {
         super();
      }
      
      override public function execute(param1:String = "") : void
      {
         var _loc2_:Boolean = false;
         var _loc5_:Array = null;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:AlertVo = null;
         if(data.roles)
         {
            if(PermissionUtils.grantedIndexes(data.roles).toString() == "25")
            {
               _loc2_ = false;
               _loc5_ = new Array("4t9fcyc9_7","w22hz6h8_6","yzsx37uv_9","t6rvecre_10","g7yu68yh_9","06h36hb2_6");
               _loc4_ = 0;
               while(_loc4_ < Sanalika.instance.avatarModel.clothesOn.length)
               {
                  _loc6_ = 0;
                  while(_loc6_ < _loc5_.length)
                  {
                     if(Sanalika.instance.avatarModel.clothesOn[_loc4_] == _loc5_[_loc6_])
                     {
                        _loc2_ = true;
                        break;
                     }
                     _loc6_++;
                  }
                  _loc4_++;
               }
               if(!_loc2_)
               {
                  _loc3_ = new AlertVo();
                  _loc3_.alertType = "tooltip";
                  _loc3_.description = printf($("REQUIREMENTS"),$("ROLE_ERROR_SPACE_COSTUME"));
                  Dispatcher.dispatchEvent(new AlertEvent(_loc3_));
                  return;
               }
            }
         }
         Sanalika.instance.roomModel.doorModel.busy = true;
         Sanalika.instance.roomModel.mapInitalized = false;
         Sanalika.instance.serviceModel.requestData("usedoor",{
            "key":param1,
            "type":data.type
         },null);
      }
   }
}
