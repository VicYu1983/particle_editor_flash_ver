package org.vic.web 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author fff
	 */
	public class WebTools 
	{
		public static function replaceAndRescale( image:DisplayObject, cw:Number, ch:Number ):void {
			if ( image.width > image.height ) {
				var scaleFactor:Number = cw / image.width;
			}else {
				scaleFactor = ch / image.height;
			}
			image.scaleX = image.scaleY = scaleFactor;
			if ( image is Bitmap ) {
				Bitmap( image ).smoothing = true;
			}
			image.x = ( cw - image.width ) / 2;
			image.y = ( ch - image.height ) / 2;
		}
	}

}