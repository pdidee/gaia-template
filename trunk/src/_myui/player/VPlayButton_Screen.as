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
         mouseChildren = false;
         
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
         mgr.addEventListener(PlayerMgr.PLAY, onPlayVid, false, 0, true);
         mgr.addEventListener(PlayerMgr.PAUSE, onPauseVid, false, 0, true);
         mgr.addEventListener(PlayerMgr.STOP, onPauseVid, false, 0, true);
         mgr.addEventListener(PlayerMgr.VIDEO_END, onPauseVid, false, 0, true);
         mgr.addEventListener(PlayerMgr.BUFFER_EMPTY, onBufferEmpty, false, 0, true);
         mgr.addEventListener(PlayerMgr.BUFFER_FULL, onBufferFull, false, 0, true);
      }
      
      public function destroy():void
      {
         // model
         mgr.removeEventListener(PlayerMgr.PLAY, onPlayVid);
         mgr.removeEventListener(PlayerMgr.PAUSE, onPauseVid);
         mgr.removeEventListener(PlayerMgr.STOP, onPauseVid);
         mgr.removeEventListener(PlayerMgr.VIDEO_END, onPauseVid);
         mgr.removeEventListener(PlayerMgr.BUFFER_EMPTY, onBufferEmpty);
         mgr.removeEventListener(PlayerMgr.BUFFER_FULL, onBufferFull);
      }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
         gotoAndStop(1);
         
         // mouse
         addEventListener(MouseEvent.CLICK, onClick);
         addEventListener(MouseEvent.ROLL_OVER, onOver);
         addEventListener(MouseEvent.ROLL_OUT, onOut);
      }
      
      protected function onRemove(e:Event):void
      {
         // model
         destroy();
         
         // mouse
         removeEventListener(MouseEvent.CLICK, onClick);
         removeEventListener(MouseEvent.ROLL_OVER, onOver);
         removeEventListener(MouseEvent.ROLL_OUT, onOut);
      }
      
      // ________________________________________________
      //                                            mouse
      
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
      
      protected function onOver(e:MouseEvent):void
      {
         TweenMax.to(this, 0.3, {alpha:1});
      }
      
      protected function onOut(e:MouseEvent):void
      {
         if (currentFrame != 3)
         {
            TweenMax.to(this, 0.3, {alpha:0});
         }
      }
      
      // ________________________________________________
      //                                            model
      
      protected function onPlayVid(e:Event):void
      {
         gotoAndStop(2);
         TweenMax.to(this, 0.3, {alpha:0});
      }
      
      protected function onPauseVid(e:Event):void
      {
         gotoAndStop(1);
         TweenMax.to(this, 0.3, {alpha:1});
      }
      
      // --------------------- LINE ---------------------
      
      protected function onBufferEmpty(e:Event):void
      {
         gotoAndStop(3);
         TweenMax.to(this, 0.3, {alpha:1});
      }
      
      protected function onBufferFull(e:Event):void
      {
         if (mgr.playing)
         {
            gotoAndStop(2);
         }
         else
         {
            gotoAndStop(1);
         }
         TweenMax.to(this, 0.3, {alpha:0});
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}