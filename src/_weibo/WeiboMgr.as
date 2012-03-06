package _weibo
{
   import _weibo.data.WeiboFriend;
   
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.system.Security;
   import flash.utils.Timer;
   
   /**
    * A social networking class based on Weibo api.
    * @author boy, cjboy1984@gmail.com
    * @dependency: boy/wbAPI.js
    * @usage
    * // flashVars
    * var param:Object = stage.loaderInfo.parameters;
    * // init
    * WeiboMgr.api.init();
    * // login
    * WeiboMgr.api.login(onLoginComplete);
    */
   public class WeiboMgr
   {
      // singleton
      private static var _instance:WeiboMgr;
      
      // info
      private var _app_key:String;
      private var _app_secret:String;
      private var _uid:String;
      private var _name:String;
      private var _screen_name:String;
      private var _gender:String;
      private var _friends:Vector.<WeiboFriend>;
      
      // login
      private var loginComplete:Function;
      private var loginErr:Function;
      
      // friends
      private var getFriendsComplete:Function;
      
      // post
      private var postComplete:Function;
      
      // retry timer
      private var retryTimer:Timer = new Timer(45000, 1);
      
      public function WeiboMgr(pvt:PrivateClass)
      {
         // do nothing
      }
      
      // ________________________________________________
      //                                    get singleton
      
      public static function get api():WeiboMgr
      {
         if (!_instance)
         {
            _instance = new WeiboMgr(new PrivateClass());
         }
         
         return _instance;
      }
      
      // ________________________________________________
      //                                             init
      
      public function init():void
      {
         // security
         Security.allowDomain('*');
         
         // js callback
         Trace2("{as} WeiboMgr | init");
         ExternalInterface.addCallback('setInfo', setInfo);
         
         ExternalInterface.addCallback('onLoginErr', onLoginErr);
         ExternalInterface.addCallback('onLoginComplete', onLoginComplete);
         
         ExternalInterface.addCallback('onGetFriendsComplete', onGetFriendsComplete);
         
         ExternalInterface.addCallback('onPostComplete', onPostComplete);
         
         // test
         ExternalInterface.addCallback('wbTest', wbTest);
      }
      
      // ________________________________________________
      //                                            login
      
      public function isLogin():Boolean
      {
         Trace2('{as} WeiboMgr | isLogin = ' + String(uid != null));
         return uid != null;
      }
      
      /**
       * Weibo login.
       */
      public function login(completeHandler:Function = null, errHandler:Function = null):void
      {
         loginComplete = completeHandler;
         loginErr = errHandler;
         
         ExternalInterface.call('wbLogin');
         
         // retry
         Trace2('{as} WeiboMgr | setup retry timer...');
         retryTimer.stop();
         retryTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, retryLogin);
         retryTimer.addEventListener(TimerEvent.TIMER_COMPLETE, retryLogin);
         retryTimer.reset();
         retryTimer.start();
      }
      
      public function logout():void
      {
         ExternalInterface.call('WB2.logout()');
         
         _uid = null;
         _name = null;
         _screen_name = null;
         _gender = null;
         _friends = null;
      }
      
      // ________________________________________________
      //                                          Friends
      
      public function getFriends(completeHandler:Function = null):void
      {
         getFriendsComplete = completeHandler;
         
         ExternalInterface.call('wbGetFriends');
      }
      
      // ________________________________________________
      //                                             Post
      
      public function submitPost(txt:String, completeHandler:Function = null):void
      {
         postComplete = completeHandler;
         
         ExternalInterface.call('wbSubmitPost', txt);
      }
      
      // ________________________________________________
      //                                      Information
      
      public function get app_secret():String { return _app_secret; }
      public function get app_key():String { return _app_key; }
      public function get uid():String { return _uid; }
      public function get name():String { return _name; }
      public function get screen_name():String { return _screen_name; }
      public function get gender():String { return _gender; }
      public function get friends():Vector.<WeiboFriend> { return _friends; }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      // ________________________________________________
      //                                            login
      
      private function onLoginComplete(data:Object):void
      {
         Trace2('{as} WeiboMgr | onLoginComplete');
         
         // retry
         retryTimer.stop();
         retryTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, retryLogin);
         
         // info
         _uid = new String(data['id']);
         _name = new String(data['name']);
         _screen_name = new String(data['screen_name']);
         _gender = new String(data['gender']);
         Trace2('uid =', _uid);
         Trace2('name =', _name);
         Trace2('screen_name =', _screen_name);
         Trace2('gender =', _gender);
         
         if (loginComplete as Function)
         {
            loginComplete();
         }
      }
      
      private function onLoginErr():void
      {
         Trace2('{as} WeiboMgr | onLoginErr');
         
         // retry
         retryTimer.stop();
         retryTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, retryLogin);
         
         if (loginErr as Function)
         {
            loginErr();
         }
      }
      
      private function setInfo($key:String, $secret:String):void
      {
         _app_key = $key;
         _app_secret = $secret;
         
         Trace2('{as} WeiboMgr | setInfo');
         Trace2('     app_key = ' + app_key);
         Trace2('     app_secret = ' + app_secret);
      }
      
      private function retryLogin(e:TimerEvent):void
      {
         ExternalInterface.call('wbLogin');
         
         // retry
         retryTimer.stop();
         retryTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, retryLogin);
         retryTimer.addEventListener(TimerEvent.TIMER_COMPLETE, retryLogin);
         retryTimer.reset();
         retryTimer.start();
      }
      
      // ________________________________________________
      //                                           friend
      
      private function onGetFriendsComplete(data:Object):void
      {
         _friends = new Vector.<WeiboFriend>();
         for each (var i:Object in data) 
         {
            var fr:WeiboFriend = new WeiboFriend(i['id'], i['name'], i['screen_name'], i['gender'], i['profile_image_url']);
            _friends.push(fr);
         }
         
         if (getFriendsComplete as Function)
         {
            getFriendsComplete();
         }
      }
      
      // ________________________________________________
      //                                             post
      
      private function onPostComplete(data:Object):void
      {
         if (postComplete as Function)
         {
            postComplete();
         }
      }
      
      // ________________________________________________
      //                                             test
      
      private function wbTest():void
      {
         Trace2('{as} Flash test message!!!');
      }
      
      // --------------------- LINE ---------------------
      
   }
   
}

class PrivateClass
{
   function PrivateClass() {}
}