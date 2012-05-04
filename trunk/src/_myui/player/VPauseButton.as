package _myui.player
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   import _myui.player.core.PlayerMgr;
   
   /**
    * @author boy, cjboy1984@gmail.com
    */
   public class VPauseButton extends MovieClip
   {
      // model
      protected var _id:String = 'tvc';
      protected function get mgr():PlayerMgr { return PlayerMgr.api.getMgr(_id); }
      
      public function VPauseButton()
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
         mouseChildren = true;
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
      
      // --------------------- LINE ---------------------
      
      protected function onClick(e:MouseEvent):void
      {
         if (mouseChildren)
         {
            mgr.pause();
         }
         else
         {
            mgr.play();
         }
      }
      
      // --------------------- LINE ---------------------
      
      protected function onPlayVid(e:Event):void
      {
         mouseChildren = true;
         alpha = 1.0;
      }
      
      protected function onPauseVid(e:Event):void
      {
         mouseChildren = false;
         alpha = 0.5;
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}