package casts._lightbox
{
   import _extension.GaiaTest;
   
   import casts._impls.IAddRemove;
   
   import com.gaiaframework.api.Gaia;
   import com.gaiaframework.events.GaiaEvent;
   import com.gaiaframework.templates.AbstractPage;
   import com.greensock.TimelineMax;
   
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;

   /**
    * Lightbox super class
    * @author boy, cjboy1984@gmail.com
    * @usage
    * // show
    * GaiaPlus.api.showAssetById('lightbox_1', 'root');
    * // hide
    * GaiaPlus.api.hideAssetById('lightbox_1', 'root');
    */   
   public class BaseLightbox extends AbstractPage
   {
      // return callback function
      public var returnCallback:Function;
      
      // cmd
      protected var cmd:TimelineMax = new TimelineMax();
      
      // true時，代表換單元前，一定會等此lightbox退場完再繼續動作；false時，不會等待，邊退場邊進行換單元。
      protected var blockMode:Boolean = false;
      protected var releaseGaia:Function;
      
      public function BaseLightbox()
      {
         super();
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // --------------------- LINE ---------------------
      
      override public function transitionIn():void
      {
         super.transitionIn();
         
         activateAutoTransitOut();
      }
      
      override public function transitionInComplete():void
      {
         super.transitionInComplete();
      }
      
      override public function transitionOut():void
      {
         super.transitionOut();
      }
      
      override public function transitionOutComplete():void
      {
         super.transitionOutComplete();
         
         deactivateAutoTransitOut();
      }
      
      // --------------------- LINE ---------------------
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
         // basic
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         // stage resize handler
         onStageResize();
         stage.addEventListener(Event.RESIZE, onStageResize);
         
         // debug
         GaiaTest.init(this);
      }
      
      protected function onRemove(e:Event):void
      {
         // stage resize handler
         stage.removeEventListener(Event.RESIZE, onStageResize);
      }
      
      protected function onStageResize(e:Event = null):void
      {
      }
      
      protected function get sw():Number { return stage.stageWidth; }
      protected function get sh():Number { return stage.stageHeight; }
      
      // --------------------- LINE ---------------------
      
      // 切換單元時，自動偵測退場
      protected function activateAutoTransitOut():void
      {
         if (Gaia.api)
         {
            Gaia.api.removeBeforeGoto(onBeforeGoto);
            releaseGaia = Gaia.api.beforeGoto(onBeforeGoto, blockMode, true);
         }
      }
      
      // 取消自動偵測退場
      protected function deactivateAutoTransitOut():void
      {
         // release GAIA
         if (releaseGaia as Function)
         {
            releaseGaia(true);
            releaseGaia = null;
         }
         // remove hijack
         if (Gaia.api)
         {
            Gaia.api.removeBeforeGoto(onBeforeGoto);
         }
      }
      
      protected function onBeforeGoto(e:GaiaEvent):void
      {
         transitionOut();
      }
      
      // --------------------- LINE ---------------------
      
      protected function returnToParent():void
      {
         if (returnCallback as Function)
         {
            returnCallback();
         }
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}