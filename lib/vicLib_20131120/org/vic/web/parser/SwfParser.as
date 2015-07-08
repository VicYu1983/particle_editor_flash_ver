package org.vic.web.parser
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import org.vic.loader.LoaderManager;
	import org.vic.web.BasicButton;
	import org.vic.web.BasicSlider;
	import org.vic.web.WebMain;
	import org.vic.web.WebView;

	/**
	 * ...
	 * @author VicYu
	 */
	public class SwfParser
	{
		public static function movieClipParser( boss:WebMain, visitor:WebView, container:DisplayObjectContainer, buttons:Vector.<BasicButton>, sliders:Vector.<BasicSlider> ):void {
			var i:int;
			for ( i = 0; i < container.numChildren; ++i )
			{
				var childDisObj:DisplayObject = container.getChildAt( i );
				if ( childDisObj is WebView ) {
					continue;
				}
				
				processContainer( boss, visitor, childDisObj, buttons, sliders );
				
				if ( childDisObj is DisplayObjectContainer )
				{
					var childDisObjCon:DisplayObjectContainer = childDisObj as DisplayObjectContainer;
					movieClipParser( boss, visitor, childDisObjCon, buttons, sliders );
				}
			}
		}
		
		private static function processContainer( boss:WebMain, visitor:WebView, container:DisplayObject, buttons:Vector.<BasicButton>, sliders:Vector.<BasicSlider> ):void {
			var name:String = container.name;
			var ary_name:Array = name.split( "_" );
			var type:String = ary_name[0];
			
			if ( container is MovieClip ) {
				var commandName:String = ary_name[1];
				var symbol:String = ary_name[2];
				if ( commandName != null ) {
					MovieClip( container ).commandName = commandName;
					MovieClip( container ).symbol = symbol;
				}
			}
			
			switch( type ) {
				case 'btn':
					createBtn();
					break;
				case 'slider':
					createSlider();
					break;
				case 'txt':
					createTextField();
			}
			
			function createBtn():void {
				var basicButton:BasicButton = new BasicButton( boss, container as MovieClip );
				visitor.addButton( basicButton );
			}
			
			function createSlider():void {
				var basicSlider:BasicSlider = new BasicSlider( visitor, container as MovieClip );
				visitor.addSlider( basicSlider );
			}
			
			function createTextField():void {
				visitor.addTextField( container as TextField );
			}
			
		}
		
	}
}