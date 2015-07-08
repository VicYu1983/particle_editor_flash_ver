package  org.vic.web
{
	import caurina.transitions.Tweener;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import org.vic.display.FakeMovieClip;
	import org.vic.loader.LoaderManager;
	import org.vic.loader.LoaderTask;
	import org.vic.web.parser.SwfParser;
	
	/**
	 * ...
	 * @author fff
	 */
	public class WebView extends Sprite 
	{
		private var _boss:WebMain;
		
		protected var _root:MovieClip;
		
		private var _ary_buttons:Vector.<BasicButton>;
		private var _ary_sliders:Vector.<BasicSlider>;
		private var _ary_textField:Vector.<TextField>;
		private var _args:Array;
		
		public function WebView( boss:WebMain, args:Array = null ) 
		{
			super();
			_boss = boss;
			_args = args;
		}
		
		public function open( cb:Function = null ):void {
			if ( getSwfInfo() != null ) {
				var swfName:String = getSwfInfo().name;
				var swfPath:String = getSwfInfo().path;
				if ( !getLoaderManager().hasTask( swfName ) ) {
					var version:String = '';
					if( getBoss().getModel() != null ){
						version = getBoss().getModel().getVersion();
					}
					getLoaderManager().addTask( swfName, 
					new LoaderTask( swfPath + '?v=' + version, function():void {
						_onOpenEvent( cb );
					} ));
				}else {
					_onOpenEvent( cb );
				}
			}else {
				_onOpenEvent( cb );
			}
			
			function _onOpenEvent( _cb:Function ):void {
				generateRoot();
				parserRoot();
				onOpenEvent( _cb );
				focus();
			}
		}
		
		public function close( cb:Function = null ):void {
			release();
			onCloseEvent();
			
			function _close():void {
				while ( numChildren > 0 ) {
					removeChild( getChildAt( 0 ));
				}
				_ary_buttons = null;
				_ary_sliders = null;
				_ary_textField = null;
				if ( cb != null ) {
					cb();
				}
			}
			
			var closeAni:Boolean = false;
			var i:int = 0;
			var lary:Array = getRoot().currentLabels;
			var max:int = lary.length;
			for (; i < max; ++i ) {
				if ( lary[i].name == 'pageClose' ) {
					closeAni = true;
				}
			}
			
			if( closeAni ){
				getRoot().gotoAndPlay( 'pageClose' );
				getRoot().addFrameScript( getRoot().totalFrames - 1, _close );
			}else {
				Tweener.addTween( this, { alpha:0, time:.5, onComplete:_close } );
			}
		}
		
		public function focus():void {
			if ( getButtons() != null ) {
				var i:int = 0;
				var max:int = getButtons().length;
				var btn:BasicButton;
				for (; i < max; ++i ) {
					btn = getButtons()[i];
					wakeUpButton( btn, false );
				}
			}
			
			if ( getSliders() != null ) {
				i = 0;
				max = getSliders().length;
				var sl:BasicSlider;
				for (; i < max; ++i ) {
					sl = getSliders()[i];
					sl.startFeature();
				}
			}
			
			if ( getTextField() != null ) {
				i = 0;
				max = getTextField().length;
				var t:TextField;
				for (; i < max; ++i ) {
					t = getTextField()[i];
					t.addEventListener(FocusEvent.FOCUS_IN, onTxtFocusIn );
					t.addEventListener(FocusEvent.FOCUS_OUT, onTxtFocusOut );
					t.addEventListener(Event.CHANGE, onTxtChange );
				}
			}
			
			onFocusEvent();
		}
		
		protected function wakeUpButton( btn:BasicButton, playOut:Boolean = false ):void {
			var mc:MovieClip;
			mc = btn.getShape();
			wakeUpButtonByMc( mc, playOut );
		}
		
		protected function sleepButton( btn:BasicButton ):void {
			var mc:MovieClip;
			mc = btn.getShape();
			mc.buttonMode = false;
			mc.removeEventListener(MouseEvent.CLICK, onClick );
			mc.removeEventListener(MouseEvent.MOUSE_OVER, onOver );
			mc.removeEventListener(MouseEvent.MOUSE_OUT, onOut );
		}
		
		protected function wakeUpButtonByMc( mc:MovieClip, playOut:Boolean = false ):void {
			mc.buttonMode = true;
			if( playOut ){
				if ( mc.currentFrame != 1 && mc.currentFrame != mc.totalFrames ) {
					mc.gotoAndPlay('out' );
				}
			}
			if ( !mc.hasEventListener(MouseEvent.CLICK )) {
				mc.addEventListener(MouseEvent.CLICK, onClick );
				mc.addEventListener(MouseEvent.MOUSE_OVER, onOver );
				mc.addEventListener(MouseEvent.MOUSE_OUT, onOut );
			}
		}
		
		public function release():void {
			if ( getButtons() != null ) {
				var i:int = 0;
				var max:int = getButtons().length;
				var btn:BasicButton;
				
				for (; i < max; ++i ) {
					btn = getButtons()[i];
					sleepButton( btn );
				}
			}
			
			if ( getSliders() != null ) {
				i = 0;
				max = getSliders().length;
				var sl:BasicSlider;
				for (; i < max; ++i ) {
					sl = getSliders()[i];
					sl.closeFeatrue();
				}
			}
			
			if ( getTextField() != null ) {
				i = 0;
				max = getTextField().length;
				var t:TextField;
				for (; i < max; ++i ) {
					t = getTextField()[i];
					t.removeEventListener(FocusEvent.FOCUS_IN, onTxtFocusIn );
					t.removeEventListener(FocusEvent.FOCUS_OUT, onTxtFocusOut );
					t.removeEventListener(Event.CHANGE, onTxtChange );
				}
			}
			
			onReleaseEvent();
		}
		
		public function addButton( b:BasicButton ):void {
			if ( _ary_buttons == null ) {
				_ary_buttons = new Vector.<BasicButton>();
			}
			_ary_buttons.push( b );
		}
		
		public function addSlider( s:BasicSlider ):void {
			if ( _ary_sliders == null ) {
				_ary_sliders = new Vector.<BasicSlider>();
			}
			_ary_sliders.push( s );
		}
		
		public function addTextField( t:TextField ):void {
			if ( _ary_textField == null ) {
				_ary_textField = new Vector.<TextField>();
			}
			_ary_textField.push( t );
		}
		
		protected function getButtons():Vector.<BasicButton> {
			return _ary_buttons;
		}
		
		protected function getSliders():Vector.<BasicSlider> {
			return _ary_sliders;
		}
		
		protected function getTextField():Vector.<TextField> {
			return _ary_textField;
		}
		
		protected function getSwfInfo():Object {
			return null;
		}
		
		protected function getRootInfo():Object {
			return null;
		}
		
		protected function getLoaderManager():LoaderManager {
			return LoaderManager.inst;
		}
		
		protected function onOpenEvent( cb:Function = null ):void {
			if ( cb != null )
				cb();
		}
		
		protected function onCloseEvent( cb:Function = null ):void {
			
		}
		
		protected function onFocusEvent():void {
			
		}
		
		protected function onReleaseEvent():void {
			
		}
		
		protected function onClick( e:MouseEvent ):void {
			var mc:MovieClip = e.currentTarget as MovieClip;
			var commandName:String = mc.commandName;
			getBoss().executeCommand( commandName, [ this ] );
		}
		
		protected function onTxtFocusIn( e:FocusEvent ):void {
			var t:TextField = e.currentTarget as TextField;
			t.text = '';
		}
		
		protected function onTxtFocusOut( e:FocusEvent ):void {
			
		}
		
		protected function onTxtChange( e:Event ):void {
			
		}
		
		public function getBasicButtonByName( n:String ):BasicButton {
			var b:BasicButton;
			for each( b in getButtons() ) {
				if ( b.getShape().name == n ) {
					return b;
				}
			}
			return null;
		}
		
		public function getBasicButtonBySymbol( n:String ):BasicButton {
			var b:BasicButton;
			for each( b in getButtons() ) {
				if ( b.getShape().symbol == n ) {
					
					return b;
				}
			}
			return null;
		}
		
		protected function getTextFieldByName( n:String ):TextField {
			var t:TextField;
			for each( t in getTextField() ) {
				if ( t.name == n ) {
					return t;
				}
			}
			return null;
		}
		
		protected function onOver( e:MouseEvent ):void {
			var mc:MovieClip = e.currentTarget as MovieClip;
			try{
				mc.gotoAndPlay( 'over' );
			}catch ( e:Error ) { }
		}
		
		protected function onOut( e:MouseEvent ):void {
			var mc:MovieClip = e.currentTarget as MovieClip;
			try{
				mc.gotoAndPlay( 'out' );
			}catch ( e:Error ) { }
		}
		
		protected function getButtonNameByEvent( e:MouseEvent ):String {
			var mc:MovieClip = e.currentTarget as MovieClip;
			return mc.name;
		}
		
		protected function createDebugButton( name:String, posx:Number = 0, posy:Number = 0 ):void {
			var mc:MovieClip = new FakeMovieClip( name, 100, 30 );
			mc.name = name;
			mc.x = posx;
			mc.y = posy;
			_root.addChild( mc );
		}
		
		protected function createDebugRoot( name:String = '', width:Number = 500, height:Number = 500 ):void {
			_root = new FakeMovieClip( name, width, height );
		}
		
		protected function generateRoot( name:String = null, linkage:String = null ):void {
			
			if ( getRootInfo() == null ) {
				if( !_root ){
					_root = new MovieClip();
				}
				return;
			}
			
			_root = getLoaderManager().getTask( getRootInfo().name ).getObject( getRootInfo().path ) as MovieClip;
		}
		
		protected function update( e:Event = null ):void {
			
		}
		
		protected function getArgs():Array {
			return _args;
		}
		
		public function getBoss():WebMain {
			return _boss;
		}
		
		public function getModel():WebModel {
			return getBoss().getModel();
		}
		
		public function getRoot():MovieClip {
			return _root;
		}
		
		private function parserRoot():void {
			if ( _root != null ) {
				SwfParser.movieClipParser( getBoss(), this, _root, getButtons(), getSliders() );
				addChild( _root );
			}
		}
	}

}