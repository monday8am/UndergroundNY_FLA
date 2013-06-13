package services
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import util.Constans;
	
	/**
	 * Abstract class providing support for Operations that perform
	 * some kind of XML/HTTP request.
	 */
	public class JSONOperation extends Operation
	{
		// real... 
		private var GATEWAY_URL : String;

		/** The URL to be requested by this operation. */
		public var url: URLRequest;
		
		/** An untyped object containing request parameters to accompany the URL. */
		public var params:Object;
		
		public var source : String;
		public var method : String;
		private var url_loader : URLLoader;

		
		/**
		 * Construct an RemotePOSTOperation.
		 */		
		public function JSONOperation( _source:String, _method:String, _params:Object = null )
		{
			source = _source;
			method = _method;
			params = _params;
			
			GATEWAY_URL = Constans.REMOTE_IP_DATA;
			
			url = new URLRequest( GATEWAY_URL + _source );
			url.method = URLRequestMethod.POST;
			_params.method = _method;
			
			url.data = _params;
			url_loader = new URLLoader();
		}
		
		override public function execute():void
		{
			url_loader.addEventListener( Event.COMPLETE, handleResult );
			url_loader.load( url );
		}        

		protected function handleResult( e:Object ):void
		{
			handleComplete( url_loader.data );
		}
	}
}

