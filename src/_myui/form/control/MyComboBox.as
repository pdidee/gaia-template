package _myui.form.control
{
   import _myui.form.control.common.MyList;
   import _myui.form.control.core.COMFocusMgr;
   
   import com.greensock.TweenMax;
   import com.greensock.easing.Strong;
   import com.greensock.plugins.AutoAlphaPlugin;
   import com.greensock.plugins.TweenPlugin;
   
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.EventPhase;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   
   /**
    * A simple combobox.
    * @author boy, cjboy1984@gmail.com
    * @usage
    * // mcClick  : A click sensor and a dependency for mask width.
    * // tfLabel  : A label.
    * // mcList   : A MyList component.
    * public var cbYear:MyComboBox;
    * 
    * cbYear.removeAll();
    * cbYear.addItem('1984');
    * cbYear.addItem('1985');
    * cbYear.addItem('1986');
    * cbYear.removeItemAt(2);
    * trace(cbYear.length);
    * 
    * cbYear.addEventListener(Event.CHANGE, onYearChange);
    * 
    * private function onYearChange(e:Event):void
    * {
    *    trace(cbYear.selectedIndex);
    *    trace(cbYear.selectedLabel);
    *    trace(cbYear.selectedData);
    *    cbYear.resetSelection();
    * }
    */
   public class MyComboBox extends MovieClip
   {
      // fla
      public var mcClick:MovieClip;
      public var tfLabel:TextField;
      public var mcMsk:MovieClip;
      public var mcList:MyList;
      
      // list
      protected var listPos1:Point = new Point(0, -70); // the transition start position.
      protected var listPos2:Point = new Point(0, 24); // the transition complete position.
      
      // flag
      protected var canOpen:Boolean = false;
      protected var isAtTarget:Boolean = false;
      
      public function MyComboBox()
      {
         super();
         
         stop();
         mcClick.buttonMode = true;
         mouseChildren = true;
         tabEnabled = false;
         
         // list mask
         mcMsk.alpha = 1;
         mcMsk.mouseChildren = mcMsk.mouseEnabled = false;
         mcList.mask = mcMsk;
         
         // gs
         TweenPlugin.activate([AutoAlphaPlugin]);
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                             item
      
      public function addItem(label:String, data:* = null, enable:Boolean = true):void
      {
         mcList.addItem(label, data, enable);
      }
      
      // todo
      public function removeItemAt(index:uint):void
      {
         mcList.removeItemAt(index);
      }
      
      public function removeAll():void
      {
         mcList.removeAll();
      }
      
      public function resetSelection():void
      {
         tfLabel.text = '';
         mcList.resetSelection();
      }
      
      public function get selectedIndex():uint { return mcList.selectedIndex; }
      public function get selectedLabel():String { return mcList.selectedLabel; }
      public function get selectedData():* { return mcList.selectedData; }
      public function get length():uint { return mcList.length; }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
         mcClick.addEventListener(MouseEvent.ROLL_OVER, onOver);
         mcClick.addEventListener(MouseEvent.ROLL_OUT, onOut);
         mcClick.addEventListener(MouseEvent.CLICK, onClick);
         
         // focus
         canOpen = false;
         COMFocusMgr.api.addEventListener(COMFocusMgr.FOCUS_CHANGE, onFocusChange);
         
         // list
         mcList.onItemClick = onListItemClick;
         TweenMax.to(mcList, 0, {y:listPos1.y});
      }
      
      protected function onRemove(e:Event):void
      {
         mcClick.removeEventListener(MouseEvent.ROLL_OVER, onOver);
         mcClick.removeEventListener(MouseEvent.ROLL_OUT, onOut);
         mcClick.removeEventListener(MouseEvent.CLICK, onClick);
         
         // this
         removeEventListener(MouseEvent.CLICK, onThisClick);
         
         // both CAPTURING_PHASE & BUBBLING_PHASE phase
         stage.removeEventListener(MouseEvent.CLICK, onStageClick, true);
         stage.removeEventListener(MouseEvent.CLICK, onStageClick);
         
         // focus
         COMFocusMgr.api.removeEventListener(COMFocusMgr.FOCUS_CHANGE, onFocusChange);
         
         // list
         mcList.removeAll();
      }
      
      // ________________________________________________
      //                                    mouse handler
      
      protected function onOver(e:MouseEvent):void
      {
         doMouseOver();
      }
      
      protected function onOut(e:MouseEvent):void
      {
         if (COMFocusMgr.api.focus != this)
            doMouseOut();
      }
      
      protected function onClick(e:MouseEvent):void
      {
         isAtTarget = true;
         
         if (!canOpen)
         {
            COMFocusMgr.api.setFocus(this);
         }
         else
         {
            COMFocusMgr.api.setFocus(null);
         }
      }
      
      protected function onListItemClick():void
      {
         isAtTarget = false;
         tfLabel.text = mcList.selectedLabel;
         
         COMFocusMgr.api.setFocus(null);
         
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      protected function onThisClick(e:MouseEvent):void
      {
         isAtTarget = true;
      }
      
      protected function onStageClick(e:MouseEvent):void
      {
         if (e.eventPhase == EventPhase.CAPTURING_PHASE) return;
         
         // whether to clear focus
         if (e.eventPhase == EventPhase.AT_TARGET || !isAtTarget)
         {
            COMFocusMgr.api.setFocus(null);
         }
         
         // flag
         if (e.eventPhase == EventPhase.BUBBLING_PHASE)
         {
            isAtTarget = false;
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
      
      // --------------------- LINE ---------------------
      
      protected function showList():void
      {
         mcList.canScroll = true;
         mcList.resetListPosition();
         TweenMax.to(mcList, 1, {y:listPos2.y, ease:Strong.easeOut});
      }
      
      protected function hideList():void
      {
         mcList.canScroll = false;
         TweenMax.to(mcList, 0.5, {y:listPos1.y, ease:Strong.easeOut});
      }
      
      // ________________________________________________
      //                                    focus handler
      
      protected function onFocusChange(e:Event):void
      {
         if (COMFocusMgr.api.focus == this)
         {
            // flag
            canOpen = true;
            
            // this
            addEventListener(MouseEvent.CLICK, onThisClick);
            
            // both CAPTURING_PHASE & BUBBLING_PHASE phase
            stage.addEventListener(MouseEvent.CLICK, onStageClick, true);
            stage.addEventListener(MouseEvent.CLICK, onStageClick);
            
            // view
            showList();
            doMouseOver();
         }
         else
         {
            // flag
            canOpen = false;
            
            // this
            removeEventListener(MouseEvent.CLICK, onThisClick);
            
            // both CAPTURING_PHASE & BUBBLING_PHASE phase
            stage.removeEventListener(MouseEvent.CLICK, onStageClick, true);
            stage.removeEventListener(MouseEvent.CLICK, onStageClick);
            
            // view
            hideList();
            doMouseOut();
         }
      }
      
      // ________________________________________________
      //                                            utils
      
      protected function phaseStr(e:Event):String
      {
         switch (e.eventPhase)
         {
            case EventPhase.CAPTURING_PHASE:
               return 'CAPTURING_PHASE';
               break;
            case EventPhase.AT_TARGET:
               return 'AT_TARGET';
               break;
            case EventPhase.BUBBLING_PHASE:
               return 'BUBBLING_PHASE';
               break;
         }
         return '';
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}