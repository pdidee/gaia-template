package casts._sample
{
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   /**
    * @author boy, cjboy1984@gmail.com
    * @usage
    * 
    * NavigationModelSample.instance.addEventListener(MouseEvent.ROLL_OVER, onOver);
    * NavigationModelSample.instance.addEventListener(MouseEvent.ROLL_OUT, onOut);
    * 
    * trace(NavigationModelSample.instance.rollover); // -1 means nothing is on over
    * trace(NavigationModelSample.instance.click); // -1 means nothing is clicked.
    */   
   public class NavigationModelSample extends EventDispatcher
   {
      private static var _instance:NavigationModelSample;
      
      private var _rollover:int = -1;
      private var _click:int = -1;
      
      public function NavigationModelSample(pvt:PrivateClass)
      {
      }
      
      // --------------------- LINE ---------------------
      
      public static function get instance():NavigationModelSample
      {
         if (!_instance)
         {
            _instance = new NavigationModelSample(new PrivateClass());
            _instance._click = -1;
            _instance._rollover = -1;
         }
         return _instance;
      }
      
      // --------------------- LINE ---------------------
      
      public function get rollover():int { return _rollover; }
      public function set rollover(v:int):void
      {
         _rollover = v;
         dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
      }
      
      public function get click():int { return _click; }
      public function set click(v:int):void
      {
         _click = v;
         dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}

class PrivateClass
{
   public function PrivateClass()
   {
   }
}