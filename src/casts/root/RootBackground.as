package casts.root
{
   import casts.impls.IAddRemove;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class RootBackground extends MovieClip implements IAddRemove
   {
      
      public function RootBackground()
      {
         super();
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // --------------------- LINE ---------------------
      
      public function onAdd(e:Event):void
      {
         // basic
         onStageResize();
         stage.addEventListener(Event.RESIZE, onStageResize);
      }
      
      public function onRemove(e:Event):void
      {
         // basic
         stage.removeEventListener(Event.RESIZE, onStageResize);
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      private function onStageResize(e:Event = null):void
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