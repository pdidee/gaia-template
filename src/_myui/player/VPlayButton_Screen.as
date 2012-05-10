package _myui.player
{
   import _myui.player.core.PlayerMgr;
   
   import com.greensock.TweenMax;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   /**
    * A full-size play button.
    * @author boy, cjboy1984@gmail.com
    */
   public class VPlayButton_Screen extends MovieClip
   {
      // model
      protected var _id:String = 'tvc';
      protected function get mgr():PlayerMgr { return PlayerMgr.api.getMgr(_id); }
      
      public function VPlayButton_Screen()
      {
         // disable tab-functionality.
         tabEnabled = false;
         tabChildren = false;
         focusRect = false;
         buttonMode = true;
         mouseChildren = false;
         
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
         mgr.addEventListener(PlayerMgr.PLAY, onPlayVid, false, 0, true);
         mgr.addEventListener(PlayerMgr.PAUSE, onPauseVid, false, 0, true);
         mgr.addEventListener(PlayerMgr.STOP, onPauseVid, false, 0, true);
         mgr.addEventListener(PlayerMgr.VIDEO_END, onPauseVid, false, 0, true);
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
         if (mgr.playing)
         {
            mgr.pause();
         }
         else
         {
            mgr.play();
         }
      }
      
      // --------------------- LINE ---------------------
      
      protected function onPlayVid(e:Event):void
      {
         buttonMode = false;
         TweenMax.to(this, 0.3, {alpha:0});
      }
      
      protected function onPauseVid(e:Event):void
      {
         buttonMode = true;
         TweenMax.to(this, 0.3, {alpha:1});
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}