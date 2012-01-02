/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2009
* Author: Steven Sacks
*
* blog: http://www.stevensacks.net/
* forum: http://www.gaiaflashframework.com/forum/
* wiki: http://www.gaiaflashframework.com/wiki/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is released under the MIT License:
* http://www.opensource.org/licenses/mit-license 
*****************************************************************************************************/

package
{
	import _extension.GaiaPlus;
	
	import casts._impls.IMyPreloader;
	
	import com.gaiaframework.api.Gaia;
	import com.gaiaframework.core.GaiaMain;
	import com.gaiaframework.debug.GaiaDebug;
	import com.gaiaframework.events.GaiaEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	public class Main extends GaiaMain
	{
      // default preloader
      private function get preloader():IMyPreloader { return IMyPreloader(Gaia.api.getPreloader().content); }
      
      private var releaseGaia:Function;

		public function Main()
		{
			super();
         
			siteXML = "site.xml";
         GLOBAL.firstTimeVisit = true;
		}
      
      // --------------------- LINE ---------------------
      
      // ################### protected ##################
      
		override protected function onAddedToStage(event:Event):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			super.onAddedToStage(event);
		}
      
      override protected function init():void
      {
         // enable or disable debug
         GaiaPlus.api.enableTest();
         
         // I want to make preloader.swf complete it's transition-in and then do the loading job.
         GaiaPlus.api.setPreloader(Gaia.api.getPreloader());
         
         // layer
         var layer_1:Sprite = Gaia.api.getDepthContainer(Gaia.PRELOADER);
         layer_1.mouseEnabled = true;
         layer_1.mouseChildren = true;
         
         Gaia.api.beforeGoto(onBeforeGoto);
         Gaia.api.afterGoto(onAfterGoto);

         // init deep-linking, history and right-click menu
         initComplete();
      }
      
      // #################### private ###################
      
      private function onBeforeGoto(e:GaiaEvent):void
      {
         GaiaDebug.log('');
         GaiaDebug.log("========== Main.onBeforeGoto(" + e.fullBranch + ") ==========");
         
         GLOBAL.lastBranch = Gaia.api.getCurrentBranch();
      }
      
      private function onAfterGoto(e:GaiaEvent):void
      {
         GaiaDebug.log("========== Main.onAfterGoto(" + e.fullBranch + ") ==========");
      }
      
      // --------------------- LINE ---------------------

	}

}
