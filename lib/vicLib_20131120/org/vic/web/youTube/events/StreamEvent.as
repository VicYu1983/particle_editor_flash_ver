package org.vic.web.youTube.events {
	import flash.events.Event;
	[Event(name = "fileLoadComplete", type = "anteater.events.StreamEvent")]	
	[Event(name = "fileLoadProgress", type = "anteater.events.StreamEvent")]	
	[Event(name = "streamProgress", type = "anteater.events.StreamEvent")]
	[Event(name = "streamComplete", type = "anteater.events.StreamEvent")]	
	public class StreamEvent extends Event {			
		public static const STREAM_PROGRESS			:String = "streamProgress";
		public static const STREAM_COMPLETE			:String = "streamComplete";	
		public static const FILE_LOAD_COMPLETE		:String = "fileLoadComplete";
		public static const FILE_LOAD_PROGRESS		:String = "fileLoadProgress";		
		/**
		 * 百分比 0 ~ 1
		 */
		private var _percentage:Number;		
		/**
		 * StreamEvent
		 * @param	pType 類型。
		 * @param	pPercentage 百分比
		 */
		public function StreamEvent(pType:String, pPercentage:Number = 0):void	{				
			super(pType, false, false);			
			percentage = pPercentage;					
		}		
		public override function toString():String {	
			return formatToString("StreamEvent", "type","percentage");			
		}		
		override public function clone():Event {
			return new StreamEvent(type, 0);									
		}
		
		public function get percentage():Number { return _percentage; }		
		public function set percentage(value:Number):void {
			_percentage = value;
		}
	}
}