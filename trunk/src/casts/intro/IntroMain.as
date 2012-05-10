package casts.intro
{
   import _extension.GaiaPlus;
   
   import com.gaiaframework.templates.AbstractPage;
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   
   public class IntroMain extends AbstractPage
   {
      // cmd
      private var cmd:TimelineMax = new TimelineMax();
      
      public function IntroMain()
      {
         super();
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // --------------------- LINE ---------------------
      
      override public function transitionIn():void
      {
         visible = true;
         super.transitionIn();
      }
      
      override public function transitionInComplete():void
      {
         super.transitionInComplete();
         transitionOut();
      }
      
      override public function transitionOut():void
      {
         super.transitionOut();
      }
      
      override public function transitionOutComplete():void
      {
         super.transitionOutComplete();
         
         // dispatch event
         dispatchEvent(new Event(Event.COMPLETE));
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
         
         TweenMax.to(this, 0, {frame:1, autoAlpha:0});
         
         // debug
         GaiaPlus.api.initTest(this);
      }
      
      private function onRemove(e:Event):void
      {
         // basic
         stage.removeEventListener(Event.RESIZE, onStageResize);
      }
      
      private function onStageResize(e:Event = null):void
      {
         x = (sw>>1) - (GB.DOC_WIDTH>>1);
         y = (sh>>1) - (GB.DOC_HEIGHT>>1);
      }
      
      private function get sw():Number { return stage.stageWidth; }
      private function get sh():Number { return stage.stageHeight; }
      
      // --------------------- LINE ---------------------
      
   }
   
}