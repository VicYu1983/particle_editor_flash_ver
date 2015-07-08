package org.vic.utils 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author fff
	 */
	public class BasicUtils 
	{
		public static function drawRect( g:Graphics, color:uint = 0, alpha:Number = 1, width:Number = 10, height:Number = 10 ):void {
			g.beginFill( color, alpha );
			g.drawRect( 0, 0, width, height );
			g.endFill();
		}
		
		public static function hasLabel( mc:MovieClip, labelName:String ):Boolean {
			var ary_label:Array = mc.currentLabels;
			var i:int = 0;
			for (; i < ary_label.length; ++i ) {
				var ln:String = ary_label[i].name;
				if ( ln == labelName )
					return true;
			}
			return false;
		}
		
		public static function revealObj( disObj:DisplayObject, doFunc:Function ):void {
			doFunc( disObj );
			if ( disObj is DisplayObjectContainer ) {
				var disObjCon:DisplayObjectContainer = disObj as DisplayObjectContainer;
				var i:int = 0;
				var max:int = disObjCon.numChildren;
				for ( ; i < max; ++i ) {
					revealObj( disObjCon.getChildAt( i ) as DisplayObject, doFunc );
				}
			}
		}
		
		public static function delayCall( delay:Number, doFunc:Function ):int {
			var timeoutId:int = setTimeout( function():void {
				doFunc();
				clearTimeout( timeoutId );
			}, delay );
			return timeoutId;
		}
		
		public static function stopMovieClip( mc:DisplayObject ):void {
			revealObj( mc, function( disObj:DisplayObject ):void {
				if ( disObj is MovieClip ) {
					MovieClip( disObj ).stop();
				}
			});
		}
		
		public static function playMovieClip( mc:DisplayObjectContainer ):void {
			revealObj( mc, function( disObj:DisplayObject ):void {
				if ( disObj is MovieClip ) {
					MovieClip( disObj ).play();
				}
			});
		}
		
	}

}