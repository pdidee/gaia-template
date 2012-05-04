package _myui.player
{
   import _myui.player.core.PlayerMgr;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;

   /**
    * A volume button with slider UI.
    * @author boy, cjboy1984@gmail.com
    */
   public class VVolButton2 extends MovieClip
   {
      // fla
      public var mcMsk:MovieClip;
      
      // bar width
      public var barWidth:Number = 100;
      
      // model
      protected var _id:String = 'tvc';
      protected function get mgr():PlayerMgr { return PlayerMgr.api.getMgr(_id); }

      /* constructor */
      public function VVolButton2()
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

      // ________________________________________________
      //                                               id
      
      public function get id():String { return _id; }
      public function set id(v:String):void
      {
         mgr.removeEventListener(PlayerMgr.VOLUME_CHANGE, onVolChange);
         
         _id = v;
         
         mgr.addEventListener(PlayerMgr.VOLUME_CHANGE, onVolChange);
      }

      // ################### protected ##################

      protected function onAdd(e:Event):void
      {
         mcMsk.scaleX = mgr.vol;
         
         // model
         mgr.addEventListener(PlayerMgr.VOLUME_CHANGE, onVolChange);
         
         // seeker functionality
         addEventListener(MouseEvent.MOUSE_DOWN, onMDown);
      }
      
      protected function onRemove(e:Event):void
      {
         // model
         mgr.removeEventListener(PlayerMgr.VOLUME_CHANGE, onVolChange);
         
         // seeker functionality
         removeEventListener(MouseEvent.MOUSE_DOWN, onMDown);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP, onMUp);
      }
      
      // ________________________________________________
      //                                       vol change
      
      protected function onVolChange(e:Event):void
      {
         updateView();
      }
      
      protected function getVol():Number
      {
         var ret:Number;
         if (mouseX < mcMsk.x)
         {
            ret = 0;
         }
         else if (mouseX > mcMsk.x + barWidth)
         {
            ret = 1;
         }
         else
         {
            var offx:Number = mouseX - mcMsk.x;
            ret = offx / barWidth;
         }
         return ret;
      }
      
      protected function updateView():void
      {
         mcMsk.scaleX = mgr.vol;
      }
      
      // ________________________________________________
      //                                            mouse

      protected function onMDown(e:MouseEvent):void
      {
         // new volume
         mgr.setVol(getVol());

         // add drag & up handler
         stage.addEventListener(MouseEvent.MOUSE_MOVE, onMMove);
         stage.addEventListener(MouseEvent.MOUSE_UP, onMUp);
      }

      protected function onMMove(e:MouseEvent):void
      {
         // new volume
         mgr.setVol(getVol());
         // view
         updateView();
      }

      protected function onMUp(e:MouseEvent):void
      {
         // new volume
         mgr.setVol(getVol());

         // remove drag & up handler
         stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP, onMUp);
      }
      
      // --------------------- LINE ---------------------

   }

}