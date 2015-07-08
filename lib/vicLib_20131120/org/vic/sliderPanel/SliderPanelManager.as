package  org.vic.sliderPanel
{
	import caurina.transitions.Tweener;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import org.vic.utils.BasicUtils;
	/**
	 * ...
	 * @author fff
	 */
	public class SliderPanelManager 
	{
		private var _ary_sliderPanel:Vector.<ISliderPanel>;
		private var _container:DisplayObjectContainer;
		private var _mode:String;
		private var _mouseDown:Boolean = false;
		private var _clickPosX:Number;
		private var _borderLeft:Number;
		private var _borderRight:Number;
		
		private var _vx:Number = 0;
		private var _ax:Number = 0;
		private var _friction:Number = .9;
		
		private var _downTime:Number;
		private var _upTime:Number;
		private var _passTime:Number;
		private var _clickPanel:ISliderPanel;
		
		private var _panelWidth:Number = 400;
		private var _tweenTime:Number = .5;
		
		private var _frontContainer:DisplayObjectContainer = new Sprite();
		private var _backContainer:DisplayObjectContainer = new Sprite();
		
		public function SliderPanelManager( container:DisplayObjectContainer ) 
		{
			_container = container;
			_container.addChild( _backContainer );
			_container.addChild( _frontContainer );
			_mode = SliderPanelMode.FRONT;
		}
		
		public function addSliderPanel( sp:ISliderPanel ):void {
			if ( !_ary_sliderPanel ) {
				_ary_sliderPanel = new Vector.<ISliderPanel>();
			}
			_ary_sliderPanel.push( sp );
		}
		
		public function removeSliderPanel( name:String ):void {
			if ( !_ary_sliderPanel )	return;
			var sp:ISliderPanel;
			for each( sp in _ary_sliderPanel ) {
				if ( sp.getName() == name ) {
					_ary_sliderPanel.splice( _ary_sliderPanel.indexOf( sp ), 1 );
					_backContainer.removeChild( sp as DisplayObject );
					break;
				}
			}
		}
		
		public function gotoBack( name:String = null):void {
			var sp:ISliderPanel;
			for each( sp in _ary_sliderPanel ) {
				if ( name ) {
					if ( sp.getName() == name ) {
						sp.gotoBack();
					}
				}else {
					sp.gotoBack();
				}
			}
			_mode = SliderPanelMode.BACK;
			replaceSliderPanel();
			addEventListener();
		}
		
		public function gotoFront( name:String ):void {
			var sp:ISliderPanel = getSliderPanelByName( name );
			if ( sp ) {
				sp.gotoFront();
			}
			_backContainer.removeChildren();
			_frontContainer.addChild( sp as DisplayObject);
			BasicUtils.playMovieClip( sp as DisplayObjectContainer );
			Tweener.addTween( sp, { scaleX:1, scaleY:1, x:0, time:_tweenTime } );
			_mode = SliderPanelMode.FRONT;
		}
		
		public function getSliderPanelByName( name:String ):ISliderPanel {
			if ( !_ary_sliderPanel ) {
				throw Error( 'no slider panel in collection' );
			}
			var sp:ISliderPanel;
			for each( sp in _ary_sliderPanel ) {
				if ( sp.getName() == name ) {
					return sp;
				}
			}
			throw Error( 'not have the name of input in slider collection' );
			return null;
		}
		
		public function update():void {
			
			if ( _mode != SliderPanelMode.BACK ) return;
			
			_vx += _ax;
			_vx *= _friction;
			_backContainer.x += _vx;
			
			checkBorder();
		}
		
		private function checkBorder():void {
			if ( !isNaN( _borderLeft ) ) {
				if ( _backContainer.x < _borderLeft ) {
					_vx *= -.3;
					_backContainer.x = _borderLeft + 5;
				}
			}
			if ( !isNaN( _borderRight ) ) {
				if ( _backContainer.x > _borderRight ) {
					_vx *= -.3;
					_backContainer.x = _borderRight - 5;
				}
			}
		}
		
		private function replaceSliderPanel():void {
			_frontContainer.removeChildren();
			_backContainer.removeChildren();
			var i:int = 0;
			var max:int = _ary_sliderPanel.length;
			var sp:ISliderPanel;
			for (; i < max; ++i ) {
				sp = _ary_sliderPanel[i];
				_backContainer.addChild( sp as DisplayObject );
				_borderLeft = -( ( _panelWidth / 2 + 10 ) * ( max - 1 ) );
				_borderRight = 0;
				BasicUtils.stopMovieClip( sp as DisplayObjectContainer );
				Tweener.addTween( sp, { x:( _panelWidth / 2 + 10 ) * i, scaleX:.5, scaleY:.5, time:_tweenTime } );
			}
		}
		
		private function addEventListener():void {
			var i:int = 0;
			var max:int = _ary_sliderPanel.length;
			var sp:ISliderPanel;
			for (; i < max; ++i ) {
				sp = _ary_sliderPanel[i];
				DisplayObject( sp ).addEventListener(MouseEvent.MOUSE_DOWN, onSpMouseDown );
				getStage().addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove );
				getStage().addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp )
			}
		}
		
		private var _oldPosX:Number = int.MAX_VALUE;
		private var _newPosX:Number;
		private var _dragVx:Number;
		
		private function onStageMouseMove(e:MouseEvent):void 
		{
			if ( _mouseDown ) {
				_newPosX = getStage().mouseX;
				var offset:Number = 0;
				if( _oldPosX != int.MAX_VALUE ){
					offset = _newPosX - _oldPosX;
				}
				_oldPosX = _newPosX;
				_backContainer.x += offset;
				_dragVx = offset;
			}
		}
		
		private function onStageMouseUp(e:MouseEvent):void 
		{
			_mouseDown = false;
			_oldPosX = int.MAX_VALUE;
			_upTime = getTimer();
			_passTime = _upTime - _downTime;
			if ( _passTime < 100 ) {
				gotoFront( _clickPanel.getName() );
				removeEventListener();
			}else {
				setVelocity();
			}
		}
		
		private function setVelocity():void 
		{
			_vx = _dragVx;
		}
		
		private function onSpMouseDown(e:MouseEvent):void 
		{
			_clickPanel = e.currentTarget as ISliderPanel;
			_mouseDown = true;
			_clickPosX = getStage().mouseX;
			_downTime = getTimer();
		}
		
		private function removeEventListener():void {
			var i:int = 0;
			var max:int = _ary_sliderPanel.length;
			var sp:ISliderPanel;
			for (; i < max; ++i ) {
				sp = _ary_sliderPanel[i];
				DisplayObject( sp ).removeEventListener(MouseEvent.MOUSE_DOWN, onSpMouseDown );
				getStage().removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove );
				getStage().removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp )
			}
		}
		
		private function getStage():Stage {
			return _container.stage;
		}
		
		public function get mode():String 
		{
			return _mode;
		}
	}

}