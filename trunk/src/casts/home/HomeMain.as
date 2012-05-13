package casts.home
{
   import _extension.GaiaPlus;
   
   import com.gaiaframework.templates.AbstractPage;
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import com.greensock.plugins.AutoAlphaPlugin;
   import com.greensock.plugins.BezierPlugin;
   import com.greensock.plugins.TweenPlugin;
   
   import flash.display.MovieClip;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   
   public class HomeMain extends AbstractPage
   {
      // fla
      public var mc1:MovieClip;
      public var mc2:MovieClip;
      public var mc3:MovieClip;
      public var mc4:MovieClip;
      
      // cmd
      private var cmd:TimelineMax = new TimelineMax();
      
      public function HomeMain()
      {
         super();
         
         // gs
         TweenPlugin.activate([AutoAlphaPlugin, BezierPlugin]);
         
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
            }
         });
         
         // ---[init]---
         TweenMax.to(this, 0, {frame:1, autoAlpha:1});
         
         mc1.orgx = mc2.orgx = mc3.orgx = mc4.orgx = 754;
         
         TweenMax.to(mc1, 0, {x:754, y:196, rotation:0, alpha:0, scaleX:0.5, scaleY:0.5});
         TweenMax.to(mc2, 0, {x:754, y:201, rotation:0, alpha:0, scaleX:0.5, scaleY:0.5});
         TweenMax.to(mc3, 0, {x:754, y:201, rotation:0, alpha:0, scaleX:0.5, scaleY:0.5});
         TweenMax.to(mc4, 0, {x:754, y:201, rotation:0, alpha:0, scaleX:0.5, scaleY:0.5});
         
         // ---[actions]---
         cmd.insert(TweenMax.to(mc1, 1, {alpha:1}), 0.0);
         cmd.insert(TweenMax.to(mc1, 3, {bezier:[{x:894,y:236},{x:400,y:256}], scaleX:1, scaleY:1, onUpdate:updateRotation, onUpdateParams:[mc1], ease:Back.easeOut}), 0.0);
         
         cmd.insert(TweenMax.to(mc2, 1, {alpha:1}), 0.2);
         cmd.insert(TweenMax.to(mc2, 3, {bezier:[{x:924,y:241},{x:461,y:265}], scaleX:1, scaleY:1, onUpdate:updateRotation, onUpdateParams:[mc2], ease:Back.easeOut}), 0.2);
         
         cmd.insert(TweenMax.to(mc3, 1, {alpha:1}), 0.4);
         cmd.insert(TweenMax.to(mc3, 3, {bezier:[{x:958,y:241},{x:528,y:265}], scaleX:1, scaleY:1, onUpdate:updateRotation, onUpdateParams:[mc3], ease:Back.easeOut}), 0.4);
         
         cmd.insert(TweenMax.to(mc4, 1, {alpha:1}), 0.6);
         cmd.insert(TweenMax.to(mc4, 3, {bezier:[{x:991,y:241},{x:594,y:265}], scaleX:1, scaleY:1, onUpdate:updateRotation, onUpdateParams:[mc4], ease:Back.easeOut}), 0.6);
         
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
               onUpdate:function()
               {
               },
               onComplete:function()
               {
                  transitionOutComplete();
               }
            }
         );
         
         // ---[init]---
         // kill rotation tween
         for each (var mc:MovieClip in [mc1,mc2,mc3,mc4]) 
         {
            TweenMax.killTweensOf(mc);
         }
         
         // ---[actions]---
         cmd.insert(TweenMax.to(this, 0.3, {autoAlpha:0}));
         
         cmd.play();
      }
      
      override public function transitionOutComplete():void
      {
         super.transitionOutComplete();
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      private function onAdd(e:Event):void
      {
         // basic
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         updatePosition();
         stage.addEventListener(Event.RESIZE, updatePosition);
         
         TweenMax.to(this, 0, {frame:1, autoAlpha:0});
         
         // debug
         GaiaPlus.api.initTest(this);
      }
      
      private function onRemove(e:Event):void
      {
         // basic
         stage.removeEventListener(Event.RESIZE, updatePosition);
      }
      
      private function updatePosition(e:Event = null):void
      {
         x = (sw - GB.DOC_WIDTH) >> 1;
         y = (sh - GB.DOC_HEIGHT) >> 1;
      }
      
      protected function get sw():Number { return stage.stageWidth; }
      protected function get sh():Number { return stage.stageHeight; }
      
      // ________________________________________________
      //                                  update rotation
      
      private function updateRotation(mc:MovieClip):void
      {
         var dx:Number = mc.x - mc.orgx;
         mc.orgx = mc.x;
         
         TweenMax.to(mc, 0.3, {rotation:dx*3});
      }
      
      // --------------------- LINE ---------------------
      
   }
   
}