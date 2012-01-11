package _myui.form.control.common
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class MyList extends MovieClip
   {
      // fla
      public var mcMsk:MovieClip;
      
      // info
      public var rowCount:int = 5;
      
      // cell
      protected var cellInitPos:Point = new Point();
      protected var cellBox:Sprite = new Sprite();
      
      public function MyList()
      {
         super();
         
         // mask
         mcMsk.cacheAsBitmap = true;
         mcMsk.alpha = 1;
         
         // cell
         cellBox.cacheAsBitmap = true;
         cellBox.mask = mcMsk;
         addChildAt(cellBox, getChildIndex(mcMsk));
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                             init
      
      public function init():void
      {
      }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
      }
      
      protected function onRemove(e:Event):void
      {
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}