package org.vic.stage3D 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author VicYu
	 */
	public class Container3D
	{
		private var _container:DisplayObjectContainer;
		private var _vp:Point = new Point();
		private var _ary_sprite3D:Vector.<Sprite3D> = new Vector.<Sprite3D>();
		
		public function Container3D( con:DisplayObjectContainer ) 
		{
			super();
			
			_container = con;
		}
		
		public function setVp( vp:Point ):void {
			var s3d:Sprite3D;
			for each( s3d in _ary_sprite3D ) {
				s3d.vp = vp;
			}
			_vp = vp;
		}
		
		public function addChild( s3d:Sprite3D ):void {
			s3d.vp = _vp;
			_container.addChild( s3d );
			_ary_sprite3D.push( s3d );
		}
		
		public function removeChild( s3d:Sprite3D ):void {
			if ( _container.contains( s3d )) {
				_container.removeChild( s3d );
				_ary_sprite3D.splice( _ary_sprite3D.indexOf( s3d ), 1 );
			}
		}
		
		public function getChilds():Vector.<Sprite3D> {
			return _ary_sprite3D;
		}
		
		public function render3D():void {
			var s3d:Sprite3D;
			for each( s3d in _ary_sprite3D ) {
				s3d.render3D();
			}
			sortZ();
		}
		
		private function sortZ():void {
			_ary_sprite3D.sort( function( aObj:Sprite3D, bObj:Sprite3D ):int {
				if ( aObj.position.z > bObj.position.z )
					return -1;
				else
					return 1;
			});
			var i:int = 0;
			for (; i < _ary_sprite3D.length; ++i ) {
				_container.addChild( _ary_sprite3D[i] );
			}
		}
	}

}