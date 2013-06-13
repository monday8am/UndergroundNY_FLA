package command
{
	import flash.utils.getQualifiedClassName;

	public class AsyncCommand implements IAsyncCommand
	{
		public var callback : Function;
		
		public function AsyncCommand()
		{
		}
		
		public function execute():void
		{
		}
		
		public function addCompleteCallback( callback : Function ):void
		{
			this.callback = callback;
		}
		
		public function complete():void
		{	
			callback.call();
		}
		
		public function release( is_complete : Boolean = true ):void
		{	
			
		}		
		
	}
}