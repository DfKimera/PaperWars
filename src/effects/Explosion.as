package effects {

	public class Explosion extends Effect {

		[Embed("../../../assets/effects/explosion.png")]
		public static var EXPLOSION_SPRITE:Class;

		public function Explosion(x:Number, y:Number) {
			super(x, y, 64, 64, EXPLOSION_SPRITE, 25);
		}
	}
}
