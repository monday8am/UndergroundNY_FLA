package ui
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class FontPage extends Page
	{
		
		private var map_game : FontMapGame;
		private var fonts_image : MovieClip; 
		
		public function FontPage(_owner:Sprite, assets:MovieClip)
		{
			super(_owner, assets);	
			map_game = new FontMapGame( content.font_map_game ); 
			fonts_image = content.font_images_mc;
			
			fonts_image.visible = false;
			
			content.show_map_btn.addEventListener( MouseEvent.CLICK, onPressSelector );
			content.show_fonts_btn.addEventListener( MouseEvent.CLICK, onPressSelector );
			content.show_fonts_btn.buttonMode = true;
			content.show_map_btn.buttonMode = true;
			content.show_map_btn.gotoAndStop( 2);
			
		}
		
		private function onPressSelector( event : MouseEvent ):void
		{
			if( event.currentTarget == content.show_map_btn )
			{
				map_game.init();
				fonts_image.visible = false;
				content.show_map_btn.gotoAndStop( 2);
				content.show_fonts_btn.gotoAndStop( 1);
			}
			else
			{
				map_game.release();
				fonts_image.visible = true;		
				content.show_map_btn.gotoAndStop( 1);
				content.show_fonts_btn.gotoAndStop( 2);
			}
		}		
		
		override public function init():void
		{
			map_game.init();
		}
		
		override public function close():void
		{
			map_game.release();
		}
		
	}
}