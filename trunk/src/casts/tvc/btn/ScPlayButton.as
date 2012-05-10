package casts.tvc.btn
{
   import _myui.player.VPlayButton_Screen;
   
   import com.greensock.TweenMax;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ScPlayButton extends VPlayButton_Screen
   {
      // fla
      public var mc1:MovieClip;
      
      public function ScPlayButton()
      {
         super();
      }
      
      // --------------------- LINE ---------------------
      
      // ################### protected ##################
      
      override protected function onAdd(e:Event):void
      {
         super.onAdd(e);
         mc1.gotoAndStop(2);
         
         addEventListener(MouseEvent.ROLL_OVER, onOver);
         addEventListener(MouseEvent.ROLL_OUT, onOut);
      }
      
      override protected function onRemove(e:Event):void
      {
         super.onRemove(e);
         
         addEventListener(MouseEvent.ROLL_OVER, onOver);
         addEventListener(MouseEvent.ROLL_OUT, onOut);
      }
      
      // ________________________________________________
      //                                            mouse
      
      override protected function onClick(e:MouseEvent):void
      {
         if (mc1.currentFrame == 2)
         {
            mgr.play();
         }
         else
         {
            mgr.pause();
         }
      }
      
      protected function onOver(e:MouseEvent):void
      {
         TweenMax.to(this, 0.3, {alpha:1});
      }
      
      protected function onOut(e:MouseEvent):void
      {
         if (mgr.playing)
         {
            TweenMax.to(this, 0.3, {alpha:0});
         }
      }
      
      // ________________________________________________
      //                                            model
      
      override protected function onPauseVid(e:Event):void
      {
         mc1.gotoAndStop(2);
         
         TweenMax.to(this, 0.3, {alpha:1});
      }
      
      override protected function onPlayVid(e:Event):void
      {
         mc1.gotoAndStop(1);
         
         TweenMax.to(this, 0.3, {alpha:0});
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}