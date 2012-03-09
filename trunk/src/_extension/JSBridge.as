package _extension
{
   import flash.external.ExternalInterface;
   
   /**
    * Class that wraps javascript code for communicating with Javascript.
    * @usage
    * // {as}
    * JSBridge.init();
    * // {js}
    * as.getSwf().callbackFunction();
    */
   public class JSBridge
   {
      public static const NS:String = "as";
      
      public function JSBridge(pvt:PrivateClass)
      {
      }
      
      public static function init():void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call(script_js);	
            
            /*Get a reference to the embedded SWF (object/embed tag). Note that Chrome/Mozilla Browsers get the 'name' attribute whereas IE uses the 'id' attribute. 
            This is important to note, since it relies on how you embed the SWF. In the examples, we embed using swfObject and we have to set the attribute 'name' the 
            same as the id.*/
            ExternalInterface.call("as.setSWFObjectID", ExternalInterface.objectID);
         }
      }
      
      private static const script_js:XML =
         <script>
            <![CDATA[
               function()
               {
                  as = 
                  {
                     setSWFObjectID:function(swfObjectID)
                     {
                        as.swfObjectID = swfObjectID;
                     },

                     getSwf:function getSwf()
                     {								
                        return document.getElementById(as.swfObjectID);								
                     },
                  };
               }
            ]]>
         </script>;
      
      // --------------------- LINE ---------------------
      
   }
   
}

class PrivateClass
{
   function PrivateClass() {}
}