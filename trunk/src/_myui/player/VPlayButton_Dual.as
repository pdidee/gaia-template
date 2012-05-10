package _myui.player
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   import _myui.player.core.PlayerMgr;

   /**
    * A play-pause mode button.
    * @author boy, cjboy1984@gmail.com
    */
   public class VPlayButton_Dual extends MovieClip
   {
      // model
      protected var _id:String = 'tvc';
      protected function get mgr():PlayerMgr { return PlayerMgr.api.getMgr(_id); }

      public function VPlayButton_Dual()
      {
         // disable tab-functionality.
         tabEnabled = false;
         tabChildren = false;
         focusRect = false;
         buttonMode = true;

         stop();

         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                     init/destroy
      
      public function init(modId:String = null):void
      {
         // model id
         if (modId)
         {
            _id = modId;
         }
         
         // model
         mgr.addEventListener(PlayerMgr.PLAY, onPlayVid);
         mgr.addEventListener(PlayerMgr.PAUSE, onPauseVid);
         mgr.addEventListener(PlayerMgr.STOP, onPauseVid);
         mgr.addEventListener(PlayerMgr.VIDEO_END, onPauseVid);
      }
      
      public function destroy():void
      {
         // model
         mgr.removeEventListener(PlayerMgr.PLAY, onPlayVid);
         mgr.removeEventListener(PlayerMgr.PAUSE, onPauseVid);
         mgr.removeEventListener(PlayerMgr.STOP, onPauseVid);
         mgr.removeEventListener(PlayerMgr.VIDEO_END, onPauseVid);
      }

      // ################### protected ##################

      protected function onAdd(e:Event):void
      {
         // click
         addEventListener(MouseEvent.CLICK, onClick);
      }

      protected function onRemove(e:Event):void
      {
         // model
         destroy();

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