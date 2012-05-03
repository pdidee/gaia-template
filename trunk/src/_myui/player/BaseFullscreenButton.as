package _myui.player
{
   import flash.display.MovieClip;
   import flash.display.BlendMode;
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.FullScreenEvent;
   // boy
   import ui2.MyPlayerMgr;
   import _myui.player.core.PlayerMgr;

   /**
    * @author  boy | cjboy1984@gmail.com
    */
   public class BaseFullscreenButton extends MovieClip
   {

      public function BaseFullscreenButton()
      {
         // disable tab-functionality.
         tabEnabled = false;
         tabChildren = false;
         focusRect = false;

         mouseChildren = true;
         buttonMode = true;

         stop();
         addEventListener(Event.ADDED_TO_STAGE, _onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, _onRemove);
      }

      // ################# Protected Func ###################

      // ################### Private Func ###################

      private function _onAdd(e:Event = null):void
      {
         addEventListener(MouseEvent.CLICK, _onClick);

         // stage full screen
         stage.addEventListener(FullScreenEvent.FULL_SCREEN, onEnterFullscreen);
      }

      private function _onRemove(e:Event = null):void
      {
         removeEventListener(MouseEvent.CLICK, _onClick);

         // stage full screen
         stage.removeEventListener(FullScreenEvent.FULL_SCREEN, onEnterFullscreen);
      }

      // -------------------- LINE -------------------

      private function _onClick(e:MouseEvent = null):void
      {
         if (stage.displayState == StageDisplayState.NORMAL)
         {
            stage.displayState = StageDisplayState.FULL_SCREEN;
         }
         else
         {
            stage.displayState = StageDisplayState.NORMAL;
         }
      }

      private function onEnterFullscreen(e:FullScreenEvent):void
      {
         if (e.fullScreen)
         {
            gotoAndStop(2);
         }
         else
         {
            gotoAndStop(1);
         }
      }

      // -------------------- LINE -------------------

      private function get mgr():PlayerMgr { return PlayerMgr.getMgrAt(0); }

      // -------------------- LINE -------------------

   }

}