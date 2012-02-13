package _myui.scrollbar.core
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   /**
    * A scroll-bar basing on MVC-pattern.
    * @auther  boy, cjboy1984@gmail.com
    * @date    Jan,01,2012
    */
   public class ScrollMgr extends EventDispatcher
   {
      // Event
      public static const VALUE_CHANGE:String = 'SCROLL_VALUE_CHANGE';
      public static const VALUE_REVERT:String = 'SCROLL_VALUE_REVERT';
      
      // A static lists saving instance of ScrollMgr class.
      private static var mgrs:Array;
      
      // target, seek percentage, mask reference...
      private var _value:Number;
      private var _oldValue:Number;
      
      public function ScrollMgr(pvt:PrivateClass)
      {
         _value = 0;
         _oldValue = 0;
      }
      
      // ________________________________________________
      //                                             main
      
      public function get value():Number { return _value; }
      public function set value(v:Number):void
      {
         _oldValue = _value;
         _value = v;
         // notify
         dispatchEvent(new Event(VALUE_CHANGE));
      }
      
      /**
       * Revert value to last time or the given one. It dispatch "VALUE_REVERT" event.
       */
      public function revertValue(v:Number = Number.MIN_VALUE):void
      {
         if (v != Number.MIN_VALUE)
         {
            _value = _oldValue;
         }
         else
         {
            _oldValue = _value;
            _value = v;
         }
         // notify
         dispatchEvent(new Event(VALUE_REVERT));
      }
      
      // ________________________________________________
      //                                            Utils
      
      /**
       * To get the Nth instance of ScrollMgr class.
       * @param i          The number.
       * @return           The Nth instance of ScrollMgr class.
       */
      public static function getMgrAt(i:int = 0):ScrollMgr
      {
         // Initialize the lists if it is null.
         if (!mgrs)
         {
            mgrs = new Array();
         }
         
         // Whether to create a new instance or NOT.
         while (i >= mgrs.length)
         {
            var mgr:ScrollMgr = new ScrollMgr(new PrivateClass());
            mgrs.push(mgr);
         }
         return mgrs[i] as ScrollMgr;
      }
      
      /**
       * Destory the lists saving the instance of MyScrollBarMgr class.
       * It might also release the memory of the instance if there isn't other reference refering to it.
       */
      public static function dispose():void
      {
         mgrs = null;
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