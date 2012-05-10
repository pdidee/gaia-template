package _myui.player
{
   import _myui.player.core.PlayerMgr;
   
   import com.greensock.TweenMax;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   /**
    * A snapshot movieclip.
    * @author boy,cjboy1984@gmail.com
    */
   public class VSnapShot extends MovieClip
   {
      // model
      protected var _id:String = 'tvc';
      protected function get mgr():PlayerMgr { return PlayerMgr.api.getMgr(_id); }
      
      public function VSnapShot()
      {
         // disable tab-functionality.
         tabEnabled = false;
         tabChildren = false;
         focusRect = false;
         
         mouseEnabled = mouseChildren = false;
         
         stop();
         
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
         mgr.addEventListener(PlayerMgr.PLAY_PROGRESS, onStatChange);
      }
      
      public function destroy():void
      {
         // model
         mgr.removeEventListener(PlayerMgr.PLAY_PROGRESS, onStatChange);
      }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
         // view
         updateView();
         
         // click
         mouseChildren = true;
         addEventListener(MouseEvent.CLICK, onClick);
      }
      
      protected function onRemove(e:Event):void
      {
         // model
         destroy();
         
         // click
         removeEventListener(MouseEvent.CLICK, onClick);
      }
      
      // ________________________________________________
      //                                            mouse
      
      protected function onClick(e:MouseEvent):void
      {
         if (mouseChildren)
         {
            mgr.play();
         }
      }
      
      // ________________________________________________
      //                                            model
      
      protected function onStatChange(e:Event):void
      {
         updateView();
      }
      
      protected function updateView():void
      {
         if (mgr.playProgress == 0)
         {
            TweenMax.to(this, 0.5, {alpha:1});
         }
         else
         {
            TweenMax.to(this, 0.5, {alpha:0});
         }
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}