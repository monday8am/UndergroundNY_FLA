package controllers
{
	import com.adobe.viewsource.ViewSource;
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	
	import command.CallProcedureCommand;
	import command.CommandList;
	import command.ServerOperationCommand;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import model.Model;
	
	import services.ServerOperation;
	
	import ui.AboutPage;
	import ui.CreateMessage;
	import ui.CreditsPage;
	import ui.FontPage;
	import ui.IntroPage;
	import ui.Navbar;
	import ui.Page;
	import ui.ShareMessage;
	
	import util.Constans;
	
	/**
	 * ...
	 * @author Angel E. Anton
	 */
	public class MainController extends EventDispatcher
	{
		
		private var main_view : Sprite;
		private var page_list : Array;
		private var scale : Number = 1;

		private var nav:Navbar;

		private var fullscreenbtn : MovieClip;
		private var copy          : MovieClip;
		private var sponsors   : MovieClip;
		
		
		public function MainController( view : Sprite ) 
		{
			super();
			main_view = view;
			main_view.addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			main_view.scaleX =
			main_view.scaleY = scale;
		}
		
		private function onAddedToStage(event:Event):void
		{
			main_view.stage.addEventListener( Event.RESIZE, onChangeSize );
			main_view.stage.addEventListener( Event.FULLSCREEN, onChangeFullScreen );
			onChangeSize( null);
		}		
		
		
		private function onChangeFullScreen(event:FullScreenEvent):void
		{
			if( fullscreenbtn == null ) return;
				
			if( event.fullScreen )
			{
				fullscreenbtn.gotoAndStop( 2);
			}
			else
			{
				fullscreenbtn.gotoAndStop( 1);				
			}
		}
		
		
		private function onChangeSize(event:Event):void
		{
			main_view.x = ( main_view.stage.stageWidth - 956  )/2;
			main_view.y = ( main_view.stage.stageHeight - 690  )/2;
			
			var offset : int = 10;
			
			if( nav != null )
			{
				copy.x = - main_view.x + offset;
				copy.y = 690 + main_view.y - offset;
				fullscreenbtn.x = copy.x;
				fullscreenbtn.y = copy.y;
				
				sponsors.gotoAndStop(2);
				sponsors.x = - main_view.x + main_view.stage.stageWidth - 2;
				sponsors.y = 690 + main_view.y - 2;				
			}
		}
		
		public function initApp():void
		{
			var command_list : CommandList = new CommandList();
			
			command_list.add( new ServerOperationCommand( ServerOperation.getVideos()	   ));
			command_list.add( new CallProcedureCommand(   defineInterface 				   ));
			command_list.add( new CallProcedureCommand(   createPages 					   ));
			command_list.add( new CallProcedureCommand(   defineFirstPage 				   ));
			
		}
		
		
		public function showPage( page_id : int ):void
		{
			Page( page_list[ page_id ] ).show();
			
			if( page_id == Constans.PAGE_ID_INTRO )   
			{
				SWFAddress.setValue( "/intro" );
				nav.visible = false;
				fullscreenbtn.visible = false;
				copy.visible = false;
				sponsors.visible = false;
			}
			else
			{
				nav.visible = true;
				fullscreenbtn.visible = true;
				copy.visible = true;	
				sponsors.visible = true;
			}
			//if( page_id == Constans.PAGE_ID_INTRO )   SWFAddress.setValue( "/intro" );
			if( page_id == Constans.PAGE_ID_CREATE )  SWFAddress.setValue( "/create" );
			if( page_id == Constans.PAGE_ID_CREDITS ) SWFAddress.setValue( "/credits" );
			if( page_id == Constans.PAGE_ID_FONT )    SWFAddress.setValue( "/font" );
			if( page_id == Constans.PAGE_ID_PREVIEW ) SWFAddress.setValue( "/message/" );
			if( page_id == Constans.PAGE_ID_ABOUT )   SWFAddress.setValue( "/about" );
		}	
		
		
		public function hidePage( page_id : int ):void
		{
			Page( page_list[ page_id ] ).hide();
		}	
		
		
		private function createPages():void
		{
			page_list = [];
			
			page_list[ Constans.PAGE_ID_CREATE ] 	= new CreateMessage ( main_view, new create_assets_mc() );
			page_list[ Constans.PAGE_ID_PREVIEW ]   = new ShareMessage	( main_view, new share_assets_mc()  );
			page_list[ Constans.PAGE_ID_ABOUT ] 	= new AboutPage( main_view, new about_assets_mc() );
			page_list[ Constans.PAGE_ID_INTRO ]     = new IntroPage( main_view, new intro_assets_mc()   );
			page_list[ Constans.PAGE_ID_CREDITS ] 	= new CreditsPage( main_view, new credits_assets_mc() );
			page_list[ Constans.PAGE_ID_FONT ] 		= new FontPage( main_view, new font_assets_mc() );
		}
		
		
		private function defineInterface():void
		{
			// add bg
			
			// add navbar
			nav = new Navbar();
			main_view.addChild( nav );
			nav.visible = false;
			
			fullscreenbtn = new fullscreen_btn();
			main_view.addChild( fullscreenbtn );
			fullscreenbtn.scaleX = 
			fullscreenbtn.scaleY = 0.8;
			fullscreenbtn.alpha = 0.8;
			fullscreenbtn.buttonMode = true;
			fullscreenbtn.addEventListener( MouseEvent.CLICK, onPressFullScreen );
			fullscreenbtn.visible = false;
			
			sponsors = new sponsors_mc();
			main_view.addChild( sponsors );
			sponsors.scaleX = sponsors.scaleY = 0.8;
			sponsors.alpha = 0.4;
			sponsors.visible = false;
				
			copy = new copyright();
			main_view.addChild( copy );
			copy.visible = false;
			
			onChangeSize( null );
		}
		
		private function onPressFullScreen(event:MouseEvent):void
		{
			
			
			if( main_view.stage.displayState == StageDisplayState.NORMAL )
			{
				main_view.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}
			else
			{
				main_view.stage.displayState = StageDisplayState.NORMAL;		
			}
			
		}		
		
		private function defineFirstPage():void
		{
			initSWFAddress();
		}
		
		
		/**
		 *  
		 * SWFAddress
		 * 
		 */
		private function initSWFAddress():void 
		{
			//handleSWFAddress( new SWFAddressEvent( SWFAddressEvent.CHANGE ) );
			SWFAddress.addEventListener( SWFAddressEvent.CHANGE, handleSWFAddress);
		}
		
		private function destroySWFAddress():void 
		{
			SWFAddress.removeEventListener( SWFAddressEvent.CHANGE, handleSWFAddress );
		}
		
		private function setSWFAddress():void 
		{
			
		}
		
		private function handleSWFAddress( event:SWFAddressEvent ):void 
		{
			if( event.value == "/" )   	    Model.instance.currentPageId = Constans.PAGE_ID_INTRO;
			if( event.value == "/about")    Model.instance.currentPageId = Constans.PAGE_ID_ABOUT;
			if( event.value == "/credits")  Model.instance.currentPageId = Constans.PAGE_ID_CREDITS;
			if( event.value == "/intro")  Model.instance.currentPageId = Constans.PAGE_ID_INTRO;
			if( event.value == "/font" )    Model.instance.currentPageId = Constans.PAGE_ID_FONT;
			if( event.value.indexOf( "/message" ) == 0 ) Model.instance.currentPageId = Constans.PAGE_ID_PREVIEW;
			if( event.value == "/create" )  Model.instance.currentPageId = Constans.PAGE_ID_CREATE;
		}		
		

	
		
	}
	
}