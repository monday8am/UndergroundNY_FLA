package ui
{
	import events.InternalEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import model.Model;
	
	import util.Constans;
	
	public class Navbar extends Sprite
	{
		public var content : MovieClip;
		private var btns : Array;
				
		public function Navbar()
		{
			super();
			
			content = new nav_assets();
			addChild( content );
			
			btns = [ content.font_btn, 
								 content.about_btn,
								 content.credits_btn,
								 //content.contact_btn,
								 content.logo_btn
								];
			
			for (var i:int = 0; i < btns.length; i++) 
			{
				btns[i].addEventListener( MouseEvent.CLICK, onPressNavBtn );
				btns[i].addEventListener( MouseEvent.ROLL_OVER, onOverNavBtn );
				btns[i].addEventListener( MouseEvent.ROLL_OUT, onOutNavBtn );
				btns[i].buttonMode = true;
			}
			
			Model.instance.addEventListener( InternalEvent.CHANGE_PAGE, onChangePage );
		}
		

		private function onPressNavBtn( event : MouseEvent ):void
		{
			if( event.currentTarget == content.font_btn ) Model.instance.currentPageId = Constans.PAGE_ID_FONT;
			if( event.currentTarget == content.about_btn ) Model.instance.currentPageId = Constans.PAGE_ID_ABOUT;
			if( event.currentTarget == content.credits_btn ) Model.instance.currentPageId = Constans.PAGE_ID_CREDITS;
			//if( event.currentTarget == content.contact_btn ) Model.instance.currentPageId = Constans.PAGE_ID_CONTACT;
			if( event.currentTarget == content.logo_btn ) 
			{ 
				
				Model.instance.message.content = ""; 
				Model.instance.currentPageId = Constans.PAGE_ID_CREATE;
			}
		}
		
		
		private function onChangePage( event : InternalEvent ):void
		{
			for (var i:int = 0; i < btns.length; i++) 
			{
				btns[i].gotoAndStop(1);
			}			
			
			if( Model.instance.currentPageId == Constans.PAGE_ID_ABOUT ) content.about_btn.gotoAndStop(3 );
			if( Model.instance.currentPageId == Constans.PAGE_ID_FONT ) content.font_btn.gotoAndStop(3 );
			if( Model.instance.currentPageId == Constans.PAGE_ID_CREDITS) content.credits_btn.gotoAndStop(3 );
			//if( Model.instance.currentPageId == Constans.PAGE_ID_CONTACT ) content.contact_btn.gotoAndStop(3 );
		}			
		

		private function onOverNavBtn( event : MouseEvent ):void
		{
			event.currentTarget.gotoAndStop( 2 );
		}	
		
		
		private function onOutNavBtn( event : MouseEvent ):void
		{
			if( Model.instance.currentPageId == Constans.PAGE_ID_ABOUT && event.currentTarget == content.about_btn ) return;
			if( Model.instance.currentPageId == Constans.PAGE_ID_FONT && event.currentTarget == content.font_btn ) return;
			if( Model.instance.currentPageId == Constans.PAGE_ID_CREDITS && event.currentTarget == content.credits_btn ) return;
			//if( Model.instance.currentPageId == Constans.PAGE_ID_CONTACT && event.currentTarget == content.contact_btn ) return;
			
			event.currentTarget.gotoAndStop( 1 );
		}			
		
	}
}