package casts.root
{
   import casts._lightbox.BaseVideoLightbox;
   
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.greensock.plugins.AutoAlphaPlugin;
   import com.greensock.plugins.TransformAroundPointPlugin;
   import com.greensock.plugins.TweenPlugin;
   
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   /**
    * A Video-Player.
    * @author boy, cjboy1984@gmail.com
    * @usage
    * // assign resource.
    * GaiaPlus.api.getAsset('tvc', 'root').video_src = 'video.flv';
    * // show and play it.
    * GaiaPlus.api.showAsset('tvc', 'root', null);
    */   
   public class RootVideoLightbox extends BaseVideoLightbox
   {
      // fla
      public var mcBg:MovieClip;
      
      public function RootVideoLightbox()
      {
         super();
         
         TweenPlugin.activate([AutoAlphaPlugin]);
         TweenPlugin.activate([TransformAroundPointPlugin]);
         
         video_src = 'http://dl.dropbox.com/u/3587501/httpdoc2/video/test.flv';
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
               playVid();
            }
         });
         
         // [init]
         TweenMax.to(this, 0, {autoAlpha:1});
         TweenMax.to(mcBg, 0, {alpha:0});
         TweenMax.to(mcPlayer, 0, {x:142, y:77, alpha:0, scaleX:1, scaleY:1});
         TweenMax.to(btnClose, 0, {x:761, y:61, alpha:0});
         initBtnClose();
         
         // [actions]
         cmd.insert(TweenMax.to(mcBg, 0.6, {alpha:1}));
         cmd.insert(TweenMax.to(mcPlayer, 0.6, {y:47, alpha:1}));
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
               mcPlayer.stopVid();
               
               // framework
               returnToParent();
               
               transitionOutComplete();
            }
         });
         
         // [init]
         // [actions]
         cmd.insert(TweenMax.to(this, 0.6, {autoAlpha:0}));
         cmd.insert(TweenMax.to(mcPlayer, 0.6, {transformAroundPoint:{point:new Point(480,260), scaleX:0.9, scaleY:0.9}}));
         
         cmd.play();
      }
      
      override public function transitionOutComplete():void
      {
         super.transitionOutComplete();
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}