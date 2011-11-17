package casts.loading.template
{
   import casts.impls.IAddRemove;
   import casts.impls.IMyPreloader;
   
   import com.gaiaframework.api.Gaia;
   import com.gaiaframework.events.GaiaEvent;
   import com.gaiaframework.templates.AbstractPreloader;
   
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   
   public class InOutBlockPreloader extends AbstractPreloader implements IMyPreloader,IAddRemove
   {
      // a call-back function that release GAIA, let it can continue its flow.
      protected var callByTransitIn:Boolean = true;
      protected var _releaseGaia:Function;
      
      // history
      protected var isShow:Boolean = true;
      protected var oldBranch:String = '';
      
      public function InOutBlockPreloader()
      {
         super();
         
         mouseChildren = false;
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                         Customized flow function
      // Default, Gaia do loading job and preloader transition-in parallelly.
      // This api provide a function to make Gaia to wait preloader to finish its transition-in and then do loading job.

      // Make Gaia to wait transition-in finished and then do something else.
      public function addBeforePreload():void
      {
         releaseGaia = Gaia.api.beforePreload(transitIn, true);
      }
      
      public function removeBeforePreload():void
      {
         Gaia.api.removeBeforePreload(transitIn);
      }
      
      // Replace transitionIn(), because it needs GaiaEvent parameter.
      public function transitIn(e:GaiaEvent):void
      {
         // bring to top
         parent.parent.setChildIndex(parent, parent.parent.numChildren-1);
         
         // Whether to show or hide this refers to the flow direction
         // down-to-up won't show this
         var searchRes:int = oldBranch.search(Gaia.api.getCurrentBranch());
         isShow = (searchRes == -1);
         if (isShow)
         {
            callByTransitIn = true;
            transitionIn();
         }
         else
         {
            tryReleaseGaia();
         }
         
         // record history
         if (Gaia.api)
         {
            oldBranch = Gaia.api.getCurrentBranch();
         }
      }
      
      public function tryReleaseGaia():void
      {
         if (releaseGaia as Function)
         {
            // release gaia but keep the listener.
            releaseGaia(false);
         }
      }
      
      public function set releaseGaia(v:Function):void { _releaseGaia = v; }
      public function get releaseGaia():Function { return _releaseGaia; }
      
      // ________________________________________________
      //                              GAIA flow functions
      
      // Do nothing just to tell Gaia flow-manager it's done immediately.
      override public function transitionIn():void
      {
         super.transitionIn();
      }
      
      // As same as above function.
      override public function transitionInComplete():void
      {
         super.transitionInComplete();
      }
      
      override public function transitionOut():void
      {
         super.transitionOut();
         
         // record history
         if (Gaia.api)
         {
            oldBranch = Gaia.api.getCurrentBranch();
         }
      }
      
      override public function transitionOutComplete():void
      {
         super.transitionOutComplete();
      }
      
      // ________________________________________________
      //                                       add/remove
      
      public function onAdd(e:Event):void
      {
         // basic
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         onStageResize();
         stage.addEventListener(Event.RESIZE, onStageResize);
         
         // reset layer
         if (Gaia.api)
         {
            var layer:Sprite = Gaia.api.getDepthContainer(Gaia.PRELOADER);
            if (!layer.contains(parent))
            {
               layer.addChildAt(parent, 0);
            }
            
            oldBranch = Gaia.api.getCurrentBranch();
         }
      }
      
      public function onRemove(e:Event):void
      {
         stage.removeEventListener(Event.RESIZE, onStageResize);
      }
      
      // ################### protected ##################
      
      protected function onStageResize(e:Event = null):void
      {
      }
      
      protected function get sw():Number { return stage.stageWidth; }
      protected function get sh():Number { return stage.stageHeight; }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}