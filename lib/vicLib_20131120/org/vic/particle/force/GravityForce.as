package org.vic.particle.force 
{
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author vic
	 */
	public class GravityForce extends Force 
	{
		public function GravityForce( p:Number ) 
		{
			super( p );
			
			name = Force.GRAVITY;
			cname = '重力';
			
			this.power = p;
		}
		
		override public function set power(value:Number):void 
		{
			super.power = value;
			acc.y = power;
		}
		
		override public function update( pvel:Vector3D ):void 
		{
			super.update( pvel );
			vel.incrementBy( acc );
			pvel.incrementBy( vel );
		}
		
		override public function clone():Force 
		{
			return new GravityForce( acc.y );
		}
	}

}