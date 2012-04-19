package _facebook.data
{
   
   public class FBFriend
   {
      private var _uid:String;
      private var _name:String;
      
      public function get uid():String { return _uid; }
      public function get name():String { return _name; }
      
      // further info callback
      private var furtherInfoCallback:Function;
      
      public function FBFriend($uid:*, $name:* = null)
      {
         _uid = new String($uid);
         _name = new String($name);
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}