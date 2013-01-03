package {

	import org.flixel.FlxObject;
	import org.flixel.FlxU;

	public class Enemy extends Character {

		[Embed("../assets/walking.png")]
		public var ENEMY_SPRITE:Class;

		public var attackRange:Number = 400;

		public function Enemy(skin:Class, skinWidth:Number, skinHeight:Number, startX:Number, startY:Number) {

			super(skin, skinWidth, skinHeight, startX, startY);

			initialize();

		}

		public function shootAtClosestPlayer(currentTarget:Player):Boolean {

			var player:Player = currentTarget;

			if(!player) {
				player = Player.findClosestToPoint(this.getMidpoint(), attackRange);
			}

			if(player is Player) {
				this.shootAt( FlxU.getAngle(this.getMidpoint(), player.getMidpoint()) - 90);
				return true;
			} else {
				this.releaseTrigger();
				return false;
			}

		}

		public static function onEnemyCollision(enemy:Enemy, target:FlxObject):void {
			enemy.onCollideWith(target);
		}

		public function onCollideWith(target:FlxObject):void {
			// This function is expected to be overrriden
		}

	}
}
