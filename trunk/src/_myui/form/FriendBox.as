package _myui.form
{
   import com.greensock.events.LoaderEvent;
   import com.greensock.loading.ImageLoader;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class FriendBox extends MovieClip
   {
      // photo
      protected var photo:PhotoBox;
      protected var pw:Number; // photo width
      protected var ph:Number; // photo height
      
      public function FriendBox(photoWidth:Number, photoHeight:Number)
      {
         super();
         
         buttonMode = true;
         gotoAndStop(1);
         
         // photo width/height
         photo = new PhotoBox(photoWidth, photoHeight);
         addChild(photo);
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                         set info
      
      public function getLoader(url:String):ImageLoader
      {
         return photo.getLoader(url);
      }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
         gotoAndStop(1);
         
         addEventListener(MouseEvent.ROLL_OVER, onOver);
         addEventListener(MouseEvent.ROLL_OUT, onOut);
         addEventListener(MouseEvent.CLICK, onClick);
      }
      
      protected function onRemove(e:Event):void
      {
         removeEventListener(MouseEvent.ROLL_OVER, onOver);
         removeEventListener(MouseEvent.ROLL_OUT, onOut);
         removeEventListener(MouseEvent.CLICK, onClick);
      }
      
      // ________________________________________________
      //                                    mouse handler
      
      protected function onOver(e:MouseEvent):void
      {
         TweenMax2.frameTo(this, 'totalFrames');
      }
      
      protected function onOut(e:MouseEvent):void
      {
         TweenMax2.frameTo(this, 1);
      }
      
      protected function onClick(e:MouseEvent):void
      {
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}