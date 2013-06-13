package ui
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import model.Model;
	
	public class FontMapGame 
	{
		
		private var map_mc      : MovieClip;
		private var lastClip 	: DisplayObject;
		private var spaces   	: String = "123456789";
		
		public function FontMapGame( map : MovieClip 	)
		{
			map_mc = map;
		}
		
		
		public function init():void
		{
			map_mc.visible = true;
			map_mc.stage.addEventListener( KeyboardEvent.KEY_DOWN, handleKeyboard );
			initMap();
			
			var letters : String = "abcdefghijklmnopqrstuvwxyz";
			var char : String = letters.charAt( randomNumber( 0, letters.length - 1 ));	
			moveMap( char );
		}
		
	
		
		public function release():void
		{
			map_mc.visible = false;
			map_mc.stage.removeEventListener( KeyboardEvent.KEY_DOWN, handleKeyboard );
		}
		
		
		public function moveMap( char : String ):void
		{
			if( char == "" ) return;
			
			if( lastClip != null ) 
			{
				//lastClip.visible = false;
				//lastClip.alpha = 0;
			}
			if( spaces.indexOf( char ) != -1 )
			{
				char = "_" + char;
			}
			var letterClip : DisplayObject = getMapClip( char.toLowerCase());
			/**/
			TweenMax.to( map_mc.map, 0.4,{ x: -letterClip.x + map_mc.mask_mc.width /2, 
												  y: -letterClip.y + map_mc.mask_mc.height /2, 
												  ease: Expo.easeInOut });
			
			
			
			
			
			
			letterClip.visible = true;
			letterClip.alpha = 1;
			TweenMax.to( letterClip, 1 , { autoAlpha: 0, delay: 0.5 } ); 
			lastClip = letterClip;
				
		}
		
		
		// events
		private function handleKeyboard(event:KeyboardEvent):void
		{
			var char : String = "";
			
			trace( event.charCode );
			
			// TODO Auto-generated method stub
			if( event.charCode == 65 || event.charCode == 97 ) char = "a";
			if( event.charCode == 66 || event.charCode == 98 ) char = "b";
			if( event.charCode == 67 || event.charCode == 99 ) char = "c";
			if( event.charCode == 68 || event.charCode == 100 ) char = "d";
			if( event.charCode == 69 || event.charCode == 101 ) char = "e";
			if( event.charCode == 70 || event.charCode == 102 ) char = "f";
			if( event.charCode == 71 || event.charCode == 103 ) char = "g";
			if( event.charCode == 72 || event.charCode == 104 ) char = "h";
			if( event.charCode == 73 || event.charCode == 105 ) char = "i";
			if( event.charCode == 74 || event.charCode == 106 ) char = "j";
			if( event.charCode == 75 || event.charCode == 107 ) char = "k";
			if( event.charCode == 76 || event.charCode == 108 ) char = "l";
			if( event.charCode == 77 || event.charCode == 109 ) char = "m";
			if( event.charCode == 78 || event.charCode == 110 ) char = "n";
			if( event.charCode == 79 || event.charCode == 111 ) char = "o";
			if( event.charCode == 80 || event.charCode == 112 ) char = "p";
			if( event.charCode == 81 || event.charCode == 113 ) char = "q";
			if( event.charCode == 82 || event.charCode == 114 ) char = "r";
			if( event.charCode == 83 || event.charCode == 115 ) char = "s";
			if( event.charCode == 84 || event.charCode == 116 ) char = "t";
			if( event.charCode == 85 || event.charCode == 117 ) char = "u";
			if( event.charCode == 86 || event.charCode == 118 ) char = "v";
			if( event.charCode == 87 || event.charCode == 119 ) char = "w";
			if( event.charCode == 88 || event.charCode == 120 ) char = "x";
			if( event.charCode == 89 || event.charCode == 121 ) char = "y";
			if( event.charCode == 90 || event.charCode == 122 ) char = "z";
			if( event.charCode == 32 ) char = String( randomNumber( 1, 9 ));
			
			moveMap( char );
			
		}	
		
		
		private function getMapClip( name : String ): DisplayObject
		{
			var result : String = "";
			
			if( spaces.indexOf( name ) != -1 )
			{
				result = "_" + name;
			}
			else
			{
				result = name;
			}
			
			return map_mc.map.getChildByName(result);
		}	
		
		private function randomNumber(low:Number=0, high:Number=1):Number
		{
			return Math.floor(Math.random() * (1+high-low)) + low;
		}	
		
		private function initMap():void
		{
			var letters : String = "abcdefghijklmnopqrstuvwxyz" + spaces;
			var clip : DisplayObject;
			
			for (var i:int = 0; i < letters.length; i++) 
			{
				clip = getMapClip( letters.charAt( i) );
				
				clip.visible = false;
				
				trace( clip.visible );
			}
		}		
		
		
	}
}