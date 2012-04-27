package _facebook.data
{
   import _facebook.FBMgr;
   
   import com.facebook.graph.Facebook;
   
   import flash.events.Event;
   
   public class FBAlbum
   {
      public var id:String;
      public var name:String;
      public var type:String = 'normal';
      public var privacy:String;
      public var updated_time:String;
      public var count:int;
      
      public function FBAlbum(data:Object = null)
      {
         if (data)
         {
            id = new String(data.id);
            name = new String(data.name);
            type = new String(data.type);
            privacy = new String(data.privacy);
            updated_time = new String(data.updated_time);
            
            count = int(data.count);
         }
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}