package casts.tvc
{
   import _myui.player.VVolButton;
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   
   public class SoundButton extends VVolButton
   {
      
      public function SoundButton()
      {
         super();
         
         buttonMode = false;
         
         // !<--- remember to check this value
         managerNo = 0;
         barWidth = 16.5;
      }
      
      // --------------------- LINE ---------------------
      
      // ################### protected ##################
      
      override protected function onAdd(e:Event):void
      {
         super.onAdd(e);
         
         addEventListener(MouseEvent.ROLL_OVER, onMOver);
         addEventListener(MouseEvent.ROLL_OUT, onMOut);
      }
      
      override protected function onRemove(e:Event):void
      {
         super.onRemove(e);
         Mouse.cursor = MouseCursor.AUTO;
      }
      
      // --------------------- LINE ---------------------
      
      override protected function onMOver(e:MouseEvent):void
      {
         isOver = true;
         if (!isDragging)
         {
            Mouse.cursor = MouseCursor.HAND;
         }
      }
      
      override protected function onMOut(e:MouseEvent):void
      {
         isOver = false;
         if (!isOver && !isDragging)
         {
            Mouse.cursor = MouseCursor.AUTO;
         }
      }
      
      // --------------------- LINE ---------------------
      
      override protected function onMDown(e:MouseEvent):void
      {
         super.onMDown(e);
         Mouse.cursor = MouseCursor.ARROW;
      }
      
      override protected function onMUp(e:MouseEvent):void
      {
         super.onMUp(e);
         if (!isOver)
         {
            Mouse.cursor = MouseCursor.AUTO;
         }
         else
         {
            Mouse.cursor = MouseCursor.HAND;
         }
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}