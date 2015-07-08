package  org.vic.sliderPanel
{
	import flash.display.Sprite;
	import org.vic.display.FakeMovieClip;
	
	/**
	 * ...
	 * @author fff
	 */
	public class BasicSliderPanel extends Sprite implements ISliderPanel 
	{
		private var _name:String;
		
		public function BasicSliderPanel() 
		{
			addChild( new FakeMovieClip('', 400, 600 ));
		}
		
		public function setName(name:String):void 
		{
			_name = name;
		}
		
		public function getName():String 
		{
			return _name;
		}
		
		public function gotoBack():void 
		{
			//release
		}
		
		public function gotoFront():void 
		{
			//focus
		}
		
	}

}