package command
{
	public class CommandList
	{
		private var commands : Array = [];
		private var isBusy : Boolean = false;
		private var isPaused : Boolean = false;
		private var current_command : IAsyncCommand;
		
		public function add( new_command : IAsyncCommand ):void
		{
			new_command.addCompleteCallback( executeNext );
			commands.push( new_command );
			attemptExecute();
		}
		
		public function restart():void
		{
			isPaused = false;
			executeNext();
		}
		
		public function pause():void
		{
			isPaused = true;
		}
		
		public function release():void
		{
			// if current command is alive..
			if( current_command != null ) 
			{
				current_command.release( false );
			}
			
			commands.splice(0);
		}
		
		private function attemptExecute():void
		{
			// if is paused... return..
			if( isPaused ) return;
			
			if( !isBusy )
			{
				executeNext();
			}
		}
		
		private function executeNext():void
		{
			isBusy = false;
			current_command  = null;
			
			if( commands.length > 0 )
			{
				isBusy = true;
				current_command  = commands.shift() as IAsyncCommand;
				current_command .execute();
			}
		}		
		
		
	}
}