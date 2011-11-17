package casts.loading
{
   import casts.loading.template.InOutBlockPreloader;
   
   import com.gaiaframework.events.AssetEvent;
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.greensock.easing.Quad;
   import com.greensock.easing.Quint;
   
   import debug.GaiaTest;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class Preloader_1 extends InOutBlockPreloader
   {
      // fla
      public var mcThumb:MovieClip;
      public var mcTrack:MovieClip;
      public var mcBLK:MovieClip;
      
      // 100%
      private const width100:Number = 118;
      
      // cmd
      private var cmd:TimelineMax = new TimelineMax();
      
      public function Preloader_1()
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
            cmd.insert(TweenMax.to(this, 0.6, { alpha:0, ease:Quint.easeIn } ), 1.0);
            
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
         visible = false;
         
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
         
         mcBLK.width = sw;
         mcBLK.height = sh;
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}