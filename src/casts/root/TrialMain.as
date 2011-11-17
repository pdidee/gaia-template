package casts.root
{
   import casts.impls.IAddRemove;
   import casts.impls.IInitDestroy;
   import casts.impls.ITransitInOut;
   
   import com.greensock.TweenMax;
   import com.jumpeye.flashEff2.symbol.squareEffect.FESBlurSquare;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class TrialMain extends MovieClip implements IAddRemove, ITransitInOut, IInitDestroy
   {
      // fla
      public var mcMain:MovieClip;
      public var mcBg:MovieClip;
      public function get btnClose():MyButton { return MyButton(mcMain.btnClose); }
      
      // effx
      private var myEffx:FlashEff2Code = new FlashEff2Code();
      
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
            
            transitOut();
         };
      }
      
      // NOT really remove it. just hide it
      public function destroyIt():void
      {
         visible = false;
      }

      // --------------------- LINE ---------------------

      public function transitIn(completeCallback:Function = null):void
      {
         visible = true;
         
         initIt();
         
         // basic
         TweenMax.killTweensOf(mcMain);
         mcMain.alpha = 1;
         mcMain.scaleX = mcMain.scaleY = 1;
         mcBg.alpha = 0;
         
         addChildAt(myEffx, numChildren - 1);
         myEffx._targetInstanceName = 'mcMain';
         // show effx
         var myPattern:FESBlurSquare = new FESBlurSquare();
         myPattern.tweenDuration = 1;
         myPattern.squareWidth = 109;
         myPattern.squareHeight = 77;
         myPattern.distance = 66;
         myPattern.squareBlur = 60;
         myPattern.groupDuration = 0.5;
         myPattern.tweenType = 'Back';
         myPattern.easeType = 'easeOut';
         myEffx.showTransition = myPattern;
         myEffx.showAutoPlay = false;
         myEffx.show();
      }
      
      public function transitOut(completeCallback:Function = null):void
      {
         TweenMax.to(mcMain, 0.3, { alpha:0, onComplete:destroyIt } );
      }
      
      // --------------------- LINE ---------------------
      
      public function onAdd(e:Event):void
      {
         // basic
         onStageResize();
         stage.addEventListener(Event.RESIZE, onStageResize);
         
         visible = false;
      }
      
      public function onRemove(e:Event):void
      {
         // basic
         stage.removeEventListener(Event.RESIZE, onStageResize);
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
      private function onStageResize(e:Event = null):void
      {
         x = sw>>1;
         y = sh>>1;
         
         mcBg.width = sw;
         mcBg.height = sh;
      }
      
      // get stage.stageWidth/Height
      private function get sw():Number { return stage.stageWidth; }
      private function get sh():Number { return stage.stageHeight; }
      
      // --------------------- LINE ---------------------
      
   }
   
}