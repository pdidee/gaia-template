package _myui.player
{
   import _myui.player.core.PlayerMgr;
   
   import com.greensock.events.LoaderEvent;
   import com.greensock.loading.VideoLoader;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   
   /**
    * A player supports FLV, F4V, or MP4 video file using "GreenSock" library and also provides convenient playback methods.
    * @author  boy, cjboy1984@gmail.com
    */
   public class GreenPlayer extends MovieClip
   {
      // fla
      public var video:VideoLoader;
      public var mcLoading:MovieClip; // The loading animation for buffering video
      
      public var src:String;
      public var docWidth:Number = 640; // <!-- width
      public var docHeight:Number = 360; // <!-- height
      
      // model
      public var id:String = 'abc';
      protected function get mgr():PlayerMgr { return PlayerMgr.api.getMgr(id); }
      
      public function GreenPlayer()
      {
         // disable tab-functionality.
         tabEnabled = false;
         tabChildren = false;
         focusRect = false;
         
         stop();
         
         addEventListener(Event.ADDED_TO_STAGE, onAdded);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
      }
      
      // ________________________________________________
      //                                             init
      
      public function init(source:String, width:Number, height:Number):void
      {
         src = source;
         docWidth = width;
         docHeight = height;
         
         // video
         video = new VideoLoader('v.mp4', {container:this, width:docWidth, height:docHeight, scaleMode:'proportionalOutside', crop:true, bgColor:0x000000, autoPlay:false, bufferTime:10});
         video.addEventListener(VideoLoader.VIDEO_BUFFER_FULL, onBuffFull);
         video.addEventListener(VideoLoader.VIDEO_BUFFER_EMPTY, onBuffEmpty);
         video.addEventListener(VideoLoader.VIDEO_PLAY, onVideoPlay);
         video.addEventListener(VideoLoader.VIDEO_PAUSE, onVideoPause);
         video.addEventListener(VideoLoader.PLAY_PROGRESS, onProgress);
         
         // model
         mgr.addEventListener(PlayerMgr.PLAY, onPlay);
         mgr.addEventListener(PlayerMgr.PAUSE, onPause);
         mgr.addEventListener(PlayerMgr.STOP, onStop);
         mgr.addEventListener(PlayerMgr.BUFFERING, onBuffering);
         mgr.addEventListener(PlayerMgr.SEEK_TO, onSeekTo);
         mgr.addEventListener(PlayerMgr.VIDEO_END, onVideoEnd);
         mgr.addEventListener(PlayerMgr.VOLUME_CHANGE, onVolChange);
      }
      
      public function destroy():void
      {
         // video
         if (video)
         {
            video.removeEventListener(VideoLoader.VIDEO_BUFFER_FULL, onBuffFull);
            video.removeEventListener(VideoLoader.VIDEO_BUFFER_EMPTY, onBuffEmpty);
            video.removeEventListener(VideoLoader.VIDEO_PLAY, onVideoPlay);
            video.removeEventListener(VideoLoader.VIDEO_PAUSE, onVideoPause);
            video.removeEventListener(VideoLoader.PLAY_PROGRESS, onProgress);
            video.dispose(true);
            video = null;
         }
         
         // model
         mgr.removeEventListener(PlayerMgr.PLAY, onPlay);
         mgr.removeEventListener(PlayerMgr.PAUSE, onPause);
         mgr.removeEventListener(PlayerMgr.STOP, onStop);
         mgr.removeEventListener(PlayerMgr.BUFFERING, onBuffering);
         mgr.removeEventListener(PlayerMgr.SEEK_TO, onSeekTo);
         mgr.removeEventListener(PlayerMgr.VIDEO_END, onVideoEnd);
         mgr.removeEventListener(PlayerMgr.VOLUME_CHANGE, onVolChange);
      }
      
      // ________________________________________________
      //                                          control
      
      override public function play():void
      {
         mgr.play();
      }
      
      public function pause():void
      {
         mgr.pause();
      }
      
      override public function stop():void
      {
         mgr.stop();
      }
      
      public function seekTo(v:Number):void
      {
         mgr.setPlayProgress(v);
      }
      
      // ################### protected ##################
      
      protected function onAdded(e:Event):void
      {
      }
      
      protected function onRemoved(e:Event):void
      {
      }
      
      // ________________________________________________
      //                                            model
      
      protected function onPlay(e:Event):void
      {
         video.load();
         video.playVideo();
      }
      
      protected function onPause(e:Event):void
      {
         video.pauseVideo();
      }
      
      protected function onStop(e:Event):void
      {
         video.pauseVideo();
         video.playProgress = 0;
      }
      
      protected function onBuffering(e:Event):void
      {
      }
      
      protected function onSeekTo(e:Event):void
      {
         // video
         video.playProgress = mgr.playProgress;
      }
      
      protected function onVideoEnd(e:Event):void
      {
      }
      
      protected function onVolChange(e:Event):void
      {
      }
      
      // ________________________________________________
      //                                            video
      
      protected function onBuffFull(e:LoaderEvent):void
      {
      }
      
      protected function onBuffEmpty(e:LoaderEvent):void
      {
      }
      
      protected function onVideoPlay(e:LoaderEvent):void
      {
      }
      
      protected function onVideoPause(e:LoaderEvent):void
      {
      }
      
      protected function onProgress(e:LoaderEvent):void
      {
         mgr.setPlayProgress(video.playProgress);
      }
      
      // #################### protected ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}