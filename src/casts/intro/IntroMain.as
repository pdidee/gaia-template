package casts.intro
{
   import com.gaiaframework.api.Gaia;
   import com.gaiaframework.templates.AbstractPage;
   import com.greensock.TimelineMax;
   
   import _extension.GaiaTest;
   
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   
   public class IntroMain extends AbstractPage
   {
      // fla
      public var mcMain:IntroMainView;
      
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
         mcMain.transitIn(transitionInComplete);
      }
      
      override public function transitionInComplete():void
      {
         super.transitionInComplete();
         transitionOut();
      }
      
      override public function transitionOut():void
      {
         super.transitionOut();
         mcMain.transitOut(transitionOutComplete);
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
         
         // debug
         GaiaTest.init(this);
      }
      
      private function onRemove(e:Event):void
      {
      }
      
      // --------------------- LINE ---------------------
      
   }
   
}