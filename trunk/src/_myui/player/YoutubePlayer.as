package _myui.player
{
   import com.greensock.TweenLite;
   import com.greensock.easing.*;
   
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.system.Security;

   /**
    * @author  cjboy1984@gmail.com
    * @date    Sep,29,2010
    * @param   autoReplay
    * @param   autoHidePanel
    * @param   _src
    * @param   playVideo()
    * @param   pauseVideo()
    * @param   stopVideo()
    */
   public class YoutubePlayer extends MovieClip
   {
      const YOUTUBE_API:String = "http://www.youtube.com/apiplayer?version=3";

      public var CONTROLLER_INIT_Y:Number;
      // fla
      public var btnVideo:MovieClip;
      public var btnController:MovieClip;
      public var btnPlayPause:MovieClip;
      public var btnStop:MovieClip;
      // fla: progress bar
      public var btnSeeker:MovieClip;
      public var btnProgressBar:MovieClip;
      public var btnFgProgress:MovieClip;
      public var btnBgProgress:MovieClip;
      public var btnBufferProgress:MovieClip;
      // fla: sound
      public var btnSound:MovieClip;
      public var btnSoundSeeker:MovieClip;
      public var btnSoundBg:MovieClip;

      private var _src:String = null;
      private var _width:Number;
      private var _height:Number;

      private var player:Object;
      private var apiLoader:Loader;

      // ------------------- LINE -------------------

      /**
       * Is automaticall replay when video plays to the end, default is true.
       */
      public var autoReplay:Boolean = true;

      private var _autoHidePanel:Boolean = true;

      // ------------------- LINE -------------------

      public function YoutubePlayer()
      {
         // save init x-pos of control panel
         CONTROLLER_INIT_Y = btnController.y;

         btnPlayPause = btnController["btnPlayPause"] as MovieClip;
         btnPlayPause.stop();

         btnStop = btnController["btnStop"] as MovieClip;

         btnSound = btnController["btnSound"] as MovieClip;
         btnSound.mouseChildren = false;
         btnSound.buttonMode = true;
         btnSound.stop();

         btnSoundSeeker = btnSound["btnSeeker"] as MovieClip;
         btnSoundBg = btnSound["btnBg"] as MovieClip;

         btnProgressBar = btnController["btnProgress"] as MovieClip;
         btnProgressBar.mouseChildren = false;
         btnProgressBar.buttonMode = true;

         btnSeeker = btnProgressBar["btnSeeker"] as MovieClip;
         btnBgProgress = btnProgressBar["btnBg"] as MovieClip;
         btnFgProgress = btnProgressBar["btnFg"] as MovieClip;
         btnBufferProgress = btnProgressBar["btnBuffer"] as MovieClip;
         btnFgProgress.width = 0;
         btnBufferProgress.width = 0;

         _width = btnVideo.width;
         _height = btnVideo.height;

         stop();

         Security.allowDomain("www.youtube.com");

         addEventListener(Event.ADDED_TO_STAGE, onAdded);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
      }

      /**
       * Usage:
       * src = video.flv   // make player to play video.flv
       * src = null        // make player stop playing
       */
      public function get src():String { return _src; }
      public function set src(value:String):void
      {
         if (value)
         {
            // parse src, whether it is in http-format or id-format
            _src = value.match(/v=([^&]+)/) ? value.match(/v=([^&]+)/)[1] : value;
         }
         else
         {
            _src = null;
         }

         if (player)
         {
            if (_src)
            {
               player.loadVideoById(_src);
            }
            else
            {
               player.stopVideo();
            }
         }

         // hide control panel
         hidePanelFunc();
      }

      /**
       * Is automaticall hide control panel, default true.
       */
      public function get autoHidePanel():Boolean { return _autoHidePanel; }
      public function set autoHidePanel(v:Boolean):void
      {
         _autoHidePanel = v;

         if (_autoHidePanel)
         {
            hidePanelFunc();
         }
         else
         {
            showPanelFunc();
         }
      }

      /**
       * Whethe to show/hide control panel, default is true.
       */
      public function get showPanel():Boolean { return btnController.visible; }
      public function set showPanel(v:Boolean):void { btnController.visible = v; }

      // TODO - fix sync problem
      public function playVideo():void
      {
         if (!player && !_src) return;

         if (-1 == player.getPlayerState()) // unstarted
         {
            player.loadVideoById(_src);
         }
         else // pause | buffering
         {
            player.playVideo();
         }
         btnPlayPause.gotoAndStop(2);
      }
      public function pauseVideo():void { btnPlayPause.gotoAndStop(2); player.pauseVideo(); }
      public function stopVideo():void { btnPlayPause.gotoAndStop(1); player.stopVideo(); }

      public function get bytesLoaded():Number { return player ? player.getVideoBytesLoaded() : 0; }
      public function get bytesTotal():Number { return player ? player.getVideoBytesTotal() : 0; }
      public function get loadPerc():Number { return player ? player.getVideoBytesLoaded() / player.getVideoBytesTotal() : 0; }

      public function get currSec():Number { return player ? player.getCurrentTime() : 0; }
      public function get totalSec():Number { return player ? player.getDuration() : 0; }
      public function get playPerc():Number { return player ? player.getCurrentTime() / player.getDuration() : 0; }

      public function get volume():Number { return player ? player.getVolume() : 0; }
      public function set volume(value:Number):void { if (player) player.setVolume(value); }

      // ------------------- Protected -------------------

      // ------------------- Private -------------------

      private function onAdded(e:Event):void
      {
         // this
         addEventListener(MouseEvent.ROLL_OVER, showPanelFunc);
         addEventListener(MouseEvent.ROLL_OUT, hidePanelFunc);

         apiLoader = new Loader();
         apiLoader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
         apiLoader.load(new URLRequest(YOUTUBE_API));
      }

      private function onRemoved(e:Event):void
      {
         // this
         removeEventListener(MouseEvent.ROLL_OVER, showPanelFunc);
         removeEventListener(MouseEvent.ROLL_OUT, hidePanelFunc);

         // destory Youtube-API
         btnVideo.removeChild(apiLoader);
         apiLoader.contentLoaderInfo.removeEventListener(Event.INIT, onLoaderInit);
         apiLoader.content.removeEventListener("onReady", onPlayerReady);
         apiLoader.content.removeEventListener("onError", onPlayerError);
         apiLoader.content.removeEventListener("onStateChange", onPlayerStateChange);
         apiLoader.content.removeEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
         apiLoader.unload();
         apiLoader = null;

         // destory player
         if (player)
         {
            player.destroy();
         }

         removeEventListener(Event.ENTER_FRAME, onProgressing);

         // controller
         btnPlayPause.removeEventListener(MouseEvent.CLICK, onPlayPause);
         btnStop.removeEventListener(MouseEvent.CLICK, onStop);

         btnSound.removeEventListener(MouseEvent.MOUSE_DOWN, startVolAdjust);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE, onVolAdjusting);
         stage.removeEventListener(MouseEvent.MOUSE_UP, stopVolAdjust);
         btnSoundSeeker.stopDrag();

         btnProgressBar.removeEventListener(MouseEvent.MOUSE_DOWN, startSeek);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSeeking);
         stage.removeEventListener(MouseEvent.MOUSE_UP, stopSeek);

         removeEventListener(Event.ENTER_FRAME, onProgressing);
         removeEventListener(Event.ENTER_FRAME, onBuffering);
         btnSeeker.stopDrag();
      }

      private function onLoaderInit(e:Event):void
      {
         apiLoader.contentLoaderInfo.removeEventListener(Event.INIT, onLoaderInit);

         btnVideo.addChild(apiLoader);

         apiLoader.content.addEventListener("onReady", onPlayerReady);
         apiLoader.content.addEventListener("onError", onPlayerError);
         apiLoader.content.addEventListener("onStateChange", onPlayerStateChange);
         apiLoader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
      }

      private function onPlayerReady(e:Event):void
      {
         player = apiLoader.content;
         player.setSize(_width, _height);

         if (_src)
         {
            btnPlayPause.gotoAndStop(2);
            player.loadVideoById(_src);
         }

         // controller
         btnPlayPause.addEventListener(MouseEvent.CLICK, onPlayPause);
         btnStop.addEventListener(MouseEvent.CLICK, onStop);
         btnSound.addEventListener(MouseEvent.MOUSE_DOWN, startVolAdjust);
         btnProgressBar.addEventListener(MouseEvent.MOUSE_DOWN, startSeek);
      }

      private function onPlayerError(e:Event):void
      {
         //trace("player error:", Object(e).data);
      }

      private function onPlayerStateChange(e:Event):void
      {
         // debug ------------->
         switch(Object(e).data)
         {
            case 1: trace("[cj's Youtube-Player] playing"); break;
            case 2: trace("[cj's Youtube-Player] pause"); break;
            case 3: trace("[cj's Youtube-Player] buffering"); break;
            case 5: trace("[cj's Youtube-Player] video cued"); break;
            case -1: trace("[cj's Youtube-Player] unstarted"); break;
            case 0: trace("[cj's Youtube-Player] end"); break;
         }
         // <-------------------

         switch(Object(e).data)
         {
            case 1: // playing
               addEventListener(Event.ENTER_FRAME, onProgressing);
               break;
            case 3: // buffering
               addEventListener(Event.ENTER_FRAME, onBuffering);
               break;
            case 0: // end
               if (autoReplay)
               {
                  player.playVideo();
               }
               else
               {
                  TweenLite.to(btnFgProgress, 0.8, { width:0 } );
                  btnPlayPause.gotoAndStop(1);
               }
            case -1: // unstarted
            case 2: // pause
            //case 5: // video cued
               removeEventListener(Event.ENTER_FRAME, onProgressing);
               break;
         }
      }

      private function onVideoPlaybackQualityChange(e:Event):void
      {
         //trace("video quality:", Object(e).data);
      }

      private function onPlayPause(e:MouseEvent = null):void
      {
         if (!_src) return;

         if (2 == btnPlayPause.currentFrame)
         {
            player.pauseVideo();
            btnPlayPause.gotoAndStop(1);
         }
         else
         {
            if (-1 == player.getPlayerState()) // unstarted
            {
               player.loadVideoById(_src);
            }
            else // pause | buffering
            {
               player.playVideo();
            }
            btnPlayPause.gotoAndStop(2);
         }
      }

      private function onStop(e:MouseEvent):void
      {
         if (!_src) return;

         btnPlayPause.gotoAndStop(1);
         player.stopVideo();
      }

      private function startVolAdjust(e:MouseEvent):void
      {
         if (!_src) return;

         btnSoundSeeker.x = e.currentTarget.mouseX;
         btnSoundSeeker.startDrag(true, new Rectangle(0, 0, btnSoundBg.width, 0));

         // adjust first
         onVolAdjusting();

         stage.addEventListener(MouseEvent.MOUSE_MOVE, onVolAdjusting);
         stage.addEventListener(MouseEvent.MOUSE_UP, stopVolAdjust);
      }

      private function onVolAdjusting(e:MouseEvent = null):void
      {
         var perc:int = Math.floor(100 * btnSoundSeeker.x / btnSoundBg.width);

         if (perc >= 80)
         {
            volume = 100;
            btnSound.gotoAndStop(1);
         }
         else if (perc >= 60)
         {
            volume = 80;
            btnSound.gotoAndStop(2);
         }
         else if (perc >= 40)
         {
            volume = 60;
            btnSound.gotoAndStop(3);
         }
         else if (perc >= 20)
         {
            volume = 40;
            btnSound.gotoAndStop(4);
         }
         else if (perc > 0)
         {
            volume = 20;
            btnSound.gotoAndStop(5);
         }
         else
         {
            volume = 0;
            btnSound.gotoAndStop(6);
         }
      }

      private function stopVolAdjust(e:MouseEvent):void
      {
         btnSoundSeeker.stopDrag();

         stage.removeEventListener(MouseEvent.MOUSE_MOVE, onVolAdjusting);
         stage.removeEventListener(MouseEvent.MOUSE_UP, stopVolAdjust);
      }

      private function startSeek(e:MouseEvent):void
      {
         // ignor when src == null, player unstarted
         if (!_src) return;

         btnSeeker.x = e.currentTarget.mouseX;
         btnSeeker.startDrag(true, new Rectangle(0, 0, btnBgProgress.width, 0));

         player.pauseVideo();
         onSeeking();

         stage.addEventListener(MouseEvent.MOUSE_MOVE, onSeeking);
         stage.addEventListener(MouseEvent.MOUSE_UP, stopSeek);
      }

      private function onSeeking(e:MouseEvent = null):void
      {
         player.seekTo(totalSec * btnSeeker.x / btnBgProgress.width, false);
         player.pauseVideo();
         TweenLite.to(btnFgProgress, 0.3, { width:btnSeeker.x });
      }

      private function stopSeek(e:MouseEvent):void
      {
         btnSeeker.stopDrag();

         if (btnSeeker.x == btnBgProgress.width) // if seek to the end
         {
            TweenLite.to(btnFgProgress, 0.8, { width:0 } );
            btnPlayPause.gotoAndStop(1);

            player.stopVideo();
         }
         else if (btnPlayPause.currentFrame == 2) // if status is "play"
         {
            player.playVideo();
         }

         stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSeeking);
         stage.removeEventListener(MouseEvent.MOUSE_UP, stopSeek);
      }

      private function onBuffering(e:Event):void
      {
         //trace("[buffering]", bytesLoaded, "/", bytesTotal, "-", loadPerc);
         TweenLite.to(btnBufferProgress, 0.3, { width:btnBgProgress.width * loadPerc });

         if (bytesLoaded == bytesTotal)
         {
            removeEventListener(Event.ENTER_FRAME, onBuffering);
         }
      }

      private function onProgressing(e:Event):void
      {
         if (!_src) return;

         //trace("[progressing]", currSec, "/", totalSec, "-", playPerc);
         TweenLite.to(btnFgProgress, 0.3, { width:btnBgProgress.width * playPerc });
      }

      private function showPanelFunc(e:MouseEvent = null):void
      {
         if (!btnController.visible) return;

         TweenLite.to(btnController, 0.4, { alpha:1, ease:Quart.easeOut } );
      }

      private function hidePanelFunc(e:MouseEvent = null):void
      {
         if (!_autoHidePanel || !btnController.visible) return;

         TweenLite.to(btnController, 0.4, { alpha:0, ease:Quart.easeIn } );
      }

   }

}