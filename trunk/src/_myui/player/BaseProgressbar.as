package _myui.player
{
   import _myui.player.core.MyPlayerMgr;
   
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
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
   public class BaseProgressbar extends MovieClip
   {
      // fla
      public var mcPlayhead:MovieClip;
      public var mcBuffer:MovieClip;
      
      // flag
      protected var isOver:Boolean = false;
      protected var isDragging:Boolean = false;
      
      // player manager
      protected var managerNo:int = 0;
      protected function get mgr():MyPlayerMgr { return MyPlayerMgr.getMgrAt(managerNo); }
      
      // data
      protected var barWidth:Number = 100;
      
      // whether to resume play
      protected var resumePlay:Boolean;
      
      // percentage of the seeker
      protected var seekToPerc:Number;
      
      /* constructor */
      public function BaseProgressbar()
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
         mgr.addEventListener(MyPlayerMgr.BUFFERING, onUpdateBuffer);
         mgr.addEventListener(MyPlayerMgr.PLAYING, onUpdatePlayhead);
         mgr.addEventListener(MyPlayerMgr.VIDEO_END, onVideoEnd);
         
         // seeker functionality
         addEventListener(MouseEvent.MOUSE_DOWN, onMDown);
      }
      
      protected function onRemove(e:Event):void
      {
         // tween
         TweenMax.killTweensOf(mcPlayhead);
         if (mcBuffer) TweenMax.killTweensOf(mcBuffer);
         
         // model
         mgr.removeEventListener(MyPlayerMgr.BUFFERING, onUpdateBuffer);
         mgr.removeEventListener(MyPlayerMgr.PLAYING, onUpdatePlayhead);
         mgr.removeEventListener(MyPlayerMgr.VIDEO_END, onVideoEnd);
         
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
         
         var w:Number = width * mgr.loadPerc / 100;
         TweenMax.to(mcBuffer, 0.2, { width:w } );
      }
      
      // --------------------- LINE ---------------------
      
      // playhead note
      protected function onUpdatePlayhead(e:Event):void
      {
         var w:Number = barWidth * mgr.playheadPercentage / 100;
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
         mgr.seekPercentage(Math.floor(100 * seekToPerc));
         if (resumePlay) mgr.play();
         
         // remove drag & up handler
         stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP, onMUp);
      }
      
      // #################### private ###################
      
   }
   
}