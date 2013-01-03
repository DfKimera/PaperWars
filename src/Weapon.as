package {
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;

	public class Weapon extends FlxSprite {

		[Embed("../assets/weapon.png")]
		public var WEAPON_SPRITE:Class;

		[Embed("../assets/bullet.png")]
		public var BULLET_SPRITE:Class;

		public var owner:Character;
		public var nozzle:FlxPoint = new FlxPoint(100, 6);

		public var holdOffset:FlxPoint = new FlxPoint(0,0);

		public var projectileSpeed:Number = 1000;
		public var projectileDamage:Number = 10;
		public var projectileSkin:Class = BULLET_SPRITE;

		public var fireRate:int = 10;
		private var cooldown:int = 0;
		private var isTriggered:Boolean = false;

		public function Weapon(skin:Class, weaponWidth:Number,  weaponHeight:Number, owner:Character) {
			this.owner = owner;

			loadGraphic(skin, true, false, weaponWidth, weaponHeight);

			GameState.weapons.add(this);

			holdOffset = Character(owner).holdOffset;
		}

		override public function update():void {

			// Updates the position of the weapon according to the owner
			this.x = owner.x + holdOffset.x;
			this.y = owner.y + holdOffset.y;

			// Updates the angle of the weapon according to the owner
			if(owner) {
				this.angle = owner.aimDirection;

				if(this.angle > 90 || this.angle < -90) {
					this.scale.y = -1;
				} else {
					this.scale.y = 1;
				}

			}

			// Ticks down the weapon cooldown timer
			if(cooldown > 0) {
				cooldown--;
			}

			if(!isTriggered) {
				play("idle");
			}

		}

		public function trigger():void {

			// Restricts the weapon firing to a certain rate
			if(cooldown <= 0) {
				cooldown = fireRate;
				this.fire();
			}

			isTriggered = true;
			play("shooting");

		}

		public function releaseTrigger():void {
			isTriggered = false;
		}

		public function fire():void {

			// Check who owns this weapon: player or enemy?
			var ownerType:int = (owner is Player) ? Projectile.OWNER_PLAYER : Projectile.OWNER_ENEMY;

			var angleRad:Number = (angle * Math.PI) / 180;

			// Calculates the projectile origin based on the position of the weapon nozzle and the weapon angle
			var thetaX:Number = this.nozzle.x * Math.cos(angleRad);
			var thetaY:Number = this.nozzle.y + (this.nozzle.x * Math.sin(angleRad));

			// Fires the projectile
			Projectile.create(projectileSkin, this.x + thetaX, this.y + thetaY, angle, projectileSpeed, projectileDamage, ownerType);

		}

	}
}
