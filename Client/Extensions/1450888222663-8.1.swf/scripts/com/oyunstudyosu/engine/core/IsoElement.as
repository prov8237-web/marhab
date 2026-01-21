package com.oyunstudyosu.engine.core
{
   import com.oyunstudyosu.engine.IntPoint;
   import com.oyunstudyosu.engine.IsoScene;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class IsoElement extends EventDispatcher
   {
       
      
      private var _id:String;
      
      public var scenePosition:Vector3d;
      
      public var canvasPosition:Point;
      
      public var cell:Cell;
      
      public var scene:IsoScene;
      
      private var _container:MovieClip;
      
      public var containerMask:MovieClip;
      
      public var depth:int;
      
      public var movedFromBackAreas:Boolean;
      
      private var p:Vector3d;
      
      private var _currentTile:IntPoint;
      
      public function IsoElement()
      {
         super();
      }
      
      public function create(param1:Vector3d, param2:MovieClip, param3:IsoScene) : void
      {
         var _loc4_:Matrix = null;
         this.scene = param3;
         this.container = param2;
         if(param2 != null)
         {
            if(Sanalika.instance.airModel.isAir())
            {
               (_loc4_ = new Matrix()).scale(1.75,1.75);
               param2["cacheAsBitmapMatrix"] = _loc4_;
               param2.cacheAsBitmap = true;
            }
         }
         if(param1 != null)
         {
            this.scenePosition = param1.clone();
         }
         else
         {
            this.scenePosition = new Vector3d();
         }
      }
      
      public function get currentTile() : IntPoint
      {
         return _currentTile;
      }
      
      public function set currentTile(param1:IntPoint) : void
      {
         if(_currentTile == param1)
         {
            return;
         }
         _currentTile = param1;
      }
      
      public function get id() : String
      {
         return _id;
      }
      
      public function set id(param1:String) : void
      {
         _id = param1;
      }
      
      public function get container() : MovieClip
      {
         return _container;
      }
      
      public function set container(param1:MovieClip) : void
      {
         _container = param1;
      }
      
      public function moveToCell(param1:int, param2:int, param3:int) : void
      {
         p = scene.getScenePositionFromTile(param1,param3);
         moveTo(p.x,p.y,p.z);
      }
      
      public function moveTo(param1:Number, param2:Number, param3:Number) : void
      {
         scenePosition = new Vector3d(param1,param2,param3);
         var _loc4_:Cell;
         if((_loc4_ = this.scene.translateToCell(scenePosition)) == null)
         {
            return;
         }
         if(this.cell == null || _loc4_ != this.cell)
         {
            this.cell = _loc4_;
         }
         this.canvasPosition = scene.getPosFromGrid(cell.posMatrix.x,cell.posMatrix.y);
         this.currentTile = cell.posMatrix.clone();
         container.x = canvasPosition.x;
         container.y = canvasPosition.y;
         if(Sanalika.instance.avatarModel.avatarId == id)
         {
            scene.screenShifting();
         }
      }
      
      public function update() : void
      {
      }
      
      public function dispose() : void
      {
         containerMask = null;
         scenePosition = null;
         canvasPosition = null;
         currentTile = null;
         scene = null;
         if(container != null)
         {
            container.removeChildren();
         }
         container = null;
      }
   }
}
