package {
	import flash.utils.setInterval;

	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;

	public class PressStartWidget extends FlxSprite {

		[Embed("../assets/press_start.png")]
		public var SPRITE:Class;

		public function PressStartWidget() {
			scrollFactor = new FlxPoint(0,0);
			moves = false;
			immovable = true;
			solid = false;
			loadGraphic(SPRITE, false,false,350,60);

			setInterval(toggleVisibility, 500);
		}

		public function toggleVisibility():void {
			this.visible = !this.visible;
		}
	}
}
