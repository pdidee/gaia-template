package _extension
{
   import com.gaiaframework.debug.GaiaDebug;
   
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
      
      public function track_MiGo_GA($code:String, $name:String, $param:String = ''):void
      {
         GaiaDebug.log('******************************************************');
         GaiaDebug.log('MyTracking.track_MiGo_GA(' + $code + ', ' + $name + ')');
         
         MiGoTrack($code, $name, $param);
         GATrack($code);
         
         GaiaDebug.log('******************************************************');
      }
      
      public function MiGoTrack($code:String, $name:String, $param:String = ''):void
      {
         if (ExternalInterface.available)
         {
            GaiaDebug.log('   MiGoTrack(' + $code + ', ' + $name + ')');
            
            ExternalInterface.call("myTracker.trackPageview", "S", $code, $name, $param);
         }
      }
      
      public function GATrack($code:String):void
      {
         if (ExternalInterface.available)
         {
            GaiaDebug.log('   GATrack(' + $code + ')');
            
            var arr:Array = ["_trackPageview", $code];
            ExternalInterface.call("_gaq.push", arr);
         }
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