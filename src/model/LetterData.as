package model
{
	public class LetterData
	{
		private var id : int;
		
		public var videoURL : String;
		
		public var duration : Number;
		
		public var character : String;
		
		public function LetterData( _data : Object = null )
		{
			if( _data != null )
			{
				id = int( _data.id );
				videoURL  = _data.video_url;
				duration = int( _data.duration );
				character   = _data.letter;
			}
			
		}
	}
}