package
{
	import controllers.MainController;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import model.Model;
	
	
	[SWF( backgroundColor="#141414", frameRate="30", width="956", height="690")]
	public class NY_msg_underground extends Sprite
	{
		public function NY_msg_underground()
		{
			//
			super();
			
			// 
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// init app..
			var m : Object = Model.instance;
			var controller : MainController = new MainController( this );
			m.mainController = controller; 	
			
			
			controller.initApp();
			//this.scaleX = this.scaleY = 0.5;
		}
	}
}