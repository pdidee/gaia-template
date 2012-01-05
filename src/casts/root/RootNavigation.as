package casts.root
{
   import _myui.buttons.BranchButton;
   
   import com.gaiaframework.api.Gaia;
   import com.gaiaframework.events.GaiaEvent;
   import com.greensock.TweenMax;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class RootNavigation extends MovieClip
   {
      // fla
      public var btnHome:BranchButton;
      public var btnCh1:BranchButton;
      public var btnCh2:BranchButton;
      public var btnCh3:BranchButton;
      public var btnCh4:BranchButton;
      public var btnCh5:BranchButton;
      
      // branch
      private var btnPool:Vector.<BranchButton>;
      private var selectOne:BranchButton;
      
      public function RootNavigation()
      {
         super();
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // --------------------- LINE ---------------------
      
      public function get pos():Point
      {
         if (Gaia.api)
         {
            var currBranch:String = Gaia.api.getCurrentBranch();
            
            // home
            if (-1 != currBranch.search('root/intro'))
            {
               return new Point(sw>>1, sh+50);
            }
            else
            {
               return new Point(sw>>1, sh);
            }
         }
         // default
         return new Point(sw>>1, sh);
      }
      
      // --------------------- LINE ---------------------

      // ################### protected ##################
      
      // #################### private ###################
      
      private function onAdd(e:Event):void
      {
         // basic
         x = pos.x;
         stage.addEventListener(Event.RESIZE, onStageResize);
         
         // [init]
         TweenMax.to(this, 0, {y:pos.y + 50});
         // [actions]
         TweenMax.to(this, 0.6, {y:pos.y});
         
         // In order to prevent user do navigating action before the 1st swf is loaded.
         disableThis();
         initButtons();
         initFrameworkRelationship();
      }
      
      private function onRemove(e:Event):void
      {
         // basic
         stage.removeEventListener(Event.RESIZE, onStageResize);
         
         destroyFrameworkRelationship();
      }
      
      // ________________________________________________
      //                                          setting
      
      private function initButtons():void
      {
         btnHome.branch = 'root/home';
         btnCh1.branch = 'root/ch1*';
         btnCh2.branch = 'root/ch2*';
         btnCh3.branch = 'root/ch3';
         btnCh4.branch = 'root/ch4';
         btnCh5.branch = 'root/ch5';
         
         btnPool = Vector.<BranchButton>([
            btnHome,
            btnCh1,
            btnCh2,
            btnCh3,
            btnCh4,
            btnCh5
         ]);
         for each (var i:BranchButton in btnPool) 
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
         
         Gaia.api.afterGoto(onAfterGoto);
         Gaia.api.afterComplete(enableThis, true);
         updateButtonStates(Gaia.api.getCurrentBranch());
      }
      
      private function destroyFrameworkRelationship():void
      {
         if (!Gaia.api) return;
         
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
         for each (var i:BranchButton in btnPool) 
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

         // change flow
         Gaia.api.setDefaultFlow(Gaia.PRELOAD);
         
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
      
      // ________________________________________________
      //                                            utils
      
      private function enableThis(e:GaiaEvent = null):void
      {
         mouseChildren = true;
      }
      
      private function disableThis():void
      {
         mouseChildren = false;
      }
      
      // --------------------- LINE ---------------------
      
      private function onStageResize(e:Event = null):void
      {
         x = pos.x;
         y = pos.y;
      }
      
      // get stage.stageWidth/Height
      private function get sw():Number { return stage.stageWidth; }
      private function get sh():Number { return stage.stageHeight; }
      
      // --------------------- LINE ---------------------
      
   }
   
}