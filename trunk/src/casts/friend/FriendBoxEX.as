package casts.friend
{
   import _myui.form.FriendBox;
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class FriendBoxEX extends FriendBox
   {
      public var nickname:String;
      public var uid:String;
      public var onClickHandler:Function;
      public var onOverHandler:Function;
      public var onOutHandler:Function;
      
      // lock
      private var lock:Boolean = false;
      
      public function FriendBoxEX()
      {
         super(50, 50); // width, height
         
         photo.x = 0;
         photo.y = 0;
      }
      
      // ________________________________________________
      //                         highlight/enable/disable
      
      public function enableIt():void
      {
         buttonMode = true;
         alpha = 1;
      }
      
      public function disableIt():void
      {
         buttonMode = false;
         alpha = 0.5;
      }
      
      public function highlightIt():void
      {
         lock = true;
         TweenMax2.frameTo(this, 'totalFrames');
      }
      
      public function unHighlightIt():void
      {
         lock = false;
         TweenMax2.frameTo(this, 1);
      }
      
      // ################### protected ##################
      
      // ________________________________________________
      //                                    mouse handler
      
      override protected function onOver(e:MouseEvent):void
      {
         if (onOverHandler as Function)
         {
            onOverHandler(e);
         }
         
         if (!buttonMode || lock) return;
         TweenMax2.frameTo(this, 'totalFrames');
      }
      
      override protected function onOut(e:MouseEvent):void
      {
         if (onOutHandler as Function)
         {
            onOutHandler(e);
         }
         
         if (!buttonMode || lock) return;
         TweenMax2.frameTo(this, 1);
      }
      
      override protected function onClick(e:MouseEvent):void
      {
         if (!buttonMode) return;
         if (onClickHandler as Function)
         {
            onClickHandler(e);
         }
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}