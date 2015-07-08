package org.vic.web 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author fff
	 */
	public class BasicButton 
	{
		private var _boss:WebMain;
		private var _shape:MovieClip;
		
		public function BasicButton( boss:WebMain, shape:MovieClip ) 
		{
			_shape = shape;
			_boss = boss;
		}
		
		public function setCommandName( cn:String ):void {
			getShape().commandName = cn;
		}
		
		public function getCommandName():String {
			return getShape().commandName;
		}
		
		public function getShape():MovieClip {
			return _shape;
		}
		
		protected function getBoss():WebMain {
			return _boss;
		}
		
		public function enable( e:Boolean ):void {
			getShape().mouseEnabled = e;
			getShape().mouseChildren = e;
			/*
			if ( e ) {
				getShape().alpha = 1;
			}else {
				getShape().alpha = .4;
			}*/
		}
	}

}