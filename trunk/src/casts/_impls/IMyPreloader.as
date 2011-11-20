package casts._impls
{
   import com.gaiaframework.events.GaiaEvent;

   public interface IMyPreloader
   {
      /**
       * @example
       * public function addBeforePreload():void
       * {
       *    releaseGaia = Gaia.api.beforePreload(transitIn, true);
       * }
       */      
      function addBeforePreload():void;
      /**
       * @example
       * public function removeBeforePreload():void
       * {
       *    Gaia.api.removeBeforePreload(transitIn);
       * }
       */ 
      function removeBeforePreload():void;
      
      // --------------------- LINE ---------------------
      
      /**
       * @example
       * public function transitIn(e:GaiaEvent):void
       * {
       *    visible = true;
       *    mcLoading.transitionIn(tryReleaseGaia);
       * }
       */ 
      function transitIn(e:GaiaEvent):void;
      /**
       * @example
       * public function tryReleaseGaia():void
       * {
       *    if (releaseGaia != null)
       *    {
       *       // release gaia but keep the listener.
       *       releaseGaia(false);
       *    }
       * }
       */ 
      function tryReleaseGaia():void;
      
      // --------------------- LINE ---------------------
      
      /**
       * @example
       * public function set releaseGaia(v:Function):void { _releaseGaia = v; }
       * public function get releaseGaia():Function { return _releaseGaia; }
       */ 
      function set releaseGaia(v:Function):void;
      function get releaseGaia():Function;
   }
}