package _facebook
{
   import _facebook.data.FBAlbum;
   import _facebook.data.FBFriend;
   
   import com.facebook.graph.Facebook;
   
   import flash.display.BitmapData;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
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
      public var appKey:String = '152204381520601';
      public var perms:String = 'user_about_me';
      public var accessToken:String;
      public var uid:String;
      public var name:String;
      public var username:String;
      public var gender:String;
      public var email:String;
      public var picUrl_square:String;
      public var picUrl_small:String;
      public var picUrl_normal:String;
      public var picUrl_large:String;
      
      public var friendPool:Vector.<FBFriend>;
      public var albumPool:Vector.<FBAlbum>;
      public var returnId:String; // photo id, request id, ...
      
      public function get isLogin():Boolean { return uid != null; }
      
      // album
      private var albumName:String = '';
      private var albumMsg:String = '';
      private var wantedAlbumNo:int = -1;
      
      // init callback
      private var callbackFunc:Function;
      
      // singleton
      private static var _instance:FBMgr;
      
      public function FBMgr(pvt:PrivateClass)
      {
         // do nothing
      }
      
      // ________________________________________________
      //                                             init
      
      /**
       * init > get album > create album
       * @param param         {fb_key:152204381520601,perms:'user_about_me,user_photos'}
       * @param callback
       */
      public function init(param:Object = null, callback:Function = null):void
      {
         // js callback
         if (ExternalInterface.available)
         {
            ExternalInterface.addCallback('findFriends', findFriends);
         }
         
         if (param)
         {
            if (param.hasOwnProperty('fb_key')) appKey = new String(param.fb_key);
            if (param.hasOwnProperty('perms')) perms = new String(param.perms);
         }
         Trace2('{as} FBMgr | init');
         Trace2('     app_key = ' + appKey);
         Trace2('     perms = ' + perms);
         
         callbackFunc = callback;
         
         var options:Object = 
            {
               frictionlessRequests:true
            };
         Facebook.init(appKey, onInit_1, options);
      }
      
      // ________________________________________________
      //                                            login
      
      /**
       * login > get profile > get profile photo > get album > create album
       * @param callback
       */
      public function login1(callback:Function = null):void
      {
         Trace2('{as} FBMgr | login');
         callbackFunc = callback;
         
         // login > profile > picture url
         Facebook.login(onLogin1_1, {scope:perms});
      }
      
      // ________________________________________________
      //                                           friend
      
      public function getFriends(callback:Function = null):void
      {
         Trace2('{as} FBMgr | getFriends');
         callbackFunc = callback;
         
         Facebook.api('/me/friends', onGetFriends);
      }
      
      public function findFriends(keyWord:String):Vector.<FBFriend>
      {
         if (friendPool)
         {
            var ret:Vector.<FBFriend> = new Vector.<FBFriend>();
            for each (var i:FBFriend in friendPool) 
            {
               if (i.name.search(keyWord) != -1)
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
      
      // todo
      public function postFeed_Link_UI($link:String, $picture:String = '', $name:String = 'name', $caption:String = 'caption', $description:String = 'description', callback:Function = null):void
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
         Facebook.ui('feed', obj, onPublishFeed_UI, DISPLAY);
      }
      
      // todo
      public function postFeed_Link($link:String, $name:String = 'name', $caption:String = 'caption', $description:String = 'description', $message:String = 'message', $picture:String = '', callback:Function = null):void
      {
         Trace2('{as} FBMgr | postFeed_Link');
         
         callbackFunc = callback;
         
         var obj:Object = 
            {
               name:$name,
               caption:$caption,
               description:$description,
               message:$message,
               link:$link
            };
         if ($picture.length > 0) obj.picture = $picture;
         
         Facebook.api('/me/feed', onPostFeed_Link, obj, 'post');
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
         callbackFunc = callback;
         
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
         Facebook.ui('apprequests', data, onPostAppreq, DISPLAY);
      }
      
      // ________________________________________________
      //                                            album
      
      public function setWantedAlbumInfo(album_name:String, album_msg:String):void
      {
         albumName = album_name;
         albumMsg = album_msg;
      }
      
      public function getWantedAlbum():FBAlbum
      {
         return wantedAlbumNo == -1 ? null : albumPool[wantedAlbumNo];
      }
      
      // ________________________________________________
      //                                            photo
      
      public function postPhoto1(message:String, image:BitmapData, callback:Function = null):void
      {
         Trace2('{as} FBMgr | postPhoto1');
         callbackFunc = callback;
         
         returnId = null;
         
         var obj:Object = 
            {
               message:message,
               file:image,
               fileName:'test'
            };
         Facebook.api('/' + albumPool[wantedAlbumNo].id + '/photos', onPostPhoto, obj, 'POST');
      }
      
      public function postPhoto2(message:String, image:BitmapData, callback:Function = null):void
      {
         Trace2('{as} FBMgr | postPhoto2');
      }
      
      public function postProfilePhoto(photo_id:String):void
      {
         var url:String = 'http://www.facebook.com/photo.php?fbid=' + photo_id + '&makeprofile=1';
         navigateToURL(new URLRequest(url), '_blank');
      }
      
      // ________________________________________________
      //                                            utils
      
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
         friendPool.sort(mySorter);
         
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
      
      // ################### protected ##################
      
      // #################### private ###################
      
      // ________________________________________________
      //                                           init 1
      
      private function onInit_1(success:Object, fail:Object):void
      {
         if (success)
         {
            uid = new String(success.uid);
            accessToken = new String(success.accessToken);
            
            Trace2('{as} FBMgr | onInitComplete | already login');
            Trace2('     uid = ' + uid);
            Trace2('     access_token = ' + accessToken);
            
            // next
            Facebook.api('/me/albums', onLogin1_4, null, 'GET');
         }
         else
         {
            Trace2('{as} FBMgr | onInitComplete | not login yet');
            
            // return
            tryCallback();
         }
      }
      
      // ________________________________________________
      //                                           login1
      
      private function onLogin1_1(success:Object, fail:Object):void
      {
         if (success)
         {
            if (!isLogin)
            {
               uid = new String(success.uid);
               accessToken = new String(success.accessToken);
               
               Trace2('{as} FBMgr | onLoginComplete | success = ', success);
               Trace2('     uid = ' + uid);
               Trace2('     access_token = ' + accessToken);
            }
            
            // next
            Facebook.api('/me', onLogin1_2);
         }
         else
         {
            Trace2('{as} FBMgr | onLoginComplete | fail = ', fail);
            
            // return
            tryCallback();
         }
      }
      
      private function onLogin1_2(success:Object, fail:Object):void
      {
         if (success)
         {
            name = new String(success.name);
            username = new String(success.username);
            gender = new String(success.gender);
            
            // optional
            if (success.hasOwnProperty('email')) email = new String(success.email);
            
            Trace2('{as} FBMgr | getProfileComplete | success = ', success);
            Trace2('     name = ' + name);
            Trace2('     username = ' + username);
            Trace2('     gender = ' + gender);
            Trace2('     email = ' + email);
            
            // next, see getProfilePhotoURL();
            Facebook.api('/me?fields=picture&type=square&', onLogin1_3);
         }
         else
         {
            Trace2('{as} FBMgr | getProfileComplete | fail = ', fail);
            
            // return
            tryCallback();
         }
      }
      
      private function onLogin1_3(success:Object, fail:Object):void
      {
         if (success)
         {
            Trace2('{as} FBMgr | getProfilePhotoURLComplete | success = ', success);
            
            picUrl_square = new String(success.picture);
            picUrl_small = square2Small(picUrl_square);
            picUrl_normal = square2Normal(picUrl_square);
            picUrl_large = square2Large(picUrl_square);
            
            tryLoadPolicy(picUrl_square); // security
            
            // next
            Facebook.api('/me/albums', onLogin1_4, null, 'GET');
         }
         else
         {
            Trace2('{as} FBMgr | getProfilePhotoComplete | fail = ', fail);
            
            // return
            tryCallback();
         }
      }
      
      private function onLogin1_4(success:Object, fail:Object):void
      {
         if (success)
         {
            Trace2('{as} FBMgr | onGetAlbumsComplete | success = ', success);
            albumPool = new Vector.<FBAlbum>();
            var arr:Array = success as Array;
            for (var i:int = 0; i < arr.length; ++i) 
            {
               if (arr[i].name == albumName)
               {
                  wantedAlbumNo = i;
               }
               
               albumPool.push(new FBAlbum(arr[i] as Object));
            }
            
            // next
            if (wantedAlbumNo == -1)
            {
               // add to pool
               var album:FBAlbum = new FBAlbum();
               album.name = albumName;
               albumPool.push(album);
               wantedAlbumNo = albumPool.length - 1;
               
               // api
               var obj:Object = 
                  {
                     name:albumName,
                     message:albumMsg
                  };
               Facebook.api('/me/albums', onLogin1_5, obj, 'POST');
            }
            else
            {
               // return
               tryCallback();
            }
         }
         else
         {
            Trace2('{as} FBMgr | onGetAlbumsComplete | fail = ', fail);
            
            // still notify when failed
            tryCallback();
         }
      }
      
      private function onLogin1_5(success:Object, fail:Object):void
      {
         if (success)
         {
            Trace2('{as} FBMgr | onCreateAlbumComplete | success = ', success);
            
            albumPool[wantedAlbumNo].id = new String(success.id);
         }
         else
         {
            Trace2('{as} FBMgr | onCreateAlbumComplete | fail = ', fail);
         }
         
         // return
         tryCallback();
      }
      
      // ________________________________________________
      //                                          friends
      
      private function onGetFriends(success:Object, fail:Object):void
      {
         if (success)
         {
            Trace2('{as} FBMgr | getFriendsComplete | success = ', success);
            
            var fArr:Array = success as Array;
            friendPool = new Vector.<FBFriend>();
            while (fArr.length)
            {
               var f:Object = fArr.pop();
               friendPool.push(new FBFriend(f.id, f.name));
            }
            sortFriends();
         }
         else
         {
            Trace2('{as} FBMgr | getFriendsComplete | fail = ', fail);
         }
         
         // return
         tryCallback();
      }
      
      // ________________________________________________
      // 
      
      private function onPostPhoto(success:Object, fail:Object):void
      {
         if (success)
         {
            Trace2('{as} FBMgr | onPostPhotoComplete | success = ', success);
            
            returnId = new String(success.id);
         }
         else
         {
            Trace2('{as} FBMgr | onPostPhotoComplete | fail = ', fail);
         }
         
         // return
         tryCallback();
      }
      
      private function onPublishFeed_UI():void
      {
      }
      
      private function onPostFeed_Link(success:Object, fail:Object):void
      {
         // return
         tryCallback();
      }
      
      private function onPostAppreq(res:Object):void
      {
         if (res)
         {
            returnId = new String(res.request);
         }
         
         // return
         tryCallback();
      }
      
      // ________________________________________________
      //                                            utils
      
      /**
       * Try to call callback function.
       */
      private function tryCallback():void
      {
         if (callbackFunc as Function)
         {
            callbackFunc();
         }
      }
      
      /**
       * Looks for a policy file at the location specified by parsing the url.
       * @param url
       */
      private function tryLoadPolicy(url:String):void
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
      
      // --------------------- LINE ---------------------
      
   }
   
}

class PrivateClass
{
   function PrivateClass() {}
}
