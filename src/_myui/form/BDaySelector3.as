package _myui.form
{
   import _myui.form.control.MyComboBox;
   
   import com.adobe.utils.NumberFormatter;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   
   import myLib.controls.ComboBox;
   
   /**
    * A customized birthday selector with combobox style. It is based on MyComboBox class.
    * @author boy, cjboy1984@gmail.com
    * @usage
    * // Set base-class as BDayComboBox, and make sure there are cbYear, cbMonth and cbDay comboboxes.
    * // fla
    * public var cbBirthday:BDayComboBox;
    * trace(cbBirthday.date);
    */   
   public class BDaySelector3 extends MovieClip
   {
      // fla
      public var cbYear:MyComboBox;
      public var cbMonth:MyComboBox;
      public var cbDay:MyComboBox;
      
      /* constructor */
      public function BDaySelector3()
      {
         stop();
         
         // disable tab
         tabEnabled = false;
         tabChildren = false;
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                             main
      
      /**
       * year/month/day
       */
      public function get year():String { return String(cbYear.selectedData || cbYear.selectedLabel); }
      public function get month():String { return String(cbMonth.selectedData || cbMonth.selectedLabel); }
      public function get day():String { return String(cbDay.selectedData || cbDay.selectedLabel); }
      
      // ################### protected ##################
      
      private function onAdd(e:Event):void
      {
         var date:Date = new Date();
         var year:Number = date.getFullYear();
         
         // year
         cbYear.removeAll();
         for (var i:int = 1952; i <= year; ++i)
         {
            cbYear.addItem(String(i), i);
         }
         
         // month
         cbMonth.removeAll();
         for (i = 1; i <= 12; ++i)
         {
            cbMonth.addItem(NumberFormatter.addLeadingZero(i), i);
         }
         
         // day
         cbDay.removeAll();
         for (i = 1; i <= 31; ++i)
         {
            cbDay.addItem(NumberFormatter.addLeadingZero(i), i);
         }
      }
      
      private function onRemove(e:Event):void
      {
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}