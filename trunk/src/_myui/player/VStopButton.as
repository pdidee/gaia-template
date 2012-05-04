package _myui.player
{
   import _myui.player.core.PlayerMgr;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   /**
    * @author boy, cjboy1984@gmail.com
    */
   public class VStopButton extends MovieClip
   {
      // model
      protected var _id:String = 'tvc';
      protected function get mgr():PlayerMgr { return PlayerMgr.api.getMgr(_id); }
      
      public function VStopButton()
      {
         // disable tab-functionality.
         tabEnabled = false;
         tabChildren = false;
         focusRect = false;
         
         stop();
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                               id
      
      public function get id():String { return _id; }
      public function set id(v:String):void
      {
         mgr.removeEventListener(PlayerMgr.PLAY, onPlayVid);
         mgr.removeEventListener(PlayerMgr.PAUSE, onPauseVid);
         mgr.removeEventListener(PlayerMgr.STOP, onPauseVid);
         
         _id = v;
         
         mgr.addEventListener(PlayerMgr.PLAY, onPlayVid);
         mgr.addEventListener(PlayerMgr.PAUSE, onPauseVid);
         mgr.addEventListener(PlayerMgr.STOP, onPauseVid);
      }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
         // model
         mgr.addEventListener(PlayerMgr.PLAY, onPlayVid);
         mgr.addEventListener(PlayerMgr.PAUSE, onPauseVid);
         mgr.addEventListener(PlayerMgr.STOP, onPauseVid);
         
         // click
         addEventListener(MouseEvent.CLICK, onClick);
      }
      
      protected function onRemove(e:Event):void
      {
         // model
         mgr.removeEventListener(PlayerMgr.PLAY, onPlayVid);
         mgr.removeEventListener(PlayerMgr.PAUSE, onPauseVid);
         mgr.removeEventListener(PlayerMgr.STOP, onPauseVid);
         
         // click
         removeEventListener(MouseEvent.CLICK, onClick);
      }
      
      // ________________________________________________
      //                                            mouse
      
      protected function onClick(e:MouseEvent):void
      {
         mgr.stop();
      }
      
      // ________________________________________________
      //                                            model
      
      protected function onPlayVid(e:Event):void
      {
         alpha = 1;
      }
      
      protected function onPauseVid(e:Event):void
      {
         alpha = 0.5;
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}