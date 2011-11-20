package _sample
{
   import _effx.Rippler;

   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;

   public class WaterRippleMain extends MovieClip
   {
      // fla
      public var mcBg:MovieClip;

      public var canvasBmp:Bitmap;
      public var rippler:Rippler;

      public function WaterRippleMain()
      {
         super();

         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }

      // --------------------- LINE ---------------------

      // ################### protected ##################

      // #################### private ###################

      private function onAdd(e:Event):void
      {
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;

         play();
         startRenderZone();
         startRippleEffx();
      }

      private function onRemove(e:Event):void
      {
      }

      // --------------------- LINE ---------------------

      private function startRenderZone():void
      {
         canvasBmp = new Bitmap();
         addChild(canvasBmp);
      }

      private function rendering():void
      {
         canvasBmp.visible = false;

         canvasBmp.bitmapData = new BitmapData(960, 520, true, 0x00000000);
         canvasBmp.bitmapData.draw(this);

         canvasBmp.visible = true;
      }

      private function renderComplete():void
      {
         canvasBmp.visible = false;
      }

      // --------------------- LINE ---------------------

      private function startRippleEffx():void
      {
         rippler = new Rippler(canvasBmp, 20, 20, 960, 520);
         rippler.onUpdate = rendering;
         rippler.onComplete = renderComplete;

         // mouse click
         stage.addEventListener(MouseEvent.CLICK, createRippler);
      }

      private function createRippler(e:MouseEvent):void
      {
         rippler.drawRipple(stage.mouseX, stage.mouseY, 80, 1);
      }

      // --------------------- LINE ---------------------

      // get stage.stageWidth/Height
      private function get sw():Number { return stage.stageWidth; }
      private function get sh():Number { return stage.stageHeight; }

      // --------------------- LINE ---------------------

   }

}