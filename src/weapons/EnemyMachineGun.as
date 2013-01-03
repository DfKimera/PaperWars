package weapons {

	import org.flixel.FlxPoint;

	public class EnemyMachineGun extends Weapon {

		[Embed("../../assets/machinegun.png")]
		public var MACHINE_GUN_BODY:Class;

		[Embed("../../assets/enemy_bullet.png")]
		public var MACHINE_GUN_BULLET:Class;

		public function EnemyMachineGun(owner:Character) {

			super(MACHINE_GUN_BODY, 70, 60, owner);

			this.antialiasing = true;

			addAnimation("idle", [1], 0, false);
			addAnimation("shooting", [1,2], 24, true);

			play("idle");

			origin = new FlxPoint(0, 12);
			nozzle = new FlxPoint(70, 12);

			projectileSpeed = 1000;
			projectileDamage = 10;
			projectileSkin = MACHINE_GUN_BULLET;

			fireRate = 10;

		}

	}
}
