package org.vic.web.leoburnet 
{
	import flash.external.ExternalInterface;
	import org.vic.web.WebCallJs;
	import org.vic.web.WebMain;
	/**
	 * ...
	 * @author fff
	 */
	public class LeoCallJs extends WebCallJs
	{
		public function LeoCallJs( boss:WebMain ) {
			super( boss );
			
		}
		public function fbLogin():void {
			callFunc( 'fnFBLogin' );
		}
		
		/**
		 * 
		 * @param	value	要分享的圖的檔名
		 */
		public function fnFBSharing( value:String ):void {
			callFunc( 'fnFBSharing', value );
		}
		
		public function fnGetAlbums():void {
			callFunc( 'fnGetAlbums' );
		}
		
		public function trackingButton( value:String ):void {
			callFunc( '_gaCK', value );
		}

		public function trackingPage( value:String ):void { 	
			callFunc( '_gaPV', value );
		}
		
	}

}