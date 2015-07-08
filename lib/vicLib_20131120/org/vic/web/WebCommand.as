package org.vic.web 
{
	/**
	 * ...
	 * @author VicYu
	 */
	public class WebCommand 
	{
		private var _name:String;
		private var _boss:WebMain;
		
		public function WebCommand( boss:WebMain, name:String = null ) 
		{
			_boss = boss;
			_name = name;
		}
		
		protected function getBoss():WebMain {
			return _boss;
		}
		
		protected function getModel():WebModel {
			return getBoss().getModel();
		}
		
		public function getName():String {
			return _name;
		}
		
		public function execute( args:Array = null ):void {
			
		}
	}

}