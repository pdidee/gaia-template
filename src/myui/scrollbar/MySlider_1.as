package myui.scrollbar
{
   import com.greensock.TweenMax;
   
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;

   /**
    * @author     cjboy | cjboy1984@gmail.com
    */
   public class MySlider_1 extends MovieClip
   {
      // fla
      public var btnThumb:MovieClip;
      public var btnFgTrack:MovieClip;

      // original width
      private const WIDTH:Number = 300;

      // minimum & maximum & tickInterval
      public var maximum:Number = 100;
      public var minimum:Number = 0;
      public var tickInterval:Number = 1;
      // value
      private var _value:int;

      // mask for foreground track
      private var fmask:Sprite;

      /* constructor */
      public function MySlider_1()
      {
         tabEnabled = false;
         tabChildren = false;
         buttonMode = true;

         // mask
         fmask = new Sprite();
         fmask.graphics.beginFill(0x0000FF);
         fmask.graphics.drawRect(0, 0, WIDTH, height);
         fmask.graphics.endFill();
         addChild(fmask);

         stop();

         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }

      // ------------------ LINE -------------------

      public function get value():int { return _value; }
      public function set value(v:int)
      {
         if (v < minimum) v = minimum;
         if (v > maximum) v = maximum;

         _value = v;

         var new_x:Number = WIDTH * _value / Math.abs(maximum - minimum);
         TweenMax.to(btnThumb, 0.3, { x:new_x } );
         TweenMax.to(fmask, 0.3, { width:new_x } );

         dispatchEvent(new Event(Event.CHANGE));
      }

      // ################ Protected ################

      // ################# Private #################

      private function onAdd(e:Event):void
      {
         btnThumb.x = 0;
         fmask.width = 0;
         btnFgTrack.mask = fmask;

         // mouse-wheel event
         addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheeling);

         // track event
         addEventListener(MouseEvent.CLICK, onTrackClick);

         // thumb event
         btnThumb.addEventListener(MouseEvent.MOUSE_DOWN, onThumbDown);
      }

      private function onRemove(e:Event):void
      {
         // tween
         TweenMax.killTweensOf(btnThumb);
         TweenMax.killTweensOf(fmask);

         // mouse-wheel event
         removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheeling);

         // track event
         removeEventListener(MouseEvent.CLICK, onTrackClick);

         // thumb event
         btnThumb.stopDrag();
         stage.removeEventListener(MouseEvent.MOUSE_MOVE, onThumbMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP, onThumbUp);
      }

      // ------------------ LINE -------------------

      private function onMouseWheeling(e:MouseEvent):void
      {
         var dv:Number = 10000 * e.delta / Math.abs(e.delta) || 0;
         value -= dv;
      }

      // ------------------ LINE -------------------

      private function onTrackClick(e:MouseEvent):void
      {
         var mx:Number = mouseX;
         if (mx < 0) mx = 0;
         if (mx > WIDTH) mx = WIDTH;
         btnThumb.x = mx;
         updateFgTrack();
      }

      // ------------------ LINE -------------------

      private function onThumbDown(e:MouseEvent):void
      {
         btnThumb.startDrag(false, new Rectangle(0, 0, WIDTH, 0));

         // foreground track
         updateFgTrack();

         // add relative handler
         stage.addEventListener(MouseEvent.MOUSE_MOVE, onThumbMove);
         stage.addEventListener(MouseEvent.MOUSE_UP, onThumbUp);
      }

      private function onThumbMove(e:MouseEvent):void
      {
         // foreground track
         updateFgTrack();
      }

      private function onThumbUp(e:MouseEvent):void
      {
         btnThumb.stopDrag();
         updateFgTrack();

         //var v:Number = Math.abs(maximum - minimum) * btnThumb.x / WIDTH;
         //var s:int = Math.floor(v / tickInterval);
         //TweenMax.to(btnThumb, 0.3, { x:s*tickInterval } );
         //TweenMax.to(fmask, 0.3, { width:s*tickInterval } );

         stage.removeEventListener(MouseEvent.MOUSE_MOVE, onThumbMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP, onThumbUp);
      }

      // ------------------ LINE -------------------

      // update foreground track and the value
      // then dispatch event
      private function updateFgTrack():void
      {
         fmask.width = btnThumb.x;

         _value = minimum + (btnThumb.x / WIDTH) * Math.abs(maximum - minimum);

         dispatchEvent(new Event(Event.CHANGE));
      }

      // ------------------ LINE -------------------

   }

}