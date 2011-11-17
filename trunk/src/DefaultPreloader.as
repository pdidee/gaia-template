package
{
   import casts.impls.IMyPreloaderView;
   import casts.loading.template.InOutBlockPreloader;
   import casts.particles.BubbleStarView;
   
   import com.gaiaframework.api.Gaia;
   import com.gaiaframework.api.IMovieClip;
   import com.gaiaframework.events.AssetEvent;
   import com.gaiaframework.events.GaiaEvent;
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.greensock.easing.Quad;
   
   import debug.GaiaTest;
   
   import extension.GaiaPlus;
   
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class DefaultPreloader extends InOutBlockPreloader
   {
      // fla
      public var mcExposure:MovieClip;
      public var mcThumb:MovieClip;
      public var mcTrack:MovieClip;
      public var mcBg:MovieClip;
      public var mcBubbleView:BubbleStarView;
      
      // 100%
      private var width100:Number;
      
      // cmd
      private var cmd:TimelineMax = new TimelineMax();
      
      public function DefaultPreloader()
      {
         super();
      }
      
      // --------------------- LINE ---------------------
      
      override public function transitionIn():void
      {
         // necessary for block-mode
         if (!callByTransitIn)
         {
            super.transitionIn();
            super.transitionInComplete();
            return;
         }
         else
         {
            callByTransitIn = false;
         }
         
         // stop cmd(TimelineMax)
         cmd.stop();
         cmd.kill();
         cmd = new TimelineMax(
            {
               onStart:function()
               {
                  visible = true;
                  mcBubbleView.startEffx();
               },
               onComplete:function()
               {
                  tryReleaseGaia();
                  transitionInComplete();
               }
            }
         );
         
         // [init]
         alpha = 0;
         mcThumb.width = 0;
         mcThumb.alpha = mcTrack.alpha = 1;
         mcExposure.alpha = 0;
         
         // [actions]
         cmd.insert(TweenMax.to(this, 0.6, { alpha:1, ease:Quad.easeOut } ));
         
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
         cmd = new TimelineMax(
            {
               onStart:function()
               {
                  mcBubbleView.stopCreateParticles();
               },
               onComplete:function()
               {
                  mcBubbleView.stopEffx();
                  
                  transitionOutComplete();
               }
            }
         );
         
         if (isShow)
         {
            // [init]
            // [actions]
            cmd.insert(TweenMax.to(mcThumb, 0.6, { width:width100 } ));
            cmd.insert(TweenMax.to(mcThumb, 0.6, { alpha:0 } ), 0.6);
            cmd.insert(TweenMax.to(mcTrack, 0.6, { alpha:0 } ), 0.6);
            cmd.insert(TweenMax.to(this, 1, { alpha:0 } ), 1.2);
            
            cmd.play();
         }
         else
         {
            transitionOutComplete();
         }
      }
      
      override public function transitionOutComplete():void
      {
         super.transitionOutComplete();
         visible = false;
         
         changePreloader();
      }
      
      // --------------------- LINE ---------------------
      
      override public function onProgress(event:AssetEvent):void
      {
         TweenMax.to(mcThumb, 1, { width:width100 * event.perc } );
      }
      
      // --------------------- LINE ---------------------
      
      override public function onAdd(e:Event):void
      {
         super.onAdd(e);
         
         alpha = 0;
         width100 = mcTrack.width;
         
         // debug
         GaiaTest.init(this);
         
         // test
//         mcLoading.transitionIn(function(){});
//         setTimeout(mcLoading.transitionOut, 2 * 1000, function(){});
      }
      
      // ################### protected ##################
      
      override protected function onStageResize(e:Event = null):void
      {
         x = (sw>>1) - 480;
         y = (sh>>1) - 260;
         
         mcExposure.width = sw;
         mcExposure.height = sh;
      }
      
      // #################### private ###################
      
      private function changePreloader():void
      {
         if (!Gaia.api) return;
         
         var newPreloader:IMovieClip = IMovieClip(Gaia.api.getPage('root').assets.preloader_1);
         GaiaPlus.api.setPreloader(newPreloader);
      }
      
      // --------------------- LINE ---------------------
      
   }
   
}