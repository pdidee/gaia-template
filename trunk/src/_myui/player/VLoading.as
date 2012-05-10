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
      //                                     init/destroy
      
      public function init(modId:String = null):void
      {
         // model id
         if (modId)
         {
            _id = modId;
         }
         
         // model
         mgr.addEventListener(PlayerMgr.BUFFER_FULL, onBuffFull);
         mgr.addEventListener(PlayerMgr.BUFFER_EMPTY, onBuffEmpty);
         mgr.addEventListener(PlayerMgr.VIDEO_END, onVideoEnd);
      }
      
      public function destroy():void
      {
         // model
         mgr.removeEventListener(PlayerMgr.PLAY_PROGRESS, onBuffFull);
         mgr.removeEventListener(PlayerMgr.BUFFER_EMPTY, onBuffEmpty);
         mgr.removeEventListener(PlayerMgr.VIDEO_END, onVideoEnd);
      }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
         visible = false;
      }
      
      protected function onRemove(e:Event):void
      {
         // model
         destroy();
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