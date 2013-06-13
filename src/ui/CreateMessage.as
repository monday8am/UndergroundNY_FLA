package ui
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import model.Model;
	
	import util.Constans;
	
	public class CreateMessage extends Page
	{
		
		private var msg_container : Sprite;
		private var letter_width 	 : int = 115;
		private var letter_height	 : int = 59;
		private var letter_max_count : int = 40;
		
		private var init_x : int = 19;
		private var init_y : int = 110;
		
		private var visual_msg : Array;
		
		private var components : Array;
		private var initial_pos : Array = [];
		private var spaces : String = "123456789";
		
		
		public function CreateMessage(_owner:Sprite, assets:MovieClip)
		{
			super(_owner, assets);
			
			content.preview_btn.addEventListener( MouseEvent.CLICK, onPressBtn );
			content.message_txt.addEventListener( Event.CHANGE, onChangeMessage );
			
			content.message_txt.restrict = "ABCDEFGHIJKLMNOPQRSTUVWXYZ ";
			
			// message container
			msg_container = new Sprite();
			content.addChild( msg_container );
			msg_container.x = init_x; msg_container.y = init_y;	
			
			components = [ content.text_bg, content.message_txt, content.time_txt, content.preview_btn, content.btn_preview ];
			for (var i:int = 0; i < components.length; i++) 
			{
				initial_pos[i] = components[i].y;
			}
		}
		
		
		override public function init():void
		{
			if( visual_msg == null ) 
			{
				visual_msg = [];
			}
			
			content.message_txt.text = getReadableMessage();
			generateVisualMessage();		
			content.stage.focus = content.message_txt;
			
			// get key presses only when the textfield is being edited
			content.message_txt.addEventListener( KeyboardEvent.KEY_DOWN, handleKeyboard );
		}
		
		
		override public function close():void
		{
			content.message_txt.removeEventListener( KeyboardEvent.KEY_DOWN, handleKeyboard);
		}
		
		
		public function generateVisualMessage():void
		{
			// TODO Auto Generated method stub
			var msg : String = content.message_txt.text;
			msg  = msg.split( "\r" ).join( "" ); 
			msg  = msg.toLowerCase();
			
			var letter : LetterClip;
			var i : int;
			
			if( msg.length > 40 ) 
			{
				content.message_txt.text = getReadableMessage();	
				return;
			}

			// add new letters
			for ( i = 0; i < msg.length; i++) 
			{
				if( visual_msg[i] != null  )
				{
					if( visual_msg[i].data.character != msg.charAt(i) )
					{
						if( msg.charAt(i) == " ")
						{
							if( spaces.indexOf( visual_msg[i].data.character ) == -1 )
							{
								visual_msg[i].data = Model.instance.letter_list[ msg.charAt(i) ];
							}
						}
						else
						{
							visual_msg[i].data = Model.instance.letter_list[ msg.charAt(i) ];
						}
					}	
				}
				else
				{
					if( msg.charAt(i) == " " )
					{
						visual_msg[i] = addLetter( spaces.charAt( randomNumber( 0, spaces.length - 1 )));
					}
					else
					{
						visual_msg[i] = addLetter( msg.charAt(i) );
					}
				}
			}
			
			
			// delete letters
			var remove_arr : Array = visual_msg.splice( msg.length, visual_msg.length - msg.length );
			for ( i = 0; i < remove_arr.length; i++) removeLetter( remove_arr[i] );
			
			// set time
			var total_time : int = 0;
			
			for ( i = 0; i < visual_msg.length; i++) 
			{
				total_time += visual_msg[i].data.duration;
			}
			
			content.time_txt.text = total_time  + " secs"; 	
			
			// save changes in Model
			Model.instance.message.totalTime = total_time;
			Model.instance.message.content = "";
			for (var j:int = 0; j < visual_msg.length; j++) 
			{
				Model.instance.message.content += visual_msg[j].data.character;
			}
			
			if( visual_msg.length == 0 )
			{
				content.preview_btn.visible = false;
				content.btn_preview.visible = true;
			}
			else
			{
				content.preview_btn.visible = true;
				content.btn_preview.visible = false;		
			}
			
			// set textbox position
			if( visual_msg.length == 0 ) {moveTextBox(true);} else {moveTextBox(false);}
			
		}
		
		
		private function addLetter( char : String ): LetterClip
		{
			var len : int = visual_msg.length;
			var y_index : int = Math.floor( len / 8 );
			var x_index : int = len % 8;
			var letter : LetterClip = new LetterClip( Model.instance.letter_list[ char ] );
			
			msg_container.addChild( letter );
			letter.x = x_index * letter_width;
			letter.y = y_index * letter_height;
				
			return letter;
		}
		
		
		private function removeLetter( letter : LetterClip ):void
		{
			msg_container.removeChild( letter);
		} 
		
		
		// 
		//  Events
		//
		private function onChangeMessage( e : Event ):void
		{
			generateVisualMessage();
			
		}	
		
		
		private function handleKeyboard( event : KeyboardEvent )
		{
			// if the key is ENTER
			if(event.charCode == 13)
			{
				Model.instance.currentPageId = Constans.PAGE_ID_PREVIEW;
			}
		}		
		
		private function onPressBtn( e : MouseEvent ):void
		{
			if( e.currentTarget == content.preview_btn ) Model.instance.currentPageId = Constans.PAGE_ID_PREVIEW;
		}		
		
		
		// utils
		private function moveTextBox( top : Boolean ):void
		{
			var i : int = 0;
			if( top )
			{
				content.time_txt.visible = false;
				//content.intro_text_mc.visible = true;
				//content.time_txt.text = "0 Sec" 
				content.text_bg.write_banner_mc.visible = true;
				for ( i = 0; i < components.length; i++) 
					components[i].y = initial_pos[i]  - 100;			
			}
			else
			{
				content.time_txt.visible = true;
				//content.intro_text_mc.visible = false;
				content.text_bg.write_banner_mc.visible = false;
				for ( i = 0; i < components.length; i++) 
					components[i].y = initial_pos[i];	
			
			}
		}
		
		private function randomNumber(low:Number=0, high:Number=1):Number
		{
			return Math.floor(Math.random() * (1+high-low)) + low;
		}
		
		private function getReadableMessage():String
		{
			var str : String = Model.instance.message.content;
			
			for (var i:int = 0; i < str.length; i++) 
			{
				if( spaces.indexOf( str.charAt(i) ) != -1 )
				{
					str.replace( str.charAt(i), " " );
				}
			}
			
			return str.toUpperCase();
			
		}
		
	
		
	}
}