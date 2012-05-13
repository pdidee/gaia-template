package casts.root
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class RootBackground extends MovieClip
   {
      
      public function RootBackground()
      {
         super();
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      private function onAdd(e:Event):void
      {
         // basic
         updatePosition();
         stage.addEventListener(Event.RESIZE, updatePosition);
      }
      
      private function onRemove(e:Event):void
      {
         // basic
         stage.removeEventListener(Event.RESIZE, updatePosition);
      }
      
      // --------------------- LINE ---------------------
      
      private function updatePosition(e:Event = null):void
      {
         x = sw>>1;
         y = sh>>1;
      }
      
      // get stage.stageWidth/Height
      private function get sw():Number { return stage.stageWidth; }
      private function get sh():Number { return stage.stageHeight; }
      
      // --------------------- LINE ---------------------
      
   }
   
}