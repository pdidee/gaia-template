package _facebook
{
   import _facebook.data.FBFriend;
   
   import com.facebook.graph.Facebook;
   
   import flash.system.Security;
   
   /**
    * 
    * @author cj, cjboy1984@gmail.com
    * 
    */   
   public class FBMgr
   {
      private const DOMAIN_FILE:String = 'crossdomain.xml';
      private var domainFilePool:Vector.<String> = new Vector.<String>();
      
      // info
      private var _app_key:String = '152204381520601';
      private var _perms:String = 'user_about_me';
      private var _access_token:String;
      private var _uid:String;
      private var _name:String;
      private var _username:String;
      private var _gender:String;
      private var _email:String;
      private var _pic_type:String;
      private var _pic_url_square:String;
      private var _pic_url_small:String;
      private var _pic_url_normal:String;
      private var _pic_url_large:String;
      
      // friend
      private var _fcount:int;
      private var _friends:Vector.<FBFriend>;
      
      // init callback
      private var initComplete:Function;
      // login callback
      private var loginComplete:Function;
      // friend callback
      private var friendComplete:Function;
      
      // singleton
      private static var _instance:FBMgr;
      
      public function FBMgr(pvt:PrivateClass)
      {
         // do nothing
      }
      
      // ________________________________________________
      //                                    get singleton
      
      public static function get api():FBMgr
      {
         if (!_instance)
         {
            _instance = new FBMgr(new PrivateClass());
         }
         
         return _instance;
      }
      
      // ________________________________________________
      //                                             init
      
      /**
       * Initialize facebook manager with a configuration.
       * @param
       * {
       *    fb_key:152204381520601,
       *    perms:'user_about_me,user_photos'
       * }
       */      
      public function init(param:Object = null, callbackFunc:Function = null):void
      {
         if (param)
         {
            if (param.hasOwnProperty('fb_key')) _app_key = new String(param.fb_key);
            if (param.hasOwnProperty('perms')) _perms = new String(param.perms);
         }
         Trace2('{as} FBMgr | init');
         Trace2('     app_key = ' + _app_key);
         Trace2('     perms = ' + _perms);
         initComplete = callbackFunc;
         
         Facebook.init(_app_key, onInitComplete);
      }
      
      // ________________________________________________
      //                                            login
      
      public function login(callback:Function = null):void
      {
         Trace2('{as} FBMgr | login');
         loginComplete = callback;
         
         // login > profile > picture url > picture
         Facebook.login(onLoginComplete, {scope:_perms});
      }
      
      private function getProfile():void
      {
         Trace2('{as} FBMgr | getProfile');
         Facebook.api('/me', getProfileComplete);
      }
      
      /**
       * Get url of profile picture.
       * @param type    square (50x50), small (50 pixels wide, variable height), normal (100 pixels wide, variable height), and large (about 200 pixels wide, variable height)
       */
      private function getProfilePhotoURL(type:String = 'square'):void
      {
         Trace2('{as} FBMgr | getProfilePhotoURL | type = ' + type);
         _pic_type = type;
         Facebook.api('/me?fields=picture&type=' + _pic_type + '&', getProfilePhotoURLComplete);
      }
      
      // ________________________________________________
      //                                           friend
      
      public function getFriends(callback:Function = null):void
      {
         Trace2('{as} FBMgr | getFriends');
         friendComplete = callback;
         
         Facebook.api('/me/friends', getFriendsComplete);
         // FB.api('/2012481?fields=picture,name,username,gender&type=square', function(success,fail){console.log('success = ',success);console.log('fail = ',fail);});
      }
      
      // ________________________________________________
      //                                          publish
      
      public function publishFeed_UI($link:String, callback:Function = null, $picture:String = '', $name:String = 'name', $caption:String = 'caption', $description:String = 'description'):void
      {
         var obj:Object = 
            {
               link:$link,
               picture:$picture,
               name:$name,
               caption:$caption,
               description:$description
            };
         Facebook.ui('feed', obj, onPublishFeed_UIComplete);
      }
      
      public function publishFeed_Sharer():void
      {
      }
      
      public function publishAppReq_UI(callback:Function = null):void
      {
         //         FB.ui({method: 'apprequests',
         //            message: 'XXXXXXXXXXXXXXXXXXXXX',
         //            to: '1533156624'
         //         }, function(res){});
      }
      
      public function publishPhoto(callback:Function = null):void
      {
      }
      
      // ________________________________________________
      //                                            album
      
      public function createAlbum(callback:Function = null):void
      {
      }
      
      // ________________________________________________
      //                                      information
      
      public function get isLogin():Boolean { return _uid != null; }
      public function get app_key():String { return _app_key; }
      public function get access_token():String { return ''; }
      public function get uid():String { return _uid; }
      public function get perms():String { return _perms; }
      public function get email():String { return _email; }
      public function get gender():String { return _gender; } // e.g. male
      public function get username():String { return _username; } // e.g. cjboy1984
      public function get name():String { return _name; } // e.g. Boy CJ
      public function get pic_url_square():String { return _pic_url_square; }
      public function get pic_url_small():String { return _pic_url_small; }
      public function get pic_url_normal():String { return _pic_url_normal; }
      public function get pic_url_large():String { return _pic_url_large; }
      public function get friends():Vector.<FBFriend> { return _friends; }
      
      // ________________________________________________
      //                                            utils
      
      /**
       * Looks for a policy file at the location specified by parsing the url.
       * @param url
       */
      public function tryLoadPolicy(url:String):void
      {
         var domain:String = new String(url);
         var buff:Array = domain.split('/');
         var domain_file:String = buff[0] + '//' + buff[2] + '/' + DOMAIN_FILE;
         
         if (domainFilePool.indexOf(domain_file) == -1)
         {
            domainFilePool.push(domain_file);
            
            Trace2('{as} FBMgr | tryToLoadPolicyFile | domain_file = ' + domain_file);
            Security.loadPolicyFile(domain_file);
         }
      }
      
      /**
       * Convert url of square to small.
       * @param url
       */
      public function square2Small(url:String):String
      {
         return url.split('_q.jpg')[0] + '_t.jpg';
      }
      
      /**
       * Convert url of square to normal.
       * @param url
       */
      public function square2Normal(url:String):String
      {
         return url.split('_q.jpg')[0] + '_s.jpg';
      }
      
      /**
       * Convert url of square to large.
       * @param url
       */
      public function square2Large(url:String):String
      {
         return url.split('_q.jpg')[0] + '_n.jpg';
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      private function onInitComplete(success:Object, fail:Object):void
      {
         if (success)
         {
            _uid = new String(success.uid);
            _access_token = new String(success.accessToken);
            
            Trace2('{as} FBMgr | onInitComplete | already login');
            Trace2('     uid = ' + _uid);
            Trace2('     access_token = ' + _access_token);
         }
         else
         {
            Trace2('{as} FBMgr | onInitComplete | not login yet');
         }
         
         // callback function
         if (initComplete as Function)
         {
            initComplete();
         }
      }
      
      private function onLoginComplete(success:Object, fail:Object):void
      {
         if (success)
         {
            if (!isLogin)
            {
               _uid = new String(success.uid);
               _access_token = new String(success.accessToken);
               
               Trace2('{as} FBMgr | onLoginComplete | success = ', success);
               Trace2('     uid = ' + _uid);
               Trace2('     access_token = ' + _access_token);
            }
            
            // next
            getProfile();
         }
         else
         {
            Trace2('{as} FBMgr | onLoginComplete | fail = ', fail);
         }
      }
      
      private function getProfileComplete(success:Object, fail:Object):void
      {
         if (success)
         {
            _name = new String(success.name);
            _username = new String(success.username);
            _gender = new String(success.gender);
            
            // optional
            if (success.hasOwnProperty('email')) _email = new String(success.email);
            
            Trace2('{as} FBMgr | getProfileComplete | success = ', success);
            Trace2('     name = ' + _name);
            Trace2('     username = ' + _username);
            Trace2('     gender = ' + _gender);
            Trace2('     email = ' + _email);
            
            // next
            getProfilePhotoURL();
         }
         else
         {
            Trace2('{as} FBMgr | getProfileComplete | fail = ', fail);
         }
      }
      
      private function getProfilePhotoURLComplete(success:Object, fail:Object):void
      {
         if (success)
         {
            Trace2('{as} FBMgr | getProfilePhotoURLComplete | success = ', success);
            switch(_pic_type)
            {
               case 'square':
                  _pic_url_square = new String(success.picture);
                  // replace https with http
                  //                  _pic_url_square = _pic_url_square.replace('https', 'http'); // replace https with http
                  tryLoadPolicy(_pic_url_square); // security
                  break;
               case 'small':
                  _pic_url_small = new String(success.picture); // security
                  // replace https with http
                  //                  _pic_url_small = _pic_url_small.replace('https', 'http'); // replace https with http
                  tryLoadPolicy(_pic_url_small);
                  break;
               case 'normal':
                  _pic_url_normal = new String(success.picture); // security
                  // replace https with http
                  //                  _pic_url_normal = _pic_url_normal.replace('https', 'http'); // replace https with http
                  tryLoadPolicy(_pic_url_normal); // security
                  break;
               case 'large':
                  _pic_url_large = new String(success.picture);
                  //                  _pic_url_large = _pic_url_large.replace('https', 'http'); // replace https with http
                  tryLoadPolicy(_pic_url_large); // security
                  break;
            }
         }
         else
         {
            Trace2('{as} FBMgr | getProfilePhotoComplete | fail = ', fail);
         }
         
         // callback function
         if (loginComplete as Function)
         {
            loginComplete();
         }
      }
      
      private function getFriendsComplete(success:Object, fail:Object):void
      {
         if (success)
         {
            Trace2('{as} FBMgr | getFriendsComplete | success = ', success);
            
            var fArr:Array = success as Array;
            _friends = new Vector.<FBFriend>();
            while (fArr.length)
            {
               var f:Object = fArr.pop();
               _friends.push(new FBFriend(f.id));
            }
            
            // get further info
            _fcount = 0;
            for (var i:int = 0; i < _friends.length; ++i) 
            {
               _friends[i].getFurtherInfo(getFriendFurtherInfo);
            }
         }
         else
         {
            Trace2('{as} FBMgr | getFriendsComplete | fail = ', fail);
         }
      }
      
      private function getFriendFurtherInfo():void
      {
         if (++_fcount == _friends.length)
         {
            Trace2('{as} getFriendFurtherInfo | friends = ', friends);
            if (friendComplete as Function)
            {
               friendComplete();
            }
         }
      }
      
      private function onPublishFeed_UIComplete():void
      {
         
      }
      
      // --------------------- LINE ---------------------
      
   }
   
}

class PrivateClass
{
   function PrivateClass() {}
}
