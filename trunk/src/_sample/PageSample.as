package _sample
{
   import com.gaiaframework.api.Gaia;
   import com.gaiaframework.templates.AbstractBase;
   import com.gaiaframework.templates.AbstractPage;
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.greensock.easing.Quint;
   
   import _extension.GaiaTest;
   
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   
   public class PageSample extends AbstractPage
   {
      // fla
      
      // cmd
      private var t1:Number = 0;
      private var t2:Number = 0;
      private var t3:Number = 0;
      private var t4:Number = 0;
      private var t5:Number = 0;
      private var cmd:TimelineMax = new TimelineMax();
      
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
      
      // #################### private ###################
      
      private function onAdd(e:Event):void
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
         GaiaTest.init(this);
      }
      
      private function onRemove(e:Event):void
      {
         // basic
         stage.removeEventListener(Event.RESIZE, onStageResize);
      }
      
      private function onStageResize(e:Event = null):void
      {
         x = (sw>>1) - (GLOBAL.DocWidth>>1);
         y = (sh>>1) - (GLOBAL.DocHeight>>1);
      }
      
      private function get sw():Number { return stage.stageWidth; }
      private function get sh():Number { return stage.stageHeight; }
      
      // --------------------- LINE ---------------------
      
   }
   
}