package casts.root
{
   import _myui.buttons.BranchButton;
   
   import casts._impls.IAddRemove;
   
   import com.gaiaframework.api.Gaia;
   import com.gaiaframework.events.GaiaEvent;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class RootNavigation extends MovieClip implements IAddRemove
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
      
      public function get fixPos():Point
      {
         if (Gaia.api)
         {
            var currBranch:String = Gaia.api.getCurrentBranch();
            
            // home
            if (-1 != currBranch.search('root/home'))
            {
               return new Point(sw>>1, sh);
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

      public function onAdd(e:Event):void
      {
         // basic
         x = fixPos.x;
         y = sh+50;
         stage.addEventListener(Event.RESIZE, onStageResize);

         initButtons();
         initFrameworkRelationship();
      }
      
      public function onRemove(e:Event):void
      {
         // basic
         stage.removeEventListener(Event.RESIZE, onStageResize);
         
         destroyFrameworkRelationship();
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      private function initFrameworkRelationship():void
      {
         if (!Gaia.api) return;
         
         Gaia.api.afterGoto(onAfterGoto);
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
      
      // --------------------- LINE ---------------------
      
      private function initButtons():void
      {
         btnHome.branch = 'root/home';
         btnCh1.branch = 'root/no1_option';
         btnCh2.branch = 'root/no1_promotion*';
         btnCh3.branch = 'root/no1_example';
         btnCh4.branch = 'root/no1_sales';
         btnCh5.branch = 'root/no1_me';
         
         btnPool = Vector.<BranchButton>([
            btnHome,
            btnCh1,
            btnCh2,
            btnCh3,
            btnCh4,
            btnCh5
         ]);
         for each (var i:MyButton in btnPool) 
         {
            i.onClickEvt = onButtonClick;
            i.onOverEvt = onButtonOver;
            i.onOutEvt = onButtonOut;
         }
      }
      
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
      
      // --------------------- LINE ---------------------
      
      private function onStageResize(e:Event = null):void
      {
         x = fixPos.x;
         y = fixPos.y;
      }
      
      // get stage.stageWidth/Height
      private function get sw():Number { return stage.stageWidth; }
      private function get sh():Number { return stage.stageHeight; }
      
      // --------------------- LINE ---------------------
      
   }
   
}