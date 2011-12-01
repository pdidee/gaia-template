package _extension
{
   import flash.external.ExternalInterface;

   public class MyTracking
   {
      private static var _instance:MyTracking;
      
      public function MyTracking(pvt:PrivateClass)
      {
         // do nothing
      }
      
      // --------------------- LINE ---------------------
      
      public static function get api():MyTracking
      {
         if (!_instance)
         {
            _instance = new MyTracking(new PrivateClass());
         }
         
         return _instance;
      }
      
      // --------------------- LINE ---------------------
      
      public function MiGOTrack($code:String, $name:String, $param:String = ''):void
      {
         if (ExternalInterface.available)
         {
            ExternalInterface.call("myTracker.trackPageview", "S", $code, $name, $param);
         }
      }
      
      public function GATrack():void
      {
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}

class PrivateClass
{
   function PrivateClass() {}
}