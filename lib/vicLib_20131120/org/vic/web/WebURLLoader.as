package  org.vic.web
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author fff
	 */
	public class WebURLLoader 
	{
		private var _hash:Dictionary = new Dictionary();
		private var _boss:WebMain;
		
		public function WebURLLoader( boss:WebMain ) 
		{
			_boss = boss;
		}
		
		public function shareToFacebook( url:String ):void {
			navigateToURL( new URLRequest( 'http://www.facebook.com/share.php?u=' + url ));
		}
		
		public function addTask( ur:URLRequest, callback:Function = null, showLoading:Boolean = true ):void {
			if( showLoading )
				getBoss().openLoadingPage();
			
			var ul:URLLoader = new URLLoader();
			ul.load( ur );
			ul.addEventListener(Event.COMPLETE, onComplete );
			_hash[ul] = callback;
		}
		
		private function onComplete( e:Event ):void {
			var l:URLLoader = e.currentTarget as URLLoader;
			if ( _hash[l] != null )
			{
				_hash[l]( l.data );
				delete _hash[l];
			}
			getBoss().closeLoadingPage();
		}
		
		protected function getBoss():WebMain {
			return _boss;
		}
	}

}