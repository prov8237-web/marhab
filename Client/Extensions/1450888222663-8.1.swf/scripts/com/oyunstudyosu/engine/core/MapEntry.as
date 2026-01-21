package com.oyunstudyosu.engine.core
{
   import com.oyunstudyosu.engine.IntPoint;
   import com.oyunstudyosu.engine.IsoScene;
   import com.oyunstudyosu.engine.pool.model.GamePoolModel;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.xml.XMLNode;
   
   public class MapEntry
   {
       
      
      public var x:int;
      
      public var y:int;
      
      public var z:int;
      
      public var f:int;
      
      public var s:int;
      
      public var fx:int;
      
      public var lc:int;
      
      public var st:int;
      
      public var sv:int;
      
      public var width:Number;
      
      public var height:Number;
      
      public var depth:Number;
      
      public var type:String;
      
      public var entryType:int;
      
      public var definition:String;
      
      public var gameZoneId:String;
      
      public var id:String;
      
      public var gameType:int;
      
      public var dir:int;
      
      public var arg:String;
      
      public var maskDefinition:String;
      
      public var objectMask:MovieClip;
      
      public var center:Point;
      
      public var heighInPx:Number;
      
      public var chairs:Array;
      
      public var hasReservedGrids:Boolean;
      
      public var enabled:Boolean;
      
      public var element:IsoElement;
      
      public var interactiveName:String;
      
      private var _clip:MovieClip;
      
      public var count:int = 1;
      
      public var currentCount:int = 0;
      
      public var targetCellPoint:Point;
      
      public var action:String;
      
      public var stuffType:int;
      
      public var room:String;
      
      public var interactive:Boolean;
      
      public var property:String;
      
      private var cell:Cell;
      
      private var multiCell:Cell;
      
      private var dirs:Array;
      
      public function MapEntry(param1:XMLNode = null)
      {
         var _loc3_:Array = null;
         super();
         if(param1 == null)
         {
            return;
         }
         this.type = param1.nodeName;
         switch(type)
         {
            case "chair":
               entryType = 1;
               break;
            case "poolEntry":
               entryType = 5;
               break;
            case "pool":
               entryType = 4;
               break;
            case "farm":
               entryType = 6;
               break;
            case "floor":
               entryType = 8;
               break;
            case "stuff":
               entryType = 3;
               this.action = param1.attributes["a"];
               if(param1.attributes["tc"])
               {
                  _loc3_ = JSON.parse(param1.attributes["tc"]) as Array;
                  this.targetCellPoint = new Point(_loc3_[0],_loc3_[1]);
               }
               break;
            case "cencor":
               entryType = 7;
               count = parseInt(param1.attributes["count"]);
               break;
            default:
               entryType = 0;
         }
         this.x = parseInt(param1.attributes["x"]);
         this.y = parseInt(param1.attributes["y"]);
         this.z = parseInt(param1.attributes["z"]);
         this.f = parseInt(param1.attributes["f"]);
         this.s = parseInt(param1.attributes["s"]);
         this.fx = parseInt(param1.attributes["fx"]);
         this.lc = parseInt(param1.attributes["lc"]);
         this.st = parseInt(param1.attributes["st"]);
         this.sv = parseInt(param1.attributes["sv"]);
         this.width = parseInt(param1.attributes["w"]);
         this.height = parseFloat(param1.attributes["h"]);
         this.enabled = param1.attributes["enabled"] != null ? param1.attributes["enabled"] == "1" : true;
         this.depth = parseInt(param1.attributes["d"]);
         this.definition = param1.attributes["def"];
         this.id = param1.attributes["id"] == null ? "0" : param1.attributes["id"];
         this.gameZoneId = param1.attributes["gamezoneid"] == undefined ? "" : param1.attributes["gamezoneid"];
         this.gameType = param1.attributes["type"] == undefined ? -1 : param1.attributes["type"];
         if(param1.attributes["interactive"] == "true")
         {
            this.interactive = true;
         }
         if(interactive)
         {
            property = param1.lastChild.nodeValue;
         }
         if(gameType != -1)
         {
            if(gameType == 1)
            {
               GamePoolModel.gamesuits = GamePoolModel.swimsuits;
            }
            else if(gameType == 2)
            {
               GamePoolModel.gamesuits = GamePoolModel.iceTickets;
            }
         }
         this.dir = param1.attributes["dir"] != null ? parseInt(param1.attributes["dir"]) : 0;
         this.arg = param1.attributes["arg"];
         this.maskDefinition = param1.attributes["mask"];
         for each(var _loc2_ in param1.childNodes)
         {
            var _loc4_:* = _loc2_.nodeName;
            if("chairs" === _loc4_)
            {
               processChairs(_loc2_);
            }
         }
      }
      
      public function toString() : String
      {
         return "MapEntry : type[" + type + "] entryType[" + entryType + "] def[" + definition + "] stuffType[" + stuffType + "] mask[" + maskDefinition + "] action[" + action + "] id[" + id + "] dir[" + dir + "] x[" + x + "] y[" + y + "] z[" + z + "] w[" + width + "] h[" + height + "] d[" + depth + "] arg[" + arg + "] enabled[" + enabled + "] room[" + room + "]";
      }
      
      public function get clip() : MovieClip
      {
         return _clip;
      }
      
      public function set clip(param1:MovieClip) : void
      {
         _clip = param1;
      }
      
      public function getEntryData() : Object
      {
         var _loc1_:Object = {};
         _loc1_.x = x;
         _loc1_.y = y;
         _loc1_.z = z;
         _loc1_.f = f;
         _loc1_.s = s;
         _loc1_.fx = fx;
         _loc1_.lc = lc;
         _loc1_.st = st;
         _loc1_.sv = sv;
         _loc1_.id = id;
         _loc1_.width = width;
         _loc1_.height = height;
         _loc1_.depth = depth;
         _loc1_.definition = definition;
         _loc1_.clip = clip;
         return _loc1_;
      }
      
      public function check4Errors() : Boolean
      {
         if(definition == null || width == 0 || depth == 0)
         {
            return true;
         }
         return false;
      }
      
      public function createStaticItem() : void
      {
      }
      
      public function init(param1:IsoScene) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         if(width == 1 && depth == 1)
         {
            center = param1.getPosFromGrid(x,z);
            cell = param1.getCellAt(x,y,z);
            if(cell == null)
            {
               return;
            }
            cell.setMapEntry(this);
            if(entryType != 8)
            {
               cell.cellType = CellType.TYPE_DISABLED;
            }
            if(maskDefinition != null)
            {
               cell.objectMask = param1.getMovieClip(maskDefinition);
            }
         }
         else
         {
            center = param1.get2dPoint((x + width - 1) * 18.07,0,(z + depth - 1) * 18.07);
            if(maskDefinition != null)
            {
               this.objectMask = param1.getMovieClip(maskDefinition);
            }
            _loc3_ = 0;
            while(_loc3_ < width)
            {
               _loc2_ = 0;
               while(_loc2_ < depth)
               {
                  multiCell = param1.getCellAt(x + _loc3_,y,z + _loc2_);
                  if(multiCell != null)
                  {
                     multiCell.setMapEntry(this);
                     if(entryType != 8)
                     {
                        multiCell.cellType = CellType.TYPE_DISABLED;
                     }
                  }
                  _loc2_++;
               }
               _loc3_++;
            }
         }
         heighInPx = height * 18.07;
      }
      
      public function getDirOfChair(param1:IntPoint) : int
      {
         if(param1 == null)
         {
            throw new Error("Null grid");
         }
         if(hasReservedGrids)
         {
            for each(var _loc2_ in chairs)
            {
               if(_loc2_.grid.equals(param1))
               {
                  return _loc2_.dir;
               }
            }
            return 4;
         }
         return (dir + 4) % 8;
      }
      
      private function processChairs(param1:XMLNode) : void
      {
         chairs = [];
         for each(var _loc2_ in param1.childNodes)
         {
            if(_loc2_ && _loc2_.nodeType != 3)
            {
               hasReservedGrids = true;
               chairs.push({
                  "type":_loc2_.nodeName,
                  "grid":new IntPoint(parseInt(_loc2_.attributes["x"]),parseInt(_loc2_.attributes["z"])),
                  "dir":parseInt(_loc2_.attributes["dir"]),
                  "inUse":false,
                  "h":(!!_loc2_.attributes["h"] ? parseFloat(_loc2_.attributes["h"]) : 0),
                  "maskDefinition":_loc2_.attributes["mask"]
               });
            }
         }
      }
      
      public function getFrontPos(param1:IsoScene, param2:Cell = null) : IntPoint
      {
         var _loc4_:IntPoint = null;
         var _loc10_:int = 0;
         if(entryType == 0)
         {
            throw new Error("Not an interactive object!");
         }
         var _loc5_:int = dir;
         var _loc9_:int = x;
         var _loc8_:int = y;
         var _loc7_:int = z;
         if(param2)
         {
            for each(var _loc3_ in chairs)
            {
               if(param2.posMatrix.equals(_loc3_.grid))
               {
                  _loc5_ = int(_loc3_.dir);
                  _loc9_ = int(_loc3_.grid.x);
                  _loc7_ = int(_loc3_.grid.y);
                  break;
               }
            }
         }
         var _loc6_:* = _loc4_ = param1.getPointAtDir(_loc5_,_loc9_,_loc8_,_loc7_);
         cell = param1.getCellAtPoint(_loc6_);
         if(cell != null && cell.cellType == CellType.TYPE_DISABLED)
         {
            _loc6_ = null;
            dirs = [2,1,3];
            _loc10_ = 0;
            while(_loc10_ < 3)
            {
               _loc6_ = param1.getPointAtDir(_loc5_ + dirs[_loc10_],_loc9_,_loc8_,_loc7_);
               if(param1.getCellAtPoint(_loc6_).cellType != CellType.TYPE_DISABLED)
               {
                  break;
               }
               _loc6_ = param1.getPointAtDir(_loc5_ - dirs[_loc10_],_loc9_,_loc8_,_loc7_);
               if(param1.getCellAtPoint(_loc6_).cellType != CellType.TYPE_DISABLED)
               {
                  break;
               }
               _loc10_++;
            }
            if(_loc6_ == null)
            {
               _loc6_ = param1.getPointAtDir(_loc5_ - 4,_loc9_,_loc8_,_loc7_);
            }
         }
         cell = null;
         return _loc6_;
      }
      
      public function dispose() : void
      {
         if(element)
         {
            element.dispose();
         }
         element = null;
         if(cell)
         {
            cell.dispose();
         }
         cell = null;
         if(multiCell)
         {
            multiCell.dispose();
         }
         multiCell = null;
         if(objectMask)
         {
            objectMask.removeChildren();
         }
         objectMask = null;
         if(clip)
         {
            clip.removeChildren();
         }
         clip = null;
         dirs = null;
         chairs = null;
      }
   }
}
