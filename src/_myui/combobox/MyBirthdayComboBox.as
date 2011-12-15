package _myui.combobox
{
   import fl.controls.ComboBox;
   
   import flash.display.MovieClip;
   import flash.events.Event;

   /**
    * @author   cjboy1984
    */
   public class MyBirthdayComboBox extends MovieClip
   {
      // fla
      public var cbYear:ComboBox;
      public var cbMonth:ComboBox;
      public var cbDay:ComboBox;

      /* constructor */
      public function MyBirthdayComboBox()
      {
         stop();

         // disable tab
         tabEnabled = false;
         tabChildren = false;

         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }

      // ------------------ LINE -------------------

      public function get value():String
      {
         return cbYear.selectedLabel + '/' + cbMonth.selectedLabel + '/' + cbDay.selectedLabel;
      }

      // ################ Protected ################

      // ################# Private #################

      private function onAdd(e:Event):void
      {
         initCBoxContent();

         cbYear.addEventListener(Event.CHANGE, onYearSelect);
         cbMonth.addEventListener(Event.CHANGE, onMonthSelect);
      }

      private function onRemove(e:Event):void
      {
         cbYear.removeEventListener(Event.CHANGE, onYearSelect);
         cbMonth.removeEventListener(Event.CHANGE, onMonthSelect);
      }

      // ------------------ LINE -------------------

      private function initCBoxContent():void
      {
         // disable tab
         cbYear.tabEnabled = false;
         cbMonth.tabEnabled = false;
         cbDay.tabEnabled = false;

         var date:Date = new Date();
         var year:Number = date.getFullYear();

         // year
         cbYear.removeAll();
         for (var i:int = 1911; i <= year; ++i)
         {
            cbYear.addItem({label:i});
         }

         // month
         cbMonth.removeAll();
         for (i = 1; i <= 12; ++i)
         {
            cbMonth.addItem({label:i});
         }

         // day
         cbDay.removeAll();
         for (i = 1; i <= 31; ++i)
         {
            cbDay.addItem({label:i});
         }
      }

      // ------------------ LINE -------------------

      private function onYearSelect(e:Event):void
      {
         // select Feb
         if(cbMonth.selectedIndex == 1)
         {
            if(int(cbYear.selectedLabel) % 4 == 0)
            {
               if(cbDay.length < 29)
               {
                  cbDay.addItem({label:29});
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
               if(int(cbYear.selectedLabel) % 4 == 0)
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
               cbDay.addItem({label:(lastDay - i + 1)});
            }
         }
         else if(off < 0)
         {
            for(var j:int = off; j < 0; ++j)
            {
               cbDay.removeItemAt(cbDay.length - 1);
            }
         }
      }

      // ------------------ LINE -------------------

   }

}