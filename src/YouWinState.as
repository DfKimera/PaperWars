package {

	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;

	public class YouWinState extends FlxState {

		[Embed("../assets/screens/you_win.jpg")]
		public var SCREEN_BACKGROUND:Class;

		public var background:FlxSprite = new FlxSprite(0,0);

		public var numFrames:int = 0;
		public var freezeTime:int = 60;

		override public function create():void {

			background.loadGraphic(SCREEN_BACKGROUND, false, false, 1280, 720);
			background.immovable = true;
			background.solid = false;
			add(background);

			FlxG.bgColor = 0xFFFFFF;

			super.create();

		}

		override public function update():void {

			if(numFrames >= freezeTime) {

				if(FlxG.keys.any()) {
					FlxG.switchState(new MenuState());
				}

			} else {
				numFrames++;
			}

		}

	}
}
