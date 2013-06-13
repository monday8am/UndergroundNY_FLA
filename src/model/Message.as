package model
{
	public class Message
	{
		
		public var id  : String = "";
		
		public var content : String = "";
		
		public var shared : Boolean = false;
		
		public var totalTime : int = 0;
		
		
		public function Message( _data : Object = null )
		{
			if( _data != null )
			{
				id = _data.id;
				content  = _data.message;
			}
		}
		
	}
	
}