package com.oyunstudyosu.engine.core
{
   import com.oyunstudyosu.engine.IntPoint;
   import com.oyunstudyosu.engine.IsoScene;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   
   public class Cell extends EventDispatcher implements ICell
   {
       
      
      public var pos3d:Vector3d;
      
      public var pos2d:Point;
      
      public var posMatrix:IntPoint;
      
      public var parent:Cell;
      
      public var g:Number = 0;
      
      public var h:Number = 0;
      
      public var cost:Number = 1;
      
      public var zIndex:uint;
      
      public var baseZIndex:uint;
      
      public var objectMask:MovieClip;
      
      public var parentMapEntry:MapEntry;
      
      private var _bit:int;
      
      private var _cellType:int;
      
      public var eventDispatcherCharNick:String;
      
      private var _isObjectInUse:Boolean;
      
      public function Cell(param1:int, param2:int)
      {
         super();
         posMatrix = new IntPoint(param1,param2);
      }
      
      public function get isObjectInUse() : Boolean
      {
         return _isObjectInUse;
      }
      
      public function set isObjectInUse(param1:Boolean) : void
      {
         if(_isObjectInUse == param1)
         {
            return;
         }
         _isObjectInUse = param1;
      }
      
      public function get bit() : int
      {
         return _bit;
      }
      
      public function set bit(param1:int) : void
      {
         _bit = param1;
      }
      
      public function get cellType() : int
      {
         return _cellType;
      }
      
      public function set cellType(param1:int) : void
      {
         _cellType = param1;
      }
      
      public function terminate() : void
      {
         pos3d = null;
         pos2d = null;
         posMatrix = null;
         parent = null;
         objectMask = null;
         dispose();
      }
      
      public function get x() : Number
      {
         return posMatrix.x;
      }
      
      public function get y() : Number
      {
         return posMatrix.y;
      }
      
      public function get f() : Number
      {
         return g + h;
      }
      
      public function get sittable() : Boolean
      {
         return parentMapEntry != null && parentMapEntry.entryType == 1;
      }
      
      public function get usable() : Boolean
      {
         if(cellType == CellType.TYPE_TARGET)
         {
            return true;
         }
         return parentMapEntry != null && parentMapEntry.entryType == 3;
      }
      
      public function get swimmable() : Boolean
      {
         return parentMapEntry != null && parentMapEntry.entryType == 5;
      }
      
      public function get isPool() : Boolean
      {
         return parentMapEntry != null && parentMapEntry.entryType == 4;
      }
      
      public function isCencored() : Boolean
      {
         if(parentMapEntry != null && parentMapEntry.entryType == 7)
         {
            for each(var _loc1_ in parentMapEntry.chairs)
            {
               if(posMatrix.equals(_loc1_.grid))
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function get playable() : Boolean
      {
         return parentMapEntry != null && parentMapEntry.entryType == 2;
      }
      
      public function isSelectable(param1:int) : Boolean
      {
         return isWalkable(param1);
      }
      
      public function isWalkable(param1:int) : Boolean
      {
         return ((bit | param1) == param1 || param1 == 1 && bit < 0) && (cellType == CellType.TYPE_EMPTY || cellType == CellType.TYPE_WALK_ONLY) || cellType == CellType.TYPE_SANALIKAX && Boolean(Sanalika.instance.avatarModel.permission.check(32)) || cellType == CellType.TYPE_DIAMOND && Boolean(Sanalika.instance.avatarModel.permission.check(14)) || cellType == CellType.TYPE_ADMIN && Boolean(Sanalika.instance.avatarModel.permission.check(20));
      }
      
      override public function toString() : String
      {
         return "[CELL:" + posMatrix.x + "/" + posMatrix.y + " | cellType:" + cellType + "]";
      }
      
      public function equals(param1:ICell) : Boolean
      {
         return param1.x == x && param1.y == y;
      }
      
      public function get objectType() : int
      {
         if(parentMapEntry != null)
         {
            return parentMapEntry.entryType;
         }
         return 0;
      }
      
      public function get charAction() : String
      {
         if(parentMapEntry != null)
         {
            return parentMapEntry.action;
         }
         return null;
      }
      
      public function setMapEntry(param1:MapEntry) : void
      {
         this.parentMapEntry = param1;
      }
      
      public function getFrontPos(param1:IsoScene) : IntPoint
      {
         if(parentMapEntry != null)
         {
            return parentMapEntry.getFrontPos(param1,this);
         }
         return posMatrix.clone();
      }
      
      public function dispose() : void
      {
         if(parent)
         {
            parent.dispose();
         }
         parent = null;
         parentMapEntry = null;
      }
   }
}
