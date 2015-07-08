package org.vic.componentDesign.web 
{
	import org.vic.componentDesign.Entity;
	/**
	 * ...
	 * @author fff
	 */
	public class PageEntity extends Entity 
	{
		
		public function PageEntity() 
		{
			super();
			
			addComponent( new OpenComponent( 'open' ) );
		}
		
	}

}