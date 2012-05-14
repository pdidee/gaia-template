package casts._lightbox
{
   import _extension.GaiaPlus;
   
   import com.gaiaframework.api.Gaia;
   import com.gaiaframework.events.GaiaEvent;
   import com.gaiaframework.templates.AbstractPage;
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.greensock.plugins.AutoAlphaPlugin;
   import com.greensock.plugins.FramePlugin;
   import com.greensock.plugins.TweenPlugin;
   
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
      
      protected var releaseGaia:Function;
      
      public function BaseLightbox()
      {
         super();
         
         // plugin
         TweenPlugin.activate([AutoAlphaPlugin, FramePlugin]);
         
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
         deactivateAutoTransitOut();
         super.transitionOut();
      }
      
      override public function transitionOutComplete():void
      {
         super.transitionOutComplete();
      }
      
      // --------------------- LINE ---------------------
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
         // basic
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         // stage resize handler
         updatePosition();
         stage.addEventListener(Event.RESIZE, updatePosition);
         
         TweenMax.to(this, 0, {frame:1, autoAlpha:0});
         
         // debug
         GaiaPlus.api.initTest(this);
      }
      
      protected function onRemove(e:Event):void
      {
         // stage resize handler
         stage.removeEventListener(Event.RESIZE, updatePosition);
      }
      
      protected function updatePosition(e:Event = null):void
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
            releaseGaia = Gaia.api.beforeGoto(onBeforeGoto, false, true);
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