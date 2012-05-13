package casts.root
{
   import _extension.GaiaPlus;
   
   import _myui.buttons.BranchButton;
   
   import com.gaiaframework.api.Gaia;
   import com.gaiaframework.events.GaiaEvent;
   import com.gaiaframework.templates.AbstractPage;
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.greensock.plugins.AutoAlphaPlugin;
   import com.greensock.plugins.TweenPlugin;
   
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class RootMain extends AbstractPage
   {
      // fla
      public var mcNav:MovieClip;
      public function get btn1():BranchButton { return BranchButton(mcNav.btn1); }
      public function get btn2():BranchButton { return BranchButton(mcNav.btn2); }
      public function get btn3():BranchButton { return BranchButton(mcNav.btn3); }
      public function get btn4():BranchButton { return BranchButton(mcNav.btn4); }
      public var mcBg:MovieClip;
      
      // branch
      private var navPool:Vector.<BranchButton>;
      private var selectOne:BranchButton;
      
      // timeline
      private var cmd:TimelineMax = new TimelineMax();
      
      public function RootMain()
      {
         super();
         
         // gs
         TweenPlugin.activate([AutoAlphaPlugin]);
         
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
         // nav
         TweenMax.to(mcNav, 0, {y:sh+50, autoAlpha:1});
         
         initButtons();
         initFrameworkRelationship();
         
         // ---[actions]---
         cmd.insert(TweenMax.to(mcNav, 0.5, {y:sh}));
         
         cmd.play();
      }
      
      override public function transitionOut():void
      {
         super.transitionOut();
         transitionOutComplete();
         
         destroyFrameworkRelationship();
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      private function onAdd(e:Event):void
      {
         // basic
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         stage.addEventListener(Event.RESIZE, updatePosition);
         updatePosition();
         
         // Rearrange the layer!!! VERY IMPORTANT
         if (Gaia.api)
         {
            var layer_1:Sprite = Gaia.api.getDepthContainer(Gaia.PRELOADER);
            var layer_2:Sprite = Gaia.api.getDepthContainer(Gaia.TOP);
            var layer_3:Sprite = Gaia.api.getDepthContainer(Gaia.MIDDLE);
            var layer_4:Sprite = Gaia.api.getDepthContainer(Gaia.BOTTOM);
            
            // lightbox
            TweenMax.to(mcNav, 0, {autoAlpha:0});
            
            // background
            layer_4.addChild(mcBg);
         }
         
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
         
         if (Gaia.api)
         {
            mcBg.x = sw >> 1;
            mcBg.y = sh >> 1;
         }
      }
      
      // get stage.stageWidth/Height
      private function get sw():Number { return stage.stageWidth; }
      private function get sh():Number { return stage.stageHeight; }
      
      // ________________________________________________
      //                                              nav
      
      private function initButtons():void
      {
         btn1.branch = 'root/home';
         btn2.branch = 'root/prodcut';
         btn3.branch = 'root/game';
         btn4.branch = 'root/rule';
         
         navPool = Vector.<BranchButton>([
            btn1,
            btn2,
            btn3,
            btn4
         ]);
         for each (var i:BranchButton in navPool) 
         {
            i.onClickEvt = onButtonClick;
            i.onOverEvt = onButtonOver;
            i.onOutEvt = onButtonOut;
         }
      }
      
      // ________________________________________________
      //                                        framework
      
      private function initFrameworkRelationship():void
      {
         if (!Gaia.api) return;
         
         // flow-handler
         Gaia.api.afterGoto(onAfterGoto);
         
         updateButtonStates(Gaia.api.getCurrentBranch());
      }
      
      private function destroyFrameworkRelationship():void
      {
         if (!Gaia.api) return;
         
         // flow-handler
         Gaia.api.removeAfterGoto(onAfterGoto);
      }
      
      private function onAfterGoto(e:GaiaEvent):void
      {
         updateButtonStates(e.validBranch);
      }
      
      private function updateButtonStates(branch:String):void
      {
         // reset selectedOne
         var oldSelectOne:BranchButton = selectOne;
         if (selectOne)
         {
            selectOne.buttonMode = true;
            selectOne = null;
         }
         
         // new selectedOne
         for each (var i:BranchButton in navPool) 
         {
            if (i.isMatchBranch(branch, true))
            {
               selectOne = i;
               // sometimes it need buttonMode=true to return.
               selectOne.buttonMode = !i.isMatchBranch(branch);
            }
         }
         
         // tween
         if (oldSelectOne && oldSelectOne != selectOne)
         {
            TweenMax2.frameTo(oldSelectOne, 1);
         }
         if (selectOne)
         {
            TweenMax2.frameTo(selectOne, selectOne.totalFrames);
         }
      }
      
      // ________________________________________________
      //                                    mouse handler
      
      private function onButtonClick(e:MouseEvent):void
      {
         var mc:BranchButton = BranchButton(e.currentTarget);
         
         if (!mc.buttonMode) return;
         mc.buttonMode = false;
         
         Gaia.api.goto(mc.getValidBranch());
      }
      
      private function onButtonOver(e:MouseEvent):void
      {
         var mc:BranchButton = BranchButton(e.currentTarget);
         
         if (!mc.buttonMode) return;
         
         TweenMax2.frameTo(mc, mc.totalFrames);
      }
      
      private function onButtonOut(e:MouseEvent):void
      {
         var mc:BranchButton = BranchButton(e.currentTarget);
         
         if (!mc.buttonMode) return;
         
         if (selectOne != mc)
         {
            TweenMax2.frameTo(mc, 1);
         }
      }
      
      // --------------------- LINE ---------------------
      
   }
   
}