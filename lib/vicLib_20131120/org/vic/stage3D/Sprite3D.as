package org.vic.stage3D 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author VicYu
	 */
	public class Sprite3D extends Sprite 
	{
		public var focusLength:Number = 100;
		public var position:Vector3D = new Vector3D();
		public var vp:Point = new Point();
		
		public function Sprite3D() 
		{
			super();
			
			graphics.lineStyle(1);
			graphics.beginFill(Math.random() * 0xffffff);
			graphics.drawRect(0, 0, 100, 100 );
			graphics.endFill();
		}
		
		public function render3D():void {
			var scaleFactor:Number = getScaleFactor();
			var posx:Number = position.x - vp.x;
			var posy:Number = position.y - vp.y;
			x = vp.x + posx * scaleFactor;
			y = vp.y + posy * scaleFactor;
			scaleX = scaleY = scaleFactor;
		}
		
		private function getScaleFactor():Number {
			return focusLength / ( focusLength + position.z );
		}
	}

}