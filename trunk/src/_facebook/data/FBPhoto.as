package _facebook.data
{
   
   public class FBPhoto
   {
      public var id:String;
      public var url_n:String; // Link of original-size photo
      public var url_s:String; // Link of icon-size photo
      public var width:Number; // Width of original-size photo
      public var height:Number; // Height of original-size photo
      
      public var name:String; // Just a name buffer
      
      public function FBPhoto(data:Object = null)
      {
         if (data)
         {
            id = new String(data.id);
            url_n = new String(data.source).replace('https', 'http');
            url_s = new String(data.picture).replace('https', 'http');
            width = Number(data.width);
            height = Number(data.height);
         }
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}