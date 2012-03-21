package _myui.form.control
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MyCheckBox extends MovieClip
   {
      
      public function MyCheckBox()
      {
         super();
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                             data
      
      public function get selected():Boolean
      {
         return currentFrame == 1;
      }
      public function set selected(v:Boolean):void
      {
         if (v)
         {
            gotoAndStop(1);
         }
         else
         {
            gotoAndStop(2);
         }
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      private function onAdd(e:Event):void
      {
         stop();
         buttonMode = true;
         
         addEventListener(MouseEvent.CLICK, onClick);
      }
      
      private function onRemove(e:Event):void
      {
         removeEventListener(MouseEvent.CLICK, onClick);
      }
      
      // ________________________________________________
      //                                            mouse
      
      private function onClick(e:MouseEvent):void
      {
         if (currentFrame == 1)
         {
            gotoAndStop(2);
         }
         else
         {
            gotoAndStop(1);
         }
      }
      
      // --------------------- LINE ---------------------
      
   }
   
}