package tokens {
	import org.flixel.FlxG;

	public class ChopperToken extends Token {

		public function ChopperToken(x:Number, y:Number) {

			this.x = x;
			this.y = y;

			loadGraphic(Chopper.CHOPPER_SKIN, false, false, 192, 128);

			addAnimation("idle", [0], 0);

			play("idle");

			this.immovable = true;

		}

		override public function onCollect(player:Player):void {

			if(!this.alive) {
				return;
			}
			GameState(FlxG.state).activateChopper(player);

			this.kill();

		}

	}
}
