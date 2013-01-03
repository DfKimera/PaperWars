package {
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;

	public class HealthMeter extends FlxGroup {

		[Embed("../assets/health_meter.png")]
		public static var PEN_SPRITE:Class;

		[Embed("../assets/red_ink.png")]
		public static var RED_INK:Class;
		[Embed("../assets/blue_ink.png")]
		public static var BLUE_INK:Class;

		public var flip:Boolean = false;

		public var player:Player;

		public var ink:FlxSprite;
		public var pen:FlxSprite;

		public var barWidth:Number = 0;

		public function HealthMeter(player:Player, inkSprite:Class, x:Number = 32, y:Number = 32, flip:Boolean = false) {

			this.flip = flip;
			this.player = player;

			pen = new FlxSprite(x, y);
			pen.loadGraphic(PEN_SPRITE, false, flip, 300, 25);
			pen.immovable = true;
			pen.moves = false;
			pen.solid = false;
			add(pen);

			pen.scrollFactor = new FlxPoint(0,0);

			ink = new FlxSprite(x+76, y+12);
			ink.loadGraphic(inkSprite, false, false, 1, 1);
			ink.immovable = true;
			ink.moves = false;
			ink.solid = false;
			ink.scrollFactor = new FlxPoint(0,0);
			ink.origin = new FlxPoint(0,0);
			ink.scale.y = 8;
			add(ink);

		}

		override public function update():void {

			if(player is Player) {
				barWidth = (player.health * 210) / player.maxHealth;
			}

			ink.scale.x = barWidth;

		}
	}
}
