package com.tyz
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * @author Thijs Broerse
	 */
	public class CacheURLLoader extends URLLoader 
	{
		private var _url:String;
		
		public function CacheURLLoader(request:URLRequest = null)
		{
			super(request);
			
			if (request) this._url = request.url;
			this.addEventListener(Event.COMPLETE, this.handleComplete);
		}

		override public function load(request:URLRequest):void
		{
			this._url = request.url;
			super.load(request);
		}

		private function handleComplete(event:Event):void
		{
			this.removeEventListener(Event.COMPLETE, this.handleComplete);
			LoaderCache.set(this._url, this.data);
		}
	}
}
