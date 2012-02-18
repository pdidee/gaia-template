package _extension
{
   import com.gaiaframework.debug.GaiaDebug;
   
   import flash.external.ExternalInterface;
   
   public class MyTracking
   {
      // singleton
      private static var _instance:MyTracking;
      
      // flag
      protected var enabled:Boolean = true;
      protected var jsConsoleEnabled:Boolean = true;
      
      public function MyTracking(pvt:PrivateClass)
      {
         // do nothing
      }
      
      // ________________________________________________
      //                                    configuration
      
      public function enable():void
      {
         enabled = true;
      }
      
      public function disable():void
      {
         enabled = false;
      }
      
      public function enableJSConsole():void
      {
         jsConsoleEnabled = true;
      }
      
      public function disableJSConsole():void
      {
         jsConsoleEnabled = false;
      }
      
      // ________________________________________________
      //                                         tracking
      
      /**
       * Add tracking code for MiGo and Google Analaytics
       * @param $code      The code.
       * @param $name      The name.
       * @param $param     The parameters.
       */      
      public function track_MiGo_GA($code:String, $name:String, $param:String = ''):void
      {
         if (!enabled) return;
         
         if (jsConsoleEnabled)
         {
            GaiaDebug.log('track_MiGo_GA : "' + $code + '", "' + $name + '", "' + $param + '"');
         }
         else
         {
            trace('track_MiGo_GA : "' + $code + '", "' + $name + '", "' + $param + '"');
         }
         
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
      
      // ________________________________________________
      //                                        singleton
      
      public static function get api():MyTracking
      {
         if (!_instance)
         {
            _instance = new MyTracking(new PrivateClass());
            _instance.enabled = true;
         }
         
         return _instance;
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