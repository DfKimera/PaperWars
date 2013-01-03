package {
	import effects.BloodSplatter;

	import flash.geom.Point;

	import org.flixel.FlxG;

	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;

	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;

	public class Character extends FlxSprite {

		public var skin:Class = null;
		public var skinSize:Point;

		public var gravity:Number = 980;
		public var walkSpeed:Number = 200;
		public var jumpVelocity:Number = 350;
		public var friction:Number = 1400;

		public var weapon:Weapon = null;
		public var holdOffset:FlxPoint = new FlxPoint(20, 48); // Note: don't forget to consider the offset/width change below (for smaller collision box)
		public var aimDirection:Number = 0;

		public function Character(skin:Class, skinWidth:Number, skinHeight:Number, startX:Number, startY:Number) {

			this.skin = skin;

			this.skinSize = new Point(skinWidth, skinHeight);

			// Creates the character graphics
			loadGraphic(skin, true, false, skinWidth, skinHeight, false);

			// Defines starting position
			this.x = startX;
			this.y = startY;

		}

		public function initialize():void {

			// Define the max horizontal speed to be the movement speed of the character
			this.maxVelocity.x = walkSpeed;

			// Define the max vertical speed to be the gravity
			this.maxVelocity.y = gravity;

			// Create an "artificial" acceleration on the vertical axis, simulating gravity
			this.acceleration.y = gravity;

			// Creates an "artificial" drag on the horizontal axis, simulating air friction
			this.drag.x = friction;

		}

		override public function update():void {

			// Defines the animation according to the player's movement
			if(this.aimDirection > 90 || this.aimDirection < -90) {
				this.scale.x = -1;
			} else {
				this.scale.x = 1;
			}

			super.update();

		}

		public function setWeapon(weapon:Weapon):void {
			this.weapon = weapon;
		}

		public function shoot():void {

			// If the player doesn't have a weapon, he can't shoot
			if(!this.weapon) {
				return;
			}

			this.weapon.trigger();

		}

		public function aimAt(angle:Number):void {
			this.aimDirection = angle;
		}

		public function shootAt(angle:Number):void {
			this.aimAt(angle);
			this.shoot();
		}

		public function releaseTrigger():void {
			if(!this.weapon) { return; }
			this.weapon.releaseTrigger();
		}

		public function resetAcceleration():void {
			this.acceleration.x = 0;
		}

		public function walkLeft():void {
			this.scale.x = -1;
			this.acceleration.x = -walkSpeed * 4;
			if(this.isTouching(FLOOR)) {
				play("walking");
			}
		}

		public function walkRight():void {
			this.scale.x = 1;
			this.acceleration.x = walkSpeed * 4;
			if(this.isTouching(FLOOR)) {
				play("walking");
			}
		}

		public function jump():void {
			this.velocity.y = -jumpVelocity;
		}

		public function inflictDamage(damage:Number, inflictedBy:uint):void {
			this.health -= damage;

			var mid:FlxPoint = this.getMidpoint();
			mid.x += Math.floor(Math.random() * (this.width / 2));
			mid.y += Math.floor(Math.random() * (this.height / 4));

			var blood:BloodSplatter = new BloodSplatter(mid.x, mid.y);

			if(this.health <= 0) {
				this.kill();
			}

			// This function is expected to be overriden
		}

		override public function kill():void {

			if(this.weapon) {
				this.weapon.kill();
			}

			super.kill();

			this.onDeath();

		}


		public function onDeath():void {
			// This function is expected to be overriden
		}

	}
}
