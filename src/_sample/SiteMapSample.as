package casts.no1_example.map
{
   import com.gaiaframework.templates.AbstractPage;
   
   public class SiteMapSample extends AbstractPage
   {
      // fla
      
      public function SiteMapSample()
      {
         super();
      }
      
      // --------------------- LINE ---------------------
      
      override public function transitionIn():void
      {
         super.transitionIn();
         transitionInComplete();
      }
      
      override public function transitionInComplete():void
      {
         super.transitionInComplete();
      }
      
      override public function transitionOut():void
      {
         super.transitionOut();
         transitionOutComplete();
      }
      
      override public function transitionOutComplete():void
      {
         super.transitionOutComplete();
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}