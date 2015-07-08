
package org.vic.web.youTube.media {		
	import org.vic.web.youTube.events.StreamEvent;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import org.vic.web.youTube.events.VideoStateEvent;
	
	public class YoutubeLoader extends Sprite {				
		public static const READY			:String = "ready";
		public static const ERROR			:String = "error";		
		public static const QUALITY_CHANGE	:String = "qualityChange";
		//沒有控制器
		private static const APIPLAYER_URL	:String = "http://www.youtube.com/apiplayer?version=3";
		//有控制器
		private static const APIPLAYER_CONTROLLER_URL	:String = "http://www.youtube.com/v/pgdgaDdNgwo?version=3";
		private var _youtubePlayer	:Object;		
		private var _youtubeLoader	:Loader;
		private var _autoPlay		:Boolean;		
		private var _isReady		:Boolean;	
		private var _isPlay			:Boolean;
		public function YoutubeLoader(pAutoPlay:Boolean = false, haveController:Boolean = false) {			
			_autoPlay = pAutoPlay;
			_isPlay = pAutoPlay;
			_youtubeLoader = new Loader();
			_youtubeLoader.contentLoaderInfo.addEventListener(Event.INIT, _loaderInitHandler);
			if ( haveController )
				_youtubeLoader.load(new URLRequest(APIPLAYER_CONTROLLER_URL));	
			else
				_youtubeLoader.load(new URLRequest(APIPLAYER_URL));	
		}		
	

		private function _loaderInitHandler(e:Event):void {
			_youtubeLoader.contentLoaderInfo.removeEventListener(Event.INIT, _loaderInitHandler);
			addChild(_youtubeLoader);			
			_youtubePlayer = _youtubeLoader.content;
			_youtubePlayer.addEventListener("onReady", _onReadyHandler);
			_youtubePlayer.addEventListener("onError", _onErrorHandler);
			_youtubePlayer.addEventListener("onStateChange", _onStateChangeHandler);
			_youtubePlayer.addEventListener("onPlaybackQualityChange", _onPlaybackQualityChangeHandler);
		}
		private function _onReadyHandler(e:Event):void {				
			dispatchEvent(new Event(READY));
			if (!_isReady) {
				_isReady = true;			
				addEventListener(Event.ENTER_FRAME , _enterFrameHandler);
			}			
		}		
		
		private function _enterFrameHandler(e:Event):void {
			//trace(getCurrentTime() , getDuration());
			dispatchEvent(new StreamEvent(StreamEvent.STREAM_PROGRESS, getCurrentTime() / getDuration()));
			dispatchEvent(new StreamEvent(StreamEvent.FILE_LOAD_PROGRESS, getVideoBytesLoaded() / getVideoBytesTotal()));
		}
		private function _onErrorHandler(e:Event):void{
			dispatchEvent(new Event(ERROR));
		}
		private function _onStateChangeHandler(e:Event):void {			
			//trace(Object(e).data, getPlayerStateToString());
			//dispatchEvent(new VideoStateEventEvent(VideoStateEventEvent.STATE_CHANGE, Object(e).data));				
			dispatchEvent(new VideoStateEvent(VideoStateEvent.STATE_CHANGE, getPlayerStateToString() ));				
		}		
		private function _onPlaybackQualityChangeHandler(e:Event):void {
			dispatchEvent(new Event(QUALITY_CHANGE));
		}				
		public function loadVideoById(pVideoId:String, pStartSeconds:Number = 0, pSuggestedQuality:String = "small"):void {						
			if (!_youtubePlayer) return;
			if (_autoPlay)	
				_youtubePlayer.loadVideoById(pVideoId, pStartSeconds, pSuggestedQuality);			
			else
				_youtubePlayer.cueVideoById(pVideoId, pStartSeconds, pSuggestedQuality);							
		}
		/**
		 * loadVideoByUrl
		 * @param pMediaContentUrl YouTube player URL in the format http://www.youtube.com/v/VIDEO_ID.
		 * @param pStartSeconds
		 */
		public function loadVideoByUrl(pMediaContentUrl:String, pStartSeconds:Number = 0):void {
			if (!_youtubePlayer) return;
			if (_autoPlay)			
				_youtubePlayer.loadVideoByUrl(pMediaContentUrl, pStartSeconds);				
			else
				_youtubePlayer.cueVideoByUrl(pMediaContentUrl, pStartSeconds);							
		}				
		/**
		 * Plays the currently cued/loaded video.
		 */		
		public function playVideo():void {
			if(_youtubePlayer) 
				_youtubePlayer.playVideo();	
			_isPlay = true;
		}
		
		/**
		 * Pauses the currently playing video.
		 */		
		public function pauseVideo():void {
			if(_youtubePlayer) 
				_youtubePlayer.pauseVideo();	
			_isPlay = false;
		}		
		/**
		 * Stops the current video. This function also cancels the loading of the video.
		 */		
		public function stopVideo():void {
			if(_youtubePlayer) 
				_youtubePlayer.stopVideo();			
		}
		
		/**
		 * Seeks to the specified time of the video in seconds. 
		 * The seekTo() function will look for the closest keyframe before the seconds specified.
		 * This means that sometimes the play head may seek to just before the requested time,
		 * usually no more than ~2 seconds.
		 * @param pSeconds
		 * @param pAllowSeekAhead The allowSeekAhead parameter determines whether or not the player will make a new request to the server if seconds is beyond the currently loaded video data.
		 */		
		public function seekTo(pSeconds:Number, pAllowSeekAhead:Boolean=true):void {
			if(_youtubePlayer) 
				_youtubePlayer.seekTo(pSeconds, pAllowSeekAhead);			
		}
		
		//-----------------------------------
		//
		// Changing the player volume
		//
		//-----------------------------------
		/**
		 * Mutes the player.
		 */		
		public function mute():void {
			if(_youtubePlayer) 
				_youtubePlayer.mute();			
		}		
		/**
		 * Unmutes the player.
		 */		
		public function unMute():void {
			if(_youtubePlayer) 
				_youtubePlayer.unMute();			
		}
		
		/**
		 * Returns true if the player is muted, false if not.
		 */		
		public function isMuted():Boolean {
			if(_youtubePlayer) 
				return _youtubePlayer.isMuted();			
			return false;
		}
		
		public function isPlayed():Boolean {
			if ( _youtubePlayer )
				if( _isReady )
					return _isPlay;
			return false;
		}
		
		/**
		 * Sets the volume. Accepts an integer between 0 and 100.
		 */		
		public function setVolume(pVolume:Number):void {
			if(_youtubePlayer) 
				_youtubePlayer.setVolume(pVolume);			
		}
		
		/**
		 * Returns the player's current volume, an integer between 0 and 100.
		 * Note that getVolume() will return the volume even if the player is muted.
		 */		
		public function getVolume():Number {
			if(_youtubePlayer) 
				return _youtubePlayer.getVolume();			
			return NaN;
		}	
		/**
		 * Sets the size in pixels of the player.
		 * This method should be used instead of setting the width and height properties of the MovieClip.
		 * Note that this method does not constrain the proportions of the video player,
		 * so you will need to maintain a 4:3 aspect ratio.
		 * The default size of the chromeless SWF when loaded into another SWF is 320px by 240px 
		 * and the default size of the embedded player SWF is 480px by 385px.
		 */		
		public function setSize(pWidth:int, pHeight:int):void {
			if(_youtubePlayer) 
				_youtubePlayer.setSize(pWidth, pHeight);			
		}
		
		//-----------------------------------
		//
		// Playback status
		//
		//-----------------------------------
		/**
		 * Returns the number of bytes loaded for the current video.
		 */		
		public function getVideoBytesLoaded():Number {
			if(_youtubePlayer) 
				return _youtubePlayer.getVideoBytesLoaded();			
			return NaN;
		}		
		/**
		 * Returns the size in bytes of the currently loaded/playing video.
		 */		
		public function getVideoBytesTotal():Number {
			if(_youtubePlayer) 
				return _youtubePlayer.getVideoBytesTotal();			
			return NaN;
		}
		
		/**
		 * Returns the number of bytes the video file started loading from.
		 * Example scenario: the user seeks ahead to a point that hasn't loaded yet,
		 * and the player makes a new request to play a segment of the video that hasn't loaded yet.
		 */		
		public function getVideoStartBytes():Number {
			if(_youtubePlayer) 
				return _youtubePlayer.getVideoStartBytes();			
			return NaN;
		}
		
		/**
		 * Returns the state of the player.
		 * Possible values are unstarted (-1), ended (0), playing (1), paused (2), buffering (3), video cued (5).
		 */		
		public function getPlayerState():Number {
			if(_youtubePlayer) 
				return _youtubePlayer.getPlayerState();			
			return NaN;
		}
		
		/**
		 * Returns the state STRING FORMAT of the player.
		 */
		public function getPlayerStateToString():String {			
			var _playerState:int = _youtubePlayer.getPlayerState();
			/**
			* This event is fired whenever the player's state changes. Possible values are 
			* unstarted (-1), ended (0), playing (1), paused (2), buffering (3), video cued (5). 
			* When the SWF is first loaded it will broadcast an unstarted (-1) event. 
			* When the video is cued and ready to play it will broadcast a video cued event (5).
			*/
			switch (_playerState){
				case-1:	return VideoStateEvent.UNSTARTED;
				case 0:	return VideoStateEvent.ENDED;
				case 1:	return VideoStateEvent.PLAYING;
				case 2:	return VideoStateEvent.PAUSED;
				case 3:	return VideoStateEvent.BUFFERING;
				case 5:	return VideoStateEvent.VIDEO_CUED;
			}			
			return null;
		}
		
		
		/**
		 * Returns the elapsed time in seconds since the video started playing.
		 */		
		public function getCurrentTime():Number {
			if(_youtubePlayer) 
				return _youtubePlayer.getCurrentTime();			
			return NaN;
		}
		
		//-----------------------------------
		//
		// Playback status
		//
		//-----------------------------------
		/**
		 * This function retrieves the actual video quality of the current video.
		 * It returns undefined if there is no current video.
		 * Possible return values are hd720, large, medium and small.
		 */		
		public function getPlaybackQuality():String {
			if(_youtubePlayer) 
				return _youtubePlayer.getPlaybackQuality();			
			return "undefined";
		}
		
		/**
		 * Quality level small: Player resolution less than 640px by 360px.
		 * Quality level medium: Minimum player resolution of 640px by 360px.
		 * Quality level large: Minimum player resolution of 854px by 480px.
		 * Quality level hd720: Minimum player resolution of 1280px by 720px.
		 * It returns undefined if there is no current video.
		 * Possible return values are hd720, large, medium and small.
		 */		
		public function setPlaybackQuality(suggestedQuality:String):void {
			if(_youtubePlayer) 
				_youtubePlayer.setPlaybackQuality(suggestedQuality);			
		}		
		/**
		 * This function returns the set of quality formats in which the current video is available.
		 * Possible array element values are hd720, large, medium and small.
		 */		
		public function getAvailableQualityLevels():Array {
			if(_youtubePlayer) 
				return _youtubePlayer.getAvailableQualityLevels();			
			return null;
		}
		
		//-----------------------------------
		//
		// Playback status
		//
		//-----------------------------------
		/**
		 * Returns the duration in seconds of the currently playing video.
		 * Note that getDuration() will return 0 until the video's metadata is loaded,
		 * which normally happens just after the video starts playing.
		 */		
		public function getDuration():Number {
			if(_youtubePlayer) 
				return _youtubePlayer.getDuration();			
			return NaN;
		}
		
		/**
		 * Returns the YouTube.com URL for the currently loaded/playing video.
		 */		
		public function getVideoUrl():String {
			if(_youtubePlayer) 
				return _youtubePlayer.getVideoUrl();			
			return "";
		}
		
		/**
		 * Returns the embed code for the currently loaded/playing video.
		 */		
		public function getVideoEmbedCode():String {
			if(_youtubePlayer) 
				return _youtubePlayer.getVideoEmbedCode();			
			return "";
		}
		public function get autoPlay():Boolean {	return _autoPlay;	}				
		public function set autoPlay(pAutoplay:Boolean):void {	_autoPlay = pAutoplay;	}				
		//public function get youtubePlayer():Object { return _youtubePlayer; }
		//public function set source(pSource:String):void {
			//loadVideoById(pSource);			
		//}
		//-----------------------------------
		//
		// Special Functions
		//
		//-----------------------------------
		/**
		 * This function, which has not yet been implemented for the AS3 Player API,
		 * destroys the player instance.
		 * This method should be called before unloading the player SWF from your parent SWF.
		 * Important: 
		 * You should always call player.destroy() to unload a YouTube player. 
		 * This function will close the NetStream object 
		 * and stop additional videos from downloading after the player has been unloaded. 
		 * If your code contains additional references to the player SWF, 
		 * you also need to destroy those references separately when you unload the player.
		 */		
		
		public function destroy():void {				
			if(_youtubePlayer) {
				_youtubePlayer.removeEventListener("onReady", _onReadyHandler);
				_youtubePlayer.removeEventListener("onError", _onErrorHandler);
				_youtubePlayer.removeEventListener("onStateChange", _onStateChangeHandler);
				_youtubePlayer.removeEventListener("onPlaybackQualityChange", _onPlaybackQualityChangeHandler);				
				_youtubePlayer.destroy();				
				_youtubeLoader.unload();
				_youtubeLoader = null;
				_youtubePlayer = null;
			}			
			removeEventListener(Event.ENTER_FRAME , _enterFrameHandler);
		}		
				
		
	}
}