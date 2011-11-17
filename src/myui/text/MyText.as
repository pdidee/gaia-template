package myui.text
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;

   /**
    * 把 TextField 用 MovieClip 包起來，開了text接口。
    * Pros: 1.可以解決使用 device font 的 TextField 旋轉後就消失問題。
    * Cons: 1.裡面只能有一個TextField元件，不能有它。
    * @author   cjboy1984@gmail.com
    */
   public class MyText extends MovieClip
   {
      // for solving rotation issue of TextField using device font.
      private const CANVAS_NAME:String = '_canvas';
      private var canvas:Bitmap;

      public function MyText()
      {
         stop();

         cacheAsBitmap = true;

         canvas = new Bitmap();
         canvas.name = CANVAS_NAME;
         canvas.smoothing = true;
         addChild(canvas);

         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }

      // --------------------- LINE ---------------------

      public function get text():String
      {
         var tf:TextField = getChildAt(0) as TextField;
         if (tf)
         {
            return tf.text;
         }
         else
         {
            return null;
         }
      }

      public function set text(v:String):void
      {
         var tf:TextField = getChildAt(0) as TextField;
         if (tf)
         {
            tf.multiline = false;
            tf.visible = false;
            tf.text = v;
            if (tf.defaultTextFormat.align == TextFormatAlign.LEFT)
            {
               tf.width = tf.textWidth + 5;
            }

            canvas.x = tf.x;
            canvas.y = tf.y;
            canvas.bitmapData = new BitmapData(tf.width, tf.height, true, 0x000000);
            canvas.bitmapData.draw(tf);
         }
      }

      // --------------------- LINE ---------------------

      public function get textWidth():Number
      {
         var tf:TextField = getChildAt(0) as TextField;
         if (tf)
         {
            return tf.textWidth;
         }
         else
         {
            return 0;
         }
      }

      public function get textHeight():Number
      {
         var tf:TextField = getChildAt(0) as TextField;
         if (tf)
         {
            return tf.textHeight;
         }
         else
         {
            return 0;
         }
      }

      // --------------------- LINE ---------------------

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