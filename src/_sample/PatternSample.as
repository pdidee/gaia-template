package _sample
{
   import com.gaiaframework.api.Gaia;
   import com.gaiaframework.api.IPageAsset;
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.greensock.easing.Quad;
   
   import flash.utils.Dictionary;
   
   public class PatternSample
   {
      // fla
//      private function get rootPage():IPageAsset { return IPageAsset(Gaia.api.getPage('root')); }
//      private function get rootPdt_1():Object { return getObj('root pdt 1') || Object(rootPage.assets.XXX); }
      
      // singleton
      private static var _instance:PatternSample;
      
      // pool
      private var objsPool:Dictionary;
      
      public function PatternSample(pvt:PvtClass)
      {
      }
      
      // --------------------- LINE ---------------------
      
      public static function get api():PatternSample
      {
         if (!_instance)
         {
            _instance = new PatternSample(new PvtClass());
            _instance.objsPool = new Dictionary();
         }
         return _instance;
      }
      
      // --------------------- LINE ---------------------
      
      public function getPattern($id:String):TimelineMax
      {
         // stop cmd(TimelineMax)
         var cmd:TimelineMax = new TimelineMax(
            {
               onStart:function()
               {
               },
               onUpdate:function()
               {
               },
               onComplete:function()
               {
               }
            }
         );
         
         switch($id)
         {
            case 'demo 1':
               break;
            case 'demo 2':
               break;
         }
         
         return cmd;
      }
      
      // --------------------- LINE ---------------------
      
      public function add($obj:Object, $id:String = null):void
      {
         var objId:String = $id;
         if (objId == null)
         {
            objId = $obj.name;
         }
         objsPool[objId] = $obj;
      }
      
      public function remove(v:Object):void
      {
         delete objsPool[v];
      }
      
      public function listObjsPool():void
      {
         trace("\n===== PatternSample.listObjsPool() =====");
         for (var key:* in objsPool) 
         {
            trace("\"" + key + "\" = " + objsPool[key]);
         }
      }
      
      // ################### protected ##################
      
      protected function getObj($id:String):Object
      {
         if (objsPool.hasOwnProperty($id))
         {
            return objsPool[$id];
         }
         else
         {
            return null;
         }
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}

class PvtClass
{
   public function PvtClass() {}
}