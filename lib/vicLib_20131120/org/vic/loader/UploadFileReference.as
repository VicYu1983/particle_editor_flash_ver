package org.vic.loader 
{
	import flash.display.Bitmap;	
	import flash.display.BitmapData;	
	import flash.display.Loader;	
	import flash.display.Sprite;	
	import flash.display.StageAlign;	
	import flash.display.StageScaleMode;	
	import flash.events.Event;	
	import flash.events.MouseEvent;	
	import flash.net.FileFilter;
	import flash.net.FileReference;	
	import flash.text.TextField;	
	import flash.text.TextFieldAutoSize;	
	import flash.text.TextFieldType;
	/**
	 * ...
	 * @author fff
	 */
	public class UploadFileReference 
	{
		private var file:FileReference=new FileReference();	
		private var loader:Loader = new Loader();
		
		public var onCompleteHandler:Function;
		
		public function onClick():void	
		{	
			var f:FileFilter=new FileFilter("Images", "*.jpg;*.gif;*.png");	
			file.browse([f]);		
			file.addEventListener(Event.SELECT,onSelect);	
		}	
		private function onSelect(event:Event):void	
		{	
			file.load();	
			file.addEventListener(Event.COMPLETE,onComplete);	
			file.removeEventListener(Event.SELECT,onSelect);	
		}	
		private function onComplete(event:Event):void	
		{	
			file.removeEventListener(Event.COMPLETE, onComplete);	
			loader.loadBytes(file.data);	
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete);	
		}	
		private function onLoadComplete(event:Event):void	
		{	
			var tempData:BitmapData = Bitmap( loader.contentLoaderInfo.content ).bitmapData;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);	
			if ( onCompleteHandler != null ) {
				onCompleteHandler( file.name, tempData );
			}
		}	
	}

}