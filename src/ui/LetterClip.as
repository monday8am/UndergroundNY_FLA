package ui
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import model.LetterData;
	
	public class LetterClip extends MovieClip
	{
		
		private var _data : LetterData;
 
		private var animation : MovieClip;
 
		private var content : MovieClip;
		
		
		public function LetterClip( _d : LetterData )
		{
			super();
			
			content = new letter_mc();
			addChild( content);
			this.data = _d;
			
			this.addEventListener( MouseEvent.CLICK, onPressLetter ); 
			
			animation = createAnimation( data.character );
			addChild( animation );
			animation.gotoAndPlay( 2 );
			content.letter_txt.visible = false;

			var timer : Timer = new Timer( 400, 1); 
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, onTimerComplete );
			timer.start();
			
			this.addEventListener( MouseEvent.ROLL_OVER, onRollOverLetter );
			this.addEventListener( MouseEvent.ROLL_OUT,  onRollOutLetter );
		}
		
		
		private function onRollOverLetter(event:MouseEvent):void
		{
			animation.visible =  true;
			animation.gotoAndPlay(2);
		}
		
		
		private function onRollOutLetter(event:MouseEvent):void
		{
			//animation.visible =  false;
			animation.gotoAndStop(1);
		}	
		
		
		private function onTimerComplete(event:TimerEvent):void
		{
			//animation.visible = false;
			animation.gotoAndStop(1);
		}
		
		
		public function get data():LetterData
		{
			return _data;
		}

		
		public function set data( value:LetterData):void
		{
			_data = value;
		 
			//content.letter_txt.text = _data.character;
		}

		 
		private function onPressLetter(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		
		private function createAnimation( char : String ): MovieClip
		{
			var animation : MovieClip =  new MovieClip(); 
			
			if( char == "a" ) animation =  new a_letter_animation();
			if( char == "b" ) animation =  new b_letter_animation();
			if( char == "c" ) animation =  new c_letter_animation();
			if( char == "d" ) animation =  new d_letter_animation();
			if( char == "e" ) animation =  new e_letter_animation();			
			if( char == "f" ) animation =  new f_letter_animation();
			if( char == "g" ) animation =  new g_letter_animation();
			if( char == "h" ) animation =  new h_letter_animation();
			if( char == "i" ) animation =  new i_letter_animation();
			if( char == "j" ) animation =  new j_letter_animation();
			if( char == "k" ) animation =  new k_letter_animation();
			if( char == "l" ) animation =  new l_letter_animation();
			if( char == "m" ) animation =  new m_letter_animation();
			if( char == "n" ) animation =  new n_letter_animation();
			if( char == "o" ) animation =  new o_letter_animation();
			if( char == "p" ) animation =  new p_letter_animation();
			if( char == "q" ) animation =  new q_letter_animation();
			if( char == "r" ) animation =  new r_letter_animation();
			if( char == "s" ) animation =  new s_letter_animation();
			if( char == "t" ) animation =  new t_letter_animation();
			if( char == "u" ) animation =  new u_letter_animation();
			if( char == "v" ) animation =  new v_letter_animation();
			if( char == "w" ) animation =  new w_letter_animation();
			if( char == "x" ) animation =  new x_letter_animation();
			if( char == "y" ) animation =  new y_letter_animation();
			if( char == "z" ) animation =  new z_letter_animation();	
			if( char == " " ) animation =  new space_letter_animation();
			if( char == "0" ) animation =  new space_letter_animation();
			if( char == "1" ) animation =  new space_letter_animation();
			if( char == "2" ) animation =  new space_letter_animation();
			if( char == "3" ) animation =  new space_letter_animation();
			if( char == "4" ) animation =  new space_letter_animation();
			if( char == "5" ) animation =  new space_letter_animation();
			if( char == "6" ) animation =  new space_letter_animation();
			if( char == "7" ) animation =  new space_letter_animation();
			if( char == "8" ) animation =  new space_letter_animation();
			if( char == "9" ) animation =  new space_letter_animation();
			
			return animation;
		}
		
		
	}
}