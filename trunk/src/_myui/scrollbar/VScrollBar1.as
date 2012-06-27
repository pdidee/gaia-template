package _myui.scrollbar
{
   import _myui.scrollbar.core.ScrollMgr;
   
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   
   import flash.display.BlendMode;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   /**
    * A vertical scroll bar with full functionality. You need to assign ta, taInitPos and mskRef to make it work.
    * @author	boy, cjboy1984@gmail.com
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
   public class VScrollBar1 extends MovieClip
   {
      // fla
      public var btnThumb:MovieClip;
      
      protected const SCROLL_SPEED:Number = 15;
      
      // fla
      protected var canScroll:Boolean = false;
      
      // manager
      protected const id:String = 'common vsbar';
      protected function get mgr():ScrollMgr { return ScrollMgr.getMgr(id); }
      
      protected var _ta:MovieClip;          // target
      protected var _taInitPos:Point;       // target init-position
      protected var _barRef:Number;         // 捲bar的可移動距離
      protected var _mskRef:Number;         // 目標的遮罩高/寬
      protected var thumbNewY:int;          // thumb的y值，因為有滑鼠滾輪功能所以存在
      
      // 是否在drag中
      protected var onDrag:Boolean;
      
      // target boundary checker
      protected var taBoundaryChecker:Timer = new Timer(1000);
      protected var taBoundary:Rectangle;
      
      public function VScrollBar1()
      {
         stop();
         
         mouseChildren = false;
         blendMode = BlendMode.LAYER;
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // --------------------- LINE ---------------------
      
      /**
       * 捲動目標
       */
      public function get ta():MovieClip { return _ta; }
      public function set ta(v:MovieClip):void
      {
         mouseChildren = false;
         canScroll = false;
         
         if (v)
         {
            _ta = v;
            thumbNewY = 0;
            
            addEventListener(MouseEvent.MOUSE_DOWN, onSBarDown);
            addEventListener(MouseEvent.ROLL_OVER, onOver);
            addEventListener(MouseEvent.ROLL_OUT, onOut);
            _ta.addEventListener(MouseEvent.ROLL_OVER, onOver);
            _ta.addEventListener(MouseEvent.ROLL_OUT, onOut);
            stage.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
            
            // 檢查目標的寬/高是否改變過
            taBoundary = _ta.getBounds(this);
            taBoundaryChecker.addEventListener(TimerEvent.TIMER, taBoundaryChange);
            taBoundaryChecker.start();
            
            TweenMax.to(btnThumb, 0.4, {y:thumbNewY, onComplete:checkAvailable});
         }
         else
         {
            disableScrolling();
            
            removeEventListener(MouseEvent.MOUSE_DOWN, onSBarDown);
            removeEventListener(MouseEvent.ROLL_OVER, onOver);
            removeEventListener(MouseEvent.ROLL_OUT, onOut);
            if (_ta)
            {
               _ta.removeEventListener(MouseEvent.ROLL_OVER, onOver);
               _ta.removeEventListener(MouseEvent.ROLL_OUT, onOut);
            }
            if (stage) stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
            
            taBoundaryChecker.removeEventListener(TimerEvent.TIMER, taBoundaryChange);
            taBoundaryChecker.stop();
            taBoundaryChecker.reset();
            
            _ta = null;
            thumbNewY = 0;
            checkAvailable();
         }
      }
      
      /**
       * 目標的初始座標
       */
      public function get taInitPos():Point { return _taInitPos; }
      public function set taInitPos(v:Point):void
      {
         _taInitPos = v;
         
         checkAvailable();
      }
      
      /**
       * 捲bar的btnThumb可移動的距離
       */
      public function get barRef():Number { return _barRef; }
      public function set barRef(v:Number):void
      {
         _barRef = v;
         checkAvailable();
      }
      
      /**
       * 目標的遮罩高/寬
       */
      public function get mskRef():Number { return _mskRef; }
      public function set mskRef(v:Number):void
      {
         _mskRef = v;
         checkAvailable();
      }
      
      // --------------------- LINE ---------------------
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
         // 這些數值都必需被設過才能work
         //_ta            = null;
         //_taInitPos     = null;
         //_mskRef        = NaN;
         //thumbNewY      = NaN;
         
         onDrag         = false;
         _barRef        = height - btnThumb.height;
         thumbNewY      = 0;
         btnThumb.y     = 0;
         
         mgr.addEventListener(ScrollMgr.VALUE_CHANGE, seekTo);
      }
      
      protected function onRemove(e:Event):void
      {
         ta = null;
         
         mgr.removeEventListener(ScrollMgr.VALUE_CHANGE, seekTo);
      }
      
      // --------------------- LINE ---------------------
      
      protected function onOver(e:MouseEvent):void
      {
         canScroll = true;
      }
      
      protected function onOut(e:MouseEvent):void
      {
         canScroll = false;
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
         if (!canScroll) return;
         
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
         
         // bar
         if (!onDrag)
         {
            thumbNewY = _barRef * mgr.value;
            TweenMax.to(btnThumb, 0.2, { y:thumbNewY, ease:Linear.easeNone } );
         }
         
         // target
         var taY:Number = _taInitPos.y - (_ta.height - _mskRef) * thumbNewY / _barRef;
         TweenMax.to(_ta, 0.4, { y:taY } );
      }
      
      protected function taBoundaryChange(e:TimerEvent):void
      {
         if (onDrag || !mouseChildren) return;
         
         var newBond:Rectangle = _ta.getBounds(this);
         if (Math.floor(taBoundary.height) != Math.floor(newBond.height))
         {
            taBoundary = newBond;
            var fixTaY:Number = _ta.y;
            if (_ta.y > _taInitPos.y) _ta.y = _taInitPos.y;
            if (_ta.y < (_taInitPos.y - (_ta.height - _mskRef))) _ta.y = _taInitPos.y - (_ta.height - _mskRef);
            mgr.value = Math.abs(fixTaY - _taInitPos.y) / (_ta.height - mskRef);
         }
      }
      
      // --------------------- LINE ---------------------
      
      protected function checkAvailable():void
      {
         if (!_ta || !_taInitPos || !_mskRef || _ta.height <= _mskRef)
         {
            mouseChildren = false;
         }
         else
         {
            mouseChildren = true;
         }
      }
      
      // --------------------- LINE ---------------------
      
      protected function get sw():Number { return stage.stageWidth; }
      protected function get sh():Number { return stage.stageHeight; }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}