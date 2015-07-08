package org.vic.componentDesign 
{
	/**
	 * ...
	 * @author fff
	 */
	public class Component 
	{
		public var owner:Entity;
		public var name:String;
		public function Component( name:String ) {
			this.name = name;
		}
		
		public function execute( args:* ):void {
			//for children
		}
		
	}

}