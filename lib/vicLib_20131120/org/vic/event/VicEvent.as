package org.vic.event {
	import flash.events.Event;
	/**
	 * ...
	 * @author fff
	 */
	public class VicEvent extends Event
	{
		public var name:String;
		public var data:Object;
		
		public function VicEvent( type:String, data:Object = null, bubble:Boolean = false, cancelable:Boolean = false ) {
			super( type, bubble, cancelable );
			this.data = data;
			name = type;
		}
		
	}
}