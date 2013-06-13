package ui
{
	
	import com.asual.swfaddress.SWFAddress;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	
	import fl.text.TLFTextField;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.net.sendToURL;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import model.Message;
	import model.Model;
	
	import org.osmf.containers.MediaContainer;
	import org.osmf.elements.SerialElement;
	import org.osmf.elements.VideoElement;
	import org.osmf.events.MediaElementEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;
	import org.osmf.traits.TimeTrait;
	
	import services.ServerOperation;
	
	import util.Bitly;
	import util.Constans;
	
	
	public class ShareMessage extends Page
	{
		private const FACEBOOK : String = "1";
		private const TWITTER : String = "2";
		private const EMAIL : String = "3";
		private const MAP_SCALE : Number = 3;
		
		private var FROM_TXT : String = "From:";
		private var TO_TXT : String = "To:";
		
		private var share_id  	 : String;
		private var serial    	 : SerialElement;
		private var player    	 : MediaPlayer;
		private var container 	 : MediaContainer;
		private var lastClip	 : DisplayObject;
		private var emailBox	 : MovieClip;
		
		private var seekerMask   : MovieClip;
		
		private var videoBtnsList   : Array = [];
		private var videoTotalTimes : Array; 
		private var partialTime    : Number; 
		
	    private var spaces : String = "123456789";
		
		private var sound : Sound;
		private var soundChannel : SoundChannel;
		private var lastTime	 : Number = 0;
		private var dx : Number = 0;
		private var dy : Number = 0;

		private var timer:Timer;

		private var share_u:String;
		
		private var textFocus : Boolean = false;
		
		
		
		public function ShareMessage(_owner:Sprite, assets:MovieClip)
		{
			super(_owner, assets);
			content.seeker.play_btn.addEventListener( MouseEvent.CLICK, onPressSeekerBtn );
			content.seeker.volume_btn.addEventListener( MouseEvent.CLICK, onPressSeekerBtn );
			content.seeker.volume_btn.buttonMode = true;
			content.seeker.play_btn.buttonMode = true;
			
			content.final_screen.play_again_btn.addEventListener( MouseEvent.CLICK, onPressFinalBtns );
			content.final_screen.new_message_btn.addEventListener( MouseEvent.CLICK, onPressFinalBtns );
			content.music_btn.buttonMode = true;
			content.music_btn.addEventListener( MouseEvent.CLICK, musicSwittecher );
			
			emailBox = content.email_box;
			emailBox.from_txt.tabIndex = 1;
			emailBox.to_txt.tabIndex = 2;
			emailBox.send_btn.addEventListener( MouseEvent.CLICK, onPressSendBtn );
			emailBox.alpha = 0;
			emailBox.from_txt.addEventListener( FocusEvent.FOCUS_IN, onFocusIn);
			emailBox.to_txt.addEventListener( FocusEvent.FOCUS_IN, onFocusIn);
			emailBox.from_txt.addEventListener( FocusEvent.FOCUS_OUT, onFocusOut);
			emailBox.to_txt.addEventListener( FocusEvent.FOCUS_OUT, onFocusOut);	
			
			emailBox.from_txt.text = FROM_TXT;
			emailBox.to_txt.text = TO_TXT;
			
			function onFocusIn( e : FocusEvent ):void { 
				textFocus = true; 

				if( e.currentTarget == emailBox.from_txt ){
					if( emailBox.from_txt.text == FROM_TXT ) 
					{
						emailBox.from_txt.text = "";
					}
				}
				if( e.currentTarget == emailBox.to_txt ){
					if( emailBox.to_txt.text == TO_TXT ) emailBox.to_txt.text = "";
				}				
			}
			function onFocusOut(e : FocusEvent ):void { 
				textFocus = false; 
				if( e.currentTarget == emailBox.from_txt ){
					if( emailBox.from_txt.text == "" ) emailBox.from_txt.text = FROM_TXT;
				}
				if( e.currentTarget == emailBox.to_txt ){
					if( emailBox.to_txt.text == "" ) emailBox.to_txt.text = TO_TXT;
				}
									
			}

			sound = new Sound();
			sound.load( new URLRequest( Constans.REMOTE_IP_DATA + "media/audio/1.mp3"));			
			
			content.stage.addEventListener( Event.RESIZE, onResizeScreen );
			initMap();
		}
		
		private function onPressSendBtn( e : MouseEvent ):void
		{
			if( checkForm())
			{
				var data : Object = new Object();
				
				data.videoUrl = share_u;
				data.from = emailBox.from_txt.text;
				data.to = emailBox.to_txt.text;		
				
				var op : ServerOperation = ServerOperation.sendEmail( data);
				op.addEventListener( Event.COMPLETE, onCompleteSend );
				op.execute();	
				
				emailBox.from_txt.text = FROM_TXT;
				emailBox.to_txt.text = TO_TXT;
				
				TweenMax.to( emailBox, 0.5, { alpha : 0} );
			}
			else
			{
				trace( "show message" );
			}
			
			function checkForm():Boolean
			{
				var result : Boolean = true;

				if( emailBox.from_txt.text == "" || emailBox.from_txt.text == FROM_TXT ) result = false;
				if( emailBox.to_txt.text == ""  || emailBox.to_txt.text == TO_TXT ) result = false;
				if( !validate_email( emailBox.from_txt.text)) result = false;
				if( !validate_email( emailBox.to_txt.text)) result = false;
				
				return result;
			}
			
			function validate_email(s:String):Boolean 
			{
				var p:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
				var r:Object = p.exec(s);
				if( r == null ) 
				{
					return false;
				}
				return true;
			}	
			
			function onCompleteSend( e : Event ):void
			{
				
			}
		}

		
		private function onResizeScreen(event:Event):void
		{
			if( container )
			{
				container.x = 77;
				container.y = 110;				
			}
			
		}
		
		
		private function onPressFinalBtns( e : MouseEvent ):void
		{
			if( content.final_screen.play_again_btn == e.currentTarget )
			{
				if( player.canSeekTo(0))
				{
					player.seek(0);
					playVideo();				
				}
			}
			else
			{
				Model.instance.message = new Message();
				Model.instance.currentPageId = Constans.PAGE_ID_CREATE;
			}
		}		

		
		override public function init():void
		{
			content.error_mc.visible = false;
			content.final_screen.visible = false;
			content.stage.addEventListener( KeyboardEvent.KEY_DOWN, handleKeyboard );		
			content.hide_mc.alpha = 0;
			
			if( Model.instance.message.content != "" )
			{
				showCompleteInterface( true);
				showMessage();
			}
			else
			{
				var addr : String = SWFAddress.getValue();
				var arr  : Array  = addr.split( "/" );
				var id   : String = arr[2];
				
				if( id != null )
				{
					var c : ServerOperation = ServerOperation.getMessage( id );
					c.addEventListener( Event.COMPLETE, onCompleteGetMessage );
					c.execute();
					
					function onCompleteGetMessage(event:Event):void
					{
						if( Model.instance.message.content == "" )
						{
							showError( 2);
						}
						else
						{
							showCompleteInterface( false);
							showMessage();
						}
					}						
				}
				else
				{
					showCompleteInterface( false);
					showError(1);
				}
			}
			
			this.content.addEventListener( Event.ENTER_FRAME, onMouseMove );
		}
		
		
		override public function close() : void
		{
			if( player != null) player.stop();			
			stopVideo();
			
			// remove events and destroy objects
			serial = null;
			player = null;
			
			content.removeChild( container );
			container = null;
			this.content.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
			content.stage.removeEventListener( KeyboardEvent.KEY_DOWN, handleKeyboard );
			content.stage.removeEventListener( Event.RESIZE, onResizeScreen );
			
			// remove letters 
			while( content.seeker.prevContainer.numChildren > 0 )
			{
				content.seeker.prevContainer.removeChildAt( 0);
				content.seeker.normalContainer.removeChildAt( 0);
			}
			content.seeker.seekerMask.width = 1;
			
			this.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
		}
		
		
		private function showMessage():void
		{
			SWFAddress.setValue( "/messages/" + Model.instance.message.id );
			
			var message : String = Model.instance.message.content;
			enableInterface( true );
			
			// create media displayer
			serial = new SerialElement();
			serial.addEventListener( MediaElementEvent.TRAIT_ADD, onTraitEvent );
			
			// player
			player  = new MediaPlayer( serial);
			player.autoDynamicStreamSwitch = false;
			player.addEventListener( TimeEvent.COMPLETE, onPlayerEvents );
			player.autoPlay = false;
			
			container = new MediaContainer();
			container.addMediaElement( serial );	
			container.width = 800;
			container.height = 450;	
			container.x = 77;
			container.y = 110;
			content.addChild( container );
			
			// reset total time
			videoTotalTimes = [];
			partialTime = 0;
			
			// create media elements
			for (var i:int = 0; i < message.length; i++) 
			{
				var url : String = Constans.REMOTE_IP_DATA + "media/video/" + Model.instance.letter_list[ message.charAt( i ).toLowerCase() ].videoURL;
				var video : VideoElement = new VideoElement( new URLResource( url ));
				video.defaultDuration = Model.instance.letter_list[ message.charAt( i ).toLowerCase() ].duration;
				serial.addChild( video );
				
				// add btn
				var graphic : MovieClip = new videoTimerPrev_mc();
				if( spaces.indexOf( message.charAt( i ) ) != -1 )
				{
					graphic.letter_mc.text = " ";
				}
				else
				{
					graphic.letter_mc.text = message.charAt( i ).toUpperCase();
				}				
				graphic.x = i * 26;
				content.seeker.prevContainer.addChild( graphic );				
				
				var btn : MovieClip = new videoTimer_mc();
				if( spaces.indexOf( message.charAt( i ) ) != -1 )
				{
					btn.letter_mc.text = " ";
				}
				else
				{
					btn.letter_mc.text = message.charAt( i ).toUpperCase();
				}
				btn.x = i * 26;
				btn.addEventListener( MouseEvent.CLICK, onPressSeekerBtn );
				btn.buttonMode = true;
				content.seeker.normalContainer.addChild( btn );
				videoBtnsList.push( btn );
				
				
				videoTotalTimes.push( int( Model.instance.letter_list[ message.charAt( i ).toLowerCase() ].duration ));
			}	
			
			// setup seeker
			content.seeker.seekerMask.width = 1;
			content.seeker.play_btn.gotoAndStop( 2);
			content.seeker.volume_btn.x = ( message.length + 1 )* 26;
			content.seeker.x = 20 + ( 912 - ( message.length )* 26 ) / 2;
			
			// play
			playVideo();
		}
		
		
		private function showError( error_id : int ):void
		{
			SWFAddress.setValue( "/messages/error" );	
			
			// show error text
			content.error_mc.visible = true;
			content.error_mc.gotoAndStop( error_id );
			enableInterface( false );
			
			content.share_facebook_btn.alpha = 0.5;
			content.share_twitter_btn.alpha = 0.5;
			content.share_email_btn.alpha = 0.5;
			content.new_note_btn.alpha = 0.5;
			content.edit_btn.alpha = 0.5;					
		}		
		
		
		private function saveMessage():void
		{
			var c : ServerOperation = ServerOperation.saveMessage( Model.instance.message.content, share_id );
			c.addEventListener( Event.COMPLETE, onCompleteSaveMessage );
			c.execute();
			enableInterface( false )
			
			function onCompleteSaveMessage(event:Event):void
			{
				var c : ServerOperation = event.currentTarget as ServerOperation;
				Model.instance.message.id = c.message_id;
				enableInterface( true );
				shareMessage();
			}		
		}
		
		
		private function shareMessage():void
		{
			if( player.playing ) pauseVideo();
			share_u = Constans.REMOTE_IP_DATA + "#/message/" + Model.instance.message.id;
			var urlRequest:URLRequest
			var urlVars : URLVariables = new URLVariables();
			
			if( share_id == FACEBOOK )
			{
				urlRequest = new URLRequest('http://www.facebook.com/sharer.php');
				urlVars.u = share_u;
				urlRequest.data = urlVars;
				urlRequest.method = URLRequestMethod.GET;	
				navigateToURL(urlRequest, '_blank');
			}
			
			if( share_id == TWITTER )
			{
				var BITLY_LOGIN:String = "o_1f6uj5rs3q";//your username
				var BITLY_KEY:String = "R_c3694082c208351f7ec71154d0a695fd";//your api key
				
				var _bitly : Bitly =  Bitly.getInstance();
				_bitly.login = BITLY_LOGIN;
				_bitly.apiKey = BITLY_KEY;
				
				_bitly.shortenUrl(share_u);
				_bitly.addEventListener(Event.COMPLETE,bitlyCompleteHandeler,false, 0, true);
				
				function bitlyCompleteHandeler(event:Event):void
				{
					_bitly.removeEventListener(Event.COMPLETE,bitlyCompleteHandeler);
					share_u = _bitly.shortUrl;

					// navigate to twitter URL
					urlVars.url = share_u;
					urlVars.text = "Messages from the heart of New York City. Enjoy the ride in one of the best cities in the world.";
					urlRequest = new URLRequest('http://twitter.com/share');
					
					urlRequest.data = urlVars;
					urlRequest.method = URLRequestMethod.GET;	
					navigateToURL(urlRequest, '_blank');							
				}				
			}	

			if( share_id == EMAIL )
			{
				emailBox.send_btn.enabled = true;
				emailBox.send_btn.alpha = 1;
			}		
		}	
		
		
		private function showLetter():void
		{
			if( Model.instance.message.content == "" ) return;
			if( lastClip != null ) lastClip.visible = false;
			
			var char  : String = Model.instance.message.content.charAt( serial.getChildIndex( serial.currentChild ) ); 
			if( spaces.indexOf( char ) != -1 )
			{
				char = "_" + char;
			}
			var letterClip : DisplayObject = getMapClip( char.toLowerCase());
			TweenMax.to( content.mapAnimation_mc.map, 1,{ x: -letterClip.x + 411/2, y: -letterClip.y + 288/2, ease: Expo.easeInOut } );
			letterClip.visible = true;
			lastClip = letterClip;
		}
		
		
		private function playVideo():void
		{
			content.final_screen.visible = false;
			player.play();
			content.seeker.play_btn.gotoAndStop( 2 );
			
			this.content.addEventListener( Event.ENTER_FRAME, onEnterFrame );	
			if( sound != null ) 
			{
				soundChannel = sound.play( lastTime );
				var myTransform : SoundTransform = new SoundTransform();
				myTransform.volume = 0.5;
				soundChannel.soundTransform = myTransform;					
			}
		}
		
		
		private function pauseVideo():void
		{
			content.final_screen.visible = false;
			player.pause();
			content.seeker.play_btn.gotoAndStop( 1 );
			this.content.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
			if( sound != null )
			{
				lastTime = soundChannel.position;
				soundChannel.stop();				
			}
		}	
		

		private function stopVideo():void
		{
			if( soundChannel != null )
			{
				var myTransform : SoundTransform = new SoundTransform();
				myTransform.volume = 0;
				soundChannel.soundTransform = myTransform;
				lastTime = 0;
				soundChannel.stop();				
			}
			
			content.final_screen.visible = true;
			content.seeker.play_btn.gotoAndStop( 1);
			this.content.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
			player.stop();			
		}
		
		/*
		*
		*  Event handlers
		*
		*/
		
		private function onPressSeekerBtn( e : MouseEvent ):void
		{
			var index : int;

			if( e.currentTarget == content.seeker.play_btn )
			{
				if( player.playing ) 
				{
					pauseVideo();
				}
				else
				{
					playVideo();
				}
			}
			else if( e.currentTarget == content.seeker.volume_btn )
			{
				if( player.muted )
				{
					player.muted = false;
					e.currentTarget.gotoAndStop( 1 );
				}
				else
				{
					player.muted = true;
					e.currentTarget.gotoAndStop( 2 );					
				}
			}
			else if( DisplayObject( e.currentTarget ).parent == content.seeker.prevContainer )
			{
				index = content.seeker.prevContainer.getChildIndex( e.currentTarget );
			}
			else
			{
				index = content.seeker.normalContainer.getChildIndex( e.currentTarget );
				var previous_time : int = 0;
				var i : int = 0;
				
				while( i < index )
				{
					previous_time += Model.instance.letter_list[ Model.instance.message.content.charAt(i) ].duration;
					i++;
				}
				
				if( player.canSeekTo( previous_time ) )
				{
					player.seek( previous_time );
					playVideo();
				}
			}			
		}
		
		
		private function musicSwittecher( event : MouseEvent ):void
		{
			var myTransform : SoundTransform = new SoundTransform();

			if( content.music_btn.currentFrame == 1 )
			{
				content.music_btn.gotoAndStop( 2 );
				myTransform.volume = 0;
				soundChannel.soundTransform = myTransform;
			}
			else
			{
				content.music_btn.gotoAndStop(1 );
				myTransform.volume = 0.7;
				soundChannel.soundTransform = myTransform;				
			}
		}
		

		private function onEnterFrame(event:Event):void
		{
			// TODO Auto-generated method stub
			/**/
			partialTime = TimeTrait( serial.currentChild.getTrait("time")).currentTime;
			
			var videoIndex : int = serial.getChildIndex( serial.currentChild );
			var totalVideoTime : Number = videoTotalTimes[ videoIndex ];
			var percente : Number = partialTime / totalVideoTime ;
			
			//Model.instance.message.content.charAt( serial.getChildIndex( serial.currentChild ) )
			content.seeker.seekerMask.width = ( videoIndex * 26 ) + percente * 24;

		}
		
		
		private function onPlayerEvents( event : Event ):void
		{
			if( event.type == TimeEvent.COMPLETE )
			{
				pauseVideo();
				stopVideo();
			}
		}
		
		
		protected function onTraitEvent(event: MediaElementEvent ):void
		{
			if( event.type == MediaElementEvent.TRAIT_ADD && event.traitType == "play" )
			{
				showLetter();
			}
		}		
		
		
		private function onPressShareBtn( e : MouseEvent ):void
		{
			if( e.currentTarget == content.share_facebook_btn ) share_id  = FACEBOOK;
			if( e.currentTarget == content.share_twitter_btn )  share_id  = TWITTER;
			if( e.currentTarget == content.share_email_btn )	
			{
				emailBox.send_btn.enabled = false;
				emailBox.send_btn.alpha = 0.7;
				if( emailBox.alpha == 0 ) 
				{
					emailBox.from_txt.text = FROM_TXT;
					emailBox.to_txt.text = TO_TXT;					
					TweenMax.to( emailBox, 0.4, { alpha: 1} );
				}
				share_id  = EMAIL;
			}
			
			if( Model.instance.message.id == "" )
			{
				saveMessage();
			}
			else
			{
				shareMessage();
			}
		}	
		
		
		private function onPressBtn( e : MouseEvent ):void
		{
			if( e.currentTarget == content.new_note_btn )
			{
				Model.instance.message = new Message();
			}
			
			Model.instance.currentPageId = Constans.PAGE_ID_CREATE;
		}		
		
		

		
		
		private function handleKeyboard( event : KeyboardEvent )
		{
			if(event.charCode == 32)
			{
				if( player.playing )
				{
					pauseVideo();
				}
				else
				{
					playVideo();
				}
			}
			
			if( event.charCode == 13)
			{
				if( emailBox.alpha > 0 )
				{
					onPressSendBtn( null);
				}
			}
		}		
		
		/*
		*
		* utils
		*
		*/
		private function enableInterface( value : Boolean ):void
		{
			if( value )
			{
				content.share_facebook_btn.addEventListener( MouseEvent.CLICK, onPressShareBtn );
				content.share_twitter_btn.addEventListener( MouseEvent.CLICK,  onPressShareBtn );
				content.share_email_btn.addEventListener( MouseEvent.CLICK,    onPressShareBtn );	
				
				content.new_note_btn.addEventListener( MouseEvent.CLICK,    onPressBtn );
				content.edit_btn.addEventListener( MouseEvent.CLICK,        onPressBtn );	
				
				content.share_facebook_btn.alpha = 1;
				content.share_twitter_btn.alpha = 1;
				content.share_email_btn.alpha = 1;
				content.new_note_btn.alpha = 1;
				content.edit_btn.alpha = 1;				
			}
			else
			{
				content.share_facebook_btn.removeEventListener( MouseEvent.CLICK, onPressShareBtn );
				content.share_twitter_btn.removeEventListener ( MouseEvent.CLICK, onPressShareBtn );
				content.share_email_btn.removeEventListener   ( MouseEvent.CLICK, onPressShareBtn );
				
				content.new_note_btn.removeEventListener( MouseEvent.CLICK, onPressBtn );
				content.edit_btn.removeEventListener	( MouseEvent.CLICK, onPressBtn );				
			}
		}
		
		
		private function initMap():void
		{
			var letters : String = "abcdefghijklmnopqrstuvwxyz" + spaces;
			var clip : DisplayObject;
			
			for (var i:int = 0; i < letters.length; i++) 
			{
				clip = getMapClip( letters.charAt( i) );
				clip.visible = false;
				clip.scaleX = 
				clip.scaleY = MAP_SCALE;
				clip.x = clip.x * MAP_SCALE;	
				clip.y = clip.y * MAP_SCALE;
			}
			
			content.mapAnimation_mc.map.mapBg.scaleX = 
			content.mapAnimation_mc.map.mapBg.scaleY = MAP_SCALE;
			
		}
		
		
		private function showCompleteInterface( value : Boolean ):void
		{
			if( !value )
			{
				content.share_facebook_btn.visible = false;
				content.share_twitter_btn.visible = false;
				content.share_email_btn.visible = false;
				content.new_note_btn.visible = false;
				content.edit_btn.visible = false;
				content.buttons_bg.visible = false;
				content.music_btn.visible = false;
				emailBox.visible = false;
				
				content.final_screen.new_message_btn.visible = true;
				content.final_screen.play_again_btn.visible = true;
				content.final_screen.play_again_btn.x = 322;
			}
			else
			{
				content.share_facebook_btn.visible = true;
				content.share_twitter_btn.visible = true;
				content.share_email_btn.visible = true;
				content.new_note_btn.visible = true;	
				content.edit_btn.visible = true;
				content.buttons_bg.visible = true;
				content.music_btn.visible = true;
				emailBox.visible = true;
				
				content.final_screen.new_message_btn.visible = false;
				content.final_screen.play_again_btn.visible = true;
				content.final_screen.play_again_btn.x = 397;
			}
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
			
			return content.mapAnimation_mc.map.getChildByName(result);
		}
		
		
		protected function onMouseMove(event:Event):void
		{
			if( dx != content.stage.mouseX || dy != content.stage.mouseY )
			{
				showInterface();
			}
			else
			{
				mouseStop();
			}
			
			dx  = content.stage.mouseX;
			dy  = content.stage.mouseY; 
			
		}				
		
		private function mouseStop():void
		{
			if( timer != null ) return;
			
			timer = new Timer( 5000, 1 );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, onTimerComplete );
			timer.start();
			
			function onTimerComplete( event : Event ):void
			{
				hideInterface();
				
			}
		}	
		
		private function showInterface() : void
		{
			if( timer != null )
			{
				timer.stop();
				timer = null;
			}
			
			if( content.share_facebook_btn.alpha == 1 )  return;
			
			TweenMax.to(content.hide_mc, 0.5, { alpha : 0} );
			TweenMax.to(content.share_facebook_btn,0.5, { alpha : 1 } );
			TweenMax.to(content.share_twitter_btn,0.5, { alpha : 1 } );
			TweenMax.to(content.share_email_btn,0.5, { alpha : 1 } );
			TweenMax.to(content.new_note_btn,0.5, { alpha : 1 } );
			TweenMax.to(content.edit_btn,0.5, { alpha : 1 } );
			TweenMax.to(content.buttons_bg,0.5, { alpha : 1 } );
			TweenMax.to(content.music_btn,0.5, { alpha : 1 } );
			
			
			TweenMax.to(content.final_screen.new_message_btn,0.5, { alpha : 1 } );
			TweenMax.to(content.final_screen.play_again_btn,0.5, { alpha : 1 } );				
		}
		
		private function hideInterface() : void
		{
			if( textFocus ) return;
			if( content.share_facebook_btn.alpha == 0 )  return;

			TweenMax.to(content.hide_mc, 0.5, { alpha : 1} );
			TweenMax.to(content.share_facebook_btn,0.5, { alpha : 0 } );
			TweenMax.to(content.share_twitter_btn,0.5, { alpha : 0 } );
			TweenMax.to(content.share_email_btn,0.5, { alpha : 0} );
			TweenMax.to(content.new_note_btn,0.5, { alpha : 0 } );
			TweenMax.to(content.edit_btn,0.5, { alpha : 0} );
			TweenMax.to(content.buttons_bg,0.5, { alpha : 0 } );
			TweenMax.to(content.music_btn,0.5, { alpha : 0 } );
			TweenMax.to(emailBox,0.5, { alpha : 0 } );
			
			TweenMax.to(content.final_screen.new_message_btn,0.5, { alpha : 0 } );
			TweenMax.to(content.final_screen.play_again_btn,0.5, { alpha : 0 } );	
		}
		

	}
}