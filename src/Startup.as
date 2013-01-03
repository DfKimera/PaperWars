package {

	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.system.Security;
	import flash.system.fscommand;

	import org.flixel.FlxG;
	import org.flixel.FlxGame;

	[SWF(width="1280",height="720")]
	public class Startup extends FlxGame {

		public static var ARCADE_MODE:Boolean = false;

		public function Startup() {

		    Security.allowDomain("*");

		    try {
				fscommand("fullscreen", "true");
		    } catch (ex:Error) {

		    }

		    stage.scaleMode = StageScaleMode.NO_BORDER;
		    stage.align = StageAlign.TOP;

		    super(1280, 720, MenuState);

		    this.useSoundHotKeys = false;

	    }

	}
}
