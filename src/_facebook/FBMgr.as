package _facebook
{
   import _facebook.data.FBAlbum;
   import _facebook.data.FBFriend;
   
   import com.facebook.graph.Facebook;
   
   import flash.display.BitmapData;
   import flash.external.ExternalInterface;
   import flash.system.Security;
   
   /**
    * 
    * @author cj, cjboy1984@gmail.com
    * 
    */   
   public class FBMgr
   {
      private const DOMAIN_FILE:String = 'crossdomain.xml';
      // must be one of "popup", "dialog", "iframe", "touch", "async", "hidden", or "none"
      private const DISPLAY:String = 'iframe';
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
      private var _albums:Vector.<FBAlbum> = new Vector.<FBAlbum>();
      private var _photo_ids:Array = new Array();
      private var _latest_aid:String; // album id
      private var _latest_appreq_id:String; // appreq id
      
      // friend
      private var _fcount:int;
      private var _friends:Vector.<FBFriend>;
      
      // init callback
      private var initComplete:Function;
      // login callback
      private var loginComplete:Function;
      // friend callback
      private var friendComplete:Function;
      // album callback
      private var albumComplete1:Function; // load
      private var albumComplete2:Function; // create
      // photo callback
      private var photoComplete:Function;
      // appreq callback
      private var appreqUIComplete:Function;
      
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
         // js callback
         if (ExternalInterface.available)
         {
            ExternalInterface.addCallback('findFriends', findFriends);
         }
         
         if (param)
         {
            if (param.hasOwnProperty('fb_key')) _app_key = new String(param.fb_key);
            if (param.hasOwnProperty('perms')) _perms = new String(param.perms);
         }
         Trace2('{as} FBMgr | init');
         Trace2('     app_key = ' + _app_key);
         Trace2('     perms = ' + _perms);
         initComplete = callbackFunc;
         
         var options:Object = 
            {
               frictionlessRequests:true
            };
         Facebook.init(_app_key, onInitComplete, options);
      }
      
      public function stop():void
      {
         initComplete = null;
         loginComplete = null;
         friendComplete = null;
         albumComplete1 = null;
         albumComplete2 = null;
         photoComplete = null;
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
         Facebook.api('/me', onGetProfileComplete);
      }
      
      /**
       * Get url of profile picture.
       * @param type    square (50x50), small (50 pixels wide, variable height), normal (100 pixels wide, variable height), and large (about 200 pixels wide, variable height)
       */
      private function getProfilePhotoURL(type:String = 'square'):void
      {
         Trace2('{as} FBMgr | getProfilePhotoURL | type = ' + type);
         _pic_type = type;
         Facebook.api('/me?fields=picture&type=' + _pic_type + '&', onGetProfilePhotoURLComplete);
      }
      
      // ________________________________________________
      //                                           friend
      
      public function getFriends(callback:Function = null):void
      {
         Trace2('{as} FBMgr | getFriends');
         friendComplete = callback;
         
         Facebook.api('/me/friends', onGetFriendsComplete);
      }
      
      public function findFriends(keyWord:String):Vector.<FBFriend>
      {
         if (friends)
         {
            var ret:Vector.<FBFriend> = new Vector.<FBFriend>();
            for each (var i:FBFriend in friends) 
            {
               if (i.name.search(keyWord) != -1 || i.username.search(keyWord) != -1)
               {
                  ret.push(i);
               }
            }
            Trace2('{as} FBMgr | findFriends | result = ', ret);
            return ret;
         }
         else
         {
            Trace2('{as} FBMgr | findFriends | no friends');
            return null;
         }
      }
      
      // ________________________________________________
      //                                          publish
      
      public function postFeed_Link_UI($link:String, callback:Function = null, $picture:String = '', $name:String = 'name', $caption:String = 'caption', $description:String = 'description'):void
      {
         Trace2('{as} FBMgr | postFeed_Link_UI');
         var obj:Object = 
            {
               link:$link,
               picture:$picture,
               name:$name,
               caption:$caption,
               description:$description
            };
         Facebook.ui('feed', obj, onPublishFeed_UIComplete, DISPLAY);
      }
      
      public function postFeed_Link($link:String, callback:Function = null, $picture:String = '', $name:String = 'name', $caption:String = 'caption', $description:String = 'description'):void
      {
         //var obj = 
         //{
         //message:'test with 洪毓翔, Erikson Chen',
         //message_tags:{id:'1652211998',offset:10,length:4},
         //caption:'caption',
         //description:"description<center/>description<center/>http://www.google.com",
         //link:'http://dl.dropbox.com/u/3587501/httpdoc/index.html',
         //picture:'http://dl.dropbox.com/u/3587501/httpdoc/pic.jpg'
         //}
         //FB.api('/me/feed', 'POST', obj, function(a){console.log('a = ', a);});
      }
      
      public function postFeed_Link_Sharer():void
      {
      }
      
      /**
       * To send a request to a single user you will need to invoke the Request Dialog with the to parameter and use it to include the User ID of the recipient user. But "App Namespace" and "Canvas URL" are necessary configurations.
       * @param message
       * @param to_ids
       * @param callback
       */
      public function postAppreq_UI(message:String, to_ids:Array, callback:Function = null):void
      {
         Trace2('{as} FBMgr | postAppreq_UI');
         appreqUIComplete = callback;
         
         var ids:String = '';
         for (var i:int = 0; i < to_ids.length; ++i) 
         {
            ids += to_ids[i];
            if (i != to_ids.length-1) ids += ',';
         }
         Trace2('ids = ' + ids.toString());
         var data:Object = 
            {
               message:message,
               to:ids
            };
         Facebook.ui('apprequests', data, onPostAppreq_UIComplete, DISPLAY);
      }
      
      // ________________________________________________
      //                                            album
      
      public function getAlbums(callback:Function = null):void
      {
         Trace2('{as} FBMgr | getAlbums');
         albumComplete1 = callback;
         
         Facebook.api('/me/albums', onGetAlbumsComplete, null, 'GET');
      }
      
      /**
       * Create a album by $name and you can get latest_aid aatribute.
       * @param $name      The title of the album.
       * @param $message   Album description.
       * @param callback
       */
      public function createAlbum($name:String, $message:String = '', callback:Function = null):void
      {
         albumComplete2 = callback;
         
         var create:Boolean = true;
         for each (var a:FBAlbum in _albums) 
         {
            if (a.name.search($name) != -1)
            {
               create = false;
               _latest_aid = new String(a.id);
               break;
            }
         }
         Trace2('{as} FBMgr | createAlbum | create = ' + create.toString());
         
         if (create)
         {
            // add
            var newAlbum:FBAlbum = new FBAlbum();
            newAlbum.name = $name;
            _albums.push(newAlbum);
            
            var obj:Object = 
               {
                  name:$name,
                  message:$message
               };
            _latest_aid = null;
            Facebook.api('/me/albums', onCreateAlbumComplete, obj, 'POST');
         }
         else
         {
            // callback
            if (albumComplete2 as Function)
            {
               albumComplete2();
            }
         }
      }
      
      public function postPhoto(album_id:String, message:String, image:BitmapData, callback:Function = null):void
      {
         Trace2('{as} FBMgr | postPhoto');
         photoComplete = callback;
         
         var obj:Object = 
            {
               message:message,
               file:image,
               fileName:'test'
            };
         Facebook.api('/' + album_id + '/photos', onPostPhotoComplete, obj, 'POST');
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
      public function get albums():Vector.<FBAlbum> { return _albums; }
      public function get photo_ids():Array { return _photo_ids; }
      
      public function get latest_aid():String { return _latest_aid; }
      public function get latest_appreq_id():String { return _latest_appreq_id; }
      
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
      
      public function sortFriends():void
      {
         _friends.sort(mySorter);
         
         function mySorter(a:*, b:*):int
         {
            if (a.name.substr(0,1) > b.name.substr(0,1))
            {
               return 1;
            }
            else if (a.name.substr(0,1) < b.name.substr(0,1))
            {
               return -1;
            }
            else
            {
               return 0;
            }
         }
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
      
      private function onGetProfileComplete(success:Object, fail:Object):void
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
      
      private function onGetProfilePhotoURLComplete(success:Object, fail:Object):void
      {
         if (success)
         {
            Trace2('{as} FBMgr | getProfilePhotoURLComplete | success = ', success);
            switch(_pic_type)
            {
               case 'square':
                  _pic_url_square = new String(success.picture);
                  tryLoadPolicy(_pic_url_square); // security
                  break;
               case 'small':
                  _pic_url_small = new String(success.picture); // security
                  tryLoadPolicy(_pic_url_small);
                  break;
               case 'normal':
                  _pic_url_normal = new String(success.picture); // security
                  tryLoadPolicy(_pic_url_normal); // security
                  break;
               case 'large':
                  _pic_url_large = new String(success.picture);
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
      
      private function onGetFriendsComplete(success:Object, fail:Object):void
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
               _friends[i].getFurtherInfo(onGetFriendFurtherInfo);
            }
         }
         else
         {
            Trace2('{as} FBMgr | getFriendsComplete | fail = ', fail);
         }
      }
      
      private function onGetFriendFurtherInfo():void
      {
         if (++_fcount == _friends.length)
         {
            sortFriends();
            
            Trace2('{as} getFriendFurtherInfo | friends = ', friends);
            if (friendComplete as Function)
            {
               friendComplete();
            }
         }
      }
      
      private function onGetAlbumsComplete(success:Object, fail:Object):void
      {
         if (success)
         {
            Trace2('{as} FBMgr | onGetAlbumsComplete | success = ', success);
            _albums = new Vector.<FBAlbum>();
            var arr:Array = success as Array;
            for each (var a:Object in arr) 
            {
               _albums.push(new FBAlbum(a));
            }
         }
         else
         {
            Trace2('{as} FBMgr | onGetAlbumsComplete | fail = ', fail);
         }
         
         // callback function
         if (albumComplete1 as Function)
         {
            albumComplete1();
         }
      }
      
      private function onCreateAlbumComplete(success:Object, fail:Object):void
      {
         if (success)
         {
            Trace2('{as} FBMgr | onCreateAlbumComplete | success = ', success);
            var a:FBAlbum = _albums[_albums.length-1];
            a.id = new String(success.id);
            
            _latest_aid = new String(success.id);
         }
         else
         {
            Trace2('{as} FBMgr | onCreateAlbumComplete | fail = ', fail);
         }
         
         // callback function
         if (albumComplete2 as Function)
         {
            albumComplete2();
         }
      }
      
      private function onPostPhotoComplete(success:Object, fail:Object):void
      {
         if (success)
         {
            Trace2('{as} FBMgr | onPostPhotoComplete | success = ', success);
         }
         else
         {
            Trace2('{as} FBMgr | onPostPhotoComplete | fail = ', fail);
         }
         
         // callback function
         if (albumComplete2 as Function)
         {
            albumComplete2();
         }
      }
      
      private function onPublishFeed_UIComplete():void
      {
      }
      
      private function onPostAppreq_UIComplete(res:Object):void
      {
         if (res)
         {
            _latest_appreq_id = new String(res.request);
         }
         
         // callback function
         if (appreqUIComplete as Function)
         {
            appreqUIComplete();
         }
      }
      
      // --------------------- LINE ---------------------
      
   }
   
}

class PrivateClass
{
   function PrivateClass() {}
}
