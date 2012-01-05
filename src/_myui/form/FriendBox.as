package _myui.form
{
   import com.greensock.events.LoaderEvent;
   import com.greensock.loading.ImageLoader;
   import com.greensock.loading.LoaderMax;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class FriendBox extends MovieClip
   {
      // loader
      protected static var totalLoader:LoaderMax;
      protected var imgLoader:ImageLoader;
      protected var _perc:Number;
      
      public function FriendBox()
      {
         super();
         
         buttonMode = true;
         gotoAndStop(1);
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                           loader
      
      public static function initLoader():void
      {
         totalLoader = new LoaderMax({
            onProgress:onTotalLoading,
            onComplete:onTotalComplete
         });
         totalLoader.maxConnections = 5;
      }
      
      public static function destroyLoader():void
      {
         if (!totalLoader) return;
         
         totalLoader.dispose(true);
      }
      
      public static function startLoad():void
      {
         totalLoader.load(true);
      }
      
      public static function get perc():Number { return totalLoader.progress; }
      
      // ________________________________________________
      //                                         set info
      
      public function init(uid:String, img_url:String):void
      {
         if (!totalLoader) return;
         
         imgLoader = new ImageLoader(img_url, {
            container:this,
            onProgress:onLoading,
            onComplete:onLoadComplete
         });
         totalLoader.append(imgLoader);
      }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
         gotoAndStop(1);
         
         addEventListener(MouseEvent.ROLL_OVER, onOver);
         addEventListener(MouseEvent.ROLL_OUT, onOut);
         addEventListener(MouseEvent.CLICK, onClick);
      }
      
      protected function onRemove(e:Event):void
      {
      }
      
      // ________________________________________________
      //                                    mouse handler
      
      protected function onOver(e:MouseEvent):void
      {
         TweenMax2.frameTo(this, 'totalFrames');
      }
      
      protected function onOut(e:MouseEvent):void
      {
         TweenMax2.frameTo(this, 1);
      }
      
      protected function onClick(e:MouseEvent):void
      {
      }
      
      // ________________________________________________
      //                             total loader handler
      
      protected static function onTotalLoading(e:LoaderEvent):void
      {
      }
      
      protected static function onTotalComplete(e:LoaderEvent):void
      {
      }
      
      // ________________________________________________
      //                                   loader handler
      
      protected function onLoading(e:LoaderEvent):void
      {
      }
      
      protected function onLoadComplete(e:LoaderEvent):void
      {
//         imgLoader.rawContent
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}