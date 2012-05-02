package _facebook.data
{
   
   public class FBAlbum
   {
      public var id:String;
      public var name:String;
      public var privacy:String; // e.g. "everyone"
      public var updated_time:String; // e.g. "2012-04-13T11:42:26+0000"
      public var count:int; // Number of photos
      
      public function FBAlbum(data:Object = null)
      {
         if (data)
         {
            id = new String(data.id);
            name = new String(data.name);
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