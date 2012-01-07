package _myui.form
{
   import flash.display.Stage;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   
   /**
    * A helper to help restrict input characters, trim tail space...etc,.
    * @author boy, cjboy1984@gmail.com
    * @usage
    * // fla
    * public var tfEmail:TextField;
    * public var tfTel:TextField;
    * public var tfId:TextField;
    * 
    * var tfHelper:TextfieldHelper = new TextfieldHelper();
    * tfHelper.add([tfEmail, tfTel, tfId]);
    * 
    * // char restric
    * tfHelper.restrictEmail(tfEmail);
    * tfHelper.restrictTel(tfTel);
    * tfHelper.restrictId(tfId);
    * 
    * // trim tail space
    * tfHelper.trimRight();
    */   
   public class TextfieldHelper extends EventDispatcher
   {
      // pool
      protected var tfPool:Vector.<TextField>;
      
      public function TextfieldHelper()
      {
      }
      
      // ________________________________________________
      //                                    add into pool
      
      /**
       * Add a array containing the TextFields you care.
       */
      public function add(tfs:Array):void
      {
         tfPool = new Vector.<TextField>();
         for each (var tf:TextField in tfs) 
         {
            tfPool.push(tf);
         }
         
         // tab sequence
         for (var i:int = 0; i < tfPool.length; ++i) 
         {
            if (i == 0)
            {
               // focus it.
               if (tfPool[i].stage) tfPool[i].stage.focus = tfPool[i];
               // move cursor to the end.
               tfPool[i].setSelection(tfPool[i].length, tfPool[i].length);
            }
            tfPool[i].tabEnabled = i;
         }
      }
      
      /**
       * Get the TextFields you care.
       */
      public function get textFields():Vector.<TextField> { return tfPool; }
      
      // ________________________________________________
      //                                         restrict
      
      public function restrictTel(tf:TextField):void { tf.restrict = "0-9\\-"; }
      public function restrictEmail(tf:TextField):void {tf.restrict = "a-z0-9\_\.\\-@"; }
      public function restrictID(tf:TextField):void {tf.restrict = "A-Z0-9"; }
      
      // ________________________________________________
      //                                             trim
      
      /**
       * Trim the chars at the end of the string of the TextFields you added.
       */
      public function trimRight(removeChars:String = " \t\n\r"):void
      {
         var pattern:RegExp = new RegExp('[' + removeChars + ']+$', '');
         for each (var tf:TextField in tfPool) 
         {
            tf.text = tf.text.replace(pattern, '');
         }
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}