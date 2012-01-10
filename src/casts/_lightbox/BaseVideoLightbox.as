package casts._lightbox
{
   import flash.display.BlendMode;
   import flash.events.Event;
   
   /**
    * A Video-Player lightbox template basing on GAIA-Framework
    * @author boy, cjboy1984@gmail.com
    * @example
    * playVid(); // to play video
    * stopVid(); // to stop video
    */   
   public class BaseVideoLightbox extends BaseLightbox
   {
      // fla
      public var btnClose:MyButton;
      public var mcPlayer:Object;
      
      // video src
      public var video_src:String = '';
      
      public function BaseVideoLightbox()
      {
         super();
         
         blendMode = BlendMode.LAYER;
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // --------------------- LINE ---------------------
      
      // close button initializer
      public function initBtnClose():void
      {
         btnClose.gotoAndStop(1);
         btnClose.buttonMode = true;
         btnClose.onClick = function()
         {
            if (!this.buttonMode) return;
            this.buttonMode = false;
            
            transitionOut();
         };
      }
      
      // --------------------- LINE ---------------------
      
      /**
       * play resource, video_src, video
       */      
      public function playVid():void
      {
         mcPlayer.playVid(video_src);
      }
      
      /**
       * stop playing
       */      
      public function stopVid():void
      {
         mcPlayer.stopVid();
      }
      
      // ################### protected ##################
      
      override protected function onAdd(e:Event):void
      {
         super.onAdd(e);
         
         alpha = 0;
         visible = false;
      }
      
      override protected function onRemove(e:Event):void
      {
         super.onRemove(e);
         // basic
         stage.removeEventListener(Event.RESIZE, onStageResize);
      }
      
      override protected function onStageResize(e:Event = null):void
      {
         x = (sw>>1) - (GB.DocWidth>>1);
         y = (sh>>1) - (GB.DocHeight>>1);
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}