package _myui.scrollbar.core
{
   import flash.events.Event;
   import flash.events.EventDispatcher;

   /**
    * It's just like a model for MyScrollBar basing on MVC-pattern.
    * @auther  cjboy1984@gmail.com
    * @date    May,13,2011
    * @usage
    * 1. 取得第n個 MyScrollBarMgr
    * var mgr:MyScrollBarMgr = MyScrollBarMgr.getMgrAt(n);
    *
    * 2. 終結所有的 MyScrollBarMgr
    * MyScrollBarMgr.dispose();
    *
    * 3. 利用取得的 MyScrollBarMgr 來做事
    * mgr.ta = mcAAA;
    * mgr.taInitPos = new Point(100, 200);
    * mgr.direction = MyScrollBarMgr.DIRECTION_V; // MyScrollBarMgr.DIRECTION_H
    * mgr.mskRef = 500;
    * mgr.percentage = 0; // 0~100
    * ...
    */
   public class MyScrollBarMgr extends EventDispatcher
   {
      // Event
      public static const SEEK_TO:String = 'MyScrollBarMgr_seek_to';

      // A static lists saving instance of MyScrollBarMgr class.
      private static var mgrs:Array;

      // target, seek percentage, mask reference...
      private var _perc:Number; // 捲動的百分比，0~1

      /* constructor */
      public function MyScrollBarMgr();

      // --------------------- LINE ---------------------

      // ________________________________________________
      //                                           STATIC

      /**
       * To get the Nth instance of MyScrollBarMgr class.
       */
      public static function getMgrAt(i:int = 0):MyScrollBarMgr
      {
         // Initialize the lists if it is null.
         if (!mgrs)
         {
            mgrs = new Array();
         }

         // Whether to create a new instance or NOT.
         while (i >= mgrs.length)
         {
            var mgr:MyScrollBarMgr = new MyScrollBarMgr();
            mgrs.push(mgr);
         }
         return mgrs[i] as MyScrollBarMgr;
      }

      /**
       * Destory the lists saving the instance of MyScrollBarMgr class.
       * It might also release the memory of the instance if there isn't other reference refering to it.
       */
      public static function dispose():void
      {
         mgrs = null;
      }

      // --------------------- LINE ---------------------

      /**
       * 捲動的百分比
       */
      public function get percentage():Number { return _perc; }
      public function set percentage(v:Number):void
      {
         var new_v:int;
         if (v < 0)
         {
            new_v = 0;
         }
         if (v > 1)
         {
            new_v = 1
         }
         else
         {
            new_v = v;
         }
         _perc = v;
         // note with event
         dispatchEvent(new Event(SEEK_TO));
      }

      // --------------------- LINE ---------------------

      // ################### protected ##################

      // #################### private ###################

      // --------------------- LINE ---------------------

   }

}