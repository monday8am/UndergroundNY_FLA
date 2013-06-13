package command
{
	public interface IAsyncCommand
	{
		function execute(): void;
		
		function addCompleteCallback( callback : Function ) : void;
		
		function complete():void
			
		function release( is_complete : Boolean = true ):void
		
	}
}