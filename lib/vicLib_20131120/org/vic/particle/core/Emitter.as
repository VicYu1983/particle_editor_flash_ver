package org.vic.particle.core 
{
	import flash.geom.Vector3D;
	import org.vic.particle.force.Force;
	/**
	 * ...
	 * @author vic
	 */
	public class Emitter extends Particle 
	{
		private var _particle:Particle;
		
		public function Emitter( ps:ParticleSystem, p:Particle ) 
		{
			super( ps );
			_particle = p;
		}
		
		override public function update():void 
		{
			super.update();
			
			var p:Particle = _particle.clone();
			p.pos = this.pos.clone();
			var ranPos:Vector3D = new Vector3D(
				Math.random() * p.random_pos.x - p.random_pos.x / 2,
				Math.random() * p.random_pos.y - p.random_pos.y / 2,
				Math.random() * p.random_pos.z - p.random_pos.z / 2
			);
			p.pos.incrementBy( ranPos );
			_particleSystem.onParticleBorn( p );
		}
		
		override public function clone():Particle 
		{
			var newP:Particle = new Emitter( _particleSystem, _particle );
			newP.visible = this.visible;
			newP.textureId = this.textureId;
			newP.textureMode = this.textureMode;
			newP.deadAge = this.deadAge;
			newP.random_deadAge = this.random_deadAge;
			newP.deadAge += newP.random_deadAge * Math.random() - newP.random_deadAge / 2;
			newP.acc = this.acc.clone();
			newP.vel = this.vel.clone();
			newP.scale = this.scale.clone();
			newP.scaleIn = this.scaleIn;
			newP.scaleOut = this.scaleOut;
			newP.alphaIn = this.alphaIn;
			newP.alphaOut = this.alphaOut;
			newP.rotation = this.rotation.clone();
			newP.rotVel = this.rotVel.clone();
			newP.random_rotation = this.random_rotation.clone();
			var ranRot:Vector3D = new Vector3D(
				Math.random() * newP.random_rotation.x - newP.random_rotation.x / 2,
				Math.random() * newP.random_rotation.y - newP.random_rotation.y / 2,
				Math.random() * newP.random_rotation.z - newP.random_rotation.z / 2
			);
			newP.rotation.incrementBy( ranRot );
			newP.random_scale = this.random_scale.clone();
			var ranSca:Vector3D = new Vector3D(
				Math.random() * newP.random_scale.x - newP.random_scale.x / 2,
				Math.random() * newP.random_scale.y - newP.random_scale.y / 2,
				Math.random() * newP.random_scale.z - newP.random_scale.z / 2
			);
			newP.scale.incrementBy( ranSca );
			newP.random_vel = this.random_vel.clone();
			var ranVel:Vector3D = new Vector3D(
				Math.random() * newP.random_vel.x - newP.random_vel.x / 2,
				Math.random() * newP.random_vel.y - newP.random_vel.y / 2,
				Math.random() * newP.random_vel.z - newP.random_vel.z / 2
			);
			newP.vel.incrementBy( ranVel );
			newP.random_pos = this.random_pos.clone();
			var f:Force;
			for each( f in _force ) {
				newP.addForce( f.clone() );
			}
			return newP;
		}
		
		override public function getSettingUsingObject():Object 
		{
			var setting:Object = { };
			setting.type = 'emitter';
			setting.visible = this.visible;
			setting.textureId = this.textureId;
			setting.textureMode = this.textureMode;
			setting.deadAge = this.deadAge;
			setting.random_deadAge = this.random_deadAge;
			setting.acc = { };
			setting.acc.x = this.acc.x;
			setting.acc.y = this.acc.y;
			setting.acc.z = this.acc.z;
			setting.vel = { };
			setting.vel.x = this.vel.x;
			setting.vel.y = this.vel.y;
			setting.vel.z = this.vel.z;
			setting.scale = { };
			setting.scale.x = this.scale.x;
			setting.scale.y = this.scale.y;
			setting.scale.z = this.scale.z;
			setting.scaleIn = this.scaleIn;
			setting.scaleOut = this.scaleOut;
			setting.alphaIn = this.alphaIn;
			setting.alphaOut = this.alphaOut;
			setting.rotation = { };
			setting.rotation.x = this.rotation.x;
			setting.rotation.y = this.rotation.y;
			setting.rotation.z = this.rotation.z;
			setting.rotVel = { };
			setting.rotVel.x = this.rotVel.x;
			setting.rotVel.y = this.rotVel.y;
			setting.rotVel.z = this.rotVel.z;
			setting.random_rotation = { };
			setting.random_rotation.x = this.random_rotation.x;
			setting.random_rotation.y = this.random_rotation.y;
			setting.random_rotation.z = this.random_rotation.z;
			setting.random_scale = { };
			setting.random_scale.x = this.random_scale.x;
			setting.random_scale.y = this.random_scale.y;
			setting.random_scale.z = this.random_scale.z;
			setting.random_vel = { };
			setting.random_vel.x = this.random_vel.x;
			setting.random_vel.y = this.random_vel.y;
			setting.random_vel.z = this.random_vel.z;
			setting.random_pos = { };
			setting.random_pos.x = this.random_pos.x;
			setting.random_pos.y = this.random_pos.y;
			setting.random_pos.z = this.random_pos.z;
			setting.force = [];
			var f:Force;
			for each( f in _force ) {
				setting.force.push( f.getSettingUsingObject() );
			}
			setting.particle = _particle.getSettingUsingObject();
			return setting;
		}
		
		override public function getSetting():XML 
		{
			var setting:XML = new XML( '<particleSetting></particleSetting>' );
			setting.type = 'emitter';
			setting.visible = this.visible;
			setting.textureId = this.textureId;
			setting.textureMode = this.textureMode;
			setting.deadAge = this.deadAge;
			setting.random_deadAge = this.random_deadAge;
			setting.acc.@x = this.acc.x;
			setting.acc.@y = this.acc.y;
			setting.acc.@z = this.acc.z;
			setting.vel.@x = this.vel.x;
			setting.vel.@y = this.vel.y;
			setting.vel.@z = this.vel.z;
			setting.scale.@x = this.scale.x;
			setting.scale.@y = this.scale.y;
			setting.scale.@z = this.scale.z;
			setting.scaleIn = this.scaleIn;
			setting.scaleOut = this.scaleOut;
			setting.alphaIn = this.alphaIn;
			setting.alphaOut = this.alphaOut;
			setting.rotation.@x = this.rotation.x;
			setting.rotation.@y = this.rotation.y;
			setting.rotation.@z = this.rotation.z;
			setting.rotVel.@x = this.rotVel.x;
			setting.rotVel.@y = this.rotVel.y;
			setting.rotVel.@z = this.rotVel.z;
			setting.random_rotation.@x = this.random_rotation.x;
			setting.random_rotation.@y = this.random_rotation.y;
			setting.random_rotation.@z = this.random_rotation.z;
			setting.random_scale.@x = this.random_scale.x;
			setting.random_scale.@y = this.random_scale.y;
			setting.random_scale.@z = this.random_scale.z;
			setting.random_vel.@x = this.random_vel.x;
			setting.random_vel.@y = this.random_vel.y;
			setting.random_vel.@z = this.random_vel.z;
			setting.random_pos.@x = this.random_pos.x;
			setting.random_pos.@y = this.random_pos.y;
			setting.random_pos.@z = this.random_pos.z;
			setting.force = '';
			var f:Force;
			for each( f in _force ) {
				setting.force.appendChild( f.getSetting() );
			}
			setting.particle = _particle.getSetting();
			return setting;
		}
	}

}