package org.vic.loader{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.globalization.DateTimeFormatter;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import org.vic.event.VicEvent;

	/**
	 * ...
	 * @author VicYu
	 */
	public class LoaderTask
	{
		private var _applicationDomain:ApplicationDomain;
		private var _loader:Loader;
		private var _path:String;
		private var _cb:Function;
		
		public var mediator:LoaderManager;

		public function LoaderTask( path:String, cb:Function = null ) 
		{
			_path = path;
			_cb = cb;
		}
		
		public function load():void {
			_loader = new Loader();
			_loader.load( new URLRequest( getPath() ));
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
				_applicationDomain = _loader.contentLoaderInfo.applicationDomain;
				_loader.unloadAndStop();
				_loader = null;
				if ( _cb != null ) {
					_cb();
					_cb = null;
				}
			});
			
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, function( e:ProgressEvent ):void {
				var total:Number = _loader.contentLoaderInfo.bytesTotal;
				var now:Number = _loader.contentLoaderInfo.bytesLoaded;
				var per:Number = now / total * 100;
				mediator.dispatchEvent( new VicEvent( LoaderManager.PROGRESS, per ));
			});
		}
		
		public function getPath():String{
			return _path;
		}
		
		public function getCb():Function {
			return _cb;
		}
		
		public function getApplicationDomain():ApplicationDomain {
			return _applicationDomain;
		}
		
		public function getObject( name:String ):Object {
			var clazz:Class = getApplicationDomain().getDefinition( name ) as Class;
			return new clazz();
		}
		
	}
}