package org.vic.loader
{
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author fff
	 */
	public class LoaderManager extends EventDispatcher
	{
		public static const PROGRESS:String = 'progress';
		
		private static var _inst:LoaderManager;
		private var _map_loader:Object;

		public function LoaderManager( sgt:Sgt ) 
		{
			_map_loader = { };
		}
		
		public static function get inst():LoaderManager {
			if ( _inst == null )
				_inst = new LoaderManager( new Sgt() );
			return _inst;
		}
		
		public function addTask( name:String, loader:LoaderTask):void {
			if ( hasTask( name ))
				throw "same name of task! please check";
			_map_loader[ name ] = loader;
			loader.mediator = this;
			loader.load();
		}
		
		public function hasTask( name:String ):Boolean {
			return _map_loader[ name ] != null;
		}
		
		public function getTask( name:String ):LoaderTask{
			if ( hasTask( name ))
				return _map_loader[ name ];
			return null;
		}
	}
}
class Sgt { }