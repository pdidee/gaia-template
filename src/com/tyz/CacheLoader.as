package com.tyz
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 * @author Thijs Broerse
	 */
	public class CacheLoader extends Loader 
	{
		private var _cacheURLLoader:URLLoader;
		private var _url:String;

		public function CacheLoader()
		{
			super();
			
			this._cacheURLLoader = new URLLoader();
			this._cacheURLLoader.addEventListener(Event.COMPLETE, this.handleURLLoaderComplete);
			this._cacheURLLoader.addEventListener(Event.OPEN, this.dispatchEvent);
			this._cacheURLLoader.addEventListener(ProgressEvent.PROGRESS, this.dispatchEvent);
			this._cacheURLLoader.addEventListener(IOErrorEvent.IO_ERROR, this.dispatchEvent);
			this._cacheURLLoader.addEventListener(IOErrorEvent.DISK_ERROR, this.dispatchEvent);
			this._cacheURLLoader.addEventListener(IOErrorEvent.NETWORK_ERROR, this.dispatchEvent);
			this._cacheURLLoader.addEventListener(IOErrorEvent.VERIFY_ERROR, this.dispatchEvent);
			this._cacheURLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.dispatchEvent);
			this._cacheURLLoader.dataFormat = URLLoaderDataFormat.BINARY;
			
			this.contentLoaderInfo.addEventListener(Event.COMPLETE, this.dispatchEvent);
		}

		/**
		 * @inheritDoc
		 */
		override public function load(request:URLRequest, context:LoaderContext = null):void
		{
			this._url = request.url;
			
			if (LoaderCache.get(this._url))
			{
				context.checkPolicyFile = false;
				this.loadBytes(LoaderCache.get(this._url), context);
			}
			else
			{
				this._cacheURLLoader.load(request);
			}
		}

		private function handleURLLoaderComplete(event:Event):void
		{
			this._cacheURLLoader.removeEventListener(Event.COMPLETE, this.handleURLLoaderComplete);
			LoaderCache.set(this._url, this._cacheURLLoader.data);
			this.loadBytes(this._cacheURLLoader.data);
		}
	}
}
