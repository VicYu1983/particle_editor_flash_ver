package  
{
	import com.adobe.images.PNGEncoder;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import mx.utils.Base64Decoder;
	/**
	 * ...
	 * @author vic
	 */
	public class TestDecodePNG extends Sprite
	{
		public function TestDecodePNG() 
		{
			var base64Str:String = "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\nAABJRU5ErkJggg=="
			var base64Encoder:Base64Decoder = new Base64Decoder();
			base64Encoder.decode( base64Str );
			var byteAry:ByteArray = base64Encoder.toByteArray();
			
			//用loader，成功
			var lr:Loader = new Loader();
			lr.loadBytes( byteAry );
			lr.x = 400;
			addChild( lr );
			
			//用bitmapData的方法會失敗，不曉得原因
			/*
			var bmd:BitmapData = new BitmapData( 16, 16, true, 0 );
			bmd.setPixels( new Rectangle(0, 0, 16, 16 ), byteAry );
			var bm:Bitmap = new Bitmap( bmd, 'auto', true );
			bm.x = 400;
			addChild( bm );
			*/
			
			
		}
		
	}

}