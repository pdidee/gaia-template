package _myui.scrollbar
{
   import _myui.scrollbar.core.ScrollMgr;
   
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   /**
    * @author	cjboy | cjboy1984@gmail.com
    * @usage	Please make sure there are "btnThumb" MovieClip
    *          btnThumb must be putted on (0, 0)
    *          And then set following properties.
    * ___________________________________________
    *                                     example
    * import flash.geom.Point;
    *
    * mcSbar.ta = mcTa;
    * mcSbar.taInitPos = new Point(0, 0);
    * mcSbar.mskRef = 200;
    * // mcSbar.barRef = 100; // 如果捲bar的thumb要特定移動範圍才設值
    */
   public class VScrollBar2 extends MovieClip
   {
      // fla
      public var btnThumb:MyButton;
      
      protected const SCROLL_SPEED:Number = 15;
      
      // manager
      protected var mgrNo:int = 0;
      protected function get mgr():ScrollMgr { return ScrollMgr.getMgrAt(mgrNo); }
      
      protected var _barRef:Number; // 捲bar的可移動距離
      protected var thumbNewY:int; // thumb的y值，因為有滑鼠滾輪功能所以存在
      
      // 是否在drag中
      protected var onDrag:Boolean;
      
      public function VScrollBar2()
      {
         stop();
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                   necessary info
      
      /**
       * The distance that btnThumb can move.
       */
      public function get barRef():Number { return _barRef; }
      public function set barRef(v:Number):void { _barRef = v; }

      /**
       * The percentage of the position of btnThumb instance, range is 0~1
       */      
      public function get headPos():Number
      {
         var offDst:Number = _barRef - btnThumb.height;
         return btnThumb.y / offDst;
      }
      public function set headPos(v:Number):void 
      {
         if (v < 0 || v > 1) return;
         mgr.value = v;
      }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
         mgr.value = 0.5;
         onDrag = false;
         _barRef = height - btnThumb.height;
         thumbNewY = _barRef * mgr.value;
         btnThumb.y = thumbNewY;
         
         // model
         mgr.addEventListener(ScrollMgr.SEEK_TO, seekTo);
         
         // scroll
         addEventListener(MouseEvent.MOUSE_DOWN, onSBarDown);
         stage.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
      }
      
      protected function onRemove(e:Event):void
      {
         // model
         mgr.removeEventListener(ScrollMgr.SEEK_TO, seekTo);
         
         // scroll
         removeEventListener(MouseEvent.MOUSE_DOWN, onSBarDown);
         stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
      }
      
      // --------------------- LINE ---------------------
      
      protected function onSBarDown(e:MouseEvent):void
      {
         onDrag = true;
         
         // if click on the track of scrollbar
         if (e.target != btnThumb)
         {
            if (mouseY > _barRef)
            {
               btnThumb.y = _barRef;
            }
            else
            {
               btnThumb.y = mouseY;
            }
            // target
            onScrolling();
         }
         
         var rect:Rectangle = new Rectangle(0, 0, 0, _barRef);
         btnThumb.startDrag(false, rect);
         stage.addEventListener(MouseEvent.MOUSE_MOVE, onScrolling);
         stage.addEventListener(MouseEvent.MOUSE_UP, disableScrolling);
      }
      
      protected function onScrolling(e:MouseEvent = null):void
      {
         if (stage.mouseX < 0 || stage.mouseX > stage.stageWidth ||
            stage.mouseY < 0 || stage.mouseY > stage.stageHeight
         )
         {
            disableScrolling();
            return;
         }
         
         thumbNewY = btnThumb.y;
         // see seekTo
         mgr.value = thumbNewY / _barRef;
      }
      
      protected function disableScrolling(e:MouseEvent = null):void
      {
         onDrag = false;
         
         btnThumb.stopDrag();
         stage.removeEventListener(MouseEvent.MOUSE_MOVE, onScrolling);
         stage.removeEventListener(MouseEvent.MOUSE_UP, disableScrolling);
      }
      
      protected function onWheel(e:MouseEvent):void
      {
         if (!mouseChildren) return;
         
         thumbNewY -=  e.delta / Math.abs(e.delta) * SCROLL_SPEED || 0; // edit scroll-speed here
         if (thumbNewY >= _barRef)
         {
            thumbNewY = _barRef;
         }
         else if (thumbNewY <= 0)
         {
            thumbNewY = 0;
         }
         
         // see seekTo
         mgr.value = thumbNewY / _barRef;
      }
      
      // --------------------- LINE ---------------------
      
      protected function seekTo(e:Event = null):void
      {
         if (!mouseChildren) return;
         
         trace(mgr.value);
         
         // bar
         if (!onDrag)
         {
            thumbNewY = _barRef * mgr.value;
            TweenMax.to(btnThumb, 0.2, { y:thumbNewY, ease:Linear.easeNone } );
         }
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}