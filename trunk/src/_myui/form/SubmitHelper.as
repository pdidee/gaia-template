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
    * var form:SubmitHelper = new SubmitHelper('http://123.com/submit.php', onDataSended, null);
    * form.addVar('name', 'David', URLRequestMethod.GET);
    * form.send();
    */   
   public class SubmitHelper extends EventDispatcher
   {
      // server info
      protected var url:String;
      protected var getIDs:Vector.<String>;
      protected var getIDValues:Vector.<String>;
      
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
         
         onCompleteFunc = onComplete;
         onIOErrFunc = onIOErr;
         
         // vars
         urlVar = new URLVariables();
         // loader
         urlLoader = new URLLoader();
         urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOErr);
         urlLoader.addEventListener(Event.COMPLETE, onDataSended);
         urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
      }
      
      // ________________________________________________
      //                                     URLVariables
      
      public function clearVars():void
      {
         getIDs = new Vector.<String>();
         getIDValues = new Vector.<String>();
      }
      
      public function addVar($id:String, $value:String, $method:String = URLRequestMethod.GET):void
      {
         switch($method)
         {
            case URLRequestMethod.GET:
               var no:int = getIDs.indexOf($id);
               if (no == -1)
               {
                  getIDs.push($id);
                  getIDValues.push($value);
               }
               else
               {
                  getIDs[no] = $id;
                  getIDValues[no] = $value;
               }
               break;
            case URLRequestMethod.POST:
               urlVar[$id] = $value;
               break;
         }
      }
      
      // ________________________________________________
      //                                             load
      
      public function send():void
      {
         var _url:String = new String(url);
         
         // get
         for (var i:int = 0; i < getIDs.length; ++i) 
         {
            if (i == 0)
            {
               _url += '?' + getIDs[i] + '=' + getIDValues[i];
            }
            else
            {
               _url += '&' + getIDs[i] + '=' + getIDValues[i];
            }
         }
         trace("url =", url);
         
         var urlReq:URLRequest = new URLRequest(url);
         urlReq.method = URLRequestMethod.POST;
         
         if (canSubmit)
         {
            canSubmit = false;
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