package effects {

	public class BloodSplatter extends Effect {

		[Embed("../../../assets/effects/blood.png")]
		public static var BLOOD_SPRITE:Class;

		public function BloodSplatter(x:Number, y:Number) {
			super(x, y, 36, 53, BLOOD_SPRITE, 8);
			this.antialiasing = true;
			this.angle = Math.floor(Math.random() * 360);
		}
	}
}
