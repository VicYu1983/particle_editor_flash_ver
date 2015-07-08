package org.vic.componentDesign 
{
	import org.vic.event.VicEventDispatcher;
	
	/**
	 * ...
	 * @author fff
	 */
	public class Entity extends VicEventDispatcher 
	{
		private var _ary_comp:Vector.<Component>;
		public var props:Object = { };
		public function Entity() {
			
		}
		
		public function addComponent( comp:Component):void {
			if ( !_ary_comp ) {
				_ary_comp = new Vector.<Component>();
			}
			comp.owner = this;
			_ary_comp.push( comp );
		}
		
		public function executeFeature( compName:String, args:* = null):void {
			var comp:Component = getComponentByName( compName );
			if ( comp ) {
				comp.execute( args );
			}else {
				throw Error( 'not install this comp, name: ' + compName );
			}
		}
		
		public function getComponentByName( compName:String ):Component {
			var i:int = 0;
			var max:int = _ary_comp.length;
			var comp:Component;
			for ( ; i < max; ++i ) {
				comp = _ary_comp[i];
				if ( comp.name == compName ) {
					return comp;
				}
			}
			return null;
		}
	}

}