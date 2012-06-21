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
      
      // model
      protected var _id:String = 'tvc';
      protected function get mgr():PlayerMgr { return PlayerMgr.api.getMgr(_id); }
      
      // data
      public var barWidth:Number = 100;
      
      // flag
      protected var cachedPlayStat:Boolean;
      protected var seeking:Boolean = false;
      
      // percentage of the seeker
      protected var seekPerc:Number;
      
      /* constructor */
      public function VProgressBar()
      {
         // disable tab-functionality.
         tabEnabled = false;
         tabChildren = false;
         focusRect = false;
         
         buttonMode = true;
         mouseChildren = true;
         
         stop();
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                     init/destroy
      
      public function init(modId:String = null):void
      {
         seeking = false;
         
         // model id
         if (modId)
         {
            _id = modId;
         }
         
         // model
         mgr.addEventListener(PlayerMgr.BUFFER_EMPTY, onUpdateBuffer, false, 0, true);
         mgr.addEventListener(PlayerMgr.PLAY_PROGRESS, onUpdatePlayhead, false, 0, true);
         mgr.addEventListener(PlayerMgr.VIDEO_END, onVideoEnd, false, 0, true);
      }
      
      public function destroy():void
      {
         seeking = false;
         
         // model
         mgr.removeEventListener(PlayerMgr.BUFFER_EMPTY, onUpdateBuffer);
         mgr.removeEventListener(PlayerMgr.PLAY_PROGRESS, onUpdatePlayhead);
         mgr.removeEventListener(PlayerMgr.VIDEO_END, onVideoEnd);
      }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
         mcPlayhead.x = 0;
         if (mcBuffer) mcBuffer.width = 0;
         
         // seeker functionality
         addEventListener(MouseEvent.MOUSE_DOWN, onMDown);
      }
      
      protected function onRemove(e:Event):void
      {
         // tween
         TweenMax.killTweensOf(mcPlayhead);
         if (mcBuffer) TweenMax.killTweensOf(mcBuffer);
         
         // model
         destroy();
         
         // seeker functionality
         removeEventListener(MouseEvent.MOUSE_DOWN, onMDown);
         stage.removeEventListener(Event.ENTER_FRAME, onMMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP, onMUp);
      }
      
      // --------------------- LINE ---------------------
      
      // buffer note
      protected function onUpdateBuffer(e:Event):void
      {
         if (!mcBuffer) return;
         
         var w:Number = width * mgr.bufferProgress;
         TweenMax.to(mcBuffer, 0.2, {width:w});
      }
      
      // --------------------- LINE ---------------------
      
      // playhead note
      protected function onUpdatePlayhead(e:Event):void
      {
         if (seeking) return;
         
         var nx:Number = barWidth * mgr.playProgress;
         var dur:Number = mgr.seekWithTween ? 0.2 : 0;
         if (dur == 0) TweenMax.killTweensOf(mcPlayhead);
         TweenMax.to(mcPlayhead, dur, {x:nx});
      }
      
      // video ends note
      protected function onVideoEnd(e:Event):void
      {
         TweenMax.to(mcPlayhead, 0.0, {x:barWidth});
      }
      
      // --------------------- LINE ---------------------
      
      protected function onMOver(e:MouseEvent):void {}
      protected function onMOut(e:MouseEvent):void {}
      
      protected function onMDown(e:MouseEvent):void
      {
         // pause video
         cachedPlayStat = mgr.playing;
         mgr.pause();
         
         // update progress bar
         seekPerc = mouseX / barWidth;
         if (seekPerc > 1) seekPerc = 1;
         else if (seekPerc < 0) seekPerc = 0;
         
         var nx:Number = barWidth * seekPerc;
         TweenMax.to(mcPlayhead, 0.0, {x:nx});
         
         // model
         mgr.seekTo(seekPerc);
         
         // add drag & up handler
         stage.addEventListener(Event.ENTER_FRAME, onMMove);
         stage.addEventListener(MouseEvent.MOUSE_UP, onMUp);
      }
      
      protected function onMMove(e:Event):void
      {
         // update progress bar
         seekPerc = mouseX / barWidth;
         if (seekPerc > 1) seekPerc = 1;
         else if (seekPerc < 0) seekPerc = 0;
         
         // model
         mgr.seekTo(seekPerc);
         
         var nx:Number = barWidth * seekPerc;
         TweenMax.to(mcPlayhead, 0.0, {x:nx});
      }
      
      protected function onMUp(e:MouseEvent):void
      {
         // update progress bar
         seekPerc = mouseX / barWidth;
         if (seekPerc > 1) seekPerc = 1;
         else if (seekPerc < 0) seekPerc = 0;
         
         // model
         mgr.seekTo(seekPerc);
         
         // resume stat
         if (cachedPlayStat) mgr.play();
         
         // remove drag & up handler
         stage.removeEventListener(Event.ENTER_FRAME, onMMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP, onMUp);
      }
      
      // #################### private ###################
      
   }
   
}