package enemies {
	import effects.Explosion;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;

	public class RobotCannon extends FlxGroup {

		[Embed("../../assets/cannon.png")]
		public var CANNON:Class;

		[Embed("../../assets/tube.png")]
		public var TUBE:Class;

		[Embed("../../assets/cannonball.png")]
		public var CANNONBALL:Class;

		public var cannonBody:FlxSprite;
		public var cannonTube:FlxSprite;
		public var aimDirection:Number = 0;

		public var midpoint:FlxPoint;
		public var health:Number = 400;
		public var range:Number = 400;

		public var aiTimer:Timer = new Timer(1500);

		public function RobotCannon(startX:Number, startY:Number) {

			cannonBody = new FlxSprite(startX, startY);
			cannonBody.loadGraphic(CANNON, false,false,64,64);
			cannonBody.immovable = true;
			cannonBody.solid = false;

			cannonTube = new FlxSprite(startX, startY);
			cannonTube.loadGraphic(TUBE, false,false,64,64);
			cannonTube.origin.x = 32;
			cannonTube.origin.y = 32;
			cannonTube.immovable = true;
			cannonTube.solid = false;

			add(cannonBody);
			add(cannonTube);

			midpoint = cannonBody.getMidpoint();

			this.aiTimer.addEventListener(TimerEvent.TIMER, onAITick);
			this.aiTimer.start();

		}

		public function shootAtClosestPlayer():void{


			var player:Player = Player.findClosestToPoint(this.cannonBody.getMidpoint(), range);

			if(player is Player) {

				aimDirection = FlxU.getAngle(midpoint, player.getMidpoint());
				cannonTube.angle = aimDirection - 90;
				Projectile.create(CANNONBALL, midpoint.x, midpoint.y, aimDirection - 90, 200, 10, Projectile.OWNER_ENEMY, onCannonballCollision);

			}

		}

		public static function onCannonballCollision(cannonball:Projectile, target:FlxObject) {

			var explosion:Explosion = new Explosion(cannonball.x, cannonball.y);

		}

		public function onAITick(ev:TimerEvent):void {
			this.shootAtClosestPlayer();
		}

	}
}
