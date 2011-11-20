package casts._lightbox
{
   import casts._impls.IAddRemove;
   
   import com.gaiaframework.api.Gaia;
   import com.gaiaframework.events.GaiaEvent;
   import com.gaiaframework.templates.AbstractPage;
   import com.greensock.TimelineMax;
   
   import _extension.GaiaTest;
   
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
   public class BaseLightbox extends AbstractPage implements IAddRemove
   {
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
      
      public function onAdd(e:Event):void
      {
         // basic
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         
         // debug
         GaiaTest.init(this);
      }
      
      public function onRemove(e:Event):void
      {
      }
      
      // ################### protected ##################
      
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
      
      // --------------------- LINE ---------------------
      
      protected function onBeforeGoto(e:GaiaEvent):void
      {
         transitionOut();
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}