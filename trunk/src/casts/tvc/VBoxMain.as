package casts.tvc
{
   import _myui.player.GreenPlayer;
   import _myui.player.VLoading;
   import _myui.player.VPlayButton;
   import _myui.player.VPlayButton_Screen;
   import _myui.player.VProgressBar;
   import _myui.player.VVolButton1;
   
   import casts._lightbox.BaseLightbox;
   
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.greensock.plugins.AutoAlphaPlugin;
   import com.greensock.plugins.BlurFilterPlugin;
   import com.greensock.plugins.TweenPlugin;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   
   /**
    * A Video-Player.
    * @author boy, cjboy1984@gmail.com
    * @usage
    * // assign resource.
    * GaiaPlus.api.getAssetContent('tvc', 'root').setInfo('video.flv', 1);
    * // show and play it.
    * GaiaPlus.api.showAsset('tvc', 'root', null);
    */   
   public class VBoxMain extends BaseLightbox
   {
      // fla
      public var btnClose:MyButton;
      public var mc1:MovieClip;
      public var mc2:MovieClip;
      public function get mcLoading():VLoading { return VLoading(mc2.mcLoading); }
      public function get btnPlay1():VPlayButton_Screen { return VPlayButton_Screen(mc2.btnPlay1); }
      public function get btnPlay2():VPlayButton { return VPlayButton(mc2.btnPlay2); }
      public function get btnBar():VProgressBar { return VProgressBar(mc2.btnBar); }
      public function get btnVol():VVolButton1 { return VVolButton1(mc2.btnVol); }
      public var mc3:MovieClip;
      
      // video-source
      public var src:String = 'http://dl.dropbox.com/u/3587501/httpdoc2/video/test.flv';
      
      // player
      private var player:GreenPlayer = new GreenPlayer(630, 362);
      
      public function VBoxMain()
      {
         super();
         
         TweenPlugin.activate([AutoAlphaPlugin, BlurFilterPlugin]);
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                             init
      
      public function setInfo(source:String, titleFrame:uint = 1):void
      {
         mc1.gotoAndStop(titleFrame);
         src = source;
      }
      
      // ________________________________________________
      //                                        framework
      
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
               mouseChildren = true;
               // video
               player.play();
            }
         });
         
         // [init]
         mouseChildren = false;
         initPlayer();
         initButton();
         TweenMax.to(this, 0, {autoAlpha:1});
         TweenMax.to(mc3, 0, {alpha:0});
         TweenMax.to(mc2, 0, {alpha:0, scaleX:0.9, scaleY:0.9, blurFilter:{blurX:20, blurY:20}});
         TweenMax.to(btnClose, 0, {y:140, alpha:0});
         
         // [actions]
         cmd.insert(TweenMax.to(mc3, 0.5, {alpha:1}));
         cmd.insert(TweenMax.to(mc2, 1.0, {alpha:1, scaleX:1, scaleY:1, blurFilter:{blurX:0, blurY:0}}));
         cmd.insert(TweenMax.to(btnClose, 0.6, {y:115, alpha:1}), 0.8);
         
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
         cmd.insert(TweenMax.to(this, 0.3, {autoAlpha:0}));
         
         cmd.play();
      }
      
      override public function transitionOutComplete():void
      {
         super.transitionOutComplete();
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      override protected function updatePosition(e:Event = null):void
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
         btnBar.barWidth = 533;
         
         // sync model
         var modId:String = 'tvc';
         mcLoading.init(modId);
         btnPlay1.init(modId);
         btnPlay2.init(modId);
         btnBar.init(modId);
         btnVol.init(modId);
         
         player.src = src;
         player.x = -314;
         player.y = -196;
         player.init(modId);
         mc2.addChildAt(player, 4);
      }
      
      private function destroyPlayer():void
      {
         mc2.removeChild(player);
      }
      
      // --------------------- LINE ---------------------
      
   }
   
}