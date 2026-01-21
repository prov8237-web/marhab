package com.oyunstudyosu.engine.character
{
   import com.oyunstudyosu.cloth.ClothType;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class IdleCacher extends Sprite
   {
      
      private static var compatibleItemList:Dictionary = new Dictionary();
       
      
      public function IdleCacher()
      {
         super();
      }
      
      public static function check(param1:Character, param2:String) : Boolean
      {
         var _loc3_:MovieClip = null;
         if(param1.isCachingCompatible(param2) == null)
         {
            _loc3_ = new MovieClip();
            param1.drawCharWithoutDrawTest(_loc3_);
            gotoAndStopAll(_loc3_,param2);
            if(checkStaticAnimation(_loc3_))
            {
               param1.addCachingCompatibleItem(param2,true);
            }
            else
            {
               param1.addCachingCompatibleItem(param2,false);
            }
         }
         return param1.isCachingCompatible(param2);
      }
      
      public static function cache(param1:Character, param2:String) : SimpleCachedCharacterClip
      {
         var _loc13_:int = 0;
         var _loc11_:* = undefined;
         var _loc18_:Array = null;
         var _loc8_:Rectangle = null;
         var _loc7_:Array = [];
         var _loc14_:int = 0;
         var _loc6_:int = -1;
         var _loc9_:int = -1;
         var _loc17_:int = -1;
         var _loc15_:MovieClip = new MovieClip();
         param1.drawCharWithoutDrawTest(_loc15_);
         try
         {
            gotoAndStopAll(_loc15_,param2);
            _loc18_ = getAllParentChilds(_loc15_);
         }
         catch(e:Error)
         {
            return null;
         }
         _loc13_ = 0;
         while(_loc13_ < _loc15_.numChildren)
         {
            if(!((_loc11_ = _loc15_.getChildAt(_loc13_)) is SimpleCachedCharacterClip))
            {
               if(_loc11_.placeBit > _loc6_)
               {
                  _loc6_ = int(_loc11_.placeBit);
               }
               if(_loc11_.maxPlaceBit > _loc9_)
               {
                  _loc9_ = int(_loc11_.maxPlaceBit);
               }
               if(_loc11_.frameBit > _loc17_)
               {
                  _loc17_ = int(_loc11_.frameBit);
               }
            }
            _loc13_++;
         }
         var _loc16_:Array = [];
         _loc18_ = null;
         gotoAndStopAll(_loc15_,param2);
         _loc18_ = getAllParentChilds(_loc15_);
         try
         {
         }
         catch(e:Error)
         {
            return null;
         }
         var _loc5_:MovieClip = new MovieClip();
         for each(var _loc3_ in _loc18_)
         {
            _loc8_ = _loc3_.getRect(Sanalika.instance.stage);
            _loc5_.addChild(_loc3_);
         }
         if(_loc5_.numChildren == 0)
         {
            return null;
         }
         var _loc10_:Rectangle = _loc5_.getBounds(_loc5_);
         var _loc12_:BitmapData;
         (_loc12_ = new BitmapData(int(_loc10_.width + 0.5),int(_loc10_.height + 0.5),true,0)).draw(_loc5_,new Matrix(1,0,0,1,-_loc10_.x,-_loc10_.y));
         var _loc4_:SimpleCachedCharacterClip;
         (_loc4_ = new SimpleCachedCharacterClip(_loc12_)).x = _loc10_.x;
         _loc4_.y = _loc10_.y;
         return _loc4_;
      }
      
      private static function checkStaticAnimation(param1:MovieClip) : Boolean
      {
         var _loc4_:int = 0;
         var _loc2_:* = undefined;
         var _loc5_:int = 0;
         var _loc3_:Boolean = false;
         _loc4_ = 0;
         while(_loc4_ < param1.numChildren)
         {
            _loc2_ = param1.getChildAt(_loc4_);
            if(!(_loc2_ is SimpleCachedCharacterClip))
            {
               _loc5_ = 0;
               while(_loc5_ < _loc2_.numChildren)
               {
                  if(!(!_loc2_.hasOwnProperty("frameBit") || _loc2_.placeBit == ClothType.BIT22_HANDITEM))
                  {
                     _loc3_ = checkChildStaticAnimation(_loc2_);
                     if(_loc3_ == false)
                     {
                        return false;
                     }
                  }
                  _loc5_++;
               }
            }
            _loc4_++;
         }
         return true;
      }
      
      private static function checkChildStaticAnimation(param1:MovieClip) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:* = undefined;
         _loc3_ = 0;
         while(_loc3_ < param1.numChildren)
         {
            _loc2_ = param1.getChildAt(_loc3_);
            if(_loc2_ is MovieClip)
            {
               if((_loc2_ as MovieClip).totalFrames > 1)
               {
                  return false;
               }
               return checkChildStaticAnimation(_loc2_);
            }
            _loc3_++;
         }
         return true;
      }
      
      private static function getAllParentChilds(param1:MovieClip) : Array
      {
         var _loc3_:int = 0;
         var _loc2_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < param1.numChildren)
         {
            _loc2_ = param1.getChildAt(_loc3_);
            if(!(_loc2_ is SimpleCachedCharacterClip || !_loc2_.hasOwnProperty("frameBit") || _loc2_.placeBit == ClothType.BIT22_HANDITEM))
            {
               _loc4_ = 0;
               while(_loc4_ < _loc2_.numChildren)
               {
                  _loc5_.push(_loc2_.getChildAt(_loc4_));
                  _loc4_++;
               }
            }
            _loc3_++;
         }
         return _loc5_;
      }
      
      private static function gotoAndStopAll(param1:MovieClip, param2:Object, param3:String = null) : void
      {
         var _loc5_:int = 0;
         var _loc4_:* = undefined;
         _loc5_ = 0;
         while(_loc5_ < param1.numChildren)
         {
            if(!((_loc4_ = param1.getChildAt(_loc5_)) is SimpleCachedCharacterClip || !_loc4_.hasOwnProperty("frameBit") || _loc4_.placeBit == ClothType.BIT22_HANDITEM))
            {
               _loc4_.gotoAndStop(param2,param3);
            }
            _loc5_++;
         }
      }
      
      private function dispose() : void
      {
      }
   }
}
