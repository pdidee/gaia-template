package _myui.player
{
   import _myui.player.core.PlayerMgr;
   
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   /**
    * @author boy, cjboy1984@gmail.com
    */
   public class VProgressBar extends MovieClip
   {
      // fla
      public var mcPlayhead:MovieClip;
      public var mcBuffer:MovieClip;
      
      // flag
      protected var isOver:Boolean = false;
      protected var isDragging:Boolean = false;
      
      // model
      public var id:String = 'abc';
      protected function get mgr():PlayerMgr { return PlayerMgr.api.getMgr(id); }
      
      // data
      protected var barWidth:Number = 100;
      
      // whether to resume play
      protected var resumePlay:Boolean;
      
      // percentage of the seeker
      protected var seekToPerc:Number;
      
      /* constructor */
      public function VProgressBar()
      {
         // disable tab-functionality.
         tabEnabled = false;
         tabChildren = false;
         focusRect = false;
         
         mouseChildren = true;
         
         stop();
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
         mcPlayhead.x = 0;
         if (mcBuffer) mcBuffer.width = 0;
         
         // model
         mgr.addEventListener(PlayerMgr.BUFFERING, onUpdateBuffer);
         mgr.addEventListener(PlayerMgr.PLAYING, onUpdatePlayhead);
         mgr.addEventListener(PlayerMgr.VIDEO_END, onVideoEnd);
         
         // seeker functionality
         addEventListener(MouseEvent.MOUSE_DOWN, onMDown);
      }
      
      protected function onRemove(e:Event):void
      {
         // tween
         TweenMax.killTweensOf(mcPlayhead);
         if (mcBuffer) TweenMax.killTweensOf(mcBuffer);
         
         // model
         mgr.removeEventListener(PlayerMgr.BUFFERING, onUpdateBuffer);
         mgr.removeEventListener(PlayerMgr.PLAYING, onUpdatePlayhead);
         mgr.removeEventListener(PlayerMgr.VIDEO_END, onVideoEnd);
         
         // seeker functionality
         removeEventListener(MouseEvent.MOUSE_DOWN, onMDown);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP, onMUp);
      }
      
      // --------------------- LINE ---------------------
      
      // buffer note
      protected function onUpdateBuffer(e:Event):void
      {
         if (!mcBuffer) return;
         
         var w:Number = width * mgr.bufferProgress;
         TweenMax.to(mcBuffer, 0.2, { width:w } );
      }
      
      // --------------------- LINE ---------------------
      
      // playhead note
      protected function onUpdatePlayhead(e:Event):void
      {
         var w:Number = barWidth * mgr.bufferProgress;
         TweenMax.to(mcPlayhead, 0.2, { x:w, ease:Linear.easeNone } );
      }
      
      // video ends note
      protected function onVideoEnd(e:Event):void
      {
         TweenMax.to(mcPlayhead, 0.2, { x:barWidth, ease:Linear.easeNone } );
      }
      
      // --------------------- LINE ---------------------
      
      protected function onMOver(e:MouseEvent):void {}
      protected function onMOut(e:MouseEvent):void {}
      
      protected function onMDown(e:MouseEvent):void
      {
         isDragging = true;
         // pause video
         resumePlay = mgr.playing;
         mgr.pause();
         
         // update progress bar
         seekToPerc = mouseX / width;
         var w:Number = barWidth * seekToPerc;
         TweenMax.to(mcPlayhead, 0.3, { x:w } );
         
         // add drag & up handler
         stage.addEventListener(MouseEvent.MOUSE_MOVE, onMMove);
         stage.addEventListener(MouseEvent.MOUSE_UP, onMUp);
      }
      
      protected function onMMove(e:MouseEvent):void
      {
         // update progress bar
         seekToPerc = mouseX / barWidth;
         if (seekToPerc < 0)
         {
            seekToPerc = 0;
         }
         else if (seekToPerc > 1)
         {
            seekToPerc = 1;
         }
         var w:Number = barWidth * seekToPerc;
         TweenMax.to(mcPlayhead, 0.2, { x:w } );
      }
      
      protected function onMUp(e:MouseEvent):void
      {
         isDragging = false;
         // resume play
         mgr.seekTo(seekToPerc);
         if (resumePlay) mgr.play();
         
         // remove drag & up handler
         stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP, onMUp);
      }
      
      // #################### private ###################
      
   }
   
}