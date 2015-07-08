
package org.vic.web.youTube.events {
	import flash.events.Event;
	
	[Event(name = "stateChange", type = "anteater.events.VideoStateEvent")]
	
	public class VideoStateEvent extends Event {
		public static const UNSTARTED	:String = "unstarted";
		public static const ENDED		:String = "ended";
		public static const PLAYING		:String = "playing";
		public static const PAUSED		:String = "paused";
		public static const BUFFERING	:String = "buffering";
		public static const VIDEO_CUED	:String = "videoCued";
		public static const STATE_CHANGE:String = "stateChange";		
		public var state:String;
		public function VideoStateEvent(pType:String, pState:String, pBubble:Boolean = false) { 			
			super(pType, pBubble, false);			
			state = pState;
		} 
		
		public override function toString():String { 
			return formatToString("VideoStateEvent", "type","state"); 
		}
		override public function clone():Event {
			return new VideoStateEvent(type, state, bubbles);						
		}
	}
	
}