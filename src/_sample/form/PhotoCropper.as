package _sample.form
{
   import _myui.scrollbar.VScrollBar2;
   import _myui.scrollbar.core.ScrollMgr;
   
   import com.greensock.TweenMax;
   import com.greensock.plugins.TransformAroundPointPlugin;
   import com.greensock.plugins.TweenPlugin;
   
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   
   /**
    * SKII photo scale and cropper.
    * @author boy, cjboy1984@gmail.com
    * @usage
    * // mcPhoto, btnZoomIn, btnZoomOut, btnScaleBar
    * 
    * // fla
    * public var cropper:PhotoCropper;
    * 
    * // setting
    * cropper.borderLimit = true; // default
    * // give photo
    * cropper.photo = xxx;
    */
   public class PhotoCropper extends MovieClip
   {
      // fla
      public var mcPhoto:MovieClip;
      public var btnZoomIn:MyButton;
      public var btnZoomOut:MyButton;
      public var btnScaleBar:VScrollBar2;
      
      // flag
      public var borderLimit:Boolean = true;
      
      // const
      protected const INIT_MGR_VALUE:Number = 0.5; // mgr.value
      
      // photo
      protected var bmp:Bitmap;
      // box
      protected var photoBox:Sprite;
      protected var downPos:Point; // mosue-down position
      protected var isOver:Boolean; // the photoBox is rollover.
      // mask
      protected var photoMsk:Shape;
      
      // scroll
      private var jump:Number = 0.05;
      private const mgrNo:int = 0;
      private function get mgr():ScrollMgr { return ScrollMgr.getMgrAt(mgrNo); }
      
      public function PhotoCropper()
      {
         super();
         
         // gs
         TweenPlugin.activate([TransformAroundPointPlugin]);
         
         // box
         isOver = false;
         photoBox = new Sprite();
         photoBox.x = mcPhoto.x;
         photoBox.y = mcPhoto.y;
         addChild(photoBox);
         
         // bmp
         bmp = new Bitmap();
         
         // mask
         photoMsk = new Shape();
         photoMsk.graphics.beginFill(0x00ff00);
         photoMsk.graphics.drawRect(0, 0, mcPhoto.width, mcPhoto.height);
         photoMsk.graphics.endFill();
         photoMsk.x = mcPhoto.x;
         photoMsk.y = mcPhoto.y;
         addChild(photoMsk);
         photoBox.mask = photoMsk;
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                             main

      /**
       * The photo, it's a BitmapData.
       */
      public function get photo():BitmapData { return bmp.bitmapData; }
      public function set photo(v:BitmapData):void 
      {
         bmp.bitmapData = v;
         bmp.smoothing = true;
         TweenMax.to(bmp, 0, {x:0, y:0, scaleX:1, scaleY:1, alpha:0});
         TweenMax.to(bmp, 0.5, {alpha:1});
         
         photoBox.addChild(bmp);
         
         mgr.value = INIT_MGR_VALUE;
      }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
         // box
         while (photoBox.numChildren)
         {
            photoBox.removeChildAt(0);
         }
         photoBox.addEventListener(MouseEvent.ROLL_OVER, onBoxOver);
         photoBox.addEventListener(MouseEvent.ROLL_OUT, onBoxOut);
         photoBox.addEventListener(MouseEvent.MOUSE_DOWN, onBoxDown);
         
         // scroll
         btnScaleBar.headPos = INIT_MGR_VALUE;
         
         // [buttons]
         var newv:Number;
         // zoom
         btnZoomIn.gotoAndStop(1);
         btnZoomIn.buttonMode = true;
         btnZoomIn.onClick = function()
         {
            if (!this.buttonMode) return;
            
            newv = mgr.value - jump;
            if (newv >= 0) mgr.value = newv;
            else mgr.value = 0;
         };
         btnZoomOut.gotoAndStop(1);
         btnZoomOut.buttonMode = true;
         btnZoomOut.onClick = function()
         {
            if (!this.buttonMode) return;
            
            newv = mgr.value + jump;
            if (newv <= 1) mgr.value = newv;
            else mgr.value = 1;
         };
         
         // scale
         mgr.addEventListener(ScrollMgr.VALUE_CHANGE, onScaleChange);
      }
      
      protected function onRemove(e:Event):void
      {
         // box
         photoBox.removeEventListener(MouseEvent.ROLL_OVER, onBoxOver);
         photoBox.removeEventListener(MouseEvent.ROLL_OUT, onBoxOut);
         photoBox.removeEventListener(MouseEvent.MOUSE_DOWN, onBoxDown);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
         
         // scale
         mgr.addEventListener(ScrollMgr.VALUE_CHANGE, onScaleChange);
      }
      
      // ________________________________________________
      //                                    mouse handler
      
      protected function onBoxOver(e:MouseEvent):void
      {
         // flag
         isOver = true;
         
         // cursor
         Mouse.cursor = MouseCursor.HAND;
      }
      
      protected function onBoxOut(e:MouseEvent):void
      {
         // flag
         isOver = false;
         
         // cursor
         if (!stage.hasEventListener(MouseEvent.MOUSE_MOVE))
         {
            Mouse.cursor = MouseCursor.AUTO;
         }
      }
      
      protected function onBoxDown(e:MouseEvent):void
      {
         // info
         downPos = new Point(bmp.mouseX * bmp.scaleX, bmp.mouseY * bmp.scaleY);
         
         // cursor
         Mouse.cursor = MouseCursor.BUTTON;
         
         // mouse handler
         stage.addEventListener(MouseEvent.MOUSE_MOVE, onMMove);
         stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
      }
      
      protected function onMMove(e:MouseEvent):void
      {
         var newx:Number = photoBox.mouseX - downPos.x;
         var newy:Number = photoBox.mouseY - downPos.y;
         
         if (borderLimit)
         {
            // x
            if (newx > 0) newx = 0;
            else if (newx < mcPhoto.width - bmp.width) newx = mcPhoto.width - bmp.width;
            // y
            if (newy > 0) newy = 0;
            else if (newy < mcPhoto.height - bmp.height) newy = mcPhoto.height - bmp.height;
         }
         
         bmp.x = newx;
         bmp.y = newy;
      }
      
      protected function onUp(e:MouseEvent):void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
         
         // cursor
         if (isOver)
         {
            Mouse.cursor = MouseCursor.HAND;
         }
         else
         {
            Mouse.cursor = MouseCursor.AUTO;
         }
      }
      
      // ________________________________________________
      //                                            scale
      
      protected function onScaleChange(e:Event):void
      {
         if (!bmp || !bmp.bitmapData) return;
         
         var scale:Number = mgr.value + 0.5;
         
         TweenMax.to(bmp, 0.3, {transformAroundPoint:{point:boxCenter, scaleX:scale, scaleY:scale}});
      }
      
      // ________________________________________________
      //                                            utils
      
      protected function get boxCenter():Point { return new Point(mcPhoto.width>>1, mcPhoto.height>>1); }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}