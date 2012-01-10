package casts.home
{
   import _extension.GaiaPlus;
   
   import com.gaiaframework.api.Gaia;
   import com.gaiaframework.templates.AbstractBase;
   import com.gaiaframework.templates.AbstractPage;
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.greensock.easing.Quint;
   
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   
   public class HomeMain extends AbstractPage
   {
      // fla
      public function get intro():AbstractBase { return page && assets && assets.intro ? AbstractBase(assets.intro.content) : null; }
      public function get nav():Object { Object(Gaia.api.getPage('root').content.mcNav); }
      
      // cmd
      private var justatimer:Number;
      private var cmd:TimelineMax = new TimelineMax();
      
      public function HomeMain()
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
         alpha = 1;
         visible = true;
         
         // intro
         if (GB.firstTimeVisit && intro)
         {
            intro.addEventListener(Event.COMPLETE, onIntroComplete);
            intro.transitionIn();
         }
         else
         {
            myTransitionIn();
         }
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
         GaiaPlus.api.initTest(this);
      }
      
      private function onRemove(e:Event):void
      {
         // basic
         stage.removeEventListener(Event.RESIZE, onStageResize);
      }
      
      private function onStageResize(e:Event = null):void
      {
         x = (sw>>1) - (GB.DocWidth>>1);
         y = (sh>>1) - (GB.DocHeight>>1);
      }
      
      private function get sw():Number { return stage.stageWidth; }
      private function get sh():Number { return stage.stageHeight; }
      
      // --------------------- LINE ---------------------
      
      private function onIntroComplete(e:Event):void
      {
         intro.removeEventListener(Event.COMPLETE, onIntroComplete);
         myTransitionIn();
      }
      
      private function myTransitionIn():void
      {
         cmd.stop();
         cmd.kill();
         cmd = new TimelineMax(
            {
               onStart:function()
               {
                  visible = true;
                  alpha = 1;
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
         if (GB.firstTimeVisit)
         {
            GB.firstTimeVisit = false;
         }
         else
         {
         }
         
         // [actions]
         // navigation
         if (Gaia.api)
         {
            cmd.insert(TweenMax.to(nav, 1.0, { y:nav.fixPos.y, ease:Quint.easeOut } ), 3.3);
         }
         
         cmd.play();
      }
      
      // --------------------- LINE ---------------------
      
   }
   
}