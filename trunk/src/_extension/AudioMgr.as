package _extension
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   /**
    * Audio singleton manager
    * @author cjboy1984
    * @usage
    * // register
    * AudioMgr.api.register('bgm', new BGM());
    * AudioMgr.api.register('snd1', new Snd1());
    * // play
    * AudioMgr.api.play('bgm', true);
    */   
   public class AudioMgr extends EventDispatcher
   {
      private var idPool:Vector.<String>;
      private var soundPool:Vector.<Sound>;
      private var channelPool:Vector.<SoundChannel>;
      private var loopPool:Vector.<Boolean>;
      
      // singleton
      private static var _instance:AudioMgr;
      
      // flag
      private var enabled:Boolean = true;
      
      public function AudioMgr(pvt:PrivateClass)
      {
         // do nothing
      }
      
      // ________________________________________________
      //                                    get singleton
      
      public static function get api():AudioMgr
      {
         if (!_instance)
         {
            _instance = new AudioMgr(new PrivateClass());
            
            // sound
            _instance.idPool = new Vector.<String>();
            _instance.soundPool = new Vector.<Sound>();
            _instance.channelPool = new Vector.<SoundChannel>();
            _instance.loopPool = new Vector.<Boolean>();
         }
         
         return _instance;
      }
      
      // ________________________________________________
      //                                   register sound
      
      public function register(id:String, snd:Sound):void
      {
         if (!enabled) return;
         
         var no:int = idPool.indexOf(id);
         var sndChannel:SoundChannel;
         if (no == -1)
         {
            idPool.push(id);
            soundPool.push(snd);
            channelPool.push(null);
            loopPool.push(false);
         }
         else
         {
            // stop old sound and try to remove its event handler.
            if (channelPool[no]) channelPool[no].stop();
            
            soundPool[no] = snd;
         }
      }
      
      public function unregisterAll():void
      {
         if (!enabled) return;
         
         while (idPool.length)
         {
            var sndChannel:SoundChannel = channelPool[0];
            if (sndChannel)
            {
               sndChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
               sndChannel.stop();
            }
            
            idPool.shift();
            soundPool.shift();
            channelPool.shift();
            loopPool.shift();
         }
      }
      
      // ________________________________________________
      //                                    sound control
      
      /**
       * Play the sound by given id.
       * @param id            Registered id.
       * @param startTimes    The initial position in milliseconds at which playback should start. -1 = forever loop.
       * @param loops         Defines the number of times a sound loops back to the startTime value before the sound channel stops playback.
       * @param volumn        The volume, ranging from 0 (silent) to 1 (full volume).
       */      
      public function play(id:String, startTimes:Number = 0, loops:int = 0, vol:Number = 1):void
      {
         if (!enabled) return;
         
         var no:int = idPool.indexOf(id);
         if (no != -1)
         {
            var snd:Sound = soundPool[no];
            var sndTransform:SoundTransform = new SoundTransform(vol);
            channelPool[no] = snd.play(startTimes, loops, sndTransform);
            if (loops == -1)
            {
               channelPool[no].addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
               loopPool[no] = true;
            }
         }
      }
      
      /**
       * Pause the sound by given id
       * @param id            Registered id.
       * @return              The position in milliseconds at which playback pause.
       */      
      public function pause(id:String):Number
      {
         if (!enabled) return 0;
         
         var ret:Number = -1;
         var no:int = idPool.indexOf(id);
         if (no != -1)
         {
            var sndChannel:SoundChannel = channelPool[no];
            if (sndChannel)
            {
               ret = sndChannel.position;
               sndChannel.stop();
            }
         }
         
         return ret;
      }
      
      public function stop(id:String):void
      {
         if (!enabled) return;
         
         var no:int = idPool.indexOf(id);
         var sndChannel:SoundChannel = channelPool[no];
         if (no != -1 && sndChannel)
         {
            sndChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
            sndChannel.stop();
         }
      }
      
      public function stopAll():void
      {
         if (!enabled) return;
         
         for (var i:int = 0; i < idPool.length; ++i) 
         {
            var sndChannel:SoundChannel = channelPool[i];
            if (sndChannel)
            {
               sndChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
               sndChannel.stop();
            }
         }
      }
      
      // ________________________________________________
      //                                 enable & disable
      
      public function enable():void { enabled = true; }
      public function disable():void { enabled = false; }
      
      // ################### protected ##################
      
      protected function onSoundComplete(e:Event):void
      {
         var sndChannel:SoundChannel = SoundChannel(e.target);
         var sndTransform:SoundTransform = sndChannel.soundTransform;
         var no:int = channelPool.indexOf(sndChannel);
         var loop:Boolean = loopPool[no];
         
         if (loop)
         {
            channelPool[no] = soundPool[no].play(0, 0, sndTransform);
            channelPool[no].addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
         }
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}

class PrivateClass
{
   function PrivateClass() {}
}
