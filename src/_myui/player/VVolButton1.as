package _myui.player
{
   import _myui.player.core.PlayerMgr;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;

   /**
    * A simple volume button and provides click to enable or mute audio.</br>
    * Frame "1" means volume is full and frame "totalFrame" means volume is zero.
    * @author boy, cjboy1984@gmail.com
    */
   public class VVolButton1 extends MovieClip
   {
      // model
      protected var _id:String = 'tvc';
      protected function get mgr():PlayerMgr { return PlayerMgr.api.getMgr(_id); }

      /* constructor */
      public function VVolButton1()
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
         // model
         mgr.addEventListener(PlayerMgr.VOLUME_CHANGE, onVolChange);
         
         // seeker functionality
         addEventListener(MouseEvent.CLICK, onClick);
      }
      
      protected function onRemove(e:Event):void
      {
         // model
         mgr.removeEventListener(PlayerMgr.VOLUME_CHANGE, onVolChange);
         
         // seeker functionality
         removeEventListener(MouseEvent.CLICK, onClick);
      }
      
      // ________________________________________________
      //                                       vol change
      
      protected function onVolChange(e:Event):void
      {
         updateView();
      }
      
      protected function updateView():void
      {
         if (mgr.vol == 1)
         {
            TweenMax2.frameTo(this, 1);
         }
         else
         {
            TweenMax2.frameTo(this, 'totalFrames');
         }
      }
      
      // ________________________________________________
      //                                            mouse

      protected function onClick(e:MouseEvent):void
      {
         // new volume
         if (mgr.vol == 1)
         {
            mgr.setVol(0);
         }
         else
         {
            mgr.setVol(1);
         }
      }

      // --------------------- LINE ---------------------

   }

}