package com.tyz
{
	import flash.utils.ByteArray;

	/**
	 * @author Thijs Broerse
	 */
	public class LoaderCache 
	{
		private static const _cache:Object = new Object();

		/**
		 * Get data from cache.
		 */
		public static function get(url:String):ByteArray
		{
			return LoaderCache._cache[url] as ByteArray;
		}

		/**
		 * Store data in cache
		 */
		public static function set(url:String, data:ByteArray):void
		{
			LoaderCache._cache[url] = data;
		}

		/**
		 * Clear cache
		 * @param url if null all data is removed, else only the data store with the provided url is removed
		 */
		public static function clear(url:String = null):void
		{
			if (url)
			{
				delete LoaderCache._cache[url];
			}
			else
			{
				for (var url : String in LoaderCache._cache)
				{
					delete LoaderCache._cache[url];
				}
			}
		}
	}
}
