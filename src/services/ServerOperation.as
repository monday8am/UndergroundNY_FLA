package services
{

	import com.adobe.crypto.MD5;
	
	import flash.events.Event;
	import flash.net.URLVariables;
	
	import model.LetterData;
	import model.Message;
	import model.Model;

	
	
	public class ServerOperation extends JSONOperation
	{
		// para persistencia
		public var result_code : String;
		
		public var image_code : String;
		public var error_message : String;
		public var json_data : Object;
		
		public var diferencia : Number;
		public var arr : Array = [];
		public var message_id : String;
		
		
		public function ServerOperation( _source:String, _method:String, _params:Object=null, _displayName:String = null )
		{
			super(_source, _method, _params);
			this.displayName = _displayName;
		}
		

		public static function getVideos():ServerOperation
		{
			var params : URLVariables  = new URLVariables();
			var source : String = "services/underground_service.php";
			var method : String = "getVideos";			
			
			var c: ServerOperation = new ServerOperation( source, method , params, "" );
			return c;
		}	

		public static function getMessage( id : String ):ServerOperation
		{
			var params : URLVariables  = new URLVariables();
			var source : String = "services/underground_service.php";
			var method : String = "getMessage";		
			
			params.message_id  = id;
			params.check = MD5.hash(id + 'underground' );
			
			var c: ServerOperation = new ServerOperation( source, method , params, "" );
			return c;
		}
		
		
		public static function saveMessage( message : String, shared_by : String ):ServerOperation
		{
			var params : URLVariables  = new URLVariables();
			var source : String = "services/underground_service.php";
			var method : String = "saveMessage";		
			
			params.message  = message;
			params.shared_by  = shared_by;
			
			var c: ServerOperation = new ServerOperation( source, method , params, "" );
			return c;
		}
		
		
		
		public static function sendEmail( data : Object):ServerOperation
		{
			var params : URLVariables  = new URLVariables();
			var source : String = "services/share_by_e.php";
			var method : String = "sendEmail";
			
			params.videoUrl = data.videoUrl;
			params.from = data.from;
			params.to = data.to;
			
			var c: ServerOperation = new ServerOperation( source, method , params, "" );
			return c;
		}		
		
		/**
		 * 
		 * 
		 * Handlers
		 * 
		 * 
		 * 
		 */
        override protected function handleComplete( e: Object ):void
        {
			var data : Object;
			var data_arr : Array = [];
			var list : Array;
			var obj : Object;
			
			if ( this.method == "getVideos" )
			{
				var arr : Object = JSON.parse( e.toString() );	
				var _letter_list : Array = [];
				
				for (var i:int = 0; i < arr.length; i++) 
				{
					var l : LetterData = new LetterData( arr[i] );
					_letter_list[ String( l.character ) ] = l;
				}
				
				Model.instance.letter_list = _letter_list;
			}		
			
			if ( this.method == "saveMessage" )
			{
				message_id = JSON.parse( e.toString() ).toString();	
			}
			
			
			if ( this.method == "getMessage" )
			{
				if( e != "false" ) Model.instance.message = new Message( JSON.parse( e.toString() ) );
				
			}			
			
	
        	dispatchEvent( new Event( Event.COMPLETE ) );
        }   

	}
}