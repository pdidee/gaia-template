package casts.tvc
{
   import _myui.player.GreenPlayer;
   import _myui.player.VLoading;
   import _myui.player.VPlayButton2;
   import _myui.player.VPlayButton3;
   import _myui.player.VProgressBar;
   import _myui.player.VVolButton2;
   
   import casts._lightbox.BaseLightbox;
   
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.greensock.plugins.AutoAlphaPlugin;
   import com.greensock.plugins.TransformAroundPointPlugin;
   import com.greensock.plugins.TweenPlugin;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   
   /**
    * A Video-Player.
    * @author boy, cjboy1984@gmail.com
    * @usage
    * // assign resource.
    * GaiaPlus.api.getAssetContent('tvc', 'root').video_src = 'video.flv';
    * // show and play it.
    * GaiaPlus.api.showAsset('tvc', 'root', null);
    */   
   public class VBoxMain extends BaseLightbox
   {
      // fla
      public var btnClose:MyButton;
      public var mcMain:MovieClip;
      public function get mcLoading():VLoading { return VLoading(mcMain.mcLoading); }
      public function get btnPlay1():VPlayButton2 { return VPlayButton2(mcMain.btnPlay1); }
      public function get btnPlay2():VPlayButton3 { return VPlayButton3(mcMain.btnPlay2); }
      public function get btnBar():VProgressBar { return VProgressBar(mcMain.btnBar); }
      public function get btnVol():VVolButton2 { return VVolButton2(mcMain.btnVol); }
      public var mcBg:MovieClip;
      
      // player
      private var player:GreenPlayer = new GreenPlayer('http://dl.dropbox.com/u/3587501/httpdoc2/video/test.flv', 632, 359);
      
      public function VBoxMain()
      {
         super();
         
         TweenPlugin.activate([AutoAlphaPlugin]);
         TweenPlugin.activate([TransformAroundPointPlugin]);
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // --------------------- LINE ---------------------
      
      override public function transitionIn():void
      {
         super.transitionIn();
         transitionInComplete();
         
         // stop cmd(TimelineMax)
         cmd.stop();
         cmd.kill();
         cmd = new TimelineMax({
            onStart:function()
            {
            },
            onUpdate:function()
            {
            },
            onComplete:function()
            {
               // video
               player.play();
            }
         });
         
         // [init]
         initPlayer();
         initButton();
         TweenMax.to(this, 0, {autoAlpha:1});
         TweenMax.to(mcBg, 0, {alpha:0});
         TweenMax.to(mcMain, 0, {x:142, y:77, alpha:0, scaleX:1, scaleY:1});
         TweenMax.to(btnClose, 0, {x:761, y:61, alpha:0});
         
         // [actions]
         cmd.insert(TweenMax.to(mcBg, 0.6, {alpha:1}));
         cmd.insert(TweenMax.to(mcMain, 0.6, {y:47, alpha:1}));
         cmd.insert(TweenMax.to(btnClose, 0.6, {y:21, alpha:1}), 0.4);
         
         cmd.play();
      }
      
      override public function transitionInComplete():void
      {
         super.transitionInComplete();
      }
      
      override public function transitionOut():void
      {
         super.transitionOut();
         
         // stop cmd(TimelineMax)
         cmd.stop();
         cmd.kill();
         cmd = new TimelineMax({
            onStart:function()
            {
            },
            onUpdate:function()
            {
            },
            onComplete:function()
            {
               // video
               player.stop();
               
               // framework
               returnToParent();
               
               transitionOutComplete();
            }
         });
         
         // [init]
         destroyPlayer();
         // [actions]
         cmd.insert(TweenMax.to(this, 0.6, {autoAlpha:0}));
         cmd.insert(TweenMax.to(mcMain, 0.6, {transformAroundPoint:{point:new Point(480,260), scaleX:0.9, scaleY:0.9}}));
         
         cmd.play();
      }
      
      override public function transitionOutComplete():void
      {
         super.transitionOutComplete();
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      override protected function onStageResize(e:Event = null):void
      {
         x = (sw>>1) - (GB.DOC_WIDTH>>1);
         y = (sh>>1) - (GB.DOC_HEIGHT>>1);
      }
      
      // ________________________________________________
      //                                           button
      
      private function initButton():void
      {
         btnClose.gotoAndStop(1);
         btnClose.buttonMode = true;
         btnClose.onClick = function()
         {
            if (!this.buttonMode) return;
            this.buttonMode = false;
            
            transitionOut();
         };
      }
      
      // ________________________________________________
      //                                           player
      
      private function initPlayer():void
      {
         // sync model
         btnBar.barWidth = 556;
         btnVol.barWidth = 35;
         mcLoading.id = btnPlay1.id = btnPlay2.id = btnBar.id = btnVol.id = player.id = 'tvc';
         
         player.x = 23;
         player.y = 9;
         mcMain.addChildAt(player, 4);
      }
      
      private function destroyPlayer():void
      {
         mcMain.removeChild(player);
      }
      
      // --------------------- LINE ---------------------
      
   }
   
}