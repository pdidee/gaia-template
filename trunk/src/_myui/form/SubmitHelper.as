package _myui.form
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   
   /**
    * A usr-info helper including upload(GET/POST) data. 
    * @author boy, cjboy1984@gmail.com
    * @usage
    * var submit:SubmitHelper = new SubmitHelper('http://123.com/submit.php', onDataSended, null);
    * submit.addGETVars('name', 'David');
    * submit.addPOSTVars('img', img_ba);
    * submit.send();
    * 
    * protected function onDataSended(e:Event):void
    * {
    *    // json string
    *    var data:Object = JSON.decode(String(submit.data));
    * }
    */   
   public class SubmitHelper extends EventDispatcher
   {
      // server info
      protected var url:String;
      protected var getIDs:Vector.<String>;
      protected var getIDValues:Vector.<String>;
      protected var postIDs:Array;
      protected var postIDValues:Array;
      
      // loader
      protected var canSubmit:Boolean;
      protected var urlLoader:URLLoader;
      protected var urlVar:URLVariables;
      
      // handler
      protected var onCompleteFunc:Function;
      protected var onIOErrFunc:Function;
      
      // return data
      protected var returnData:*;
      
      public function SubmitHelper($url:String, onComplete:Function = null, onIOErr:Function = null)
      {
         canSubmit = true;
         url = $url;
         
         getIDs = new Vector.<String>();
         getIDValues = new Vector.<String>();
         
         postIDs = new Array();
         postIDValues = new Array();
         
         onCompleteFunc = onComplete;
         onIOErrFunc = onIOErr;
         
         // vars
         urlVar = new URLVariables();
         // loader
         urlLoader = new URLLoader();
         urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOErr);
         urlLoader.addEventListener(Event.COMPLETE, onDataSended);
      }
      
      // ________________________________________________
      //                                     URLVariables
      
      public function clearVars():void
      {
         getIDs = new Vector.<String>();
         getIDValues = new Vector.<String>();
         
         postIDs = new Array();
         postIDValues = new Array();
      }
      
      /**
       * Add a 'GET' parameter.
       */
      public function addGETVars($key:String, $value:*):void
      {
         var no:int = getIDs.indexOf($key);
         if (no == -1)
         {
            getIDs.push($key);
            getIDValues.push(String($value));
         }
         else
         {
            getIDs[no] = $key;
            getIDValues[no] = String($value);
         }
      }
      
      /**
       * Add a 'POST' parameter.
       */
      public function addPOSTVars($key:String, $value:*):void
      {
         var no:int = postIDs.indexOf($key);
         if (no == -1)
         {
            postIDs.push($key);
            postIDValues.push($value);
         }
         else
         {
            postIDs[no] = $key;
            postIDValues[no] = $value;
         }
      }
      
      // ________________________________________________
      //                                             load
      
      public function send():void
      {
         var newURL:String = new String(url);
         
         // get var
         for (var i:int = 0; i < getIDs.length; ++i) 
         {
            if (i == 0)
            {
               newURL += '?' + getIDs[i] + '=' + getIDValues[i];
            }
            else
            {
               newURL += '&' + getIDs[i] + '=' + getIDValues[i];
            }
         }
         
         // post var
         urlVar = new URLVariables();
         for each (var key:* in postIDs) 
         {
            var no:int = postIDs.indexOf(key);
            urlVar[key] = postIDValues[no];
         }
         
         // req
         var urlReq:URLRequest = new URLRequest();
         urlReq.url = newURL;
         urlReq.method = URLRequestMethod.POST;
         urlReq.data = urlVar;
         
         if (canSubmit)
         {
            trace("SubmitHelper.send | urlReq.url =", urlReq.url);
            
            canSubmit = false;
            //            urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
            urlLoader.load(urlReq);
         }
      }
      
      public function dispose():void
      {
         // loader
         if (!canSubmit)
         {
            urlLoader.close();
         }
         
         // var
         clearVars();
      }
      
      // ________________________________________________
      //                                      Return data
      
      /**
       * The return data.
       */
      public function get data():* { return returnData; }
      
      // ################### protected ##################
      
      // ________________________________________________
      //                                URLLoader handler
      
      protected function onIOErr(e:IOErrorEvent):void
      {
         canSubmit = true;
         
         // callback
         if (onIOErrFunc as Function)
         {
            onIOErrFunc(e);
         }
      }
      
      protected function onDataSended(e:Event):void
      {
         canSubmit = true;
         
         returnData = urlLoader.data;
         
         // callback
         if (onCompleteFunc as Function)
         {
            onCompleteFunc(e);
         }
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}