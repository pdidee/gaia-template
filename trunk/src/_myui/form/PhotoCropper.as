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
      public var mcHint:MovieClip;
      
      // flag
      public var borderLimit:Boolean = true;
      
      // const
      protected const INIT_MGR_VALUE:Number = 0.5; // mgr.value
      
      // photo
      protected var bmp:Bitmap;
      protected var orgW:Number;
      protected var orgH:Number;
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
      protected var mgrNo:int = 0;
      protected function get mgr():ScrollMgr { return ScrollMgr.getMgrAt(mgrNo); }
      
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
         addChild(photoBox);
         
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
         meterWidth = mcMeter.width;
         meterHeight = mcMeter.height;
         
         // hint
         mcHint.mouseChildren = mcHint.mouseEnabled = false;
         mcHint.alpha = 0;
         mcHint.visible = false;
         
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
            
            // save info
            orgW = bmp.width;
            orgH = bmp.height;
            
            mgr.value = INIT_MGR_VALUE;
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
         mtx.translate(transx, transy);
         mtx.scale(bmp.scaleX, bmp.scaleY);
         
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
         
         // hint
         mcHint.addEventListener(Event.ENTER_FRAME, hintFollowThumb);
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
         
         // hint
         mcHint.removeEventListener(Event.ENTER_FRAME, hintFollowThumb);
         
         // gs
         TweenMax.killTweensOf(bmp);
         TweenMax.killTweensOf(mcHint);
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
         if (!bmp || !bmp.bitmapData) return;
         
         var scale:Number = 2 * (1 - mgr.value);
         var neww:Number = orgW * scale;
         var newh:Number = orgH * scale;
         
         if (neww < meterWidth)
         {
            scale = meterWidth / orgW;
            neww = meterWidth;
            newh = orgH * scale;
            
            // hint
            showHintAWhile();
            
            mgr.revertValue(1-scale/2);
         }
         else if (newh < meterHeight)
         {
            scale = meterHeight / orgH;
            neww = orgW * scale;
            newh = meterHeight;
            
            // hint
            showHintAWhile();
            
            mgr.revertValue(1-scale/2);
         }
         else
         {
            // hint
            hideHint();
         }
         
         TweenMax.to(bmp, 0.3, {transformAroundPoint:{point:boxCenter, scaleX:scale, scaleY:scale}, onUpdate:checkPosition});
      }
      
      // ________________________________________________
      //                                             hint
      
      protected function showHintAWhile():void
      {
         TweenMax.killTweensOf(mcHint);
         TweenMax.to(mcHint, 0.3, {autoAlpha:1});
         TweenMax.to(mcHint, 0.3, {autoAlpha:0, delay:1});
      }
      
      protected function hideHint():void
      {
         TweenMax.killTweensOf(mcHint);
         TweenMax.to(mcHint, 0.1, {autoAlpha:0});
      }
      
      protected function hintFollowThumb(e:Event):void
      {
         mcHint.x = btnScaleBar.x + btnScaleBar.width;
         mcHint.y = btnScaleBar.y + btnScaleBar.barRef * mgr.value;
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