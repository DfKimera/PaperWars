package {

	import enemies.RobotCannon;

	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.flixel.system.FlxTile;

	public class Projectile extends FlxSprite {

		public static const OWNER_PLAYER:uint = 1;
		public static const OWNER_ENEMY:uint = 2;

		public var damage:Number = 0;
		public var owner:uint = 0;

		private var onCollideCB:Function = null;

		public function Projectile(skin:Class, startX:Number, startY:Number, angle:Number, speed:Number, damage:Number, owner:uint = OWNER_PLAYER, callback:Function = null) {

			this.damage = damage;
			this.owner = owner;

			this.onCollideCB = callback;

			loadGraphic(skin, false);

			this.x = (startX - (this.width / 2));
			this.y = (startY - (this.width / 2));

			this.maxVelocity.x = speed;
			this.maxVelocity.y = speed;

			this.drag.x = 0;
			this.drag.y = 0;

			var angleRad:Number = (angle * Math.PI) / 180;

			this.velocity.x = Math.cos(angleRad) * speed;
			this.velocity.y = Math.sin(angleRad) * speed;

		}

		public static function create(skin:Class, startX:Number, startY:Number, angle:Number, speed:Number, damage:Number, owner:uint = OWNER_PLAYER, callback:Function = null):void {
			var projectile:Projectile = new Projectile(skin, startX, startY, angle, speed, damage, owner, callback);

			GameState.bullets.add(projectile);

		}

		public static function onProjectileCollision(proj:Projectile, target:FlxObject):Boolean {

			if(target is Character || target is Level || target is FlxTilemap || target is FlxTile) {

				if(proj.onCollideCB is Function) {
					proj.onCollideCB(proj, target);
				}

				proj.kill();

				if(target is Character) {

					if(proj.owner == Projectile.OWNER_PLAYER && target is Player) {
						return false;
					}

					if(proj.owner == Projectile.OWNER_ENEMY && target is Enemy) {
						return false;
					}

					Character(target).inflictDamage(proj.damage, proj.owner);

					return true;
				}

			}

			return false;

		}


	}
}
