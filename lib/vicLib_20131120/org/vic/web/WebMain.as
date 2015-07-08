package  org.vic.web
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import org.vic.event.VicEvent;
	import org.vic.loader.LoaderManager;
	import org.vic.utils.BasicUtils;
	import org.vic.web.WebView;
	/**
	 * ...
	 * @author VicYu
	 */
	public class WebMain extends Sprite 
	{
		private var _webUrlLoader:WebURLLoader;
		private var _webCallJs:WebCallJs;
		private var _model:WebModel;
		private var _collect_page:Object = { };
		private var _collect_command:Object = { };
		private var _ary_layer:Vector.<DisplayObjectContainer>;
		private var _rootLayer:DisplayObjectContainer = new Sprite();
		
		public function WebMain() {
			addChild( _rootLayer );
			
			LoaderManager.inst.addEventListener( LoaderManager.PROGRESS, function( e:VicEvent ):void {
				var per:Number = e.data as Number;
				setLoadingPercent( per );
			});
		}
		
		public function getRootLayer():DisplayObjectContainer {
			return _rootLayer;
		}
		
		public function setWebURLLoader( ul:WebURLLoader ):void {
			_webUrlLoader = ul;
		}
		
		public function getWebURLLoader():WebURLLoader {
			return _webUrlLoader;
		}
		
		public function setWebCallJs( wcj:WebCallJs ):void {
			_webCallJs = wcj;
		}
		
		public function getWebCallJs():WebCallJs {
			if ( !_webCallJs ) {
				_webCallJs = new WebCallJs( this );
			}
			return _webCallJs;
		}
		
		public function setMask( mw:Number, mh:Number ):void {
			var mask:Sprite = new Sprite();
			BasicUtils.drawRect( mask.graphics, 0, 1, mw, mh );
			getRootLayer().addChild( mask );
			getRootLayer().mask = mask;
		}
		
		public function setModel( m:WebModel ):void {
			_model = m;
		}
		
		public function getModel():WebModel {
			return _model;
		}
		
		public function getTargetPage( name:String ):WebView {
			return _collect_page[name];
		}
		
		public function openTargetPage( name:String, layerName:String = '', args:Array = null, cb:Function = null ):void {
			if ( _collect_page[name] == null ) {
				var clazz:Class = getDefinitionByName( name ) as Class;
				var page:WebView = new clazz( this, args );
				_collect_page[name] = page;
				page.open( cb );
				getLayerByName( layerName ).addChild( page );
			}
		}
		public function closeTargetPage( name:String ):void {
			if ( _collect_page[name] != null ) {
				var page:WebView = _collect_page[name] as WebView;
				page.close( removePage );
				_collect_page[name] = null;
				delete _collect_page[name];
			}
			
			function removePage():void{
				var layer:DisplayObjectContainer = page.parent;
				if ( layer != null ) {
					layer.removeChild( page );
				}
			}
		}
		
		public function closeAllPageByLayer( layerId:int = 0 ):void {
			var layer:DisplayObjectContainer = getLayer( layerId );
			if ( layer != null ) {
				var i:int = layer.numChildren - 1;
				for ( ; i >= 0; --i )
				{
					var page:WebView = layer.getChildAt( i ) as WebView;
					var className:String = getQualifiedClassName( page );
					var clazz:Class = getDefinitionByName( className ) as Class;
					closeTargetPage( clazz['NAME'] );
				}
			}
		}
		
		public function openLoadingPage():void {
			//for children
		}
		
		public function closeLoadingPage():void {
			//for children
		}
		
		protected function setLoadingPercent( per:Number ):void {
			//for children
		}
		
		public function jsCallFlash( value:Object ):void {
			if ( value.type == null || value.content == null ) {
				getWebCallJs().alert( '從js的回呼的物件都需要有type和content' );
			}
		}
		
		public function getLayer( id:int = 0 ):DisplayObjectContainer {
			return _ary_layer[id];
		}
		
		public function getLayerByName( layerName:String ):DisplayObjectContainer {
			var i:int = 0;
			var max:int = _ary_layer.length;
			var layer:DisplayObjectContainer;
			for (; i < max; ++i ) {
				layer = _ary_layer[i];
				if ( layer.name == layerName ) {
					return layer;
				}
			}
			return null;
		}
		
		public function addLayer( name:String ):void {
			if ( _ary_layer == null ) {
				_ary_layer = new Vector.<DisplayObjectContainer>();
			}
			var layer:DisplayObjectContainer = new Sprite();
			layer.name = name;
			_ary_layer.push( layer );
			getRootLayer().addChild( layer );
		}
		
		public function addCommand( c:Class ):void {
			if ( _collect_command[c['NAME']] == null ) {
				_collect_command[c['NAME']] = new c( this, c['NAME'] );
			}else {
				throw Error( 'the name already exist!, please rename it!' );
			}
		}
		
		public function executeCommand( cname:String, args:Array = null ):void {
			if ( getCommand( cname ) != null ) {
				getCommand( cname ).execute( args );
			}else {
				throw Error( 'the name of command has not been registerd yet! command name is ' + cname );
			}
		}
		
		public function getCommand( cname:String ):WebCommand {
			return _collect_command[cname];
		}
	}
	
}