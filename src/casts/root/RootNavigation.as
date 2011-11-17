package casts.root
{
   import casts.impls.IAddRemove;
   
   import com.gaiaframework.api.Gaia;
   import com.gaiaframework.events.GaiaEvent;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   import myui.buttons.BranchButton;
   
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
      private var btnsPool:Vector.<BranchButton>;
      private var selectedOne:BranchButton;
      
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
         var oldSelectOne:BranchButton = selectedOne;
         if (selectedOne)
         {
            selectedOne.buttonMode = true;
            selectedOne = null;
         }
         
         // new selectedOne
         for (var i:int = 0; i < btnsPool.length; ++i) 
         {
            if (btnsPool[i].isMatchBranch(branch))
            {
               selectedOne = btnsPool[i];
               selectedOne.buttonMode = false;
            }
         }
         
         // tween
         if (selectedOne && selectedOne != oldSelectOne)
         {
            TweenMax2.frameTo(oldSelectOne, 1);
         }
         if (selectedOne)
         {
            TweenMax2.frameTo(selectedOne, selectedOne.totalFrames);
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
         
         btnsPool = Vector.<BranchButton>([
            btnHome,
            btnCh1,
            btnCh2,
            btnCh3,
            btnCh4,
            btnCh5
         ]);
         for (var i:int = 0; i < btnsPool.length; ++i) 
         {
            btnsPool[i].onClickEvt = onButtonClick;
            btnsPool[i].onOverEvt = onButtonOver;
            btnsPool[i].onOutEvt = onButtonOut;
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
         
         if (selectedOne != mc)
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