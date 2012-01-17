package _myui.canvas
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   /**
    * A canvas (Bitmap) that can draw stage without display object in hidePool.
    * @author boy, cjboy1984@gmail.com
    * @usage
    * var canvas:Canvas = new Canvas();
    * canvas.addHideList(this);
    * // Or some other object you don't want to draw.
    * canvas.addHideList(abc);
    * // Don't worry where you want to add it.
    * addChildAt(canvas, 0);
    * 
    * // draw
    * canvas.update();
    */
   public class StageCanvas extends Sprite
   {
      // canvas border
      public var BORDER:Number = 30;
      // canvas
      protected var canvas:Bitmap = new Bitmap();
      
      // hide list
      protected var hidePool:Vector.<Object> = new Vector.<Object>();
      
      // redraw timer id (Event.RESIZE)
      protected var tid:uint;
      
      public function StageCanvas()
      {
         super();
         hidePool.push(this);
         
         // add
         addChild(canvas);
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                             blur
      
      public function addHideList(obj:Object):void
      {
         if (-1 == hidePool.indexOf(obj))
            hidePool.push(obj);
      }
      
      public function clearHideList():void
      {
         hidePool = new Vector.<Object>();
         hidePool.push(this);
      }
      
      public function update():void
      {
         setVisiblity(false);
         
         var mtx:Matrix = new Matrix();
         mtx.translate(BORDER, BORDER);
         
         x = LeftTop.x - BORDER;
         y = LeftTop.y - BORDER;
         canvas.bitmapData = new BitmapData(sw + (BORDER<<1), sh + (BORDER<<1), false, 0xffffffff);
         canvas.bitmapData.draw(stage, mtx);
         
         setVisiblity(true);
      }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
         // basic
         stage.addEventListener(Event.RESIZE, onStageResize);
      }
      
      protected function onRemove(e:Event):void
      {
         // basic
         stage.removeEventListener(Event.RESIZE, onStageResize);
         
         canvas.bitmapData.dispose();
      }
      
      protected function onStageResize(e:Event):void
      {
         clearTimeout(tid);
         tid = setTimeout(update, 300);
      }
      
      protected function get LeftTop():Point
      {
         return parent.globalToLocal(new Point());
      }
      
      protected function get sw():Number { return stage.stageWidth; }
      protected function get sh():Number { return stage.stageHeight; }
      
      // ________________________________________________
      //                                            utils
      
      protected function setVisiblity($visible:Boolean):void
      {
         for each (var obj:Object in hidePool) 
         {
            obj.visible = $visible;
         }
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}