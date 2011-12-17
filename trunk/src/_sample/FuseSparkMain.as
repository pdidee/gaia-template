package _sample
{
	import _effx.FuseSpark;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class FuseSparkMain extends Sprite
	{
      private var oldX:Number;
      private var oldY:Number;
		
		public function FuseSparkMain()
		{
         FuseSpark.init(stage);
         stage.addEventListener(MouseEvent.MOUSE_DOWN, onMDown);
		}
      
      protected function onMDown(e:MouseEvent):void
      {
         oldX = stage.mouseX;
         oldY = stage.mouseY;
         
         makeSpark();
         stage.addEventListener(Event.ENTER_FRAME, makeSpark);
         stage.addEventListener(MouseEvent.MOUSE_UP, onMUp);
         
//         FuseSpark.start(stage.mouseX, stage.mouseY, -135);
      }
      
      protected function makeSpark(e:Event = null):void
      {
         FuseSpark.addPulse(stage.mouseX, stage.mouseY);
      }
      
      protected function onMUp(e:MouseEvent):void
      {
         stage.removeEventListener(Event.ENTER_FRAME, makeSpark);
         stage.removeEventListener(MouseEvent.MOUSE_UP, onMUp);
         
         FuseSpark.stop();
      }
      
      // --------------------- LINE ---------------------
      
	}
   
}