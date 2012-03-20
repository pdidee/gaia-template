package _myui.form
{
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   
   /**
    * A URLRequest advanced builder.
    * @author boy, cjboy1984@gmail.com
    * @usage
    * private var reqb:ReqBuilder = new ReqBuilder();
    * // clean old data
    * reqb.removeVars();
    * // create new data
    * reqb.addGETVars('name', 'CJ'); // method:'GET'
    * reqb.addPOSTVars('abc', 123123123); // method:'POST'
    * // get URLRequest
    * urlLoader.load(reqb.build('http://www.test.com.tw/test.php'));
    */
   public class ReqBuilder
   {
      // server info
      protected var getData:Vector.<URLData>;
      protected var postData:Vector.<URLData>;
      
      public function ReqBuilder()
      {
      }
      
      // ________________________________________________
      //                                     URLVariables
      
      public function removeVars():void
      {
         getData = new Vector.<URLData>();
         postData = new Vector.<URLData>();
      }
      
      /**
       * Add a 'GET' parameter.
       */
      public function addGETVars($key:String, $value:*):void
      {
         for (var i:int = 0; i < getData.length; ++i) 
         {
            if (getData[i].key == $key)
            {
               getData[i].value = $value;
               return;
            }
         }

         var data:URLData = new URLData();
         data.key = $key;
         data.value = $value;
         getData.push(data);
      }
      
      /**
       * Add a 'POST' parameter.
       */
      public function addPOSTVars($key:String, $value:*):void
      {
         for (var i:int = 0; i < postData.length; ++i) 
         {
            if (postData[i].key == $key)
            {
               postData[i].value = $value;
               return;
            }
         }
         
         var data:URLData = new URLData();
         data.key = $key;
         data.value = $value;
         postData.push(data);
      }
      
      /**
       * Return a URLRequest object.
       * @param url
       * @param method     'auto', 'post', 'get'
       * @return 
       * 
       */
      public function build(url:String, method:String = 'auto'):URLRequest
      {
         var newURL:String = new String(url);
         
         // get var
         for (var i:int = 0; i < getData.length; ++i) 
         {
            if (i == 0)
            {
               newURL += '?' + getData[i].key + '=' + String(getData[i].value);
            }
            else
            {
               newURL += '&' + getData[i].key + '=' + String(getData[i].value);
            }
         }
         
         // post var
         var vars:URLVariables = new URLVariables();
         for each (var d:URLData in postData) 
         {
            vars[d.key] = d.value;
         }
         
         // req
         var req:URLRequest = new URLRequest();
         req.url = newURL;
         if (method == 'auto')
         {
            if (postData.length)
            {
               req.method = URLRequestMethod.POST;
               req.data = vars;
            }
         }
         else
         {
            if (method == 'post')
            {
               req.method = URLRequestMethod.POST;
               req.data = vars;
            }
            else if (method == 'get')
            {
               req.method = URLRequestMethod.GET;
            }
         }
         
         Trace2('{as} ReqBuilder | url = ' + newURL);
         
         return req;
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}

class URLData
{
   public var key:String;
   public var value:*;
   
   public function URLData() {}
}