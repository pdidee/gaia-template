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
      public var link:String;
      
      public function FBAlbum(data:Object = null)
      {
         if (data)
         {
            id = new String(data.id);
            name = new String(data.name);
            type = new String(data.type);
            link = new String(data.link);
         }
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}