package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import org.vic.particle.ParticleParser;
	import org.vic.particle.core.ParticleSystem;
	
	/**
	 * ...
	 * @author vic
	 */
	public class TestParser extends Sprite 
	{
		
		public function TestParser() 
		{
			super();
			
			//particle system init
			var ps:ParticleSystem = new ParticleSystem( this );
			
			//parser init
			ParticleParser.inst.setParticleSystem( ps );
			
			//single particle loader
			/*
			ParticleParser.inst.setParticleSystem( ps );
			ParticleParser.inst.loadParticle( 'vic_fire', function():void {
					trace("OK" );
			});*/
			
			//multi particle loader
			ParticleParser.inst.loadQueue( ['vic_fire', 'vic_test2'], function():void {
				trace("OK");
			});
			
			//update particle system
			addEventListener(Event.ENTER_FRAME, function( e:Event ):void {
				ps.update();
			});
			
			//test particle
			addEventListener(Event.ADDED_TO_STAGE, function( e:Event ):void {
				stage.addEventListener(MouseEvent.CLICK, function( e:MouseEvent ):void {
					ParticleParser.inst.playParticle( 'vic_test2', stage.mouseX, stage.mouseY );
					ParticleParser.inst.playParticle( 'vic_fire', stage.mouseX, stage.mouseY );
				});
			});
			
			
		}
		
	}

}