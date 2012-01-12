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
//      public function get date():String { return cbYear.selectedData + '/' + cbMonth.selectedData + '/' + cbDay.selectedData; }
//      public function get year():String { return cbYear.selectedData; }
//      public function get month():String { return cbMonth.selectedData; }
//      public function get day():String { return cbDay.selectedData; }
      
      // ################### protected ##################
      
      private function onAdd(e:Event):void
      {
         var str:String;
         var date:Date = new Date();
         var year:Number = date.getFullYear();
         
         // year
         cbYear.removeAll();
         for (var i:int = 1952; i <= year; ++i)
         {
            cbYear.addItem(String(i));
         }
         
         // month
         cbMonth.removeAll();
         for (i = 1; i <= 12; ++i)
         {
            str = NumberFormatter.addLeadingZero(i);
            cbMonth.addItem(NumberFormatter.addLeadingZero(i));
         }
         
         // day
         cbDay.removeAll();
         for (i = 1; i <= 31; ++i)
         {
            str = NumberFormatter.addLeadingZero(i);
            cbDay.addItem(NumberFormatter.addLeadingZero(i));
         }
         
         // handler
         cbYear.addEventListener(Event.CHANGE, onYearSelect);
         cbMonth.addEventListener(Event.CHANGE, onMonthSelect);
      }
      
      private function onRemove(e:Event):void
      {
         // handler
         cbYear.removeEventListener(Event.CHANGE, onYearSelect);
         cbMonth.removeEventListener(Event.CHANGE, onMonthSelect);
      }
      
      // ________________________________________________
      //                                   select handler
      
      private function onYearSelect(e:Event):void
      {
         // select Feb
         if(cbMonth.selectedIndex == 1)
         {
            if(int(cbYear.selectedIndex) % 4 == 0)
            {
               if(cbDay.length < 29)
               {
                  cbDay.addItem(String(29));
               }
            }
            else
            {
               if(cbDay.length > 28)
               {
                  cbDay.removeItemAt(cbDay.length - 1);
               }
            }
         }
         
         cbMonth.resetSelection();
         cbDay.resetSelection();
      }
      
      private function onMonthSelect(e:Event):void
      {
         var lastDay:int;
         
         switch(cbMonth.selectedIndex)
         {
            case 0: // 1
            case 2: // 3
            case 4: // 5
            case 6: // 7
            case 7: // 8
            case 9: // 10
            case 11: // 12
               lastDay = 31;
               break;
            case 1: // 2
               if(int(cbYear.selectedIndex) % 4 == 0)
               {
                  lastDay = 29;
               }
               else
               {
                  lastDay = 28;
               }
               break;
            case 3: // 4
            case 5: // 6
            case 8: // 9
            case 10: // 11
               lastDay = 30;
               break;
         }
         
         var off:int = lastDay - cbDay.length;
         if(off > 0)
         {
            for(var i:int = off; i > 0; --i)
            {
               cbDay.addItem(String(lastDay - i + 1));
            }
         }
         else if(off < 0)
         {
            for(var j:int = off; j < 0; ++j)
            {
               cbDay.removeItemAt(cbDay.length - 1);
            }
         }
         
         cbDay.resetSelection();
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}