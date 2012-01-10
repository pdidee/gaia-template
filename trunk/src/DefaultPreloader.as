package
{
   import _extension.GaiaPlus;
   
   import casts.loading.template.InOutBlockPreloader;
   
   import com.gaiaframework.api.Gaia;
   import com.gaiaframework.api.IMovieClip;
   import com.gaiaframework.events.AssetEvent;
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.greensock.easing.Quad;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class DefaultPreloader extends InOutBlockPreloader
   {
      // fla
      public var mcThumb:MovieClip;
      public var mcTrack:MovieClip;
      public var mcBg:MovieClip;
      
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
         GaiaPlus.api.initTest(this);
      }
      
      // ################### protected ##################
      
      override protected function onStageResize(e:Event = null):void
      {
         x = (sw>>1) - (GB.DocWidth>>1);
         y = (sh>>1) - (GB.DocHeight>>1);
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