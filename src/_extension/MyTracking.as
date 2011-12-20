package _extension
{
   import com.gaiaframework.debug.GaiaDebug;
   
   import flash.external.ExternalInterface;
   
   public class MyTracking
   {
      // singleton
      private static var _instance:MyTracking;
      
      // flag
      protected var enabled:Boolean;
      
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
            _instance.enabled = true;
         }
         
         return _instance;
      }
      
      public function enable():void
      {
         enabled = true;
      }
      
      public function disable():void
      {
         enabled = false;
      }
      
      // --------------------- LINE ---------------------
      
      /**
       * Add tracking code for MiGo and Google Analaytics
       * @param $code      The code.
       * @param $name      The name.
       * @param $param     The parameters.
       */      
      public function track_MiGo_GA($code:String, $name:String, $param:String = ''):void
      {
         if (!enabled) return;
         
         GaiaDebug.log('track_MiGo_GA : "' + $code + '", "' + $name + '", "' + $param + '"');
         
         track_MiGo($code, $name, $param);
         track_GA($code);
      }
      
      // --------------------- LINE ---------------------
      
      /**
       * Add tracking code for MiGo.
       * @param $code      The code.
       * @param $name      The name.
       * @param $param     The parameters.
       */  
      public function track_MiGo($code:String, $name:String, $param:String = ''):void
      {
         if (!enabled) return;
         
         if (ExternalInterface.available)
         {
            ExternalInterface.call("myTracker.trackPageview", "S", $code, $name, $param);
         }
      }
      
      /**
       * Add tracking code for Google Analaytics
       * @param $code      The code.
       */  
      public function track_GA($code:String):void
      {
         if (!enabled) return;
         
         if (ExternalInterface.available)
         {
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