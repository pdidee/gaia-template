package _facebook
{
   import _facebook.data.FBAlbum;
   import _facebook.data.FBFriend;
   import _facebook.data.FBPhoto;
   
   import com.facebook.graph.Facebook;
   import com.openass.math.UniqRand;
   
   import flash.display.BitmapData;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.Security;
   
   /**
    * A facebook manager.
    * @author boy, cjboy1984@gmail.com
    * @usage
    * // init
    * FBMgr.api.setLikeId('1234567');
    * FBMgr.api.setWantedAlbumInfo('album name', 'album msg');
    * FBMgr.api.init(...);
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
      public var id:String;
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
      public var profilePhotoPool:Vector.<FBPhoto>;
      public var dataPool:Vector.<FBPhoto>;
      
      public var returnId:String; // photo id, request id, ...
      
      // album
      private var albumName:String = 'test';
      private var albumMsg:String = '...';
      private var wantedAlbum:FBAlbum;
      // profile album
      private var profileAlbum:FBAlbum;
      // like
      private var likeId:String = '20531316728';
      private var _isLike:Boolean = false;
      
      // callback
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
       * init > get profile > get profile picture > get album > create album
       * @param param         {fb_key:152204381520601,perms:'user_about_me,user_photos'}
       * @param callback
       */
      public function init(param:Object = null, callback:Function = null):void
      {
         if (param)
         {
            if (param.hasOwnProperty('appKey')) appKey = new String(param.appKey);
            if (param.hasOwnProperty('perms')) perms = new String(param.perms);
         }
         Trace2('{as} FBMgr | init');
         Trace2('     app_key = ' + appKey);
         Trace2('     perms = ' + perms);
         
         callbackFunc = callback;
         
         Facebook.init(appKey, onInit_1);
      }
      
      // --------------------- LINE ---------------------
      
      private function onInit_1(success:Object, fail:Object):void
      {
         if (success)
         {
            id = new String(success.uid);
            accessToken = new String(success.accessToken);
            
            Trace2('{as} FBMgr | init | already login');
            Trace2('     uid = ' + id);
            Trace2('     access_token = ' + accessToken);
            
            // next
            Facebook.api('/me', onLogin1_2);
         }
         else
         {
            Trace2('{as} FBMgr | init | not login yet');
            
            // return
            tryCallback();
         }
      }
      
      // ________________________________________________
      //                                            login
      
      public function get isLogin():Boolean
      {
         var ret:Boolean = (id != null);
         Trace2('###########################');
         Trace2('{as} FBMgr | check status, ' + (ret?'already login.':'not login yet.'));
         Trace2('###########################');
         return ret;
      }
      
      // login > get profile > get profile photo > get album > create album
      public function login1(callback:Function = null):void
      {
         Trace2('{as} FBMgr | login');
         callbackFunc = callback;
         
         // login > profile > picture url
         Facebook.login(onLogin1_1, {scope:perms});
      }
      
      // login in a redirect way
      public function login2(redirectParams:*):void
      {
         Trace2('{as} FBMgr | login');
         
         var url:String = 'http://www.facebook.com/dialog/oauth?client_id=' + appKey
            + '&redirect_uri=' + 'https://apps.facebook.com/skii-ja/?' + String(redirectParams)
            + '&scope=' + perms;
         navigateToURL(new URLRequest(url), '_parent');
      }
      
      // --------------------- LINE ---------------------
      
      private function onLogin1_1(success:Object, fail:Object):void
      {
         if (success)
         {
            if (!isLogin)
            {
               id = new String(success.uid);
               accessToken = new String(success.accessToken);
               
               Trace2('{as} FBMgr | login | success = ', success);
               Trace2('     uid = ' + id);
               Trace2('     access_token = ' + accessToken);
            }
            
            // next
            Facebook.api('/me', onLogin1_2);
         }
         else
         {
            Trace2('{as} FBMgr | login | fail = ', fail);
            
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
            
            Trace2('{as} FBMgr | get profile | success = ', success);
            Trace2('     name = ' + name);
            Trace2('     username = ' + username);
            Trace2('     gender = ' + gender);
            Trace2('     email = ' + email);
            
            // next, see getProfilePhotoURL();
            var params:Object = {
               fields:'picture',
               type:'square'
            }
            Facebook.api('/me', onLogin1_3, params, 'GET');
         }
         else
         {
            Trace2('{as} FBMgr | get profile | fail = ', fail);
            
            // return
            tryCallback();
         }
      }
      
      private function onLogin1_3(success:Object, fail:Object):void
      {
         if (success)
         {
            Trace2('{as} FBMgr | get profile picture | success = ', success);
            
            picUrl_square = String(success.picture).replace('https', 'http');
            picUrl_small = square2Small(picUrl_square);
            picUrl_normal = square2Normal(picUrl_square);
            picUrl_large = square2Large(picUrl_square);
            
            tryLoadPolicy(picUrl_square); // security
            
            Trace2('     size square = ' + picUrl_square);
            Trace2('     size small = ' + picUrl_small);
            Trace2('     size normal = ' + picUrl_normal);
            Trace2('     size large = ' + picUrl_large);
            
            // next
            wantedAlbum = null;
            Facebook.api('/me/albums', onLogin1_4, null, 'GET');
         }
         else
         {
            Trace2('{as} FBMgr | get profile picture | fail = ', fail);
            
            // return
            tryCallback();
         }
      }
      
      private function onLogin1_4(success:Object, fail:Object):void
      {
         if (success)
         {
            Trace2('{as} FBMgr | get album | success = ', success);
            albumPool = new Vector.<FBAlbum>();
            for (var i:int = 0; i < success.length; ++i) 
            {
               var album:FBAlbum = new FBAlbum(Object(success[i]));
               albumPool.push(album);
               
               // handle wannted album
               if (success[i].name == albumName)
               {
                  wantedAlbum = album;
               }
               
               // handle profile album
               if (success[i].name == 'Profile Pictures')
               {
                  profileAlbum = album;
               }
            }
            
            // next
            if (!wantedAlbum)
            {
               // add to pool
               wantedAlbum = new FBAlbum();
               wantedAlbum.name = albumName;
               albumPool.push(wantedAlbum);
               
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
            Trace2('{as} FBMgr | get album | fail = ', fail);
            
            // return
            tryCallback();
         }
      }
      
      private function onLogin1_5(success:Object, fail:Object):void
      {
         if (success)
         {
            Trace2('{as} FBMgr | create album done | success = ', success);
            
            wantedAlbum.id = new String(success.id);
         }
         else
         {
            Trace2('{as} FBMgr | create album done | fail = ', fail);
         }
         
         // return
         tryCallback();
      }
      
      // ________________________________________________
      //                                             like
      
      /**
       * Initialize the id for checking user's likes.
       * @see checkLikeId
       * @see isLike
       */
      public function setLikeId($likeId:String):void
      {
         likeId = $likeId;
      }
      /**
       * If user like the <code>likeId</code> or not.
       * @see setLikeId
       * @see checkLikeId
       */
      public function get isLike():Boolean { return _isLike; }
      
      /**
       * Check if user like the <code>likeId</code> or not.
       * @see setLikeId
       */
      public function checkLikeId(callback:Function = null):void
      {
         callbackFunc = callback;
         _isLike = false;
         
         Facebook.api('/me/likes', onCheckLike_1);
      }
      
      // --------------------- LINE ---------------------
      
      private function onCheckLike_1(success:Object, fail:Object):void
      {
         if (success)
         {
            Trace2('{as} FBMgr | onCheckLike_1 | success = ', success);
            
            for (var i:int = 0; i < success.length; ++i) 
            {
               if (success[i].id == likeId)
               {
                  _isLike = true;
                  break;
               }
            }
            Trace2('     result = ' + _isLike);
         }
         else
         {
            Trace2('{as} FBMgr | onCheckLike_1 | fail = ', fail);
         }
         
         // return
         tryCallback();
      }
      
      // ________________________________________________
      //                                           friend
      
      public function getFriends(callback:Function = null):void
      {
         Trace2('{as} FBMgr | getFriends');
         callbackFunc = callback;
         
         Facebook.api('/me/friends', onGetFriends_1);
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
      
      // --------------------- LINE ---------------------
      
      private function onGetFriends_1(success:Object, fail:Object):void
      {
         if (success)
         {
            Trace2('{as} FBMgr | getFriendsComplete | success = ', success);
            
            friendPool = new Vector.<FBFriend>();
            while (success.length)
            {
               var f:Object = success.pop();
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
      
      private function sortFriends():void
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
      //                                            album
      
      // 
      /**
       * Initialize the information for creating the customized album.
       * @see init
       * @see login1
       */
      public function setWantedAlbumInfo(album_name:String, album_msg:String):void
      {
         albumName = album_name;
         albumMsg = album_msg;
      }
      
      public function get hasProfileAlbum():Boolean { return (profileAlbum != null); }
      
      /**
       * Get all the photos in the "Profile Pictures" album. Save the link of the photos in a Array.
       * @see profilePhotos
       */
      public function getProfilePhotos(callback:Function = null):void
      {
         callbackFunc = callback;
         profilePhotoPool = null;
         
         Facebook.api('/' + profileAlbum.id + '/photos', onGetProfilePhotos_1);
      }
      
      // --------------------- LINE ---------------------
      
      private function onGetProfilePhotos_1(success:Object, fail:Object):void
      {
         if (success)
         {
            Trace2('{as} FBMgr | get profile photos | success = ', success);
            
            profilePhotoPool = new Vector.<FBPhoto>();
            for (var i:int = 0; i < success.length; ++i) 
            {
               var obj:FBPhoto = new FBPhoto(success);
               profilePhotoPool.push(obj);
            }
         }
         else
         {
            Trace2('{as} FBMgr | get profile photos | fail = ', fail);
         }
         
         // return
         tryCallback();
      }
      
      // ________________________________________________
      //                                            photo
      
      /**
       * Upload <code>BitmapData</code> to <code>wantedAlbum</code> album.
       */
      public function uploadPhoto(message:String, image:BitmapData, callback:Function = null):void
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
         Facebook.api('/' + wantedAlbum.id + '/photos', onUploadPhoto_1, obj, 'POST');
      }
      
      /**
       * Navigate to the page for changing user's profile picture.
       */
      public function updateProfilePicture(photo_id:String):void
      {
         var url:String = 'http://www.facebook.com/photo.php?fbid=' + photo_id + '&makeprofile=1';
         navigateToURL(new URLRequest(url), '_blank');
      }
      
      // --------------------- LINE ---------------------
      
      private function onUploadPhoto_1(success:Object, fail:Object):void
      {
         if (success)
         {
            Trace2('{as} FBMgr | post photo | success = ', success);
            
            returnId = new String(success.id);
         }
         else
         {
            Trace2('{as} FBMgr | onPostPhotoComplete | fail = ', fail);
         }
         
         // return
         tryCallback();
      }
      
      // ________________________________________________
      //                                             feed
      
      /**
       * Publish a feed.
       * @param $link
       * @param $name
       * @param $description
       * @param $message
       * @param $picture
       * @param callback
       */
      public function postFeed1($link:String = 'link', $name:String = 'name', $caption:String = 'caption', $description:String = 'description', $message:String = 'message', $picture:String = '', callback:Function = null):void
      {
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
         
         Facebook.api('/me/feed', onPostFeed1_1, obj, 'POST');
      }
      
      /**
       * Publish a feed by poping up a dialog.
       * @param $link
       * @param $name
       * @param $description
       * @param $message
       * @param $picture
       * @param callback
       */
      public function postFeed2($link:String = 'link', $picture:String = '', $name:String = 'name', $caption:String = 'caption', $description:String = 'description', callback:Function = null):void
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
         Facebook.ui('feed', obj, onPostFeed2_1, DISPLAY);
      }
      
      /**
       * To send a request to a single user you will need to invoke the Request Dialog with the to parameter and use it to include the User ID of the recipient user. But "App Namespace" and "Canvas URL" are necessary configurations.
       * @param message
       * @param to_ids
       * @param callback
       */
      public function sendAppRequest(message:String, to_ids:Array, callback:Function = null):void
      {
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
         Facebook.ui('apprequests', data, onSendAppRequest_1, DISPLAY);
      }
      
      // --------------------- LINE ---------------------
      
      private function onPostFeed1_1(success:Object, fail:Object):void
      {
         // return
         tryCallback();
      }
      
      private function onPostFeed2_1(res:Object):void
      {
         // return
         tryCallback();
      }
      
      private function onSendAppRequest_1(res:Object):void
      {
         if (res)
         {
            returnId = new String(res.request);
         }
         
         // return
         tryCallback();
      }
      
      // ________________________________________________
      //                                 by case function
      
      /**
       * Get all the photos that the app needs.</br>
       * <code>dataPool[0]</code> is user's icon.</br>
       * <code>dataPool[1~5]</code> are random friends' icons.</br>
       * <code>dataPool[6~15]</code> are random photos tagged with user.</br>
       */
      public function getData(callback:Function = null):void
      {
         callbackFunc = callback;
         
         dataPool = new Vector.<FBPhoto>();
         seed = null;
         
         // profile icon
         var obj:FBPhoto = new FBPhoto();
         obj.id = id;
         obj.name = name;
         obj.url_n = picUrl_square;
         dataPool.push(obj);
         
         Facebook.api('/me/friends', onGetGameData_1);
      }
      
      // --------------------- LINE ---------------------
      
      private var seed:Array;
      
      private function getData_1():void
      {
         // get 5 friends
         if (!seed)
         {
            seed = UniqRand.getUintSeed(0, friendPool.length, 5); // count
         }
         
         // get friends' icon
         if (seed.length > 0)
         {
            var params:Object = {
               fields:'name,picture',
               type:'square'
            }
            Facebook.api('/' + friendPool[seed.pop()].id, onGetGameData_2, params, 'GET');
         }
         else
         {
            Facebook.api('/me/photos', onGetGameData_3);
         }
      }
      
      // --------------------- LINE ---------------------
      
      private function onGetGameData_1(success:Object, fail:Object):void
      {
         if (success)
         {
            Trace2('{as} FBMgr | get friends | success = ', success);
            
            friendPool = new Vector.<FBFriend>();
            while (success.length)
            {
               var f:Object = success.pop();
               friendPool.push(new FBFriend(f.id, f.name));
            }
            
            getData_1();
         }
         else
         {
            Trace2('{as} FBMgr | get friends | fail = ', fail);
         }
      }
      
      private function onGetGameData_2(success:Object, fail:Object):void
      {
         if (success)
         {
            Trace2('{as} FBMgr | get friends\' icon | success = ', success);
            
            var obj:FBPhoto = new FBPhoto();
            obj.id = new String(success.id);
            obj.name = new String(success.name);
            obj.url_n = String(success.picture).replace('https', 'http');
            dataPool.push(obj);
            
            getData_1();
         }
         else
         {
            Trace2('{as} FBMgr | get friends\' icon | fail = ', fail);
         }
      }
      
      private function onGetGameData_3(success:Object, fail:Object):void
      {
         if (success)
         {
            Trace2('{as} FBMgr | get photo with me | success = ', success);
            
            var arr:Array = UniqRand.getUintSeed(0, success.length, 10); // count
            
            while (arr.length)
            {
               var obj:FBPhoto = new FBPhoto();
               obj.url_n = String(success[arr.pop()].source).replace('https', 'http');
               dataPool.push(obj);
            }
         }
         else
         {
            Trace2('{as} FBMgr | get photo with me | fail = ', fail);
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
            
            Security.loadPolicyFile(domain_file);
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
      
      // --------------------- LINE ---------------------
      
   }
   
}

class PrivateClass
{
   function PrivateClass() {}
}
