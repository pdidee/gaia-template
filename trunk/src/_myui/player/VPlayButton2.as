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
   public class VPlayButton2 extends MovieClip
   {
      // model
      protected var _id:String = 'tvc';
      protected function get mgr():PlayerMgr { return PlayerMgr.api.getMgr(_id); }
      
      public function VPlayButton2()
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
      //                                               id
      
      public function get id():String { return _id; }
      public function set id(v:String):void
      {
         mgr.removeEventListener(PlayerMgr.PLAY, onPlayVid);
         mgr.removeEventListener(PlayerMgr.PAUSE, onPauseVid);
         mgr.removeEventListener(PlayerMgr.STOP, onPauseVid);
         mgr.removeEventListener(PlayerMgr.VIDEO_END, onPauseVid);
         
         _id = v;
         
         mgr.addEventListener(PlayerMgr.PLAY, onPlayVid);
         mgr.addEventListener(PlayerMgr.PAUSE, onPauseVid);
         mgr.addEventListener(PlayerMgr.STOP, onPauseVid);
         mgr.addEventListener(PlayerMgr.VIDEO_END, onPauseVid);
      }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
         // model
         mgr.addEventListener(PlayerMgr.PLAY, onPlayVid);
         mgr.addEventListener(PlayerMgr.PAUSE, onPauseVid);
         mgr.addEventListener(PlayerMgr.STOP, onPauseVid);
         mgr.addEventListener(PlayerMgr.VIDEO_END, onPauseVid);
         
         // click
         addEventListener(MouseEvent.CLICK, onClick);
      }
      
      protected function onRemove(e:Event):void
      {
         // model
         mgr.removeEventListener(PlayerMgr.PLAY, onPlayVid);
         mgr.removeEventListener(PlayerMgr.PAUSE, onPauseVid);
         mgr.removeEventListener(PlayerMgr.STOP, onPauseVid);
         mgr.removeEventListener(PlayerMgr.VIDEO_END, onPauseVid);
         
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