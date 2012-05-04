package _myui.player
{
   import _myui.player.core.PlayerMgr;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   
   /**
    * A play button.
    * @author boy,cjboy1984@gmail.com
    */
   public class VLoading extends MovieClip
   {
      // model
      protected var _id:String = 'tvc';
      protected function get mgr():PlayerMgr { return PlayerMgr.api.getMgr(_id); }
      
      public function VLoading()
      {
         // disable tab-functionality.
         tabEnabled = tabChildren = focusRect = false;
         mouseChildren = mouseEnabled = false;
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                               id
      
      public function get id():String { return _id; }
      public function set id(v:String):void
      {
         mgr.removeEventListener(PlayerMgr.PLAY_PROGRESS, onBuffFull);
         mgr.removeEventListener(PlayerMgr.BUFFER_EMPTY, onBuffEmpty);
         mgr.removeEventListener(PlayerMgr.VIDEO_END, onVideoEnd);
         
         _id = v;
         
         mgr.addEventListener(PlayerMgr.BUFFER_FULL, onBuffFull);
         mgr.addEventListener(PlayerMgr.BUFFER_EMPTY, onBuffEmpty);
         mgr.addEventListener(PlayerMgr.VIDEO_END, onVideoEnd);
      }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
         visible = false;
         
         // model
         mgr.addEventListener(PlayerMgr.BUFFER_FULL, onBuffFull);
         mgr.addEventListener(PlayerMgr.BUFFER_EMPTY, onBuffEmpty);
         mgr.addEventListener(PlayerMgr.VIDEO_END, onVideoEnd);
      }
      
      protected function onRemove(e:Event):void
      {
         // model
         mgr.removeEventListener(PlayerMgr.PLAY_PROGRESS, onBuffFull);
         mgr.removeEventListener(PlayerMgr.BUFFER_EMPTY, onBuffEmpty);
         mgr.removeEventListener(PlayerMgr.VIDEO_END, onVideoEnd);
      }
      
      // ________________________________________________
      //                                            model
      
      protected function onBuffFull(e:Event):void
      {
         visible = false;
      }
      
      protected function onBuffEmpty(e:Event):void
      {
         visible = true;
      }
      
      protected function onVideoEnd(e:Event):void
      {
         visible = false;
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}