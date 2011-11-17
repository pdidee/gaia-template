package casts.root
{
   import casts.impls.IAddRemove;
   
   import com.gaiaframework.api.Gaia;
   import com.gaiaframework.templates.AbstractPage;
   
   import debug.GaiaTest;
   
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   
   public class RootMain extends AbstractPage implements IAddRemove
   {
      // fla
      public var mcNav:RootNavigation;
      public var mcBg:RootBackground;
      
      public function RootMain()
      {
         super();
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // --------------------- LINE ---------------------
      
      override public function transitionIn():void
      {
         super.transitionIn();
         transitionInComplete();
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
      }

      // --------------------- LINE ---------------------
      
      public function onAdd(e:Event):void
      {
         // basic
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         
         // Rearrange the layer!!! VERY IMPORTANT
         if (Gaia.api)
         {
            var layer_1:Sprite = Gaia.api.getDepthContainer(Gaia.PRELOADER);
            var layer_2:Sprite = Gaia.api.getDepthContainer(Gaia.TOP);
            var layer_3:Sprite = Gaia.api.getDepthContainer(Gaia.MIDDLE);
            var layer_4:Sprite = Gaia.api.getDepthContainer(Gaia.BOTTOM);
            
            // lightbox
            layer_1.addChild(mcNav);
            
            // background
            layer_4.addChild(mcBg);
         }
         
         // debug
         GaiaTest.init(this);
      }
      
      public function onRemove(e:Event):void
      {
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      // get stage.stageWidth/Height
      private function get sw():Number { return stage.stageWidth; }
      private function get sh():Number { return stage.stageHeight; }
      
      // --------------------- LINE ---------------------
      
   }
   
}