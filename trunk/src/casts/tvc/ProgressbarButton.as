package casts.tvc
{
   import _myui.player.VProgressBar;
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   
   public class ProgressbarButton extends VProgressBar
   {
      
      public function ProgressbarButton()
      {
         super();
         
         // !<--- remember to check this value
         barWidth = 556;
         managerNo = 0;
      }
      
      // --------------------- LINE ---------------------
      
      // ################### protected ##################
      
      override protected function onAdd(e:Event):void
      {
         super.onAdd(e);
         
         mcPlayhead.buttonMode = false;
         mcPlayhead.onOver = function()
         {
            TweenMax2.frameTo(this, this.totalFrames);
         };
         mcPlayhead.onOut = function()
         {
            TweenMax2.frameTo(this, 1);
         };
         
         addEventListener(MouseEvent.ROLL_OVER, onMOver);
         addEventListener(MouseEvent.ROLL_OUT, onMOut);
      }
      
      override protected function onRemove(e:Event):void
      {
         super.onRemove(e);
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