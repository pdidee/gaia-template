package casts.loading.template
{
   import casts._impls.IMyPreloader;
   
   import com.gaiaframework.api.Gaia;
   import com.gaiaframework.events.GaiaEvent;
   import com.gaiaframework.templates.AbstractPreloader;
   
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   
   public class InOutNonblockPreloader extends AbstractPreloader implements IMyPreloader
   {
      // a call-back function that release GAIA, let it can continue its flow.
      protected var _releaseGaia:Function;
      
      // A boolean represents if it's a branch of the current path.
      protected var isShow:Boolean = true;
      // framework history
      protected var oldBranch:String = '';
      
      public function InOutNonblockPreloader()
      {
         super();
         
         mouseChildren = false;
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                         Customized flow function
      // Default, Gaia do loading job and call transitionIn parallelly.
      
      public function addBeforePreload():void {}
      public function removeBeforePreload():void {}
      public function transitIn(e:GaiaEvent):void {}
      public function tryReleaseGaia():void {}
      public function set releaseGaia(v:Function):void { _releaseGaia = v; }
      public function get releaseGaia():Function { return _releaseGaia; }
      
      // ________________________________________________
      //                              GAIA flow functions
      
      override public function transitionIn():void
      {
         super.transitionIn();
         
         // bring to top
         parent.parent.setChildIndex(parent, parent.parent.numChildren-1);
         
         var searchRes:int = oldBranch.search(Gaia.api.getCurrentBranch());
         isShow = (searchRes == -1);
         // following are sample code
//         if (isShow)
//         {
//         }
//         else
//         {
//            transitionInComplete();
//         }
         
         // record history
         if (Gaia.api)
         {
            oldBranch = Gaia.api.getCurrentBranch();
         }
      }
      
      override public function transitionInComplete():void
      {
         super.transitionInComplete();
      }
      
      override public function transitionOut():void
      {
         super.transitionOut();
         // following are sample code
//         if (isShow)
//         {
//         }
//         else
//         {
//            transitionOutComplete();
//         }
         
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
         
         // framework history
         if (Gaia.api)
         {
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