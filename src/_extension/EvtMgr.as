package _extension
{
   import flash.events.EventDispatcher;
   
   /**
    * A singleton event manager.
    * @author cjboy, cjboy1984@gmail.com
    * @usage
    * // init
    * EvtMgr.api.enableIt();
    * // send event
    * EvtMgr.api.dispatchEvent(new Event('SOME_EVENT'));
    * // event handler
    * EvtMgr.api.addEventListener('SOME_EVENT', someEvtHandler);
    */
   public class EvtMgr extends EventDispatcher
   {
      // flag
      private var enable:Boolean = true;
      
      // singleton
      private static var _instance:EvtMgr;
      
      public function EvtMgr(pvt:PrivateClass)
      {
         // do nothing
      }
      
      // ________________________________________________
      //                                             init
      
      public function enableIt():void
      {
         enable = true;
      }
      
      public function disableIt():void
      {
         enable = false;
      }
      
      // ________________________________________________
      //                                    get singleton
      
      public static function get api():EvtMgr
      {
         if (!_instance)
         {
            _instance = new EvtMgr(new PrivateClass());
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