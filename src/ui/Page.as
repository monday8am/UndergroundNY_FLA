package ui
{
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	 
	public class Page extends EventDispatcher
	{
		public var owner : Sprite;
		public var content : MovieClip;
		
		public function Page( _owner : Sprite, assets : MovieClip )
		{
			super();
			owner = _owner;
			
			content = assets;
			content.visible = false;
			content.alpha = 0;
			
			owner.addChild( content );
		}
		
		public function show():void
		{
			//TweenMax.to( content, 0.5, { autoAlpha: 1} );
			content.visible = true;
			content.alpha = 1;			
			init();
		}
		
		public function hide():void
		{
			//TweenMax.to( content, 0.5, { autoAlpha: 0, complete: close } );
			content.visible = false;
			content.alpha = 0;
			close();
		}
		
		public function init():void 
		{
			
		}
		
		public function close():void 
		{
			
		}			
	}
}