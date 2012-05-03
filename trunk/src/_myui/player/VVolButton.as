package _myui.player
{
   import _myui.player.core.PlayerMgr;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;

   /**
    * @author boy, cjboy1984@gmail.com
    */
   public class VVolButton extends MovieClip
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
      
      // model
      public var id:String = 'abc';
      protected function get mgr():PlayerMgr { return PlayerMgr.api.getMgr(id); }

      /* constructor */
      public function VVolButton()
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
         mcMsk.scaleX = mgr.vol;
         
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
         mgr.vol = getVolumePercentage();
         
         // view
         changeViewByVolumn();

         // add drag & up handler
         stage.addEventListener(MouseEvent.MOUSE_MOVE, onMMove);
         stage.addEventListener(MouseEvent.MOUSE_UP, onMUp);
      }

      protected function onMMove(e:MouseEvent):void
      {
         // new volume
         mgr.vol = getVolumePercentage();
         // view
         changeViewByVolumn();
      }

      protected function onMUp(e:MouseEvent):void
      {
         isDragging = false;
         // new volume
         mgr.vol = getVolumePercentage();
         
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
            return 1;
         }
         else
         {
            var offx:Number = mouseX - mcMsk.x;
            return offx / barWidth;
         }
      }

      protected function changeViewByVolumn():void
      {
         mcMsk.scaleX = mgr.vol;
      }
      
      // --------------------- LINE ---------------------

   }

}