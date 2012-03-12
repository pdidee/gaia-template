package
{
   import flash.events.Event;

   /**
    * A customized event.
    * @author boy, cjboy1984@gmail.com
    */
   public class EEvent extends Event
   {
      public static const DEF_PRELOADER_TOUT:String = 'DEF_PRELOADER_TOUT';
      
      public function EEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type, bubbles, cancelable);
      }
      
      // --------------------- LINE ---------------------
      
   }
   
}