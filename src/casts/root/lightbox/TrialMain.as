package casts.root
{
   import _extension.GaiaPlus;
   
   import casts._impls.IAddRemove;
   
   import com.gaiaframework.api.Gaia;
   import com.gaiaframework.templates.AbstractPage;
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class TrialMain extends AbstractPage
   {
      // fla
      public var mcMain:MovieClip;
      public var mcBg:MovieClip;
      public function get btnClose():MyButton { return MyButton(mcMain.btnClose); }
      
      // cmd
      public var t1:Number = 0;
      public var t2:Number = 0;
      public var t3:Number = 0;
      public var t4:Number = 0;
      public var t5:Number = 0;
      private var cmd:TimelineMax = new TimelineMax();
      
      public function TrialMain()
      {
         super();

         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // --------------------- LINE ---------------------
      
      public function initIt():void
      {
         btnClose.gotoAndStop(1);
         btnClose.buttonMode = true;
         btnClose.onClick = function()
         {
            if (!this.buttonMode) return;
            this.buttonMode = false;
            
            if (Gaia.api)
            {
               GaiaPlus.api.hideAsset('trial', 'root');
            }
         };
      }
      
      public function destroyIt():void
      {
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
         
         // [init]
         initIt();
         visible = true;
         TweenMax.to(this, 0, {alpha:0});
         // [actions]
         cmd.insert(TweenMax.to(this, 1, {alpha:1}));
         
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
         cmd = new TimelineMax({
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
         });
         
         // [init]
         initIt();
         visible = true;
         TweenMax.to(this, 0, {alpha:0});
         // [actions]
         cmd.insert(TweenMax.to(this, 1, {alpha:1}));
         
         cmd.play();
      }
      
      override public function transitionOutComplete():void
      {
         super.transitionOutComplete();
         visible = false;
         destroyIt();
         // notify
         dispatchEvent(new Event('AFTER_TRANSITION_OUT'));
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      protected function onAdd(e:Event):void
      {
         // basic
         onStageResize();
         stage.addEventListener(Event.RESIZE, onStageResize);
         
         visible = false;
      }
      
      protected function onRemove(e:Event):void
      {
         // basic
         stage.removeEventListener(Event.RESIZE, onStageResize);
      }
      
      protected function onStageResize(e:Event = null):void
      {
         x = sw>>1;
         y = sh>>1;
         
         mcBg.width = sw;
         mcBg.height = sh;
      }
      
      // get stage.stageWidth/Height
      protected function get sw():Number { return stage.stageWidth; }
      protected function get sh():Number { return stage.stageHeight; }
      
      // --------------------- LINE ---------------------
      
   }
   
}