package  org.vic.web.leoburnet 
{
	import com.adobe.images.JPGEncoder;
	import flash.display.BitmapData;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.JPEGLoaderContext;
	import flash.utils.ByteArray;
	import org.vic.web.WebMain;
	import org.vic.web.WebURLLoader;
	import org.vic.web.WebURLMultipart;
	
	/**
	 * ...
	 * @author VicYu
	 */
	public class LeoUrlLoader extends WebURLLoader 
	{
		
		public function LeoUrlLoader(boss:WebMain) 
		{
			super(boss);
			
		}
		
		public function setProfile( n:String, t:String, m:String, a:String, cb:Function ):void {
			var ua:URLVariables = new URLVariables();
			ua.n = n;
			ua.t = t;
			ua.m = m;
			ua.a = a;
			
			var ur:URLRequest = new URLRequest( 'bo/_saveData.asp' );
			ur.data = ua;
			ur.method = URLRequestMethod.POST;
			
			addTask( ur, cb );
		}
		
		public function uploadImage( f:String, s:String, n:String, image:BitmapData, callback:Function = null ):void {
			if ( CONFIG::debug )
				return ;
			
			var jpgEncoder:JPGEncoder = new JPGEncoder( 100 );
			var imageByteAry:ByteArray = jpgEncoder.encode( image );
			
			var multi:WebURLMultipart = new WebURLMultipart( 'bo/_saveImg.php' );
			multi.addField( 'f', f );
			multi.addField( 's', s );
			multi.addField( 'n', n );
			multi.addFile( 'upload', imageByteAry, 'image/jpeg', f + '_' + s +'.jpg' );
			
			addTask( multi.request );
		}
	}

}