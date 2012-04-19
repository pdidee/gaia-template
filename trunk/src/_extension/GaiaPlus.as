package _extension
{
   import casts._impls.IMyPreloader;
   
   import com.gaiaframework.api.Gaia;
   import com.gaiaframework.api.IBase;
   import com.gaiaframework.api.IMovieClip;
   import com.gaiaframework.api.IPageAsset;
   import com.gaiaframework.templates.AbstractBase;
   
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   /**
    * A extension utils for GAIA framework.
    * @author boy, cjboy1984@gmail.com
    */   
   public class GaiaPlus
   {
      private static const defaultPageId:String = 'root';
      
      // singleton
      private static var instance:GaiaPlus;
      
      // transition in/out utils
      private var testTarget:AbstractBase;
      private var testEnabled:Boolean;
      private var transitIn:Function;
      private var transitOut:Function;
      
      public function GaiaPlus(pvt:PrivateClass)
      {
      }
      
      // ________________________________________________
      //                                  Transition Test
      
      public function enableTest():void { testEnabled = true; }
      public function disableTest():void { testEnabled = false; }
      
      /**
       * A transition test model. If you want to press "i" and "o" on your keyboard to test transition in-out functionality, please feel free to use it.
       * @param $target          : A class inherited from AbstractBase class.
       */      
      public function initTest($target:AbstractBase):void
      {
         if (!testEnabled) return;
         
         testTarget = $target;
         if (testTarget.stage && !testTarget.stage.hasEventListener(KeyboardEvent.KEY_UP))
         {
            testTarget.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUPUP);
         }
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
      
      /**
       * Show asset by given asset-id and page-id. It helps you to control asset's content directly.
       * @param $assetId         : String. Check part of site.xml of GAIA Framework for detail.
       * @param $pageId          : String. Check part of site.xml of GAIA Framework for detail.
       * @param $returnCallback  : A callback function notify the asset is removed or closed.
       * @usage
       * GaiaPlus.api.showAsset('tvc', 'root', callback);
       * 
       * function callback()
       * {
       *    trace('!!!back!!!');
       * };
       */ 
      public function showAsset($assetId:String, $pageId:String = defaultPageId, $returnCallback:Function = null):void
      {
         var asset:Object = getAsset($assetId, $pageId);
         var assetContent:Object = getAssetContent($assetId, $pageId);
         if (assetContent)
         {
            assetContent.transitionIn();
            
            // return call back (for BaseLightbox)
            if (assetContent.hasOwnProperty('returnCallback'))
            {
               assetContent.returnCallback = $returnCallback;
            }
         }
         else
         {
//            IAsset(asset).load();
         }
      }
      
      /**
       * Hide asset by given asset-id and page-id. It helps you to control asset's content directly.
       * @param $assetId         : String. Check part of site.xml of GAIA Framework for detail.
       * @param $pageId          : String. Check part of site.xml of GAIA Framework for detail.
       * @usage
       * GaiaPlus.api.hideAsset('tvc', 'root');
       */      
      public function hideAsset($assetId:String, $pageId:String = defaultPageId):void
      {
         var assetContent:Object = getAssetContent($assetId, $pageId);
         if (assetContent)
         {
            assetContent.transitionOut();
         }
      }
      
      // ________________________________________________
      //                                      Asset Utils
      
      public function getAsset($assetId:String, $pageId:String = defaultPageId):Object
      {
         if (!Gaia.api) return null;
         
         var page:IPageAsset = Gaia.api.getPage($pageId);
         if (!page) return null; // page doesn't exist
         if (!page.assets.hasOwnProperty($assetId)) return null; // not an asset
         
         return page.assets[$assetId];
      }
      
      public function getAssetContent($assetId:String, $pageId:String = defaultPageId):Object
      {
         if (!Gaia.api) return null;
         
         var page:IPageAsset = Gaia.api.getPage($pageId);
         if (!page) return null; // page doesn't exist
         if (!page.assets.hasOwnProperty($assetId)) return null; // not an asset
         
         var asset:Object = page.assets[$assetId];
         return asset.content;
      }
      
      // ________________________________________________
      //                                        singleton
      
      // Just like Gaia.api (smile :D)
      public static function get api():GaiaPlus
      {
         if (!instance)
         {
            instance = new GaiaPlus(new PrivateClass());
            // init
            instance.testEnabled = true;
         }
         
         return instance;
      }
      
      // ################### protected ##################
      
      protected function onKeyUPUP(e:KeyboardEvent):void
      {
         if (!testEnabled) return;
         
         switch(e.keyCode)
         {
            case Keyboard.I:
            case Keyboard.RIGHT:
               testTarget.transitionIn();
               break;
            case Keyboard.O:
            case Keyboard.LEFT:
               testTarget.transitionOut();
               break;
         }
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}

class PrivateClass
{
   function PrivateClass() {}
}
