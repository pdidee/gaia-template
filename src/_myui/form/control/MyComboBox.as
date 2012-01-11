package _myui.form.control
{
   import _myui.form.control.common.MyList;
   import _myui.form.control.core.FocusMgr;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   /**
    * 
    * @author boy, cjboy1984@gmail.com
    * 
    */
   public class MyComboBox extends MovieClip
   {
      // fla
      public var tfLable:TextField;
      public var mcList:MyList;
      
      public function MyComboBox()
      {
         super();
         
         stop();
         buttonMode = true;
         mouseChildren = false;
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                       properties

      public function get rowCount():uint { return mcList.rowCount; }
      public function set rowCount(v:uint):void
      {
         mcList.rowCount = v;
      }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
         addEventListener(MouseEvent.ROLL_OVER, onOver);
         addEventListener(MouseEvent.ROLL_OUT, onOut);
         addEventListener(MouseEvent.CLICK, onClick);
      }
      
      protected function onRemove(e:Event):void
      {
         removeEventListener(MouseEvent.ROLL_OVER, onOver);
         removeEventListener(MouseEvent.ROLL_OUT, onOut);
         removeEventListener(MouseEvent.CLICK, onClick);
      }
      
      // ________________________________________________
      //                                     mouse action
      
      protected function onOver(e:MouseEvent):void
      {
         gotoAndStop(2);
      }
      
      protected function onOut(e:MouseEvent):void
      {
         if (FocusMgr.api.focus != this)
            gotoAndStop(1);
      }
      
      protected function onClick(e:MouseEvent):void
      {
         FocusMgr.api.setFocus(this);
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}