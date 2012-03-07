package _facebook.data
{
   import _facebook.FBMgr;
   
   import com.facebook.graph.Facebook;
   
   import flash.events.Event;
   
   public class FBFriend
   {
      private var _uid:String;
      private var _name:String;
      private var _username:String;
      private var _gender:String;
      private var _pic_url_square:String;
      private var _pic_url_small:String;
      private var _pic_url_normal:String;
      private var _pic_url_large:String;
      
      // further info callback
      private var furtherInfoComplete:Function;
      
      public function FBFriend($uid:*)
      {
         _uid = new String($uid);
      }
      
      // ________________________________________________
      //                                      information
      
      public function get uid():String { return _uid; }
      public function get name():String { return _name; }
      public function get username():String { return _username; }
      public function get gender():String { return _gender; }
      public function get pic_url_large():String { return _pic_url_large; }
      public function get pic_url_normal():String { return _pic_url_normal; }
      public function get pic_url_small():String { return _pic_url_small; }
      public function get pic_url_square():String { return _pic_url_square; }
      
      // ________________________________________________
      //                                 get further info
      
      public function getFurtherInfo(callback:Function = null):void
      {
         furtherInfoComplete = callback;
         Facebook.api('/' + _uid + '?fields=picture,name,username,gender&type=square&', getFurtherInfoComplete);
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      private function getFurtherInfoComplete(success:Object, fail:Object):void
      {
         if (success)
         {
            _name = new String(success.name);
            _username = new String(success.username);
            _gender = new String(success.gender);
            _pic_url_square = new String(success.picture);
            _pic_url_small = FBMgr.api.square2Small(_pic_url_square);
            _pic_url_normal = FBMgr.api.square2Normal(_pic_url_square);
            _pic_url_large = FBMgr.api.square2Large(_pic_url_square);
            
            // security
            FBMgr.api.tryLoadPolicy(_pic_url_square);
         }
         else
         {
         }
         
         // callback
         if (furtherInfoComplete as Function)
         {
            furtherInfoComplete();
         }
      }
      
      // --------------------- LINE ---------------------
      
   }
   
}