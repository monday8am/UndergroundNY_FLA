package command
{
	import flash.events.Event;
	
	import services.ServerOperation;

	public class CallProcedureCommand extends AsyncCommand
	{
		private var procedure : Function;
		
		public function CallProcedureCommand( procedure : Function )
		{
			super();
			this.procedure = procedure;
		}
		
		override public function execute():void
		{
			procedure.call();
			release();
		}

		override public function release( is_complete : Boolean = true ):void
		{
			// complete
			if( is_complete ) complete();			
		}		
		
	}
}