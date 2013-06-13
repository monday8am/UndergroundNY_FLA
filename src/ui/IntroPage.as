package ui
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import model.Model;
	
	import util.Constans;
	
	public class IntroPage extends Page
	{
		
		public function IntroPage(_owner:Sprite, assets:MovieClip)
		{
			super(_owner, assets);
			
			content.start_btn.addEventListener( MouseEvent.CLICK, onPressStart );
		}
		
		private function onPressStart( e : MouseEvent ):void
		{
			Model.instance.currentPageId = Constans.PAGE_ID_CREATE;
		}
	}
}