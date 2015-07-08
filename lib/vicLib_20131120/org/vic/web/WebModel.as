package org.vic.web 
{
	/**
	 * ...
	 * @author VicYu
	 */
	public class WebModel 
	{
		private var _boss:WebMain;
		
		public function WebModel( boss:WebMain ) 
		{
			_boss = boss;
		}
		
		public function getBoss():WebMain {
			return _boss;
		}
		
		public function getVersion():String {
			return '';
		}
	}

}