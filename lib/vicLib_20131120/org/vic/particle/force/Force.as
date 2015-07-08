package  org.vic.particle.force
{
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author vic
	 */
	public class Force 
	{
		public static const GRAVITY:String = 'gravity';
		public static const DRAG:String = 'drag';
		
		public var name:String;
		public var cname:String;
		
		private var _power:Number;
		public var acc:Vector3D = new Vector3D();
		public var vel:Vector3D = new Vector3D();
		
		public function Force( p:Number ) 
		{
			power = p;
		}
		
		public function set power( p:Number ):void {
			_power = p;
		}
		
		public function get power():Number {
			return _power;
		}
		
		public function update( pvel:Vector3D ):void {
			
		}
		
		public function clone():Force {
			throw Error( 'need to override this function!' );
			return null;
		}
		
		public function getSettingUsingObject():Object {
			var setting:Object = { };
			setting.name = name;
			setting.power = _power;
			return setting;
		}
		
		public function setSettingUsingObject( settingObject:Object ):void {
			name = settingObject.name;
			power = settingObject.power;
		}
		
		public function getSetting():XML {
			var setting:XML = new XML( '<forceSetting></forceSetting>' );
			setting.@name = name;
			setting.@power = _power;
			return setting;
		}
		
		public function setSetting( setting:XML ):void {
			name = setting.@name;
			power = setting.@power;
		}
	}

}