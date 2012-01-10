package _sample
{
   import com.facebook.graph.Facebook;
   import com.facebook.graph.data.FacebookAuthResponse;
   import com.facebook.graph.data.FacebookSession;
   import com.facebook.graph.utils.FacebookDataUtils;
   
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   /**
    * Facebook Graph API sample
    * @author cjboy1984@gmail.com
    * @note
    * 1. 如何在post貼上朋友名字，而且是可以點連過去該朋友呢？
    * @[uid:0] // 這樣就行了！
    */
   public class FacebookDemo
   {
      // <!---------- Facebook ----------!>
      private var profile:Object; // personal info
      private var friends:Array; // friend list
      private var aid:String; // album id of the new created one
      private var pid:String; // photo id of the new uploaded one
      
      public function FacebookDemo()
      {
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      // ________________________________________________
      //                                   facebook basic
      
      // init facebook
      private function fbInit():void
      {
         Facebook.init(GB.APP_ID);
      }
      
      // before login facebook, remember to do init() job at first
      private function fbLogin():void
      {
         // add loading
         
         Facebook.login(fbLogin_Complete, { perms:GB.PERMISSION } );
      }
      
      // login complete
      private function fbLogin_Complete(success:Object, fail:Object):void
      {
         trace('fbLogin_Complete >>', Facebook.getAuthResponse().uid);
         if (Facebook.getAuthResponse().uid)
         {
            fbGetProfile();
         }
         else
         {
            // remove loading
            
            MyAlert.jsShow('登入facebook失敗…請重試');
         }
      }
      
      // get user personal info
      private function fbGetProfile():void
      {
         Facebook.api('/me', fbGetProfile_Complete);
      }
      
      // save user personal info
      private function fbGetProfile_Complete(success:Object, fail:Object):void
      {
         // remove loading
         
         if (success)
         {
            // save
            profile = success;
            
            // debug
            trace();
            trace('>>> get my facebook profile.');
            trace('----------------------------');
            for (var v:String in success)
            {
               trace(v, '=', success[v]);
            }
            trace('----------------------------');
         }
         else
         {
            MyAlert.jsShow('取得個人facebook資訊失敗…請重試');
         }
      }
      
      // ________________________________________________
      //                          facebook get my picture
      
      private function fbGetProfilePicture():void
      {
         Facebook.api('me?fields=picture&type=square&', fbGetProfilePicture_Complete);
      }
      
      private function fbGetProfilePicture_Complete(success:Object, fail:Object):void
      {
         if (success)
         {
            // This is the url of the picture
            var url:String = String(success.picture);
         }
         else
         {
            MyAlert.jsShow('取得個人大頭照失敗…請重試');
         }
      }
      
      // ________________________________________________
      //                  facebook friend request (html)
      
      // use Facebook.ui() to do friend request job
      private function fbInviteFriend():void
      {
         // for more detail information, see
         // http://developers.facebook.com/docs/reference/dialogs/requests/
         var _title:String = 'title'; // max 50 characters.
         var _msg:String = 'Please choose only 1 friend from the list.'; // max 255 characters.
         var _filters:Array = ['app_non_users']; // all | app_users | app_non_users
         var _max_recip:int = 3; // max recipients
         
         var dat:Object = { message:_msg, title:_title, filters:_filters, max_recipients:_max_recip };
         Facebook.ui('apprequests', dat, fbInviteFriend_Complete, 'popup'); // iframe | popup
      }
      
      // the return data is a array
      private function fbInviteFriend_Complete(res:Object):void
      {
         if (res)
         {
            // save
            friends = res.request_ids as Array;
         }
      }
      
      // ________________________________________________
      //                  facebook friend request (flash)
      
      // get friend list
      private function fbGetFriends():void
      {
         // 加入loading
         
         // square (50x50), small (50x??), normal (100x??), large (200x??)
         Facebook.api('/me/friends?fields=picture,name&type=square&', fbGetFriends_Complete);
      }
      
      // save friend list
      private function fbGetFriends_Complete(success:Object, fail:Object):void
      {
         // remove loading
         
         if (success)
         {
            // it is a array containing Object {id:XXX, name:XXX, picture:XXX}
            friends = success as Array;
            // sort by alphabet
            friends.sort(mySortor);
         }
         else
         {
            MyAlert.jsShow('取得facebook朋友列表失敗…請重試');
         }
      }
      
      // 字碼大的就排後面
      // -1代表a在b前面；1代表a在b後面；0代表相等
      private function mySortor(a:*, b:*):int
      {
         if (a.name.substr(0, 1) > b.name.substr(0, 1))
         {
            return 1;
         }
         else if (a.name.substr(0, 1) < b.name.substr(0, 1))
         {
            return -1;
         }
         else
         {
            return 0;
         }
      }
      
      // ________________________________________________
      //                            facebook create album
      
      // create album
      private function fbCreateAlbum():void
      {
         // add loading
         
         var album_name:String = 'Test_Album_by_cjboy';
         var album_msg:String = 'XXX';
         var params:Object = { name:album_name, message:album_msg };
         Facebook.api('/me/albums', fbCreateAlbum_Complete, params, 'POST');
      }
      
      // save album id
      private function fbCreateAlbum_Complete(success:Object, fail:Object):void
      {
         // remove loading
         
         if (success)
         {
            aid = String(success.id);
         }
         else
         {
            MyAlert.jsShow('創立facebook相簿失敗…請重試');
         }
      }
      
      // ________________________________________________
      //                             facebook post photos
      
      // post photos
      private function fbPostPhoto():void
      {
         // tags
         var ttags:String = '[{tag_uid:171280426263499,x:50,y:0}'; // tag fans group
         //ttags += ',{tag_uid:' + FriendBox.focusOne.fb_id + ',x:50,y:100}'; // tag friend
         ttags += ',{tag_uid:' + Facebook.getAuthResponse().uid + ',x:50,y:50}'; // tag myself
         ttags += ']';
         
         // photos
         var bmpData_1:BitmapData = new BitmapData(100, 100);
         var bmp_1:Bitmap = new Bitmap(bmpData_1);
         var msg:String = "message" + "\n" + GB.CAMPAIGN_URL;
         var params_1:Object = {file:bmp_1, message:msg, fileName:GB.APP_NAME + "_1", tags:ttags};
         Facebook.api('/' + aid + '/photos', fbPostPhoto_Complete, params_1, 'POST'); // upload the photos to the assigned album by the giving album id
         //Facebook.api('/me/photos', fbPostPhoto_Complete, params_1, 'POST'); // upload the photos to the latest album
      }
      
      private function fbPostPhoto_Complete(success:Object, fail:Object):void
      {
         if (success)
         {
            // DO SOMETHING
         }
         else
         {
            trace(fail);
         }
      }
      
      // ________________________________________________
      //                  facebook change profile picture
      
      // send chaning profile picture request
      private function fbChangeProfilePicture():void
      {
         var url:String = 'http://www.facebook.com/photo.php?fbid=' + pid + '&makeprofile=1';
         navigateToURL(new URLRequest(url), '_blank');
      }
      
      // --------------------- LINE ---------------------
      
   }
   
}
