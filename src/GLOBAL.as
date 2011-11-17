package
{
   
   public class GLOBAL
   {
      
      // ________________________________________________
      //                                    document info
      
      public static var DocWidth:Number = 960;
      public static var DocHeight:Number = 520;
      
      public static var firstTimeVisit:Boolean = true;
      
      // ________________________________________________
      //                                      facebook 區
      
      public static var BASE_URL:String = '';
      
      // app id
      public static var APP_ID:String = '152204381520601'; // my test app-id
      public static var PERMISSION:String = 'user_about_me,user_birthday,user_photos,email,read_friendlists,publish_stream';
      // 活動名稱(創相簿、上傳照片…用)
      public static var APP_NAME:String = 'DEMO';
      // 活動網址
      public static var CAMPAIGN_URL:String = 'http://aaa/';
      // app 名字
      public static var CANVAS_ID:String = 'null';
      // 認證 url
      public static function get AUTHORIZATION_URL():String { return 'https://www.facebook.com/dialog/oauth?client_id=' + APP_ID + '&redirect_uri=http://apps.facebook.com/' + CANVAS_ID + '/&scope=' + PERMISSION; }
      // 個資(/me/profile回來的資料)
      public static var profile:Object;
      
      // --------------------- LINE ---------------------
      
   }
   
}