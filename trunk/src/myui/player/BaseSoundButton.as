package myui.player
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   import myui.player.core.MyPlayerMgr;
   
   import org.flintparticles.common.utils.interpolateColors;

   /**
    * @author     cjboy | cjboy1984@gmail.com
    * @usage
    * 1. 首先，你必需先有個MyPlayerMgr的getter，以範例來說是取得第0個MyPlayerMgr。
    * protected function get mgr():MyPlayerMgr { return MyPlayerMgr.getMgrAt(0); }
    *
    * 2. 再來利用mgr來監聽事件和用mgr來執行行為。
    * mgr.play();
    * mgr.pause();
    * ...
    */
   public class BaseSoundButton extends MovieClip
   {
      // fla
      public var mcMsk:MovieClip;
      
      // bar width
      protected var barWidth:Number = 100;
      
      // flag
      protected var isOver:Boolean = false;
      protected var isDragging:Boolean = false;
      
      // percentage of the seeker
      protected var seekToPerc:Number;
      
      // player manager
      protected var managerNo:int = 0;
      protected function get mgr():MyPlayerMgr { return MyPlayerMgr.getMgrAt(managerNo); }

      /* constructor */
      public function BaseSoundButton()
      {
         // disable tab-functionality.
         tabEnabled = false;
         tabChildren = false;
         focusRect = false;

         buttonMode = true;
         mouseChildren = false;

         stop();

         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }

      // --------------------- LINE ---------------------

      // ################### protected ##################

      protected function onAdd(e:Event):void
      {
         mcMsk.scaleX = mgr.volumePercentage / 100;
         
         // seeker functionality
         addEventListener(MouseEvent.MOUSE_DOWN, onMDown);
      }

      protected function onRemove(e:Event):void
      {
         // seeker functionality
         removeEventListener(MouseEvent.MOUSE_DOWN, onMDown);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP, onMUp);
      }
      
      // --------------------- LINE ---------------------
      
      protected function onMOver(e:MouseEvent):void {}
      protected function onMOut(e:MouseEvent):void {}

      // --------------------- LINE ---------------------

      protected function onMDown(e:MouseEvent):void
      {
         isDragging = true;
         // new volume
         mgr.volumePercentage = getVolumePercentage();
         
         // view
         changeViewByVolumn();

         // add drag & up handler
         stage.addEventListener(MouseEvent.MOUSE_MOVE, onMMove);
         stage.addEventListener(MouseEvent.MOUSE_UP, onMUp);
      }

      protected function onMMove(e:MouseEvent):void
      {
         // new volume
         mgr.volumePercentage = getVolumePercentage();
         // view
         changeViewByVolumn();
      }

      protected function onMUp(e:MouseEvent):void
      {
         isDragging = false;
         // new volume
         mgr.volumePercentage = getVolumePercentage();
         
         // view
         changeViewByVolumn();

         // remove drag & up handler
         stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP, onMUp);
      }

      // --------------------- LINE ---------------------

      protected function getVolumePercentage():int
      {
         if (mouseX < mcMsk.x)
         {
            return 0;
         }
         else if (mouseX > mcMsk.x + barWidth)
         {
            return 100;
         }
         else
         {
            var offx:Number = mouseX - mcMsk.x;
            return int(100 * offx / barWidth);
         }
      }

      protected function changeViewByVolumn():void
      {
         mcMsk.scaleX = mgr.volumePercentage / 100;
      }
      
      // --------------------- LINE ---------------------

   }

}