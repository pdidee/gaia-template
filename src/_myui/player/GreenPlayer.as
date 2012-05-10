package _myui.player
{
   import _myui.player.core.PlayerMgr;
   
   import com.greensock.events.LoaderEvent;
   import com.greensock.loading.VideoLoader;
   
   import flash.display.Sprite;
   import flash.events.Event;
   
   /**
    * A player supports FLV, F4V, or MP4 video file using "GreenSock" library and Model-View-Controller pattern. It also provides convenient playback methods.
    * @author  boy, cjboy1984@gmail.com
    * @usage
    * // Synchronize the model
    * var player:GreenPlayer = new GreenPlayer(640, 480);
    * player.src = 'demo.mp4';
    * 
    * // init
    * player.init('tvc');
    * addChild(player);
    * 
    * // play
    * player.play();
    * 
    * // All the UI component need to initialize the "id" property to make sure they have listened to a same model.
    */
   public class GreenPlayer extends Sprite
   {
      // fla
      public var video:VideoLoader;
      
      public var src:String = ''; // <!-- source
      public var docWidth:Number = 640; // <!-- width
      public var docHeight:Number = 360; // <!-- height
      
      protected var isEnd:Boolean = false;
      
      // model
      protected var _id:String = 'tvc';
      protected function get mgr():PlayerMgr { return PlayerMgr.api.getMgr(_id); }
      
      public function GreenPlayer(width:Number, height:Number, source:String = null)
      {
         // disable tab-functionality.
         tabEnabled = false;
         tabChildren = false;
         focusRect = false;
         
         src = source;
         docWidth = width;
         docHeight = height;
         
         addEventListener(Event.ADDED_TO_STAGE, onAdded);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
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
         
         // video
         video = new VideoLoader(src, {container:this, width:docWidth, height:docHeight, scaleMode:'proportionalOutside', crop:true, bgColor:0x000000, bgAlpha:0, autoPlay:false, bufferTime:10, onOpen:onLoadOpen, onComplete:onLoadComplete});
         video.addEventListener(VideoLoader.VIDEO_BUFFER_FULL, onBuffFull);
         video.addEventListener(VideoLoader.VIDEO_BUFFER_EMPTY, onBuffEmpty);
         video.addEventListener(VideoLoader.VIDEO_PLAY, onVideoPlay);
         video.addEventListener(VideoLoader.VIDEO_PAUSE, onVideoPause);
         video.addEventListener(VideoLoader.PLAY_PROGRESS, onProgress);
         
         // model
         mgr.addEventListener(PlayerMgr.PLAY, onPlay);
         mgr.addEventListener(PlayerMgr.PAUSE, onPause);
         mgr.addEventListener(PlayerMgr.STOP, onStop);
         mgr.addEventListener(PlayerMgr.BUFFER_EMPTY, onBuffering);
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
         mgr.removeEventListener(PlayerMgr.BUFFER_EMPTY, onBuffering);
         mgr.removeEventListener(PlayerMgr.SEEK_TO, onSeekTo);
         mgr.removeEventListener(PlayerMgr.VIDEO_END, onVideoEnd);
         mgr.removeEventListener(PlayerMgr.VOLUME_CHANGE, onVolChange);
      }
      
      // ________________________________________________
      //                                          control
      
      public function play():void
      {
         mgr.play();
      }
      
      public function pause():void
      {
         mgr.pause();
      }
      
      public function stop():void
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
         destroy();
      }
      
      // ________________________________________________
      //                                            model
      
      protected function onPlay(e:Event):void
      {
         // init
         video.volume = mgr.vol;
         video.playProgress = mgr.playProgress;
         
         video.load();
         video.playVideo();
         
         // restart
         if (isEnd)
         {
            isEnd = false;
            video.playProgress = 0;
         }
      }
      
      protected function onPause(e:Event):void
      {
         video.pauseVideo();
      }
      
      protected function onStop(e:Event):void
      {
         video.playProgress = mgr.playProgress;
         video.pauseVideo();
      }
      
      protected function onBuffering(e:Event):void
      {
         mgr.setBufferProgress(video.bufferProgress);
      }
      
      protected function onSeekTo(e:Event):void
      {
         // video
         video.playProgress = mgr.playProgress;
      }
      
      protected function onVideoEnd(e:Event):void
      {
         isEnd = true;
      }
      
      // ________________________________________________
      //                                            video
      
      /**
       * A handler function for LoaderEvent.OPEN events which are dispatched when the loader begins loading. Make sure your onOpen function accepts a single parameter of type LoaderEvent (com.greensock.events.LoaderEvent).
       */
      protected function onLoadOpen(e:LoaderEvent):void
      {
         mgr.setBufferEmpty();
         addEventListener(Event.ENTER_FRAME, onBuffering);
      }
      
      /**
       * A handler function for LoaderEvent.COMPLETE events which are dispatched when the loader has finished loading successfully. Make sure your onComplete function accepts a single parameter of type LoaderEvent (com.greensock.events.LoaderEvent).
       */
      protected function onLoadComplete(e:LoaderEvent):void
      {
         removeEventListener(Event.ENTER_FRAME, onBuffering);
      }
      
      /**
       * A handler function for VideoLoader.VIDEO_BUFFER_FULL events.
       */
      protected function onBuffFull(e:LoaderEvent):void
      {
         mgr.setBufferFull();
      }
      
      /**
       * A handler function for VideoLoader.VIDEO_BUFFER_EMPTY events.
       */
      protected function onBuffEmpty(e:LoaderEvent):void
      {
         mgr.setBufferEmpty();
      }
      
      /**
       * A handler function for VideoLoader.VIDEO_PLAY events.
       */
      protected function onVideoPlay(e:LoaderEvent):void
      {
      }
      
      /**
       * A handler function for VideoLoader.VIDEO_PAUSE events.
       */
      protected function onVideoPause(e:LoaderEvent):void
      {
      }
      
      /**
       * A handler function for VideoLoader.PLAY_PROGRESS events.
       */
      protected function onProgress(e:LoaderEvent):void
      {
         mgr.setPlayProgress(video.playProgress);
      }
      
      /**
       * A handler function for VideoLoader.VOLUME_CHANGE events.
       */
      protected function onVolChange(e:Event):void
      {
         video.volume = mgr.vol;
      }
      
      // #################### protected ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}