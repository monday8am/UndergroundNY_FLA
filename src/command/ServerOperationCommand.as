package command
{
	import flash.events.Event;
	
	import model.Model;
	
	import services.ServerOperation;

	public class ServerOperationCommand extends AsyncCommand
	{
		private var op : ServerOperation;
		
		public function ServerOperationCommand( op : ServerOperation )
		{
			super();
			this.op = op;
		}
		
		override public function execute():void
		{
			op.addEventListener( Event.COMPLETE, onOperationComplete );
			op.execute();
		}
		
		private function onOperationComplete(event:Event):void
		{
			release();
		}
		
		override public function release( is_complete : Boolean = true ):void
		{
			op.removeEventListener( Event.COMPLETE, onOperationComplete );
			// complete
			if( is_complete ) complete();			
		}		
		
	}
}