package _facebook
{
   import com.facebook.graph.Facebook;
   
   import flash.system.Security;
   import flash.utils.ByteArray;
   
   import org.flintparticles.threeD.initializers.FaceAxis;
   
   /**
    * 
    * @author cj, cjboy1984@gmail.com
    * 
    */   
   public class FBMgr
   {
      private const DOMAIN_FILE:String = 'crossdomain.xml';
      
      // info
      private var _app_key:String = '152204381520601';
      private var _perms:String = 'user_about_me';
      private var _access_token:String;
      private var _uid:String;
      private var _name:String;
      private var _username:String;
      private var _gender:String;
      private var _email:String;
      private var _pic_url:String;
      private var _pic:ByteArray;
      
      // init callback
      private var initComplete:Function;
      // login callback
      private var loginComplete:Function;
      
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
         
         // login > profile > picture
         Facebook.login(onLoginComplete, {scope:_perms});
      }
      
      private function getProfile():void
      {
         Trace2('{as} FBMgr | getProfile');
         Facebook.api('/me', getProfileComplete);
      }
      
      private function getProfilePhoto():void
      {
         Trace2('{as} FBMgr | getProfilePhoto');
         Facebook.api('/me?fields=picture&type=square&', getProfilePhotoComplete);
      }
      
      // ________________________________________________
      //                                           friend
      
      public function getFriends():void
      {
      }
      
      // ________________________________________________
      //                                      Information
      
      public function get isLogin():Boolean { return _uid != null; }
      public function get app_key():String { return _app_key; }
      public function get access_token():String { return ''; }
      public function get uid():String { return _uid; }
      public function get perms():String { return _perms; }
      public function get email():String { return _email; }
      public function get gender():String { return _gender; } // e.g. male
      public function get username():String { return _username; } // e.g. cjboy1984
      public function get name():String { return _name; } // e.g. Boy CJ
      public function get pic():ByteArray { return _pic; }
      public function get pic_url():String { return _pic_url; }
      
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
            getProfilePhoto();
         }
         else
         {
            Trace2('{as} FBMgr | getProfileComplete | fail = ', fail);
         }
      }
      
      private function getProfilePhotoComplete(success:Object, fail:Object):void
      {
         if (success)
         {
            _pic_url = new String(success.picture);
            Trace2('{as} FBMgr | getProfilePhotoComplete | success = ', success);
            Trace2('     pic_url = ' + _pic_url);
            
            // security
            tryToLoadPolicyFile(_pic_url);
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
      
      // ________________________________________________
      //                                            utils
      
      private function tryToLoadPolicyFile(url:String):void
      {
         var domain:String = new String(url);
         var buff:Array = domain.split('/');
         var domain_file:String = buff[0] + '//' + buff[2] + '/' + DOMAIN_FILE;
         Trace2('{as} FBMgr | tryToLoadPolicyFile | domain_file = ' + domain_file);
         Security.loadPolicyFile(domain_file);
      }
      
      // --------------------- LINE ---------------------
      
   }
   
}

class PrivateClass
{
   function PrivateClass() {}
}
