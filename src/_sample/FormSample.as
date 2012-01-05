package _sample
{
   import boy.net.PhotoSelector;
   
   import flash.events.Event;
   
   public class FormSample
   {
      
      public function FormSample()
      {
      }
      
      // ________________________________________________
      //                                     select photo
      
      public function selectPhoto():void
      {
         var selector:PhotoSelector = new PhotoSelector();
         selector.addEventListener(PhotoSelector.FILE_SELECT, onFileSelected);
         selector.addEventListener(PhotoSelector.FILE_LOADED, onFileLoaded);
         selector.browse();
      }
      
      // ################### protected ##################
      
      protected function onFileSelected(e:Event):void
      {
      }
      
      protected function onFileLoaded(e:Event):void
      {
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}