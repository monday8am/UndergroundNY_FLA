package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Angel E. Anton
	 */
	public class InternalEvent extends Event
	{
		public static var TRACK_ADDRESS : String = "track_adress";
		public static var SET_DEVICE : String = "change_current_device";
		public static var LOGIN_OK : String = "login_ok";
		public static var CHANGE_PAGE : String = "change_page";
		
		public var string_data : String;
		public var number_data : Number;
		
		
	
		public function InternalEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
		}
		
	}

}