package casts.root.player
{
   import _myui.player.BaseFlvPlayer;
   
   import flash.events.Event;
   
   public class PlayerMain extends BaseFlvPlayer
   {
      
      public function PlayerMain()
      {
         super();
         
         // !<--- remember to check this value
         managerNo = 0;
         autoPlay = true;
         autoRewind = false;
      }
      
      // --------------------- LINE ---------------------
      
      // ################### protected ##################
      
      override protected function onAdded(e:Event):void
      {
         super.onAdded(e);
      }
      
      // #################### private ###################
      
   }
   
}