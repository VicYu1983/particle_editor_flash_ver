package org.vic.componentDesign.web 
{
	import org.vic.componentDesign.Component;
	/**
	 * ...
	 * @author fff
	 */
	public class OpenComponent extends Component 
	{
		
		public function OpenComponent(name:String) 
		{
			super(name);
			
		}
		
		override public function execute(args:*):void 
		{
			super.execute(args);
			
			trace( 'open' );
		}
	}

}