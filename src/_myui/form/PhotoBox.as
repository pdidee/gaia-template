package _myui.form
{
   import com.greensock.layout.ScaleMode;
   import com.greensock.loading.ImageLoader;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PhotoBox extends MovieClip
   {
      public var onOverEvt:Function;
      public var onOutEvt:Function;
      public var onClickEvt:Function;
      
      private var bmpLoader:ImageLoader;
      
      public function PhotoBox()
      {
         super();
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // --------------------- LINE ---------------------
      
      public function getLoader(str:String):ImageLoader
      {
         if (bmpLoader && bmpLoader.bytesLoaded > 0) bmpLoader.dispose(true);
         bmpLoader = new ImageLoader(str, {container:this, smoothing:true, width:56, height:56, scaleMode:ScaleMode.PROPORTIONAL_OUTSIDE, crop:true});
         return bmpLoader;
      }
      
      public function disposeImage():void
      {
         if (bmpLoader)
         {
            bmpLoader.dispose(true);
         }
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      private function onAdd(e:Event):void
      {
         addEventListener(MouseEvent.ROLL_OVER, onOver);
         addEventListener(MouseEvent.ROLL_OUT, onOut);
         addEventListener(MouseEvent.CLICK, onClick);
      }
      
      private function onRemove(e:Event):void
      {
         addEventListener(MouseEvent.ROLL_OVER, onOver);
         addEventListener(MouseEvent.ROLL_OUT, onOut);
         addEventListener(MouseEvent.CLICK, onClick);
      }
      
      // --------------------- LINE ---------------------
      
      private function onOver(e:MouseEvent):void
      {
         if (onOverEvt as Function) onOverEvt(e);
      }
      
      private function onOut(e:MouseEvent):void
      {
         if (onOutEvt as Function) onOutEvt(e);
      }
      
      private function onClick(e:MouseEvent):void
      {
         if (onClickEvt as Function) onClickEvt(e);
      }
      
      // --------------------- LINE ---------------------
      
   }
   
}