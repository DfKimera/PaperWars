package enemies {
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import org.flixel.FlxObject;

	import org.flixel.FlxPoint;

	import weapons.EnemyMachineGun;

	import weapons.MachineGun;

	public class Soldier extends Enemy {

		[Embed("../../assets/soldier.png")]
		public var SOLDIER_SKIN:Class;

		public var scanTimer:Timer = new Timer(500);
		public var patrolTimer:Timer = new Timer(1000);
		public var attackTimer:Timer = new Timer(500);

		public var patrolDirection:int = 1;

		public var currentTask:String = "patrol";
		public var currentTarget:Player = null;

		public function Soldier(startX:Number, startY:Number) {

			super(SOLDIER_SKIN, 64, 96, startX, startY);

			health = 50;
			walkSpeed = 100;
			friction = 0.2;
			holdOffset = new FlxPoint(20, 32);
			attackRange = 600;

			initialize();

			addAnimation("idle", [0]);
			addAnimation("walking", [4,5,6,7,8,9,10,11], 18);
			addAnimation("jumping", [1,2,3], 12, false);

			// Sets up AI timers
			scanTimer.addEventListener(TimerEvent.TIMER, onScanTick);
			patrolTimer.addEventListener(TimerEvent.TIMER, onPatrolTick);
			attackTimer.addEventListener(TimerEvent.TIMER, onAttackTick);

			// Begin scanning for nearby players
			scanTimer.start();

			// Sets him walking left
			this.velocity.x = patrolDirection * walkSpeed;

			// Gives him a weapon
			this.setWeapon(new EnemyMachineGun(this));

			// Reduces the size of the collision box
			this.offset.x = 16;
			this.width -= 24;
			centerOffsets();

			// Begins patrol
			beginPatrol();

		}


		private function onPatrolTick(ev:TimerEvent):void {
			if(GameState.isHalted) { this.kill(); return; }

			if(currentTask == "patrol") {
				walkToTheOtherSide();
			}

		}

		private function onScanTick(ev:TimerEvent):void {
			if(GameState.isHalted) { this.kill(); return; }

			currentTarget = Player.findClosestToPoint(this.getMidpoint(), attackRange);

			if(currentTarget && currentTask != "attack") {
				this.beginAttack();
			} else if(!currentTarget && currentTask != "patrol") {
				this.beginPatrol();
			}

		}

		public function beginAttack():void {

			this.velocity.x = 0;

			this.faceClosestPlayer();

			this.patrolTimer.stop();
			this.attackTimer.start();

			this.currentTask = "attack";

			play("idle");
		}

		public function beginPatrol():void {

			this.velocity.x = patrolDirection * walkSpeed;
			this.aimAt((patrolDirection * 70) - 90);

			this.attackTimer.stop();
			this.patrolTimer.start();
			this.currentTask = "patrol";

			play("walking");
		}

		private function walkToTheOtherSide():void {

			patrolDirection *= -1;

			this.velocity.x = patrolDirection * walkSpeed;
			this.aimAt((patrolDirection * 70) - 90);

			this.patrolTimer.reset();
			this.patrolTimer.start();

			play("walking");

		}

		public function faceClosestPlayer():void {

			if(currentTarget.x < this.x) {
				this.scale.x = -1;
			} else {
				this.scale.x = 1;
			}

		}

		private function onAttackTick(ev:TimerEvent):void {
			if(GameState.isHalted) { this.kill(); return; }
			this.faceClosestPlayer();
			this.shootAtClosestPlayer(currentTarget);
		}

		override public function onCollideWith(target:FlxObject):void {

			if(target is Level && this.isTouching(FlxObject.LEFT | FlxObject.RIGHT) && currentTask == "patrol") {
				walkToTheOtherSide();
			}

		}

		override public function kill():void {
			this.attackTimer.removeEventListener(TimerEvent.TIMER, onAttackTick);
			this.scanTimer.removeEventListener(TimerEvent.TIMER, onScanTick);
			this.patrolTimer.removeEventListener(TimerEvent.TIMER, onPatrolTick);

			super.kill();
		}

		override public function onDeath():void {
			if(!GameState.isHalted) {
				play("death", true);
			}
		}
	}
}
