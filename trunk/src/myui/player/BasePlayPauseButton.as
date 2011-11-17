package myui.player
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   import myui.player.core.MyPlayerMgr;

   /**
    * @author     cjboy | cjboy1984@gmail.com
    * @usage
    * 1. 首先，你必需先有個MyPlayerMgr的getter，以範例來說是取得第0個MyPlayerMgr。
    * protected function get mgr():MyPlayerMgr { return MyPlayerMgr.getMgrAt(0); }
    *
    * 2. 再來利用mgr來監聽事件和用mgr來執行行為。
    * mgr.play();
    * mgr.pause();
    * ...
    */
   public class BasePlayPauseButton extends MovieClip
   {
      protected var managerNo:int = 0;
      protected function get mgr():MyPlayerMgr { return MyPlayerMgr.getMgrAt(managerNo); }

      public function BasePlayPauseButton()
      {
         // disable tab-functionality.
         tabEnabled = false;
         tabChildren = false;
         focusRect = false;

         stop();

         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }

      // --------------------- LINE ---------------------

      // ################### protected ##################

      protected function onAdd(e:Event):void
      {
         // model
         mgr.addEventListener(MyPlayerMgr.PLAY, onPlayVid);
         mgr.addEventListener(MyPlayerMgr.PAUSE, onPauseVid);
         mgr.addEventListener(MyPlayerMgr.STOP, onPauseVid);

         // click
         addEventListener(MouseEvent.CLICK, onClick);
      }

      protected function onRemove(e:Event):void
      {
         // model
         mgr.removeEventListener(MyPlayerMgr.PLAY, onPlayVid);
         mgr.removeEventListener(MyPlayerMgr.PAUSE, onPauseVid);
         mgr.removeEventListener(MyPlayerMgr.STOP, onPauseVid);

         // click
         removeEventListener(MouseEvent.CLICK, onClick);
      }

      // --------------------- LINE ---------------------

      protected function onClick(e:MouseEvent):void
      {
         if (currentFrame == 1)
         {
            mgr.play();
         }
         else
         {
            mgr.pause();
         }
      }

      // --------------------- LINE ---------------------

      protected function onPlayVid(e:Event):void
      {
         gotoAndStop(2);
      }

      protected function onPauseVid(e:Event):void
      {
         gotoAndStop(1);
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------

   }

}