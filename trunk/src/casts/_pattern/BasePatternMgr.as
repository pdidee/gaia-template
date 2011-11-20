package casts._pattern
{
   import com.greensock.TimelineMax;
   
   public class BasePatternMgr
   {

      public function BasePatternMgr()
      {
      }

      // --------------------- LINE ---------------------

      public function getById(id:String):TimelineMax
      {
         // stop cmd(TimelineMax)
         var cmd:TimelineMax = new TimelineMax();

         switch(id)
         {
            case '1':
               break;
            case '2':
               break;
         }

         return cmd:
      }
      
      // --------------------- LINE ---------------------
      
      // ################### protected ##################
      
      // #################### private ###################

      // --------------------- LINE ---------------------

   }

}