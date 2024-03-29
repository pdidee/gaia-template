package
{
   import _extension.GaiaPlus;
   
   import casts.loading.template.InOutBlockPreloader;
   
   import com.gaiaframework.api.Gaia;
   import com.gaiaframework.api.IMovieClip;
   import com.gaiaframework.events.AssetEvent;
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.greensock.plugins.AutoAlphaPlugin;
   import com.greensock.plugins.TweenPlugin;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class Preloader1 extends InOutBlockPreloader
   {
      // fla
      public var mcThumb:MovieClip;
      public var mcTrack:MovieClip;
      public var mcBg:MovieClip;
      
      // 100%
      private var width100:Number;
      
      // cmd
      private var cmd:TimelineMax = new TimelineMax();
      
      public function Preloader1()
      {
         super();
         
         // gs
         TweenPlugin.activate([AutoAlphaPlugin]);
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
               },
               onComplete:function()
               {
                  tryReleaseGaia();
                  transitionInComplete();
               }
            }
         );
         
         // [init]
         TweenMax.to(this, 0, {autoAlpha:1});
         TweenMax.to(mcThumb, 0, {alpha:1, width:0});
         TweenMax.to(mcTrack, 0, {alpha:0});
         TweenMax.to(mcBg, 0, {alpha:0});
         
         // layer
         if (Gaia.api)
         {
            parent.parent.setChildIndex(parent, 0);
         }
         
         // [actions]
         cmd.insert(TweenMax.to(mcTrack, 0.7, {alpha:1}));
         cmd.insert(TweenMax.to(mcBg, 0.7, {alpha:1}));
         
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
               },
               onComplete:function()
               {
                  transitionOutComplete();
               }
            }
         );
         
         if (isShow)
         {
            // [init]
            // [actions]
            cmd.insert(TweenMax.to(mcThumb, 0.2, {width:width100}));
            cmd.insert(TweenMax.to(this, 0.5, {autoAlpha:0}), 0.0);
            
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
         changePreloader();
      }
      
      // --------------------- LINE ---------------------
      
      override public function onProgress(event:AssetEvent):void
      {
         TweenMax.to(mcThumb, 1, {width:width100 * event.perc});
      }
      
      // --------------------- LINE ---------------------
      
      override public function onAdd(e:Event):void
      {
         super.onAdd(e);
         
         visible = false;
         alpha = 0;
         width100 = mcTrack.width;
         
         // debug
         GaiaPlus.api.initTest(this);
      }
      
      // ################### protected ##################
      
      override protected function updatePosition(e:Event = null):void
      {
         x = (sw>>1) - (GB.DOC_WIDTH>>1);
         y = 0;
      }
      
      // #################### private ###################
      
      private function changePreloader():void
      {
         if (!Gaia.api) return;
         
         var newPreloader:IMovieClip = IMovieClip(Gaia.api.getPage('root').assets.preloader2);
         GaiaPlus.api.setPreloader(newPreloader);
      }
      
      // --------------------- LINE ---------------------
      
   }
   
}