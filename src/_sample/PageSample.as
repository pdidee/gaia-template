package _sample
{
   import _extension.GaiaTest;
   
   import com.gaiaframework.api.Gaia;
   import com.gaiaframework.events.GaiaEvent;
   import com.gaiaframework.templates.AbstractPage;
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   
   public class PageSample extends AbstractPage
   {
      // fla
      
      // framework history
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
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // --------------------- LINE ---------------------
      
      override public function transitionIn():void
      {
         super.transitionIn();
         transitionInComplete();
         
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
         visible = true;
         TweenMax.to(this, 0, {alpha:1, scaleX:1, scaleY:1});
         // [actions]
         
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
         
         // [init]
         // [actions]
         
         cmd.play();
      }
      
      override public function transitionOutComplete():void
      {
         super.transitionOutComplete();
         visible = false;
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
         
         // framework
         initFrameworkRelationship();
         
         // debug
         GaiaTest.init(this);
      }
      
      protected function onRemove(e:Event):void
      {
         // basic
         stage.removeEventListener(Event.RESIZE, onStageResize);
         
         // framework
         destroyFrameworkRelationship();
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
      }
      
      protected function onAfterGoto(e:GaiaEvent):void
      {
         if (e.validBranch != 'root/product') return;
         
         // save branchs
         previousBranch = Gaia.api.getCurrentBranch();
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}