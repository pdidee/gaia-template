package myui.player.core
{
   import flash.events.Event;
   import flash.events.EventDispatcher;

   /**
    * It's just like a model for MyPlayer basing on MVC-pattern.
    * @auther  cjboy1984@gmail.com
    * @date    Mar,16,2011
    * @usage
    * 1. 取得第n個MyPlayerMgr
    * var mgr:MyPlayerMgr = MyPlayerMgr.getMgrAt(n);
    *
    * 2. 終結所有的MyPlayerMgr
    * MyPlayerMgr.dispose();
    *
    * 3. 利用取得的MyPlayerMgr來做事
    * mgr.play();
    * mgr.pause();
    * mgr.stop();
    * ...
    */
   public class MyPlayerMgr extends EventDispatcher
   {
      // Event
      public static const PLAY:String = 'MyPlayerMgr_play';
      public static const PAUSE:String = 'MyPlayerMgr_pause';
      public static const STOP:String = 'MyPlayerMgr_stop';
      // Event
      public static const BUFFERING:String = 'MyPlayerMgr_buffering';
      public static const PLAYING:String = 'MyPlayerMgr_playing';
      // Event
      public static const SEEK_TO:String = 'MyPlayerMgr_seekto';
      public static const VIDEO_END:String = 'MyPlayerMgr_videoend';
      // Event
      public static const VOLUME_CHANGE:String = 'MyPlayerMgr_volumechange';
      // Event
      public static const ROLL_OVER:String = 'MyPlayerMgr_rollover';
      public static const ROLL_OUT:String = 'MyPlayerMgr_rollout';
      public static const MOUSE_MOVE:String = 'MyPlayerMgr_mousemove';

      // A static lists saving instance of MyPlayerMgr class.
      private static var mgrs:Vector.<MyPlayerMgr>;

      // load percentage, play head percentage...
      public var playing:Boolean = false;          // 是否播放中
      private var _volumePercentage:int = 100;     // 音量0~100
      private var _loadPerc:int = 0;               // load的百分比
      private var _playheadPercentage:int = 0;     // 播放百分比

      public function MyPlayerMgr(pvt:PrivateClass);

      // ________________________________________________
      //                                           STATIC

      /**
       * To get the Nth MyPlayerMgr instance.
       */
      public static function getMgrAt(i:int = 0):MyPlayerMgr
      {
         // Initialize the lists if it is null.
         if (!mgrs)
         {
            mgrs = new Vector.<MyPlayerMgr>();
         }

         // Whether to create a new instance or NOT.
         while (i >= mgrs.length)
         {
            var mgr:MyPlayerMgr = new MyPlayerMgr(new PrivateClass());
            mgrs.push(mgr);
         }
         return mgrs[i];
      }

      /**
       * Destory the lists saving the instance of MyPlayerMgr class.
       * It might also release the memory of the instance if there isn't other reference refering to it.
       */
      public static function dispose():void
      {
         mgrs = null;
      }

      // --------------------- LINE ---------------------

      public function play():void
      {
         playing = true;
         dispatchEvent(new Event(MyPlayerMgr.PLAY));
      }

      public function pause():void
      {
         playing = false;
         dispatchEvent(new Event(MyPlayerMgr.PAUSE));
      }

      public function stop():void
      {
         playing = false;
         dispatchEvent(new Event(MyPlayerMgr.STOP));
      }

      public function seekPercentage(v:int):void
      {
         if (v < 0 || v > 100) return;

         _playheadPercentage = v;
         dispatchEvent(new Event(MyPlayerMgr.SEEK_TO));
      }

      // --------------------- LINE ---------------------

      public function get loadPerc():int { return _loadPerc; }
      public function set loadPerc(v:int):void
      {
         if (v < 0 || v > 100) return;

         _loadPerc = v;
         dispatchEvent(new Event(MyPlayerMgr.BUFFERING));
      }

      public function get playheadPercentage():int { return _playheadPercentage; }
      public function set playheadPercentage(v:int):void
      {
         if (v < 0 || v > 100) return;

         _playheadPercentage = v;
         dispatchEvent(new Event(MyPlayerMgr.PLAYING));
      }

      public function sendVideoEndNote():void
      {
         dispatchEvent(new Event(MyPlayerMgr.VIDEO_END));
      }

      // --------------------- LINE ---------------------

      public function get volumePercentage():int { return _volumePercentage; }
      public function set volumePercentage(v:int):void
      {
         if (v < 0 || v > 100) return;

         _volumePercentage = v;
         dispatchEvent(new Event(MyPlayerMgr.VOLUME_CHANGE));
      }

      // --------------------- LINE ---------------------

      // ################### protected ##################

      // #################### private ###################

      // --------------------- LINE ---------------------

   }

}

class PrivateClass
{
   public function PrivateClass() {}
}