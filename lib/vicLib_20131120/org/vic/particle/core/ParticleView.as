package org.vic.particle.core 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import org.vic.utils.BasicUtils;
	
	/**
	 * ...
	 * @author vic
	 */
	public class ParticleView extends Sprite 
	{
		public var id:int;
		private var _particle:Particle;
		private var _bitmap:Bitmap;
		
		public function ParticleView() 
		{
			super();
		}
		
		public function setBornId( pid:int ):void {
			this.id = pid;
		}
		
		public function setBitmapData( bitmapData:BitmapData ):void {
			if( bitmapData != null ){
				_bitmap = new Bitmap( bitmapData );
				_bitmap.x = -_bitmap.width / 2;
				_bitmap.y = -_bitmap.height / 2;
				addChild(_bitmap );
			}else {
				BasicUtils.drawRect( graphics, 0xff0000 );
			}
		}
		
		public function update( p:Particle ):void {
			visible = p.visible;
			x = p.pos.x;
			y = p.pos.y;
			z = p.pos.z;
			scaleX = p.scale.x * p.scaleVal;
			scaleY = p.scale.y * p.scaleVal;
			scaleZ = p.scale.z * p.scaleVal;
			rotationX = p.rotation.x;
			rotationY = p.rotation.y;
			rotationZ = p.rotation.z;
			alpha = p.alphaVal;
			
			if( p.textureMode != null )
				blendMode = p.textureMode;
		}
	}

}