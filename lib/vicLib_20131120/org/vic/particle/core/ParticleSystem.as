package org.vic.particle.core 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author vic
	 */
	public class ParticleSystem 
	{
		private var _pid:int = 0;
		private var _ary_particle:Vector.<Particle> = new Vector.<Particle>();
		private var _ary_particleView:Vector.<ParticleView> = new Vector.<ParticleView>();
		private var _ary_texture:Vector.<BitmapData>;
		private var _container:DisplayObjectContainer;
		
		public function ParticleSystem( pc:DisplayObjectContainer ) 
		{
			_container = pc;
		}
		
		/**
		 * 更新所有粒子
		 */
		public function update(): void {
			var p:Particle;
			for each( p in _ary_particle ) {
				p.update();
			}
		}
		
		/**
		 * 讓所有粒子死亡
		 */
		public function letAllParticleToDie():void {
			var p:Particle;
			for each( p in _ary_particle ) {
				p.age = p.deadAge;
			}
		}
		
		/**
		 * 粒子出生
		 * @param	p	要出生的粒子
		 */
		public function onParticleBorn( p:Particle ):void {
			p.age = 0;
			p.setBornId( getBornId());
			
			var pv:ParticleView = new ParticleView();
			pv.setBornId( p.id );
			pv.setBitmapData( getTextureById( p.textureId ) );
			pv.visible = p.visible;
			pv.blendMode = p.textureMode;
			pv.x = p.pos.x;
			pv.y = p.pos.y;
			pv.z = p.pos.z;
			_container.addChild( pv );
			
			_ary_particle.push( p );
			_ary_particleView.push( pv );
		}
		
		/**
		 * 更新粒子視圖
		 * @param	p
		 */
		public function onParticleUpdate( p:Particle ):void {
			var pv:ParticleView = getParticleViewById( p.id );
			if ( pv ) {
				pv.update( p );
			}
		}
		
		/**
		 * 粒子死亡
		 * @param	p
		 */
		public function onParticleDead( p:Particle ):void {
			var pv:ParticleView = getParticleViewById( p.id );
			if ( pv ) {
				if ( _container.contains( pv )) {
					_container.removeChild( pv );
				}
				var deleteid:int = _ary_particle.indexOf( p );
				_ary_particle.splice( deleteid, 1 );
				_ary_particleView.splice( deleteid, 1 );
			}
		}
		
		/**
		 * 取得粒子視圖id
		 * @param	pid
		 * @return
		 */
		public function getParticleViewById( pid:int ):ParticleView {
			var pv:ParticleView;
			for each( pv in _ary_particleView ) {
				if ( pv.id == pid )
					return pv;
			}
			return null;
		}
		
		/**
		 * 新增貼圖
		 * @param	bitmapData
		 */
		public function addTexture( bitmapData:BitmapData ):void {
			if ( _ary_texture == null ) {
				_ary_texture = new Vector.<BitmapData>();
			}
			_ary_texture.push( bitmapData );
		}
		
		/**
		 * 移除貼圖
		 * @param	bitmapData
		 */
		public function removeTexture( bitmapData:BitmapData ):void {
			if ( _ary_texture == null )	return;
			var tid:int = _ary_texture.indexOf( bitmapData );
			if ( tid != -1 ) {
				_ary_texture.splice( tid, 1 );
			}
		}
		
		/**
		 * 移除所有貼圖
		 */
		public function removeAllTextures():void {
			if ( _ary_texture == null )	return;
			while ( _ary_texture.length ) {
				_ary_texture.pop();
			}
			_ary_texture = null;
		}
		
		/**
		 * 取得所有貼圖
		 * @return
		 */
		public function getTextures():Vector.<BitmapData> {
			return _ary_texture;
		}
		
		/**
		 * 取得貼圖
		 * @param	tid		貼圖id
		 * @return
		 */
		public function getTextureById( tid:int ):BitmapData {
			if ( tid < 0 )	return null;
			if ( _ary_texture == null ) {
				return null;
			}
			if ( _ary_texture.length <= tid ) {
				return null;
			}
			return _ary_texture[tid];
		}
		
		/**
		 * 取得粒子數量
		 * @return
		 */
		public function getParticleCount():int {
			if ( _ary_particle == null ) {
				return 0;
			}
			return _ary_particle.length;
		}
		
		private function getBornId():int {
			return _pid++;
		}
	}

}