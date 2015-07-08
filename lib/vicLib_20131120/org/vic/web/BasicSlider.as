package org.vic.web 
{
	import adobe.utils.CustomActions;
	import caurina.transitions.Tweener;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import org.vic.display.FakeMovieClip;
	/**
	 * ...
	 * @author fff
	 */
	public class BasicSlider 
	{
		private var _root:MovieClip;
		private var _boss:WebView;
		
		private var _btn_slider:MovieClip;
		private var _mc_slider:MovieClip;
		private var _mc_content:MovieClip;
		private var _mc_mask:MovieClip;
		
		//球心的位置不在0,0所以要先記下來
		private var _initBtnY:Number;
		private var _initContentY:Number;
		private var _oldSliderY:Number;
		private var _downY:Number;
		private var _objForMove:Sprite;
		private var _sliderModel:SliderModel;
		private var _lastY:Number;
		
		public function BasicSlider( boss:WebView, root:MovieClip ) 
		{
			_root = root;
			_boss = boss;
		}
		
		public function getRoot():MovieClip {
			return _root;
		}
		
		public function getBoss():WebView {
			return _boss;
		}
		
		public function startFeature():void {
			if ( _btn_slider == null )
			{
				_btn_slider = getRoot().dragBtn;
				_btn_slider.mouseEnabled = false;
				_btn_slider.mouseChildren = false;
				_btn_slider.enabled = false;
				_initBtnY = _btn_slider.y;
				
				
				_mc_slider = getRoot().dragLine;
				_mc_slider.buttonMode = true;
				_mc_slider.addEventListener(MouseEvent.MOUSE_DOWN, onSliderDown );
				getBoss().getBoss().stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel );
				_mc_content = getRoot().content_mc;
				_mc_mask = getRoot().mask_mc;
				
				_initContentY = _mc_content.y;
				
				_sliderModel = new SliderModel( _mc_slider.height );
			}
		}
		
		public function closeFeatrue():void {
			_mc_slider.removeEventListener(MouseEvent.MOUSE_DOWN, onSliderDown );
			getBoss().getBoss().stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel );
		}
		
		public function setHeadPosition( value:Number ):void {
			moveContentAndSlider( value );
		}
		
		public function getHeadPosition():Number {
			return _lastY;
		}
		
		private function onSliderDown(e:MouseEvent):void {
			//算出滑鼠在slider的local坐標，直接位移
			var targetY:Number = e.localY + _initBtnY;
			moveContentAndSlider( targetY );
			
			if ( _objForMove == null )
			{
				_downY = e.stageY;
				_oldSliderY = e.localY;
				
				_objForMove = new Sprite();
				_objForMove.graphics.beginFill(0, 0 );
				_objForMove.graphics.drawRect( 0, 0, 1024, 1024 );
				_objForMove.graphics.endFill();
				_objForMove.addEventListener(MouseEvent.MOUSE_MOVE, onSliderMove );
				_objForMove.addEventListener(MouseEvent.MOUSE_UP, onSliderUp );
				getBoss().addChild( _objForMove );
			}
			
		}
		
		private function onSliderMove(e:MouseEvent):void {
			if ( !e.buttonDown )
				return;
			//算出滑鼠在slider的local坐標加上slider本來的位置，位移
			var targetY:Number = _oldSliderY + ( e.stageY - _downY ) + _initBtnY;
			moveContentAndSlider( targetY );
		}
		
		private function onSliderUp(e:MouseEvent):void {
			if ( _objForMove != null )
			{
				_objForMove.removeEventListener(MouseEvent.MOUSE_MOVE, onSliderMove );
				_objForMove.removeEventListener(MouseEvent.MOUSE_UP, onSliderUp );
				if ( getBoss().contains( _objForMove ))
					getBoss().removeChild( _objForMove );
				_objForMove = null;
			}
		}
		
		private function moveContentAndSlider( targetY:Number ):void {
			var newTargetY:Number = targetY;
			
			if ( newTargetY > _sliderModel.getTotal() + _initBtnY - _btn_slider.height )	
				newTargetY = _sliderModel.getTotal() + _initBtnY - _btn_slider.height;
				
			if ( newTargetY < _initBtnY )	
				newTargetY = _initBtnY;
				
			_lastY = newTargetY;
			
			var per:Number = _sliderModel.setNow( newTargetY -  _initBtnY);
			
			if ( per >= 0 && per <= 1 )
			{
				Tweener.addTween( _btn_slider, { y:newTargetY, time:.5 } );
				Tweener.addTween( _mc_content, { y:( per * -( _mc_content.height - _mc_mask.height + 100 ) ) + _initContentY, time:.5 } );
			}
		}
		
		private function onMouseWheel( e:MouseEvent ):void {
			
			var targetY:Number = _btn_slider.y + -e.delta * 20;
			moveContentAndSlider( targetY );
		}
	}

}

class SliderModel {
	
	private var _total:Number;
	public function SliderModel( total:Number ) {
		_total = total;
	}
	
	public function getTotal():Number {
		return _total;
	}
	
	public function setNow( value:Number ):Number {
		var ret:Number = value / _total;
		if ( ret < 0 )
			return 0;
		else if ( ret > 1 )
			return 1;
		return ret;
	}
}