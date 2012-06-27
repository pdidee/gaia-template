package _myui.form
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
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   
   /**
    * Photo scale and cropper. (mostly used by SKII project)
    * @author boy, cjboy1984@gmail.com
    * @usage
    * // mcPhoto, btnZoomIn, btnZoomOut, btnScaleBar, mcHint
    * 
    * // fla
    * public var cropper:PhotoCropper;
    * 
    * // setting
    * cropper.borderLimit = true; // default
    * cropper.setPhotoPadding(0, 0, 0, 0);
    * // give photo, or give it null to destroy it!
    * cropper.photo = xxx;
    * // get the snapshot
    * trace(cropper.photoSnap);
    */
   public class PhotoCropper extends MovieClip
   {
      // fla
      public var mcMeter:MovieClip;
      public var btnZoomIn:MyButton;
      public var btnZoomOut:MyButton;
      public var btnScaleBar:VScrollBar2;
      
      // flag
      public var borderLimit:Boolean = true;
      
      // const
      protected const DEFAULT_VALUE:Number = 0.5; // mgr.value
      
      // photo
      protected var bmp:Bitmap;
      protected var orgW:Number;
      protected var orgH:Number;
      protected var minSX:Number;
      protected var minSY:Number;
      protected var maxSX:Number = 2;
      protected var maxSY:Number = 2;
      // photo padding
      protected var paddingLeft:Number;
      protected var paddingRight:Number;
      protected var paddingTop:Number;
      protected var paddingBottom:Number;
      // photo meter
      public var meterWidth:Number;
      public var meterHeight:Number;
      // box
      protected var photoBox:Sprite;
      protected var downPos:Point; // mosue-down position
      protected var isOver:Boolean; // the photoBox is rollover.
      // mask
      protected var photoMsk:Shape;
      
      // scroll
      protected var jump:Number = 0.05; // scale jump
      protected const id:String = 'cropper';
      protected function get mgr():ScrollMgr { return ScrollMgr.getMgr(id); }
      
      public function PhotoCropper()
      {
         super();
         
         // gs
         TweenPlugin.activate([TransformAroundPointPlugin]);
         
         // box
         isOver = false;
         photoBox = new Sprite();
         photoBox.x = mcMeter.x;
         photoBox.y = mcMeter.y;
         addChildAt(photoBox, getChildIndex(mcMeter));
         
         // bmp
         bmp = new Bitmap();
         
         // mask
         photoMsk = new Shape();
         photoMsk.graphics.beginFill(0x00ff00);
         photoMsk.graphics.drawRect(0, 0, mcMeter.width, mcMeter.height);
         photoMsk.graphics.endFill();
         photoMsk.x = mcMeter.x;
         photoMsk.y = mcMeter.y;
         addChild(photoMsk);
         photoBox.mask = photoMsk;
         
         // padding
         paddingLeft = 0;
         paddingRight = 0;
         paddingTop = 0;
         paddingBottom = 0;
         
         // meter
         mcMeter.visible = false;
         meterWidth = mcMeter.width;
         meterHeight = mcMeter.height;
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                             main
      
      /**
       * Set 4-direction padding for the photo.
       */
      public function setPhotoPadding(left:Number, right:Number, top:Number, bottom:Number):void
      {
         paddingLeft = left;
         paddingRight = right;
         paddingTop = top;
         paddingBottom = bottom;
         
         meterWidth = mcMeter.width + paddingLeft + paddingRight;
         meterHeight = mcMeter.height + paddingTop + paddingBottom
      }
      
      /**
       * Check the size of the photo is larger than the minimum limits.
       */
      public function checkPhoto(bmpData:BitmapData):Boolean
      {
         var ret:Boolean = true;
         
         if (bmpData.width < meterWidth || bmpData.height < meterHeight)
         {
            ret = false;
         }
         
         return ret;
      }
      
      /**
       * The photo, it's a BitmapData.
       */
      public function get photo():BitmapData { return bmp.bitmapData; }
      public function set photo(v:BitmapData):void 
      {
         if (bmp) TweenMax.killTweensOf(bmp);
         
         if (v)
         {
            bmp.bitmapData = v;
            bmp.x = -paddingLeft;
            bmp.y = -paddingTop;
            bmp.scaleX = bmp.scaleY = 1;
            bmp.smoothing = true;
            photoBox.addChild(bmp);
            
            // save raw info
            orgW = bmp.width;
            orgH = bmp.height;
            minSX = meterWidth / bmp.width;
            minSY = meterHeight / bmp.height;
            if (minSX > minSY) minSY = minSX; else if (minSX < minSY) minSX = minSY;
            
            mgr.value = DEFAULT_VALUE;
         }
         else
         {
            if (bmp.bitmapData) bmp.bitmapData.dispose();
         }
      }
      
      /**
       * The scaled and cropped (considering the padding) snapshot of the photo.
       */
      public function get photoSnap():BitmapData
      {
         var transx:Number = bmp.x + paddingLeft;
         var transy:Number = bmp.y + paddingRight;
         
         var mtx:Matrix = new Matrix();
         mtx.scale(bmp.scaleX, bmp.scaleY);
         mtx.translate(transx, transy);
         
         var ret:BitmapData = new BitmapData(meterWidth, meterHeight, false, 0xffffffff);
         ret.draw(bmp, mtx);
         
         return ret;
      }
      
      /**
       * The photo position.
       */
      public function get photoPos():Point { return new Point(bmp.x, bmp.y); }
      /**
       * The photo scale.
       */
      public function get photoScale():Number { return bmp.scaleX; }
      
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
         btnScaleBar.headPos = DEFAULT_VALUE;
         
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
         mgr.removeEventListener(ScrollMgr.VALUE_CHANGE, onScaleChange);
         
         // gs
         TweenMax.killTweensOf(bmp);
      }
      
      // ________________________________________________
      //                                    mouse handler
      
      protected function onBoxOver(e:MouseEvent):void
      {
         // flag
         isOver = true;
         
         // cursor
         if (!stage.hasEventListener(MouseEvent.MOUSE_MOVE))
         {
            Mouse.cursor = MouseCursor.HAND;
         }
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
         bmp.x = photoBox.mouseX - downPos.x;
         bmp.y = photoBox.mouseY - downPos.y;
         checkPosition();
         
         e.updateAfterEvent();
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
         if (!bmp || !bmp.bitmapData)
         {
            mgr.revertValue(DEFAULT_VALUE);
            return;
         }
         
         var rValue:Number = 1 - mgr.value;
         var scale:Number;
         if (rValue == DEFAULT_VALUE)
         {
            scale = 1;
         }
         else if (rValue > DEFAULT_VALUE)
         {
            scale = maxSX * (rValue - DEFAULT_VALUE) / 0.5 + 1;
         }
         else if (rValue < DEFAULT_VALUE)
         {
            scale = 1 - (1 - minSX) * (DEFAULT_VALUE - rValue) / 0.5;
         }
         var neww:Number = orgW * scale;
         var newh:Number = orgH * scale;
         
         if (neww < meterWidth)
         {
            scale = meterWidth / orgW;
            neww = meterWidth;
            newh = orgH * scale;
         }
         else if (newh < meterHeight)
         {
            scale = meterHeight / orgH;
            neww = orgW * scale;
            newh = meterHeight;
         }
         else
         {
         }
         
         TweenMax.to(bmp, 0.3, {transformAroundPoint:{point:boxCenter, scaleX:scale, scaleY:scale}, onUpdate:checkPosition});
      }
      
      // ________________________________________________
      //                                            utils
      
      protected function get boxCenter():Point { return new Point(mcMeter.width>>1, mcMeter.height>>1); }
      
      protected function checkPosition():void
      {
         if (borderLimit)
         {
            // x
            if (bmp.x >  -paddingLeft) bmp.x = -paddingLeft;
            else if (bmp.x < mcMeter.width - bmp.width + paddingRight) bmp.x = mcMeter.width - bmp.width + paddingRight;
            // y
            if (bmp.y >  -paddingTop) bmp.y = -paddingTop;
            else if (bmp.y < mcMeter.height - bmp.height + paddingBottom) bmp.y = mcMeter.height - bmp.height + paddingBottom;
         }
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}