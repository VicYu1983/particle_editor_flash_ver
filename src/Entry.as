package  
{
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.vic.event.VicEvent;
	import org.vic.loader.UploadFileReference;
	import org.vic.particle.core.Emitter;
	import org.vic.particle.force.DragForce;
	import org.vic.particle.force.GravityForce;
	import org.vic.particle.core.Particle;
	import org.vic.particle.core.ParticleSystem;
	
	/**
	 * ...
	 * @author vic
	 */
	public class Entry extends Sprite 
	{
		private var _ps:ParticleSystem;
		private var _p:Particle;
		private var _em:Particle;
		private var _em2:Particle;
		
		public function Entry() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage );
		}
		
		public function createEmitter():void {
			clearParticle();
			_p = new Particle( _ps );
			_em = new Emitter( _ps, _p );
		}
		
		public function createEmitterSprayEmitter():void {
			clearParticle();
			_p = new Particle( _ps );
			_em = new Emitter( _ps, _p );
			_em2 = new Emitter( _ps, _em );
		}
		
		public function getParticle():Particle {
			return _p;
		}
		
		public function getEmitter():Particle {
			return _em;
		}
		
		public function getEmitter2():Particle {
			return _em2;
		}
		
		public function setSetting( setting:Object ):void {
			switch( setting.level + '' ) {
				case '0':
					_p.setSettingUsingObject( setting.particleSetting.particle );
					_em.setSettingUsingObject( setting.particleSetting ); 
					break;
				case '1':
					_p.setSettingUsingObject( setting.particleSetting.particle.particle );
					_em.setSettingUsingObject( setting.particleSetting.particle );
					_em2.setSettingUsingObject( setting.particleSetting );
					break;
			}
		}
		
		public function getTextures():Vector.<BitmapData> {
			return _ps.getTextures();
		}
		
		public function addTexture():void {
			var uf:UploadFileReference = new UploadFileReference();
			uf.onClick();
			uf.onCompleteHandler = function( fn:String, bd:BitmapData ):void {
				processTexture( fn, bd );
			};
		}
		
		public function processTexture( fn:String, bd:BitmapData ):void {
			_ps.addTexture( bd );
			dispatchEvent( new VicEvent( 'addTexture', [ fn, bd.width, bd.height, bd] ));
		}
		
		public function removeTexture( bd:BitmapData ):void {
			_ps.removeTexture( bd );
		}
		
		public function removeAllTextures():void {
			_ps.removeAllTextures();
		}
		
		private function clearParticle():void {
			if ( _ps ) {
				_ps.letAllParticleToDie();
				_p = null;
				_em = null;
				_em2 = null;
			}
		}
		
		private function onAddToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame );
			
			_ps = new ParticleSystem( this );
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if( _ps ){
				_ps.update();
			}
			
			if ( _ps.getParticleCount() == 0 ) {
				_ps.onParticleBorn( getCurrentHead() );
			}
			
			if ( mouseX > 280 ) {
				getCurrentHead().pos.x = mouseX;
				getCurrentHead().pos.y = mouseY;
			}

		}
		
		private function getCurrentHead():Particle {
			return _em2 ? _em2 : _em;
		}
	}

}