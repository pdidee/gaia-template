package
{
   import com.gaiaframework.templates.AbstractPage;
   
   import extension.GaiaPlus;
   
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   
   public class Test extends AbstractPage
   {
      // fla
      public var btn1:MyButton;
      
      public function Test()
      {
         super();
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // --------------------- LINE ---------------------
      
      override public function transitionIn():void
      {
         super.transitionIn();
         transitionInComplete();
      }
      
      override public function transitionInComplete():void
      {
         super.transitionInComplete();
      }
      
      override public function transitionOut():void
      {
         super.transitionOut();
         transitionOutComplete();
      }
      
      override public function transitionOutComplete():void
      {
         super.transitionOutComplete();
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      private function onAdd(e:Event):void
      {
         // basic
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         
         btn1.buttonMode = true;
         btn1.onClick = function()
         {
            GaiaPlus.showAssetById('test_1');
         };
      }
      
      private function onRemove(e:Event):void
      {
      }
      
      // --------------------- LINE ---------------------
      
   }
   
}