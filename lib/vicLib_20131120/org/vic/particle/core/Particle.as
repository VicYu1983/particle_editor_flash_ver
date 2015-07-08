package  org.vic.particle.core
{
	import flash.geom.Vector3D;
	import org.vic.event.VicEvent;
	import org.vic.event.VicEventDispatcher;
	import org.vic.particle.force.DragForce;
	import org.vic.particle.force.Force;
	import org.vic.particle.force.GravityForce;
	/**
	 * ...
	 * @author vic
	 */
	public class Particle extends VicEventDispatcher
	{
		//粒子id
		public var id:int;
		//可見性
		public var visible:Boolean = true;
		//材質id
		public var textureId:int = -1;
		//mode
		public var textureMode:String = 'normal';
		//年齡
		public var age:int = 0;
		//死亡年齡
		public var deadAge:int = 10;
		//位置
		public var pos:Vector3D = new Vector3D();
		//速度
		public var vel:Vector3D = new Vector3D();
		//加速度
		public var acc:Vector3D = new Vector3D();
		//大小
		public var scale:Vector3D = new Vector3D( 1, 1, 1 );
		//旋轉
		public var rotation:Vector3D = new Vector3D();
		//角加速度
		public var rotAcc:Vector3D = new Vector3D();
		//角速度
		public var rotVel:Vector3D = new Vector3D();
		//隨機死亡年齡
		public var random_deadAge:int = 0;
		//隨機位置
		public var random_pos:Vector3D = new Vector3D();
		//隨機速度
		public var random_vel:Vector3D = new Vector3D();
		//隨機大小
		public var random_scale:Vector3D = new Vector3D();
		//隨機角度
		public var random_rotation:Vector3D = new Vector3D();
		//縮小進場
		public var scaleIn:int = 0;
		//縮小出場
		public var scaleOut:int = 0;
		//alpha進場
		public var alphaIn:int = 0;
		//alpha出場
		public var alphaOut:int = 0;
		//縮放系數
		internal var scaleVal:Number = 1;
		//alpha系數
		internal var alphaVal:Number = 1;
		//力
		protected var _force:Vector.<Force>;
		
		protected var _particleSystem:ParticleSystem;
		
		public function Particle( ps:ParticleSystem ) 
		{
			_particleSystem = ps;
		}
		
		public function setBornId( pid:int ):void {
			this.id = pid;
		}
		
		public function update():void {
			age++;
			if ( age > deadAge ) {
				_particleSystem.onParticleDead( this );
				return ;
			}
			
			var scaleStartAge:int = deadAge - scaleOut;
			var val:Number = 1;
			if ( age > scaleStartAge ) {
				val = 1 - ( age - scaleStartAge ) / scaleOut;
				scaleVal = val;
			}
			if ( age < scaleStartAge ) {
				val = age / scaleIn > 1 ? 1 : age / scaleIn;
				scaleVal = val;
			}
			var alphaStartAge:int = deadAge - alphaOut;
			if ( age > alphaStartAge ) {
				val = 1 - ( age - alphaStartAge ) / alphaOut;
				alphaVal = val;
			}
			if ( age < alphaStartAge ) {
				val = age / alphaIn > 1 ? 1 : age / alphaIn;
				alphaVal = val;
			}
			
			vel.incrementBy( acc );
			rotVel.incrementBy( rotAcc );
			executeForce();
			pos.incrementBy( vel );
			rotation.incrementBy( rotVel );
			_particleSystem.onParticleUpdate( this );
		}
		
		public function clone():Particle {
			var newP:Particle = new Particle( _particleSystem );
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
		
		public function addForce( force:Force ):void {
			if ( _force == null ) {
				_force = new Vector.<Force>();
			}
			_force.push( force );
		}
		
		public function removeForce( force:Force ):void {
			if ( _force == null )	return;
			var fid:int = _force.indexOf( force );
			if ( fid != -1 ) {
				_force.splice( fid, 1 );
			}
		}
		
		public function getForce():Vector.<Force> {
			return _force;
		}
		
		public function getSettingUsingObject():Object {
			var setting:Object = { };
			setting.type = 'particle';
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
			return setting;
		}
		
		public function getSetting():XML {
			var setting:XML = new XML( '<particleSetting></particleSetting>' );
			setting.type = 'particle';
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
			return setting;
		}
		
		public function setSettingUsingObject( setting:Object ):void {
			this.visible = setting.visible;
			this.textureId = setting.textureId;
			this.textureMode = setting.textureMode;
			this.deadAge = setting.deadAge;
			this.random_deadAge = setting.random_deadAge;
			this.acc.x = setting.acc.x;
			this.acc.y = setting.acc.y;
			this.acc.z = setting.acc.z;
			this.vel.x = setting.vel.x;
			this.vel.y = setting.vel.y;
			this.vel.z = setting.vel.z;
			this.scale.x = setting.scale.x;
			this.scale.y = setting.scale.y;
			this.scale.z = setting.scale.z;
			this.scaleIn = setting.scaleIn;
			this.scaleOut = setting.scaleOut;
			this.alphaIn = setting.alphaIn;
			this.alphaOut = setting.alphaOut;
			this.rotation.x = setting.rotation.x;
			this.rotation.y = setting.rotation.y;
			this.rotation.z = setting.rotation.z;
			this.rotVel.x = setting.rotVel.x;
			this.rotVel.y = setting.rotVel.y;
			this.rotVel.z = setting.rotVel.z;
			this.random_rotation.x = setting.random_rotation.x;
			this.random_rotation.y = setting.random_rotation.y;
			this.random_rotation.z = setting.random_rotation.z;
			this.random_scale.x = setting.random_scale.x;
			this.random_scale.y = setting.random_scale.y;
			this.random_scale.z = setting.random_scale.z;
			this.random_vel.x = setting.random_vel.x;
			this.random_vel.y = setting.random_vel.y;
			this.random_vel.z = setting.random_vel.z;
			this.random_pos.x = setting.random_pos.x;
			this.random_pos.y = setting.random_pos.y;
			this.random_pos.z = setting.random_pos.z;
			if ( setting.force != null ) {
				var i:int = 0;
				var max:int = setting.force.length;
				var forceName:String;
				var force:Force;
				for (; i < max; ++i ) {
					forceName = setting.force[i].name;
					switch( forceName ) {
						case Force.DRAG:
							force = new DragForce( 0 );
							break;
						case Force.GRAVITY:
							force = new GravityForce( 0 );
							break;
					}
					force.setSettingUsingObject( setting.force[i] );
					addForce( force );
				}
			}
		}
		
		public function setSetting( setting:XML ):void {
			this.visible = setting.visible == 'true' ? true : false;
			this.textureId = setting.textureId;
			this.textureMode = setting.textureMode;
			this.deadAge = setting.deadAge;
			this.random_deadAge = setting.random_deadAge;
			this.acc.x = setting.acc.@x;
			this.acc.y = setting.acc.@y;
			this.acc.z = setting.acc.@z;
			this.vel.x = setting.vel.@x;
			this.vel.y = setting.vel.@y;
			this.vel.z = setting.vel.@z;
			this.scale.x = setting.scale.@x;
			this.scale.y = setting.scale.@y;
			this.scale.z = setting.scale.@z;
			this.scaleIn = setting.scaleIn;
			this.scaleOut = setting.scaleOut;
			this.alphaIn = setting.alphaIn;
			this.alphaOut = setting.alphaOut;
			this.rotation.x = setting.rotation.@x;
			this.rotation.y = setting.rotation.@y;
			this.rotation.z = setting.rotation.@z;
			this.rotVel.x = setting.rotVel.@x;
			this.rotVel.y = setting.rotVel.@y;
			this.rotVel.z = setting.rotVel.@z;
			this.random_rotation.x = setting.random_rotation.@x;
			this.random_rotation.y = setting.random_rotation.@y;
			this.random_rotation.z = setting.random_rotation.@z;
			this.random_scale.x = setting.random_scale.@x;
			this.random_scale.y = setting.random_scale.@y;
			this.random_scale.z = setting.random_scale.@z;
			this.random_vel.x = setting.random_vel.@x;
			this.random_vel.y = setting.random_vel.@y;
			this.random_vel.z = setting.random_vel.@z;
			this.random_pos.x = setting.random_pos.@x;
			this.random_pos.y = setting.random_pos.@y;
			this.random_pos.z = setting.random_pos.@z;
			if ( setting.force.forceSetting != null ) {
				var i:int = 0;
				var max:int = setting.force.forceSetting.length();
				var forceName:String;
				var force:Force;
				for (; i < max; ++i ) {
					forceName = setting.force.forceSetting[i].@name;
					switch( forceName ) {
						case Force.DRAG:
							force = new DragForce( 0 );
							break;
						case Force.GRAVITY:
							force = new GravityForce( 0 );
							break;
					}
					force.setSetting( setting.force.forceSetting[i] );
					addForce( force );
				}
			}
		}
		
		private function executeForce():void {
			if ( _force ) {
				var i:int = 0;
				var max:int = _force.length;
				for (; i < max; ++i ) {
					var f:Force = _force[i];
					f.update( vel );
				}
			}
		}
	}

}