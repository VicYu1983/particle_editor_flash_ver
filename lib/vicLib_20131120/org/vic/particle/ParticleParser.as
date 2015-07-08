package org.vic.particle 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import mx.utils.Base64Decoder;
	import org.vic.event.VicEvent;
	import org.vic.particle.core.ParticleSystem;
	import org.vic.utils.LoaderQueue;
	/**
	 * ...
	 * @author vic
	 */
	public class ParticleParser 
	{
		private static var _inst:ParticleParser;
		
		private var _ul:URLLoader = new URLLoader();
		private var _ur:URLRequest = new URLRequest( 'http://ad.arcww.com.tw/VicDemo/particleEditorNew/actions/getData.php' );
		private var _ua:URLVariables = new URLVariables();
		
		private var _ary_particleWrapper:Vector.<ParticleWrapper> = new Vector.<ParticleWrapper>();
		private var _ps:ParticleSystem;
		private var _cb:Function;
		
		private var _textureId:int = 0;
		
		public function ParticleParser( sgt:Sgt) 
		{
			LoaderQueue.inst.addEventListener( Event.COMPLETE, onLoaderQueueComplete );
		}
		
		public static function get inst():ParticleParser {
			if ( _inst == null ) {
				_inst = new ParticleParser( new Sgt());
			}
			return _inst;
		}
		
		/**
		 * 設定系統
		 * @param	ps
		 */
		public function setParticleSystem( ps:ParticleSystem):void {
			_ps = ps;
		}
		
		/**
		 * 讀取單一粒子
		 * @param	name	粒子名稱
		 * @param	cb
		 */
		public function loadParticle( name:String, cb:Function ):void {
			if ( _ps == null ) {
				throw Error( 'should set particleSystem first! use setParticleSystem().' );
			}
			_cb = cb;
			
			_ua.name = name;
			_ur.data = _ua;
			_ur.method = 'post';
			_ul.load( _ur )
			_ul.addEventListener(Event.COMPLETE, onLoaderComplete );
		}
		
		/**
		 * 讀取多粒子
		 * @param	ary_queue	粒子名稱陣列
		 * @param	cb
		 */
		public function loadQueue( ary_queue:Array, cb:Function ):void {
			loadOneQueue();
			
			function loadOneQueue():void {
				if ( ary_queue.length == 0 ) {
					cb();
					return;
				}
				loadParticle( ary_queue.shift(), loadOneQueue );
			}
		}
		
		/**
		 * 取得粒子代理
		 * @param	name	粒子名稱
		 * @return
		 */
		public function getParticleWrapper( name:String ):ParticleWrapper {
			var i:int = 0;
			var max:int = _ary_particleWrapper.length;
			var pw:ParticleWrapper;
			for (; i < max; ++i ) {
				pw = _ary_particleWrapper[i];
				if ( pw.name == name ) {
					return pw;
				}
			}
			return null;
		}
		
		/**
		 * 播放粒子
		 * @param	name	粒子名稱
		 * @param	x
		 * @param	y
		 */
		public function playParticle( name:String, x:Number, y:Number ):void {
			var pw:ParticleWrapper = getParticleWrapper( name );
			if ( pw == null )	throw Error( 'not have the name of Particle!' );
			pw.getParticleRoot().pos.x = x;
			pw.getParticleRoot().pos.y = y;
			_ps.onParticleBorn( pw.getParticleRoot() );
		}
		
		private function onLoaderComplete( e:Event ):void {
			_ul.removeEventListener(Event.COMPLETE, onLoaderComplete );
			
			var retObj:Object =  JSON.parse( _ul.data );
			var pw:ParticleWrapper = new ParticleWrapper( _ps );
			pw.setSetting( retObj.content, _textureId );
			parserTextures( retObj.content );
			_ary_particleWrapper.push( pw );
			
			if ( _cb != null ) {
				_cb();
			}
		}
		
		private function parserTextures( retObj:Object ):void {
			if ( retObj.textures != null ) {
				var ary_t:Array = retObj.textures;
				var i:int = 0;
				var max:int = ary_t.length;
				var base64Str:String;
				for (; i < max; ++i ) {
					_textureId++;
					base64Str = ary_t[i];
					decodePNG( base64Str );
				}
				LoaderQueue.inst.start();
			}
		}
		
		private function decodePNG( base64Str:String ):void {
			var base64Encoder:Base64Decoder = new Base64Decoder();
			base64Encoder.decode( base64Str );
			var byteAry:ByteArray = base64Encoder.toByteArray();
			LoaderQueue.inst.addTask( byteAry );
		}
		
		private function onLoaderQueueComplete( e:VicEvent ):void {
			var bm:Bitmap = e.data as Bitmap;
			processTexture( bm.bitmapData );
		}
		
		private function processTexture( bd:BitmapData ):void {
			_ps.addTexture( bd );
		}
	}

}
class Sgt { }