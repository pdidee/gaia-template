package _myui.form.control.common
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class MyListCell extends MovieClip
   {
      // fla
      public var mcClick:MovieClip;
      public var tfLabel:TextField;
      
      // callback
      public var onClickHandler:Function;
      
      // info
      protected var _label:String;
      protected var _data:*;
      
      public function MyListCell()
      {
         super();
         
         stop();
         tabEnabled = false;
         mcClick.buttonMode = true;
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                             info

      public function get cellWidth():Number { return mcClick.width; }
      public function get cellHeight():Number { return mcClick.height; }
      
      public function get label():String { return _label };
      public function set label(v:String):void
      {
         tfLabel.text = _label = v;
      }
      
      public function get data():* { return _data; }
      public function set data(v:*):void { _data = v; }
      
      public function get isEnable():Boolean { return mcClick.buttonMode; }
      
      // ________________________________________________
      //                                   enable/disable
      
      public function enable():void { mcClick.buttonMode = true; }
      public function disable():void { mcClick.buttonMode = false; }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
         mcClick.addEventListener(MouseEvent.ROLL_OVER, onOver);
         mcClick.addEventListener(MouseEvent.ROLL_OUT, onOut);
         mcClick.addEventListener(MouseEvent.CLICK, onClick);
         
         // basic
         gotoAndStop(1);
      }
      
      protected function onRemove(e:Event):void
      {
         mcClick.removeEventListener(MouseEvent.ROLL_OVER, onOver);
         mcClick.removeEventListener(MouseEvent.ROLL_OUT, onOut);
         mcClick.removeEventListener(MouseEvent.CLICK, onClick);
      }
      
      // ________________________________________________
      //                                    mouse handler
      
      protected function onOver(e:MouseEvent):void
      {
         if (!mcClick.buttonMode) return;
         doMouseOver();
      }
      
      protected function onOut(e:MouseEvent):void
      {
         if (!mcClick.buttonMode) return;
         doMouseOut();
      }
      
      protected function onClick(e:MouseEvent):void
      {
         if (!mcClick.buttonMode) return;
         
         if (onClickHandler as Function)
         {
            onClickHandler(this);
         }
      }
      
      // ________________________________________________
      //                                           action
      
      protected function doMouseOver():void
      {
         gotoAndStop(2);
      }
      
      protected function doMouseOut():void
      {
         gotoAndStop(1);
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}