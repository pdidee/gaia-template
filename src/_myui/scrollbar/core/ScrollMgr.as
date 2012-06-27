package _myui.scrollbar.core
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   /**
    * A scroll-bar basing on MVC-pattern.
    * @auther  boy, cjboy1984@gmail.com
    * @date    Jan,01,2012
    */
   public class ScrollMgr extends EventDispatcher
   {
      // Event
      public static const VALUE_CHANGE:String = 'VALUE_CHANGE';
      public static const VALUE_REVERT:String = 'VALUE_REVERT';
      
      // target, seek percentage, mask reference...
      private var _value:Number = 0;
      private var _oldValue:Number = 0;
      
      // singleton
      private static var mgrPool:Dictionary = new Dictionary();
      
      public function ScrollMgr(pvt:PrivateClass)
      {
         // DO NOTHING
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
      public static function getMgr(id:String):ScrollMgr
      {
         if (!mgrPool) mgrPool = new Dictionary();
         
         // Whether to create a new instance or NOT.
         var mgr:ScrollMgr = ScrollMgr(mgrPool[id]);
         if (mgr == null)
         {
            mgr = new ScrollMgr(new PrivateClass());
            mgrPool[id] = mgr;
         }
         
         return mgr;
      }
      
      /**
       * Destory the lists saving the instance of MyScrollBarMgr class.
       * It might also release the memory of the instance if there isn't other reference refering to it.
       */
      public static function dispose():void
      {
         mgrPool = null;
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