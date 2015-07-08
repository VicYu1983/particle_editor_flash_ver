package org.vic.particle.force 
{
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author vic
	 */
	public class DragForce extends Force 
	{
		private var _force:Number; 
		public function DragForce( p:Number ) 
		{
			super( p );
			
			name = Force.DRAG;
			cname = '阻力';
			
			this.power = power;
		}
		
		override public function get power():Number 
		{
			return super.power;
		}
		
		override public function set power(value:Number):void 
		{
			super.power = value;
			_force = power;
		}
		
		override public function update( pvel:Vector3D ):void 
		{
			super.update( pvel );
			pvel.scaleBy( _force );
		}
		
		override public function clone():Force 
		{
			return new DragForce( power );
		}
	}

}