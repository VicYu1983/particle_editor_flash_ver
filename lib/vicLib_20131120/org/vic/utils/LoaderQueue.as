package org.vic.utils 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import org.vic.event.VicEvent;
	import org.vic.event.VicEventDispatcher;
	/**
	 * ...
	 * @author vic
	 */
	public class LoaderQueue extends VicEventDispatcher
	{
		private static var _inst:LoaderQueue;
		
		private var _loader:Loader = new Loader();
		private var _ary_url:Array = [];
		private var _isLoaded:Boolean = false;
		
		public function LoaderQueue( sgt:Sgt ) 
		{
			
		}
		
		public static function get inst():LoaderQueue {
			if ( _inst == null ) {
				_inst = new LoaderQueue( new Sgt());
			}
			return _inst;
		}
		
		public function addTask( url:* ):void {
			_ary_url.push( url );
		}
		
		public function start():void {
			if ( hasTask()) {
				_isLoaded = true;
				var loadContent:* = _ary_url.shift();
				if ( loadContent is ByteArray ) {
					_loader.loadBytes( loadContent as ByteArray );
				}else if ( loadContent is String ) {
					_loader.load( new URLRequest( loadContent ));
				}else {
					throw Error( 'invalid format' );
				}
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete );
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoeError );
			}
		}
		
		public function hasTask():Boolean {
			return _ary_url.length > 0;
		}
		
		public function get isLoaded():Boolean {
			return _isLoaded;
		}
		
		private function onLoadComplete(e:Event ):void {
			dispatchEvent( new VicEvent( Event.COMPLETE, _loader.contentLoaderInfo.content ));
			_isLoaded = false;
			start();
		}
		
		private function onIoeError( e:IOErrorEvent ):void {
			//error 
		}
	}

}
class Sgt { }