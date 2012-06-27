package _myui.form.control.core
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   /**
    * A focus manager for customized ui component.
    * @author boy, cjboy1984@gmail.com
    */
   public class COMFocusMgr extends EventDispatcher
   {
      // event
      public static const FOCUS_CHANGE:String = 'FOCUS_CHANGE';
      
      // focus
      protected var _focus:Object;
      
      // singleton
      private static var _instance:COMFocusMgr;
      
      public function COMFocusMgr(pvt:PrivateClass)
      {
         // do nothing
      }
      
      // ________________________________________________
      //                                     focus action
      
      public function setFocus(ta:Object):void
      {
         _focus = ta;
         dispatchEvent(new Event(FOCUS_CHANGE));
      }
      
      public function get focus():Object { return _focus; }
      
      // ________________________________________________
      //                                    get singleton
      
      public static function get api():COMFocusMgr
      {
         if (!_instance)
         {
            _instance = new COMFocusMgr(new PrivateClass());
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