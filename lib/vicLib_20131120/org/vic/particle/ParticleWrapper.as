package org.vic.particle 
{
	import org.vic.particle.core.Emitter;
	import org.vic.particle.core.Particle;
	import org.vic.particle.core.ParticleSystem;
	/**
	 * ...
	 * @author vic
	 */
	public class ParticleWrapper 
	{
		public var name:String;
		
		private var _ps:ParticleSystem;
		private var _p:Particle;
		private var _e:Particle;
		private var _e2:Particle;
		
		public function ParticleWrapper( ps:ParticleSystem ) 
		{
			_ps = ps;
		}
		
		public function getParticleRoot():Particle {
			return _e2 == null ? _e : _e2;
		}
		
		public function setSetting( setting:Object, tid:int ):void {
			name = setting.saveName;
			
			trace( '粒子準備完成: ', name );
			
			switch( setting.level + '' ) {
				case '0':
					_p = new Particle( _ps );
					_e = new Emitter( _ps, _p );
					_p.setSettingUsingObject( setting.particleSetting.particle );
					_e.setSettingUsingObject( setting.particleSetting ); 
					resetTid( _p );
					resetTid( _e );
					break;
				case '1':
					_p = new Particle( _ps );
					_e = new Emitter( _ps, _p );
					_e2 = new Emitter( _ps, _e );
					_p.setSettingUsingObject( setting.particleSetting.particle.particle );
					_e.setSettingUsingObject( setting.particleSetting.particle );
					_e2.setSettingUsingObject( setting.particleSetting );
					resetTid( _p );
					resetTid( _e );
					resetTid( _e2 );
					break;
			}
			
			function resetTid( p:Particle ):void {
				if ( p.textureId != -1 ) {
					p.textureId += tid;
				}
			}
		}
		
		
	}

}