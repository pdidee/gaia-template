package _weibo.data
{
   
   public class WeiboFriend
   {
      protected var _uid:String;
      protected var _name:String;
      protected var _screen_name:String;
      protected var _gender:String;
      protected var _profile_image_url:String;
      
      public function WeiboFriend($uid:*, $name:*, $screen_name:*, $gender:*, $profile_image_url:*)
      {
         _uid = new String($uid);
         _name = new String($name);
         _screen_name = new String($screen_name);
         _gender = new String($gender);
         _profile_image_url = new String($profile_image_url);
      }
      
      // ________________________________________________
      //                                      Information
      
      public function get uid():String { return _uid; }
      public function get name():String { return _name; }
      public function get screen_name():String { return _screen_name; }
      public function get gender():String { return _gender; }
      public function get profile_image_url():String { return _profile_image_url; }
      
      // --------------------- LINE ---------------------
      
      public function toString():String
      {
         return '[uid = ' + _uid + ', name = ' + _name + ', screen_name = ' + _screen_name + ', gender = ' + _gender + ']'; 
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}