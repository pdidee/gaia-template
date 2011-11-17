package myui.scrollbar
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import myui.scrollbar.core.MyScrollBarMgr;

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
   public class VScrollBar extends MovieClip
   {
      // fla
      public var btnThumb:MovieClip;

      private const SCROLL_SPEED:Number = 15;

      private var _ta:MovieClip;          // target
      private var _taInitPos:Point;       // target init-position
      private var _barRef:Number;         // 捲bar的可移動距離
      private var _mskRef:Number;         // 目標的遮罩高/寬
      private var thumbNewY:int;          // thumb的y值，因為有滑鼠滾輪功能所以存在

      // 是否在drag中
      private var onDrag:Boolean;

      // target boundary checker
      private var taBoundaryChecker:Timer = new Timer(1000);
      private var taBoundary:Rectangle;

      public function VScrollBar()
      {
         visible        = false;
         mouseChildren  = true;

         stop();
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }

      // ------------------------- LINE --------------------------

      /**
       * 捲動目標
       */
      public function get ta():MovieClip { return _ta; }
      public function set ta(v:MovieClip):void
      {
         if (v)
         {
            _ta = v;
            thumbNewY = 0;

            addEventListener(MouseEvent.MOUSE_DOWN, onSBarDown);
            addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
            _ta.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);

            // 檢查目標的寬/高是否改變過
            taBoundary = _ta.getBounds(this);
            taBoundaryChecker.addEventListener(TimerEvent.TIMER, taBoundaryChange);
            taBoundaryChecker.start();

            checkVisibility();
         }
         else
         {
            disableScrolling();

            removeEventListener(MouseEvent.MOUSE_DOWN, onSBarDown);
            removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
            if (_ta) _ta.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);

            taBoundaryChecker.removeEventListener(TimerEvent.TIMER, taBoundaryChange);
            taBoundaryChecker.stop();
            taBoundaryChecker.reset();

            checkVisibility();

            _ta = null;
            thumbNewY = 0;
         }
      }

      /**
       * 目標的初始座標
       */
      public function get taInitPos():Point { return _taInitPos; }
      public function set taInitPos(v:Point):void
      {
         _taInitPos = v;

         checkVisibility();
      }

      /**
       * 捲bar的btnThumb可移動的距離
       */
      public function get barRef():Number { return _barRef; }
      public function set barRef(v:Number):void
      {
         _barRef = v;
         checkVisibility();
      }

      /**
       * 目標的遮罩高/寬
       */
      public function get mskRef():Number { return _mskRef; }
      public function set mskRef(v:Number):void
      {
         _mskRef = v;
         checkVisibility();
      }

      // --------------------- LINE ---------------------

      // ################### protected ##################

      // #################### private ###################

      private function onAdd(e:Event):void
      {
         // 這些數值都必需被設過才能work
         //_ta            = null;
         //_taInitPos     = null;
         //_mskRef        = NaN;
         //thumbNewY      = NaN;

         onDrag         = false;
         _barRef        = height - btnThumb.height;
         thumbNewY      = 0;

         mgr.percentage = 0;

         mgr.addEventListener(MyScrollBarMgr.SEEK_TO, seekTo);
      }

      private function onRemove(e:Event):void
      {
         ta = null;

         mgr.removeEventListener(MyScrollBarMgr.SEEK_TO, seekTo);
      }

      // --------------------- LINE ---------------------

      private function onSBarDown(e:MouseEvent):void
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

      private function onScrolling(e:MouseEvent = null):void
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
         mgr.percentage = thumbNewY / _barRef;
      }

      private function disableScrolling(e:MouseEvent = null):void
      {
         onDrag = false;

         btnThumb.stopDrag();
         stage.removeEventListener(MouseEvent.MOUSE_MOVE, onScrolling);
         stage.removeEventListener(MouseEvent.MOUSE_UP, disableScrolling);
      }

      private function onWheel(e:MouseEvent):void
      {
         if (!visible) return;

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
         mgr.percentage = thumbNewY / _barRef;
      }

      // --------------------- LINE ---------------------

      private function seekTo(e:Event = null):void
      {
         if (!visible) return;

         // bar
         if (!onDrag)
         {
            thumbNewY = _barRef * mgr.percentage;
            TweenMax.to(btnThumb, 0.2, { y:thumbNewY, ease:Linear.easeNone } );
         }

         // target
         var taY:Number = _taInitPos.y - (_ta.height - _mskRef) * thumbNewY / _barRef;
         TweenMax.to(_ta, 0.4, { y:taY } );
      }

      private function taBoundaryChange(e:TimerEvent):void
      {
         if (onDrag || !visible) return;

         var newBond:Rectangle = _ta.getBounds(this);
         if (Math.floor(taBoundary.height) != Math.floor(newBond.height))
         {
            taBoundary = newBond;
            var fixTaY:Number = _ta.y;
            if (_ta.y > _taInitPos.y) _ta.y = _taInitPos.y;
            if (_ta.y < (_taInitPos.y - (_ta.height - _mskRef))) _ta.y = _taInitPos.y - (_ta.height - _mskRef);
            mgr.percentage = Math.abs(fixTaY - _taInitPos.y) / (_ta.height - mskRef);
         }
      }

      // --------------------- LINE ---------------------

      private function checkVisibility():void
      {
         if (!_ta || !_taInitPos || !_mskRef || _ta.height <= _mskRef)
         {
            visible = false;
         }
         else
         {
            visible = true;
         }
      }

      // --------------------- LINE ---------------------

      private function get mgr():MyScrollBarMgr { return MyScrollBarMgr.getMgrAt(0); }

      private function get sw():Number { return stage.stageWidth; }
      private function get sh():Number { return stage.stageHeight; }

      // --------------------- LINE ---------------------

   }

}