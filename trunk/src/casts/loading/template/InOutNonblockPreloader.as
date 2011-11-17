package casts.loading.template
{
   import casts.impls.IAddRemove;
   import casts.impls.IMyPreloader;
   import casts.impls.IMyPreloaderView;
   
   import com.gaiaframework.api.Gaia;
   import com.gaiaframework.events.AssetEvent;
   import com.gaiaframework.events.GaiaEvent;
   import com.gaiaframework.templates.AbstractPreloader;
   
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   
   public class InOutNonblockPreloader extends AbstractPreloader implements IMyPreloader,IAddRemove
   {
      // a call-back function that release GAIA, let it can continue its flow.
      protected var _releaseGaia:Function;
      
      // history
      protected var isShow:Boolean = true;
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
      // Default, Gaia do loading job and preloader transition-in parallelly.
      // This api provide a function to make Gaia to wait preloader to finish its transition-in and then do loading job.
      
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
         oldBranch = Gaia.api.getCurrentBranch();
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
         oldBranch = Gaia.api.getCurrentBranch();
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