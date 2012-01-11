package _myui.form.control.common
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class MyListCell extends MovieClip
   {
      // fla
      public var mcMeter:MovieClip;
      
      public function MyListCell()
      {
         super();
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                             info

      public function get cellWidth():Number { return mcMeter.width; }
      public function get cellHeight():Number { return mcMeter.height; }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
      }
      
      protected function onRemove(e:Event):void
      {
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}