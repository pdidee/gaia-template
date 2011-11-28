package _sample
{
   import casts._lightbox.BaseLightbox;
   
   import flash.events.Event;
   
   public class LightboxSample extends BaseLightbox
   {
      
      public function LightboxSample()
      {
         super();
      }
      
      // --------------------- LINE ---------------------
      
      override public function transitionIn():void
      {
         super.transitionIn();
         visible = true;
      }
      
      override public function transitionInComplete():void
      {
         super.transitionInComplete();
      }
      
      override public function transitionOut():void
      {
         super.transitionOut();
      }
      
      override public function transitionOutComplete():void
      {
         super.transitionOutComplete();
         visible = false;
      }
      
      // ################### protected ##################
      
      override protected function onAdd(e:Event):void
      {
      }
      
      override protected function onRemove(e:Event):void
      {
      }
      
      // --------------------- LINE ---------------------
      
      override protected function onStageResize(e:Event = null):void
      {
//         x = sw;
//         y = sh;
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}