package _myui.player.core
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   /**
    * It's just like a model for MyPlayer basing on MVC-pattern.
    * @auther  boy, cjboy1984@gmail.com
    * @date    May,3,2012
    * @usage
    * 1. Get the model:
    * var mgr:PlayerMgr = PlayerMgr.getMgr('id');
    *
    * 2. Using the model to do something...
    * mgr.play();
    * mgr.pause();
    * mgr.stop();
    * ...
    */
   public class PlayerMgr extends EventDispatcher
   {
      // Event
      public static const PLAY:String = '__PLAY__';
      public static const PAUSE:String = '__PAUSE__';
      public static const STOP:String = '__STOP__';
      // Event
      public static const BUFFER_EMPTY:String = '__BUFFER_EMPTY__';
      public static const BUFFER_FULL:String = '__BUFFER_FULL__';
      public static const BUFFER_PROGRESS:String = '__BUFFER_PROGRESS__';
      public static const PLAY_PROGRESS:String = '__PLAY_PROGRESS__';
      // Event
      public static const SEEK_TO:String = '__SEEK_TO__';
      public static const VIDEO_END:String = '__VIDEO_END__';
      // Event
      public static const VOLUME_CHANGE:String = '__VOLUME_CHANGE__';
      
      // A static lists saving instance of MyPlayerMgr class.
      private var mgrPool:Dictionary = new Dictionary();
      
      // load percentage, play head percentage...
      public var playing:Boolean = false;
      public var vol:Number = 1; // 0~1
      public var bufferProgress:Number = 0; // 0~1
      public var playProgress:Number = 0; // 0~1
      
      // singleton
      private static var instance:PlayerMgr;
      
      // --------------------- LINE ---------------------
      
      public function PlayerMgr(pvt:PrivateClass)
      {
         // DO NOTHING
      }
      
      // ________________________________________________
      //                                             init
      
      /**
       * To get the responding reference of PlayerMgr.
       */
      public function getMgr(id:String):PlayerMgr
      {
         // Initialize the lists if it is null.
         if (!mgrPool)
         {
            mgrPool = new Vector.<PlayerMgr>();
         }
         
         // Whether to create a new instance or NOT.
         var mgr:PlayerMgr = PlayerMgr(mgrPool[id]);
         if (mgr == null)
         {
            mgr = new PlayerMgr(new PrivateClass());
            mgrPool[id] = mgr;
         }
         
         return mgr;
      }
      
      /**
       * Initialize.
       */
      public function init():void
      {
         // DO NOTHING
      }
      
      /**
       * Destory the dictionary.
       */
      public function dispose():void
      {
         mgrPool = null;
      }
      
      // ________________________________________________
      //                             play, pause, stop...
      
      public function play():void
      {
         playing = true;
         dispatchEvent(new Event(PlayerMgr.PLAY));
      }
      
      public function pause():void
      {
         playing = false;
         dispatchEvent(new Event(PlayerMgr.PAUSE));
      }
      
      public function stop():void
      {
         playing = false;
         playProgress = 0;
         dispatchEvent(new Event(PlayerMgr.STOP));
      }
      
      public function seekTo(v:Number):void
      {
         playProgress = v;
         dispatchEvent(new Event(PlayerMgr.SEEK_TO));
      }
      
      // ________________________________________________
      //                                           setter
      
      public function setBufferProgress(v:Number):void
      {
         bufferProgress = v;
         dispatchEvent(new Event(PlayerMgr.BUFFER_PROGRESS));
      }
      
      public function setBufferEmpty():void
      {
         dispatchEvent(new Event(PlayerMgr.BUFFER_EMPTY));
      }
      
      public function setBufferFull():void
      {
         dispatchEvent(new Event(PlayerMgr.BUFFER_FULL));
      }
      
      public function setPlayProgress(v:Number):void
      {
         playProgress = v;
         dispatchEvent(new Event(PlayerMgr.PLAY_PROGRESS));
         
         if (playProgress == 1)
         {
            playing = false;
            dispatchEvent(new Event(PlayerMgr.VIDEO_END));
         }
      }
      
      public function setVol(v:Number):void
      {
         vol = v;
         dispatchEvent(new Event(PlayerMgr.VOLUME_CHANGE));
      }
      
      // ________________________________________________
      //                                        singleton
      
      public static function get api():PlayerMgr
      {
         if (!instance)
         {
            instance = new PlayerMgr(new PrivateClass());
         }
         
         return instance;
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}

class PrivateClass
{
   public function PrivateClass() {}
}