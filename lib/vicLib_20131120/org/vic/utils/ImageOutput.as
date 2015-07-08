package  org.vic.utils 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import mx.graphics.codec.JPEGEncoder;
	import mx.graphics.codec.PNGEncoder;
	/**
	 * ...
	 * @author fff
	 */
	public class ImageOutput 
	{
		public static function startJPEG( targetImage:DisplayObject, path:String, quality:int = 85 ):void {
			path = fixWord( path );
			var bitmapData:BitmapData = new BitmapData(targetImage.width, targetImage.height);
			bitmapData.draw(targetImage);
			
			var jpgEnc:JPEGEncoder = new JPEGEncoder(quality);
			var jpgByteArray:ByteArray = jpgEnc.encode(bitmapData);
			var jpgFile:File = File.desktopDirectory.resolvePath( path );
			
			var fs:FileStream = new FileStream();
			
			try{
				fs.open(jpgFile,FileMode.WRITE);
				fs.writeBytes(jpgByteArray);
				fs.close();
			}catch (e:Error) { }
		}
		
		public static function startPNG( targetImage:DisplayObject, path:String ):void {
			path = fixWord( path );
			var bitmapData:BitmapData = new BitmapData(targetImage.width, targetImage.height);
			bitmapData.draw(targetImage);
			
			var jpgEnc:PNGEncoder = new PNGEncoder();
			var jpgByteArray:ByteArray = jpgEnc.encode(bitmapData);
			var jpgFile:File = File.desktopDirectory.resolvePath( path );
			var fs:FileStream = new FileStream();
			
			try{
				fs.open(jpgFile,FileMode.WRITE);
				fs.writeBytes(jpgByteArray);
				fs.close();
			}catch (e:Error) { }
		}
		
		private static function fixWord( old:String ):String {
			old = old.split( '-' ).join( '_' );
			old = old.split( '.' ).join( '_' );
			old = old.split( ' ' ).join( '_' );
			old = old.split( '_jpg' ).join( '.jpg' );
			old = old.split( '_png' ).join( '.png' );
			return old;
		}
	}

}