package org.vic.event 
{
	import adobe.utils.CustomActions;
	/**
	 * ...
	 * @author fff
	 */
	public class VicEventDispatcher 
	{
		private var observers:Object = { };
		
		public function VicEventDispatcher() 
		{
			
		}
		
		public function addEventListener( name:String, func:Function ):void {
			if ( observers[name] != null )
				observers[name].push( func );
			else
				observers[name] = [ func ];
		}
		
		public function removeEventListener( name:String, func:Function):void {
			var ary_func:Array = observers[ name ];
			if ( ary_func != null )
			{
				var i:int = 0, 
					max:int = ary_func.length;
				for ( i; i < max; ++i )
				{
					if ( ary_func[i] == func )
						ary_func.splice( i, 1 );
				}
			}
		}
		
		public function dispatchEvent( e:VicEvent ):void {
			var ary_func:Array = observers[e.name];
			if ( ary_func != null )
			{
				var k:Function;
				for each( k in ary_func ) {
					k( e );
				}
			}
		}
	}

}