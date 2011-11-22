package _extension
{
   import casts._impls.IMyPreloader;
   
   import com.gaiaframework.api.Gaia;
   import com.gaiaframework.api.IBase;
   import com.gaiaframework.api.IMovieClip;
   import com.gaiaframework.api.IPageAsset;
   
   import flash.events.Event;
   
   public class GaiaPlus
   {
      private static const defaultPageId:String = 'root';
      
      // singleton
      private static var instance:GaiaPlus;
      
      // callback
      protected var callback:Function;
      
      public function GaiaPlus(pvt:PrivateClass)
      {
      }
      
      // --------------------- LINE ---------------------
      
      // Just like Gaia.api (smile :)
      public static function get api():GaiaPlus
      {
         if (!instance)
         {
            instance = new GaiaPlus(new PrivateClass());
         }
         
         return instance;
      }
      
      // ________________________________________________
      //                                        Preloader
      
      public function setPreloader(asset:IMovieClip):void
      {
         if (!Gaia.api) return;
         
         // old one
         var preloader:casts._impls.IMyPreloader = IMyPreloader(Gaia.api.getPreloader().content);
         preloader.removeBeforePreload();
         
         // new one
         preloader = IMyPreloader(asset.content);
         preloader.addBeforePreload();
         Gaia.api.setPreloader(asset);
      }
      
      // ________________________________________________
      //                                   Lightbox Asset
      
      public function showAssetById($assetId:String, $pageId:String = defaultPageId, $callback:Function = null):void
      {
         if (!Gaia.api) return;
         
         var page:IPageAsset = Gaia.api.getPage($pageId);
         if (!page) return; // page doesn't exist
         if (!page.assets.hasOwnProperty($assetId)) return; // not an asset
         
         // callback
         callback = $callback;
         
         var asset:Object = page.assets[$assetId];
         var cast:IBase;
         if (asset.content)
         {
            cast = IBase(asset.content);
            // remove old handler and add a new one
            cast.removeEventListener('AFTER_TRANSITION_OUT', returnHandler);
            cast.addEventListener('AFTER_TRANSITION_OUT', returnHandler);
            cast.transitionIn();
         }
         else // need to load
         {
            //            IAsset(asset).load();
         }
      }
      
      public function hideAssetById($assetId:String, $pageId:String = defaultPageId):void
      {
         if (!Gaia.api) return;
         
         var page:IPageAsset = Gaia.api.getPage($pageId);
         if (!page) return; // page doesn't exist
         if (!page.assets.hasOwnProperty($assetId)) return; // not an asset
         
         var asset:Object = page.assets[$assetId];
         var cast:IBase;
         if (asset.content)
         {
            cast = IBase(asset.content);
            cast.transitionOut();
         }
      }
      
      // ################### protected ##################
      
      protected function returnHandler(e:Event):void
      {
         var page:IBase = IBase(e.target);
         page.removeEventListener('AFTER_TRANSITION_OUT', returnHandler);
         if (callback as Function) callback();
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}

class PrivateClass
{
   function PrivateClass() {}
}
