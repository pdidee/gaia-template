﻿package myui.player{   import com.greensock.TweenMax;   import com.greensock.plugins.AutoAlphaPlugin;   import com.greensock.plugins.TweenPlugin;      import fl.video.FLVPlayback;   import fl.video.VideoEvent;      import flash.display.MovieClip;   import flash.events.Event;   import flash.events.FullScreenEvent;   import flash.events.MouseEvent;   import flash.geom.Point;   import flash.geom.Rectangle;      import myui.player.core.MyPlayerMgr;
   /**   * A FLV-player template basing on the MVC Pattern. It represent the "C", the controller.    * @author  boy | cjboy1984@gmail.com    */   public class BaseFlvPlayer extends MovieClip   {      // fla      public var mcPlayer:FLVPlayback;      public var mcFg:MovieClip;      public var mcLoading:MovieClip;      // data      private var firstTimePlay:Boolean = true;      protected var _autoRewind:Boolean = false;      // org pos, width x height, for fullscreen      protected var orgInfo:Rectangle;      protected var _fullscreen:Boolean;            // player manager      protected var managerNo:int = 0;      protected function get mgr():MyPlayerMgr { return MyPlayerMgr.getMgrAt(managerNo); }      public function BaseFlvPlayer()      {         // disable tab-functionality.         tabEnabled = false;         tabChildren = false;         focusRect = false;                  TweenPlugin.activate([AutoAlphaPlugin]);         stop();         addEventListener(Event.ADDED_TO_STAGE, onAdded);         addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);      }      // --------------------- LINE ---------------------      public function playVid(v:String = null):void      {         if (v) src = v;         mgr.play();      }      public function pauseVid():void { mgr.pause(); }      public function stopVid():void { mgr.stop(); }      public function get src():String { return mcPlayer.source; }      public function set src(v:String):void { mcPlayer.source = v; }      // Is automaticall replay when video plays to the end, default is true.      public function get autoRewind():Boolean { return mcPlayer.autoRewind; }      public function set autoRewind(v:Boolean):void { mcPlayer.autoRewind = v; }      // Is automaticall play video after src is given, default is true.      public function get autoPlay():Boolean { return mcPlayer.autoPlay; }      public function set autoPlay(value:Boolean):void { mcPlayer.autoPlay = value; }      // Is Playing???      public function get isPlaying():Boolean { return mcPlayer.playing; }      // ################### protected ##################      protected function onAdded(e:Event):void      {         mcPlayer.fullScreenTakeOver = false;                  // loading         if (mcLoading)         {            TweenMax.killTweensOf(mcLoading);            mcLoading.visible = false;            mcLoading.alpha = 0;         }         // foreground         if (mcFg)         {            TweenMax.killTweensOf(mcFg);            mcFg.visible = true;            mcFg.alpha = 1;         }         // save org width x height         orgInfo = new Rectangle(mcPlayer.registrationX, mcPlayer.registrationY, mcPlayer.width, mcPlayer.height);         // using 0th model         mgr.addEventListener(MyPlayerMgr.PLAY, onPlayVid);         mgr.addEventListener(MyPlayerMgr.PAUSE, onPauseVid);         mgr.addEventListener(MyPlayerMgr.STOP, onStopVid);         mgr.addEventListener(MyPlayerMgr.SEEK_TO, onSeekTo);         mgr.addEventListener(MyPlayerMgr.VOLUME_CHANGE, onVolumeChange);         // this         addEventListener(MouseEvent.MOUSE_MOVE, onMMove);         addEventListener(MouseEvent.ROLL_OVER, onMOut);         addEventListener(MouseEvent.ROLL_OUT, onMOver);         // mcPlayer         mcPlayer.addEventListener(VideoEvent.STATE_CHANGE, onPlayerStateChange);         mcPlayer.addEventListener(VideoEvent.COMPLETE, onVideoEnd);         // stage full screen         stage.addEventListener(FullScreenEvent.FULL_SCREEN, onEnterFullscreen);         stage.addEventListener(Event.RESIZE, onStageResize);      }      protected function onRemoved(e:Event):void      {         if (mcFg) TweenMax.killTweensOf(mcFg);                  // model         mgr.removeEventListener(MyPlayerMgr.PLAY, onPlayVid);         mgr.removeEventListener(MyPlayerMgr.PAUSE, onPauseVid);         mgr.removeEventListener(MyPlayerMgr.STOP, onStopVid);         mgr.removeEventListener(MyPlayerMgr.SEEK_TO, onSeekTo);         mgr.removeEventListener(MyPlayerMgr.VOLUME_CHANGE, onVolumeChange);         // this         removeEventListener(MouseEvent.MOUSE_MOVE, onMMove);         removeEventListener(MouseEvent.ROLL_OVER, onMOut);         removeEventListener(MouseEvent.ROLL_OUT, onMOver);         removeEventListener(Event.ENTER_FRAME, onVideoPlaying);         removeEventListener(Event.ENTER_FRAME, onVideoBuffering);         // mcPlayer         mcPlayer.removeEventListener(VideoEvent.COMPLETE, onVideoEnd);         mcPlayer.removeEventListener(VideoEvent.STATE_CHANGE, onPlayerStateChange);         mcPlayer.stop();         mcPlayer.getVideoPlayer(0).close(); // TODO - not sure does it work well?         // stage full screen         stage.removeEventListener(FullScreenEvent.FULL_SCREEN, onEnterFullscreen);         stage.removeEventListener(Event.RESIZE, onStageResize);      }      // --------------------- LINE ---------------------      protected function onPlayVid(e:Event):void      {         mcPlayer.play();      }      protected function onPauseVid(e:Event):void      {         mcPlayer.pause();      }      protected function onStopVid(e:Event):void      {         mcPlayer.stop();      }      // --------------------- LINE ---------------------      protected function onPlayerStateChange(e:VideoEvent):void      {//         trace(" BaseFlvPlayer | state =", e.state);         // buffering         if (e.state == "buffering")         {            addEventListener(Event.ENTER_FRAME, onVideoBuffering);         }                  // loading         if (mcLoading)         {            if (e.state == 'loading' || e.state == 'buffering')            {               TweenMax.to(mcLoading, 0.4, {autoAlpha:1});            }            else            {               TweenMax.to(mcLoading, 0.4, {autoAlpha:0});            }         }         // progressing         switch(e.state)         {            case "playing":               //mcPlayer.seekPercent(mgr.playheadPercentage);               addEventListener(Event.ENTER_FRAME, onVideoPlaying);                              // because mcPlayer.autoPlay = true, mgr won't know it is playing.               if (firstTimePlay)               {                  firstTimePlay = false;                  mgr.play();                                    if (mcFg) TweenMax.to(mcFg, 0.6, {alpha:0, visible:false});               }               break;            case "stopped":            case "seeking":            case "paused":               removeEventListener(Event.ENTER_FRAME, onVideoPlaying);               break;            case 'rewinding':               mgr.play();               break;         }      }      // --------------------- LINE ---------------------      protected function onVideoPlaying(e:Event):void      {         mgr.playheadPercentage = mcPlayer.playheadPercentage;      }      protected function onVideoBuffering(e:Event):void      {         var perc:int = Math.floor(100 * mcPlayer.bytesLoaded / mcPlayer.bytesTotal);         mgr.loadPerc = perc;         if (perc == 100)         {            removeEventListener(Event.ENTER_FRAME, onVideoBuffering);         }      }      protected function onSeekTo(e:Event):void      {         if (mcPlayer.bytesLoaded != 0)         {            mcPlayer.seekPercent(mgr.playheadPercentage);         }      }      protected function onVideoEnd(e:VideoEvent):void      {         // dispatch event         mgr.sendVideoEndNote();         dispatchEvent(new Event(MyPlayerMgr.VIDEO_END));      }      // --------------------- LINE ---------------------      protected function onVolumeChange(e:Event):void      {         mcPlayer.volume = mgr.volumePercentage / 100;      }      // --------------------- LINE ---------------------      protected function onMMove(e:MouseEvent):void      {         mgr.dispatchEvent(new Event(MyPlayerMgr.MOUSE_MOVE));      }      protected function onMOver(e:MouseEvent):void      {         mgr.dispatchEvent(new Event(MyPlayerMgr.ROLL_OUT));      }      protected function onMOut(e:MouseEvent):void      {         mgr.dispatchEvent(new Event(MyPlayerMgr.ROLL_OVER));      }      // --------------------- LINE ---------------------      // 先觸發fullscreen事件才觸發resize事件      protected function onEnterFullscreen(e:FullScreenEvent):void      {         _fullscreen = e.fullScreen;      }      protected function onStageResize(e:Event):void      {         if (_fullscreen)         {            // player            var locPos:Point = globalToLocal(new Point(0, 0));            mcPlayer.registrationX = locPos.x;            mcPlayer.registrationY = locPos.y;            mcPlayer.setSize(sw, sh);         }         else         {            // player            mcPlayer.registrationX = orgInfo.x;            mcPlayer.registrationY = orgInfo.y;            mcPlayer.setSize(orgInfo.width, orgInfo.height);         }      }            protected function get sw():Number { return stage.stageWidth; }      protected function get sh():Number { return stage.stageHeight; }            // #################### protected ###################      // --------------------- LINE ---------------------   }}