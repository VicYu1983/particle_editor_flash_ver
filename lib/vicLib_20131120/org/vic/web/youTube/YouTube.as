package org.vic.web.youTube 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.flashdevelop.utils.FlashConnect;
	import org.vic.web.CallJs;
	import org.vic.web.youTube.media.YoutubeLoader;
	/**
	 * ...
	 * @author VicYu
	 */
	public class YouTube
	{
		private var _path:String;
		private var _youtube:YoutubeLoader;
		private var _youtubeContainer:DisplayObjectContainer;
		private var _width:Number;
		private var _height:Number;
		private var _goIcon:Sprite;
		
		public function YouTube( sgt:Sgt = null ) 
		{
			
		}
		
		public function setSize( width:Number, height:Number ):void {
			_width = width;
			_height = height;
		}
		
		public function setContainer( con:DisplayObjectContainer ):void {
			_youtubeContainer = con;
		}
		
		public function setPath( path:String ):void {
			_path = path;
		}
		
		public function startYoutube( haveController:Boolean = false ):void {
			_youtube = new YoutubeLoader( true, haveController );
			_youtube.addEventListener( YoutubeLoader.READY, onYouTubeReady );
			_youtubeContainer.addChild( _youtube );
		}
		
		public function stopYoutube():void {
			if ( _youtube != null )
			{
				_youtube.buttonMode = false;
				_youtube.removeEventListener( MouseEvent.CLICK, onClick );
				_youtube.removeEventListener( YoutubeLoader.READY, onYouTubeReady );
				_youtube.destroy();
				_youtube = null;
			}
			
			if ( _goIcon != null )
			{
				_goIcon.buttonMode = false;
				_goIcon.removeEventListener( MouseEvent.CLICK, onClick );
				if ( _youtubeContainer.contains( _goIcon ))
					_youtubeContainer.removeChild( _goIcon );
				_goIcon = null;
			}
		}
		
		public function getYoutube():YoutubeLoader {
			return _youtube;
		}
		
		private function onYouTubeReady( e:Event ):void {
			
			if ( _youtube != null )
			{
				_youtube.removeEventListener( YoutubeLoader.READY, onYouTubeReady );
				_youtube.loadVideoById( _path );
				_youtube.setSize( _width, _height );
			}
		}
		
		private function onClick( e:MouseEvent ):void {
			if( _youtube.isPlayed() )
				_youtube.pauseVideo();
			else
				_youtube.playVideo();
		}
	}

}

class Sgt { }