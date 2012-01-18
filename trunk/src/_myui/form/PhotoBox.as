package _myui.form
{
   import com.greensock.events.LoaderEvent;
   import com.greensock.loading.ImageLoader;
   
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   
   /**
    * A box(Sprite) that help you to load photo.
    * @author boy, cjboy1984@gmail.com
    * @usage
    * var photo:PhotoBox = new PhotoBox(100, 100);
    * // It will automatically flush the old image and load the new one.
    * photo.loadURL('http://abc.com/123.jpg', onBmpLoaded, onBmpLoading);
    * 
    * private function onBmpLoaded():void
    * {
    *    // do something
    * }
    * 
    * private function onBmpLoading():void
    * {
    *    trace(photo.perc);
    * }
    * 
    * // Or you just want to get the loader, and then append it to a LoaderMax instance.
    * var totalLoader:LoaderMax = new LoaderMax();
    * totalLoader.append(photo.getLoader('http://abc.com/123.jpg'));
    * ...
    * totalLoader.load();
    */
   public class PhotoBox extends Sprite
   {
      // photo width and height
      protected var pw:Number;
      protected var ph:Number;
      
      // photo mask
      protected var pmsk:Shape;
      // photo container
      protected var pbox:Sprite;
      
      // photo loader
      protected var imgLoader:ImageLoader;
      protected var completeHander:Function;
      protected var progressHander:Function;
      
      public function PhotoBox(photoWidth:Number, photoHeight:Number)
      {
         super();
         
         // loader
         pbox = new Sprite();
         addChild(pbox);
         
         // photo width/height
         pw = photoWidth;
         ph = photoHeight;
         
         // mask
         pmsk = new Shape();
         pmsk.graphics.beginFill(0x0000ff);
         pmsk.graphics.drawRect(0, 0, pw, ph);
         pmsk.graphics.endFill();
         addChild(pmsk);
         pbox.mask = pmsk;
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                            photo
      
      public function loadURL(v:String, complete:Function = null, progress:Function = null):void 
      {
         completeHander = complete;
         progressHander = progress;
         
         // clear old
         if (imgLoader)
         {
            while (pbox.numChildren) pbox.removeChildAt(0);
            imgLoader.dispose(true);
         }
         
         imgLoader = new ImageLoader(v, {container:pbox, width:pw, height:ph, scaleMode:"proportionalOutside", onProgress:onImgLoading, onComplete:onImgLoaded});
         imgLoader.load(true);
      }
      
      public function getLoader(url:String):ImageLoader
      {
         // clear old
         if (imgLoader)
         {
            while (pbox.numChildren) pbox.removeChildAt(0);
            imgLoader.dispose(true);
         }
         
         imgLoader = new ImageLoader(url, {container:pbox, width:pw, height:ph, scaleMode:"proportionalOutside"});
         return imgLoader;
      }
      
      //      public function set srcBmp(v:String):void 
      //      {
      //      }
      //      
      //      public function set srcBmpData(v:String):void 
      //      {
      //      }
      
      public function get photo():Bitmap { return imgLoader ? imgLoader.rawContent : null; }
      
      public function get photoWidth():Number { return pw; }
      public function get photoHeight():Number { return ph; }
      public function get photoScale():Number { return imgLoader ? imgLoader.rawContent.scaleX : 0; }
      
      public function get photoX():Number { return imgLoader ? imgLoader.rawContent.x : 0; }
      public function set photoX(v:Number) { if (imgLoader) imgLoader.rawContent.x = v; }
      
      public function get photoY():Number { return imgLoader ? imgLoader.rawContent.y : 0; }
      public function set photoY(v:Number) { if (imgLoader) imgLoader.rawContent.y = v; }
      
      // ________________________________________________
      //                                          loading
      
      public function get perc():Number { return imgLoader.bytesLoaded / imgLoader.bytesTotal; }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
      }
      
      protected function onRemove(e:Event):void
      {
         if (imgLoader)
         {
            imgLoader.dispose(true);
         }
      }
      
      // ________________________________________________
      //                                  loading handler
      
      protected function onImgLoading(e:LoaderEvent):void
      {
         // callback fuction
         if (progressHander as Function)
         {
            progressHander();
         }
      }
      
      protected function onImgLoaded(e:LoaderEvent):void
      {
         // callback fuction
         if (completeHander as Function)
         {
            completeHander();
         }
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}