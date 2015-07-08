package org.vic.web 
{
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @author fff
	 */
	public class WebCallJs 
	{
		private var _boss:WebMain;
		
		public function WebCallJs( boss:WebMain ) 
		{
			_boss = boss;
		}
		
		public function alert( msg:String ):void {
			callFunc( 'alert', msg );
		}
		
		public function callFunc( name:String, ...rest ):void {
			try
			{
				if( rest == null )
					ExternalInterface.call( name );
				else
				{
					ExternalInterface.call( name, rest );
				}
			}catch ( e:Error ) { }
		}
		
		public function addCallback( name:String, cb:Function ):void {
			try{
				ExternalInterface.addCallback( name, cb );
			}catch ( e:Error ) { };
		}
		
		protected function getBoss():WebMain {
			return _boss;
		}
	}

}