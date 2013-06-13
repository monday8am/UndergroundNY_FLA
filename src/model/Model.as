package model
{
	import controllers.MainController;
	
	import events.InternalEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Angel E. Anton Yebra
	 */
	public class Model extends EventDispatcher
	{
		
		// singleton...	
		private static var _instance : Model;
		
		// objects
		private var _main_controller : MainController;
		
		// state..
		private var _currentPageId : int = -1;
		private var _message : Message;
		
		// data variables
		public  var base_url      : String;
		private var _images_list  : Array = [];
		private var _letter_list  : Array = []; 

		
		public function get letter_list():Array
		{
			return _letter_list;
		}

		public function set letter_list(value:Array):void
		{
			_letter_list = value;
		}

		public static function get instance() : Model 
		{
			if ( _instance == null) 
			{
				_instance = new Model( new SingletonEnforcer() );
			} 
			return _instance;
		}			
		
		/*
		 * Model constructor.
		 * 
		 * 
		 */
		public function Model( pvt:SingletonEnforcer ) 
		{
			super();
		}
		
		/*
		 * Getters and Setters
		 * 
		 * 
		 */
		public function set mainController( value: MainController ):void { _main_controller = value; }
		public function get mainController() : MainController { return _main_controller; }	

		public function get currentPageId():int { return _currentPageId; }
		
		public function set currentPageId( value : int ):void
		{
			if( value == _currentPageId ) return;
			
			if( _currentPageId != -1 ) _main_controller.hidePage( _currentPageId );
			
			_currentPageId = value;
			
			_main_controller.showPage( _currentPageId );
			dispatchEvent( new InternalEvent( InternalEvent.CHANGE_PAGE ) );
		}		
		
		public function get images_list():Array { return _images_list; }
		public function set images_list(value:Array):void 
		{ 
			_images_list = value;
			dispatchEvent( new Event( "get_drawings" ) );
		}

		public function get message():Message 
		{
			if( _message == null )
			{
				_message = new Message();
			}
			
			return _message; 
		}
		public function set message( value : Message ) : void
		{
			_message = value;
		}


	}
	
}

internal class SingletonEnforcer { }

