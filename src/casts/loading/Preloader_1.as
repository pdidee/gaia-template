package casts.loading
{
   import _extension.GaiaPlus;
   
   import casts.loading.template.InOutNonblockPreloader;
   
   import com.gaiaframework.events.AssetEvent;
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.greensock.easing.Quad;
   import com.greensock.easing.Quint;
   import com.greensock.plugins.AutoAlphaPlugin;
   import com.greensock.plugins.TweenPlugin;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class Preloader_1 extends InOutNonblockPreloader
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
         isShow = false;
         
         // gs
         TweenPlugin.activate([AutoAlphaPlugin]);
      }
      
      // --------------------- LINE ---------------------
      
      override public function transitionIn():void
      {
         // necessary for block mode
         //         if (!callByTransitIn)
         //         {
         //            super.transitionIn();
         //            super.transitionInComplete();
         //            return;
         //         }
         //         else
         //         {
         //            callByTransitIn = false;
         //         }
         
         // stop cmd(TimelineMax)
         cmd.stop();
         cmd.kill();
         cmd = new TimelineMax(
            {
               onStart:function()
               {
                  // necessary for non-block mode
                  isShow = true;
                  
                  transitionInComplete();
               },
               onComplete:function()
               {
                  tryReleaseGaia();
                  transitionInComplete();
               }
            }
         );
         
         // [init]
         TweenMax.to(this, 0, {autoAlpha:1, scaleX:1, scaleY:1});
         TweenMax.to(mcThumb, 0, {alpha:1, width:0});
         TweenMax.to(mcTrack, 0, {alpha:1});
         
         // [actions]
         cmd.insert(TweenMax.to(this, 0.4, {alpha:1, ease:Quad.easeOut}));
         
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
                  // necessary for non-block mode
                  isShow = false;
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
            cmd.insert(TweenMax.to(mcThumb, 0.4, {width:width100}));
            cmd.insert(TweenMax.to(mcThumb, 0.4, {alpha:0}), 0.4);
            cmd.insert(TweenMax.to(mcTrack, 0.4, {alpha:0}), 0.4);
            cmd.insert(TweenMax.to(this, 0.4, {autoAlpha:0, ease:Quint.easeIn}), 0.8);
         }
         
         cmd.play();
      }
      
      override public function transitionOutComplete():void
      {
         super.transitionOutComplete();
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
         
         // debug
         GaiaPlus.api.initTest(this);
      }
      
      // ################### protected ##################
      
      override protected function onStageResize(e:Event = null):void
      {
         x = (sw>>1) - (GB.DOC_WIDTH>>1);
         y = (sh>>1) - (GB.DOC_HEIGHT>>1);
         
         mcBLK.width = sw;
         mcBLK.height = sh;
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}