package _sample
{
   import _extension.GaiaPlus;
   
   import com.gaiaframework.api.Gaia;
   import com.gaiaframework.events.GaiaEvent;
   import com.gaiaframework.templates.AbstractPage;
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.greensock.plugins.AutoAlphaPlugin;
   import com.greensock.plugins.TweenPlugin;
   
   import flash.display.BlendMode;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   
   public class PageSample extends AbstractPage
   {
      // fla
      
      // framework history
      private const BRANCH:String = 'path';
      private var previousBranch:String;
      
      // cmd
      public var t1:Number = 0;
      public var t2:Number = 0;
      public var t3:Number = 0;
      public var t4:Number = 0;
      public var t5:Number = 0;
      private var cmd:TimelineMax = new TimelineMax();
      
      protected function get sw():Number { return stage.stageWidth; }
      protected function get sh():Number { return stage.stageHeight; }
      
      public function PageSample()
      {
         super();
         
         blendMode = BlendMode.LAYER;
         
         TweenPlugin.activate([AutoAlphaPlugin]);
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                       transition
      
      override public function transitionIn():void
      {
         super.transitionIn();
         transitionInComplete();
         
         // framework
         initFrameworkRelationship();
         
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
               }
            }
         );
         
         // [init]
         TweenMax.to(this, 0, {autoAlpha:1, scaleX:1, scaleY:1, t1:0, t2:0, t3:0, t4:0, t5:0});
         // [actions]
         // This if-else statement is for sub-pages.
         // Condition 1 is for going to this page directly.
         // Condition 2 is for going to its sub-pages.
         if (!Gaia.api || Gaia.api.getCurrentBranch() == BRANCH)
         {
         }
         else
         {
         }
         
         cmd.delay = 0.4;
         cmd.play();
      }
      
      override public function transitionInComplete():void
      {
         super.transitionInComplete();
      }
      
      override public function transitionOut():void
      {
         super.transitionOut();
         
         // framework
         destroyFrameworkRelationship();
         
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
         
         // [init]
         // [actions]
         cmd.insert(TweenMax.to(this, 0.5, {autoAlpha:0}));
         
         cmd.play();
      }
      
      override public function transitionOutComplete():void
      {
         super.transitionOutComplete();
      }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
         // basic
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         onStageResize();
         stage.addEventListener(Event.RESIZE, onStageResize);
         
         alpha = 0;
         visible = false;
         gotoAndStop(1);
         
         // debug
         GaiaPlus.api.initTest(this);
      }
      
      protected function onRemove(e:Event):void
      {
         // basic
         stage.removeEventListener(Event.RESIZE, onStageResize);
      }
      
      protected function onStageResize(e:Event = null):void
      {
         x = (sw>>1) - (GLOBAL.DocWidth>>1);
         y = (sh>>1) - (GLOBAL.DocHeight>>1);
      }
      
      // ________________________________________________
      //                                        framework
      
      protected function initFrameworkRelationship():void
      {
         if (!Gaia.api) return;
         
         Gaia.api.beforeGoto(onBeforeGoto)
         Gaia.api.afterGoto(onAfterGoto);
      }
      
      protected function destroyFrameworkRelationship():void
      {
         if (!Gaia.api) return;
         
         Gaia.api.removeAfterGoto(onAfterGoto);
         Gaia.api.removeAfterGoto(onAfterGoto);
      }
      
      protected function onBeforeGoto(e:GaiaEvent):void
      {
         // Because it is triggered before transitionOut()
         if (e.validBranch != BRANCH) return;
      }
      
      protected function onAfterGoto(e:GaiaEvent):void
      {
         // Because it is triggered before transitionOut()
         if (e.validBranch != BRANCH) return;
         
         // save branchs
         previousBranch = Gaia.api.getCurrentBranch();
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}