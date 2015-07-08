package org.vic.display{

import flash.display.MovieClip;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

/**
 * ...
 * @author VicYu
 */
	public dynamic class FakeMovieClip extends MovieClip
	{
		private var _name:TextField;
		private var _txt_frame:TextField;

		public function FakeMovieClip( name:String, width:Number = 100, height:Number = 100 ) 
		{
			super();
			
			var rc:int =  Math.random() * 0xffffff;
			graphics.beginFill( rc );
			graphics.drawRect( 0, 0, width, height );
			graphics.endFill();
			
			_name = new TextField();
			_name.text = name;
			_name.mouseEnabled = false;
			_name.autoSize = TextFieldAutoSize.LEFT;
			addChild( _name );
			
			_txt_frame = new TextField();
			_txt_frame.text = "F_1";
			_txt_frame.y = 20;
			_txt_frame.mouseEnabled = false;
			addChild( _txt_frame);
		}
		
		override public function gotoAndStop(frame:Object, scene:String = null):void 
		{
			super.gotoAndStop(frame, scene);
			
			_txt_frame.text = 'F_' + frame;
		}
	}
}