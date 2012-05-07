package _sample
{
   import casts._lightbox.BaseLightbox;
   
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   
   import flash.events.Event;
   
   public class LightboxSample extends BaseLightbox
   {
      
      public function LightboxSample()
      {
         super();
      }
      
      // --------------------- LINE ---------------------
      
      override public function transitionIn():void
      {
         super.transitionIn();
         transitionInComplete();
         
         cmd.stop();
         cmd.kill();
         cmd = new TimelineMax(
            {
               onStart:function()
               {
               },
               onUpdate:function()
               {
               },
               onComplete:function()
               {
               }
            }
         );
         
         // [init]
         TweenMax.to(this, 0, {autoAlpha:1, scaleX:1, scaleY:1});
         // [actions]
         
         cmd.play();
      }
      
      override public function transitionInComplete():void
      {
         super.transitionInComplete();
      }
      
      override public function transitionOut():void
      {
         super.transitionOut();
         
         // stop cmd(TimelineMax)
         cmd.stop();
         cmd.kill();
         cmd = new TimelineMax(
            {
               onStart:function()
               {
               },
               onUpdate:function()
               {
               },
               onComplete:function()
               {
                  transitionOutComplete();
               }
            }
         );
         
         // [init]
         // [actions]
         cmd.insert(TweenMax.to(this, 0.5, {autoAlpha:0}));
         
         cmd.play();
      }
      
      override public function transitionOutComplete():void
      {
         super.transitionOutComplete();
      }
      
      // ################### protected ##################
      
      override protected function onAdd(e:Event):void
      {
         super.onAdd(e);
      }
      
      override protected function onRemove(e:Event):void
      {
         super.onRemove(e);
      }
      
      // --------------------- LINE ---------------------
      
      override protected function onStageResize(e:Event = null):void
      {
         x = (sw>>1) - (GB.DOC_WIDTH>>1);
         y = (sh>>1) - (GB.DOC_HEIGHT>>1);
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}