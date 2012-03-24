package _myui.io
{
   import flash.display.DisplayObject;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   /**
    * The original author was Jesses who hosts the WCK (World Construction Kit) project.
    * This is the WCK official website - http://www.sideroller.com/wck/
    * @author Jesses
    * @author cjboy1984@gmail.com
    * @usage
    * Construct MyInput                - MyInput.init(stage);
    * Destruct MyInput                 - MyInput.dispose();
    * Detect key-down                  - MyInput.keyDown('shift', 'a'); // return true if 'shift' and 'a' are both pressed!
    * Detect key-up                    - MyInput.keyUp('B'); // return true if 'B' is released!
    * Detect key-press(buffer)         - MyInput.keyPress('c') // return ture if 'c' is in press-buffer. Buffer will be cleared every enter-frame(the lowest priority)
    */
   public class Input
   {
      /**
       * Listen for this event on the stage for better mouse-up handling. This event will fire either on a
       * legitimate mouseUp or when flash no longer has any idea what the mouse is doing.
       */
      protected static const MOUSE_UP_OR_LOST:String = 'mouseUpOrLost';
      
      /// Mouse stuff.
      protected var mousePos:Point = new Point(-1000, -1000);
      protected var mouseTrackable:Boolean = false; /// True if flash knows what the mouse is doing.
      protected var mouseDetected:Boolean = false; /// True if flash detected at least one mouse event.
      protected var mouseIsDown:Boolean = false;
      
      /// Keyboard stuff. For these dictionaries, the keys are keyboard key-codes. The value is always true (a nil indicates no event was caught for a particular key).
      protected var keysDown:Dictionary;
      protected var keysPressed:Dictionary;
      protected var keysUp:Dictionary;
      
      protected var stage:Stage;
      
      protected static var obj:Input;
      
      public function Input(pvt:PrivateClass)
      {
         // do nothing
      }
      
      /**
       * In order to track input, a reference to the stage is required. Pass the stage to this static function
       * to start tracking input.
       * NOTE: "clear()" must be called each timestep. If false is pased for "autoClear", then "clear()" must be
       * called manually. Otherwise a low priority enter frame listener will be added to the stage to call "clear()"
       * each timestep.
       */
      public static function init(s:Stage, autoClear:Boolean = true):void
      {
         if (api.stage) return;
         
         api.keysDown = new Dictionary();
         api.keysPressed = new Dictionary();
         api.keysUp = new Dictionary();
         
         if (autoClear)
         {
            s.addEventListener(Event.ENTER_FRAME, api._onEnterFrame, false, -1000, true); /// Very low priority.
         }
         
         s.addEventListener(KeyboardEvent.KEY_DOWN, api._onKeyDown, false, 0, true);
         s.addEventListener(KeyboardEvent.KEY_UP, api._onKeyUp, false, 0, true);
         s.addEventListener(MouseEvent.MOUSE_UP, api._onMouseUp, false, 0, true);
         s.addEventListener(MouseEvent.MOUSE_DOWN, api._onMouseDown, false, 0, true);
         s.addEventListener(MouseEvent.MOUSE_MOVE, api._onMouseMove, false, 0, true);
         s.addEventListener(Event.MOUSE_LEAVE, api._onMouseLeave, false, 0, true);
         s.addEventListener(Event.DEACTIVATE, api._onDeactivate, false, 0, true);
         api.stage = s;
      }
      
      /**
       * Dispose every thing about tracking input.
       */
      public static function dispose():void
      {
         if (!api.stage) return;
         
         api.keysDown = null;
         api.keysPressed = null;
         api.keysUp = null;
         
         api.mouseTrackable = false;
         api.mouseDetected = false;
         api.mouseIsDown = false;
         
         api.stage.removeEventListener(Event.ENTER_FRAME, api._onEnterFrame);
         api.stage.removeEventListener(KeyboardEvent.KEY_DOWN, api._onKeyDown);
         api.stage.removeEventListener(KeyboardEvent.KEY_UP, api._onKeyUp);
         api.stage.removeEventListener(MouseEvent.MOUSE_UP, api._onMouseUp);
         api.stage.removeEventListener(MouseEvent.MOUSE_DOWN, api._onMouseDown);
         api.stage.removeEventListener(MouseEvent.MOUSE_MOVE, api._onMouseMove);
         api.stage.removeEventListener(Event.MOUSE_LEAVE, api._onMouseLeave);
         api.stage.removeEventListener(Event.DEACTIVATE, api._onDeactivate);
         
         api.stage = null;
      }
      
      // -------------------------- LINE --------------------------
      
      /**
       * Quick key-down detection for one or more keys. Pass strings that correspond to constants in the KeyCodes class.
       * If all of the passed keys are down, returns true. Example:
       *
       * MyInput.keyDown('SHIFT', 'a'); /// True if shift and a are currently down.
       */
      public static function keyDown(...args):Boolean
      {
         return api.keySearch(api.keysDown, args);
      }
      
      /**
       * Quick key-up detection for one or more keys. Pass strings that correspond to constants in the KeyCodes class.
       * If all of the passed keys have been released this frame, returns true.
       */
      public static function keyUp(...args):Boolean
      {
         return api.keySearch(api.keysUp, args);
      }
      
      /**
       * Quick key-pressed detection for one or more keys. Pass strings that correspond to constants in the KeyCodes class.
       * If any of the passed keys have been pressed this frame, returns true. This differs from keyDown in that a key held down
       * will only return true for one frame.
       */
      public static function keyPress(...args):Boolean
      {
         return api.keySearch(api.keysPressed, args);
      }
      
      // ################### protected ##################
      
      /**
       * clear key up and key pressed dictionaries.
       */
      protected function clear():void
      {
         api.keysUp = new Dictionary();
         api.keysPressed = new Dictionary();
      }
      
      /**
       * Used internally by keyDown(), keyUp() and keyPress().
       */
      protected function keySearch(d:Dictionary, keys:Array):Boolean
      {
         var ret:uint = 0;
         for (var i:uint = 0; i < keys.length; ++i)
         {
            if (d[keys[i]])
               //            if (d[KeyCodes[keys[i]]])
            {
               ++ret;
            }
         }
         
         return (ret == keys.length) ? true : false;
      }
      
      /**
       * Record a key down, and count it as a key press if the key isn't down already.
       */
      protected function _onKeyDown(e:KeyboardEvent):void
      {
         if (!api.keysDown[e.keyCode])
         {
            api.keysPressed[e.keyCode] = true;
            api.keysDown[e.keyCode] = true;
         }
      }
      
      /**
       * Record a key up.
       */
      protected function _onKeyUp(e:KeyboardEvent):void
      {
         api.keysUp[e.keyCode] = true;
         delete api.keysDown[e.keyCode];
      }
      
      /**
       * clear key up and key pressed dictionaries. This event handler has a very low priority, so it should
       * occur AFTER ALL other enterFrame events. This ensures that all other enterFrame events have access to
       * keysUp and keysPressed before they are cleared.
       */
      protected function _onEnterFrame(e:Event):void
      {
         clear();
      }
      
      /**
       * Record the mouse position, and clamp it to the size of the stage. Not a direct event listener (called by others).
       */
      protected function handleMouseEvent(e:MouseEvent):void
      {
         /// Strage bug where totally bogus mouse positions are reported... ?
         if (Math.abs(e.stageX) < 900000)
         {
            api.mousePos.x = e.stageX < 0 ? 0 : e.stageX > api.stage.stageWidth ? api.stage.stageWidth : e.stageX;
            api.mousePos.y = e.stageY < 0 ? 0 : e.stageY > api.stage.stageHeight ? api.stage.stageHeight : e.stageY;
         }
         api.mouseTrackable = true;
         api.mouseDetected = true;
      }
      
      /**
       * Get the mouse position in the local coordinates of an object.
       */
      protected function mousePositionIn(o:DisplayObject):Point
      {
         return o.globalToLocal(api.mousePos);
      }
      
      /**
       * Record a mouse down event.
       */
      protected function _onMouseDown(e:MouseEvent):void
      {
         api.mouseIsDown = true;
         handleMouseEvent(e);
      }
      
      /**
       * Record a mouse up event. Fires a MOUSE_UP_OR_LOST event from the stage.
       */
      protected function _onMouseUp(e:MouseEvent):void
      {
         api.mouseIsDown = false;
         handleMouseEvent(e);
         api.stage.dispatchEvent(new Event(MOUSE_UP_OR_LOST));
      }
      
      /**
       * Record a mouse move event.
       */
      protected function _onMouseMove(e:MouseEvent):void
      {
         handleMouseEvent(e);
      }
      
      /**
       * The mouse has left the stage and is no longer trackable. Fires a MOUSE_UP_OR_LOST event from the stage.
       */
      protected function _onMouseLeave(e:Event):void
      {
         api.mouseIsDown = false;
         api.stage.dispatchEvent(new Event(MOUSE_UP_OR_LOST));
         api.mouseTrackable = false;
      }
      
      /**
       * Flash no longer has focus and has no idea where the mouse is. Fires a MOUSE_UP_OR_LOST event from the stage.
       */
      protected function _onDeactivate(e:Event):void
      {
         api.mouseIsDown = false;
         api.stage.dispatchEvent(new Event(MOUSE_UP_OR_LOST));
         api.mouseTrackable = false;
      }
      
      // ________________________________________________
      //                                         sinleton
      
      protected function get api():Input
      {
         if (!obj)
         {
            obj = new Input(new PrivateClass);
         }
         return obj;
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}

class PrivateClass
{
   function PrivateClass()
   {
   }
}