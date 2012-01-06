package _myui.form
{
   import fl.controls.ComboBox;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.ByteArray;
   
   /**
    * A address selector based on fl-components with combobox style.
    * @author boy, cjboy1984@gmail.com
    * @usage
    * // Set base-class as BDayComboBox, and make sure there are cbAddr1 and cbAddr2 comboboxes.
    * // fla
    * public var addrSelector:TaiwanAddrSelector;
    * trace(addrSelector.value);
    */
   public class TaiwanAddrSelector extends MovieClip
   {
      // xml
      [Embed(source = './TaiwanAddr.xml', mimeType = 'application/octet-stream')]
      public static const TaiwanAddr:Class;
      
      // fla
      public var cbAddr1:ComboBox;
      public var cbAddr2:ComboBox;
      
      // xml
      private var xml:XML;
      
      /// constructor
      public function TaiwanAddrSelector()
      {
         stop();
         
         // disable tab
         tabEnabled = false;
         tabChildren = false;
         
         // create xml
         var file:ByteArray = new TaiwanAddr();
         var str:String = file.readUTFBytes(file.length);
         xml = new XML(str);
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                             main
      
      public function get value():String
      {
         // check
         if (cbAddr1.selectedIndex == -1) cbAddr1.selectedIndex = 0;
         if (cbAddr2.selectedIndex == -1) cbAddr2.selectedIndex = 0;
         
         var i:int = cbAddr1.selectedIndex;
         var j:int = cbAddr2.selectedIndex;
         var post:String = xml.addr[i].addr[j].@post;
         var ret:String = new String(post + ' ' +
            cbAddr1.selectedLabel + ' ' +
            cbAddr2.selectedLabel
         );
         
         return ret;
      }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
         initAddrCBox();
      }
      
      protected function onRemove(e:Event):void
      {
         cbAddr1.removeEventListener(Event.CHANGE, onAddr1Change);
      }
      
      // ________________________________________________
      //                                             init
      
      protected function initAddrCBox():void
      {
         // disable tab
         cbAddr1.tabEnabled = false;
         cbAddr2.tabEnabled = false;
         
         // init addr 1
         cbAddr1.removeAll();
         var len:int = xml.addr.length();
         for(var i:int = 0; i < len; ++i)
         {
            cbAddr1.addItem({label:xml.addr[i].@label});
         }
         cbAddr1.selectedIndex = 0;
         cbAddr1.addEventListener(Event.CHANGE, onAddr1Change);
         
         // init addr 2
         cbAddr2.removeAll();
         len = xml.addr[0].addr.length();
         for(i = 0; i < len; ++i)
         {
            cbAddr2.addItem({label:xml.addr[0].addr[i]});
         }
         cbAddr2.selectedIndex = 0;
      }
      
      // ________________________________________________
      //                                          handler
      
      protected function onAddr1Change(e:Event):void
      {
         var select:XML = xml.addr[cbAddr1.selectedIndex];
         var len:int = select.addr.length();
         
         // set cbAddr2
         cbAddr2.removeAll();
         for(var i:int = 0; i < len; ++i)
         {
            cbAddr2.addItem({label:select.addr[i]});
         }
         cbAddr2.selectedIndex = 0;
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}