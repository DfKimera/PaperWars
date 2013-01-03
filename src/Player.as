package {

	import flash.utils.setTimeout;

	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxU;
	import org.flixel.system.input.Keyboard;

	import weapons.MachineGun;

	public class Player extends Character {


		public static const PLAYER_JOHN:int = 1;
		public static const PLAYER_TERRY:int = 2;

		public static const CTRL_UP:int = 1;
		public static const CTRL_LEFT:int = 2;
		public static const CTRL_RIGHT:int = 3;
		public static const CTRL_DOWN:int = 4;
		public static const CTRL_JUMP:int = 5;
		public static const CTRL_SHOOT:int = 6;

		[Embed("../assets/john.png")]
		public static var PLAYER_JOHN_SPRITE:Class;

		[Embed("../assets/terry.png")]
		public static var PLAYER_TERRY_SPRITE:Class;

		public var type:int = PLAYER_JOHN;
		public var maxHealth:Number = 1000;
		public var inChopper:Boolean = false;

		public static const CONTROL_MODE_JOYSTICK:uint = 1;
		public static const CONTROL_MODE_MOUSE:uint = 2;

		public var controlMode:int = CONTROL_MODE_JOYSTICK;

		public function Player(type:int, startX:Number, startY:Number) {

			this.type = type;

			var skin:Class = PLAYER_JOHN_SPRITE;

			if(type == PLAYER_TERRY) {
				skin = PLAYER_TERRY_SPRITE;
			}

			// Initialize the character superclass
			super(skin, 64, 96, startX, startY);

			health = maxHealth;
			gravity = 980;
			walkSpeed = 250;
			jumpVelocity = 550;
			friction = 1400;
			holdOffset = new FlxPoint(25, 32);

			initialize();

			// Creates animations
			addAnimation("idle", [0]);
			addAnimation("walking", [4,5,6,7,8,9,10,11], 18);
			addAnimation("jumping", [1,2,3], 12, false);

			play("idle");

			// Reduces the size of the collision box
			this.offset.x = 16;
			this.width -= 24;
			centerOffsets();

			// Gives the player a generic weapon
			this.setWeapon(new MachineGun(this));

		}

		public function isControllerPressed(key:int):Boolean {

			if(Startup.ARCADE_MODE) {

				if(this.type == PLAYER_JOHN) {

					switch(key) {
						case CTRL_UP: return FlxG.keys.Q; break;
						case CTRL_LEFT: return FlxG.keys.E; break;
						case CTRL_RIGHT: return FlxG.keys.R; break;
						case CTRL_DOWN: return FlxG.keys.W; break;
						case CTRL_JUMP: return FlxG.keys.justPressed("A"); break;
						case CTRL_SHOOT: return FlxG.keys.S; break;
						default: return false; break;
					}

				} else {

					switch(key) {
						case CTRL_UP: return FlxG.keys.T; break;
						case CTRL_LEFT: return FlxG.keys.U; break;
						case CTRL_RIGHT: return FlxG.keys.I; break;
						case CTRL_DOWN: return FlxG.keys.Y; break;
						case CTRL_JUMP: return FlxG.keys.justPressed("Z"); break;
						case CTRL_SHOOT: return FlxG.keys.X; break;
						default: return false; break;
					}

				}

			} else {

				if(this.type == PLAYER_JOHN) {

					switch(key) {
						case CTRL_UP: return FlxG.keys.W; break;
						case CTRL_LEFT: return FlxG.keys.A; break;
						case CTRL_RIGHT: return FlxG.keys.D; break;
						case CTRL_DOWN: return FlxG.keys.S; break;
						case CTRL_JUMP: return FlxG.keys.justPressed("SPACE"); break;
						case CTRL_SHOOT: return FlxG.keys.SHIFT; break;
						default: return false; break;
					}

				} else {

					switch(key) {
						case CTRL_UP: return FlxG.keys.UP; break;
						case CTRL_LEFT: return FlxG.keys.LEFT; break;
						case CTRL_RIGHT: return FlxG.keys.RIGHT; break;
						case CTRL_DOWN: return FlxG.keys.DOWN; break;
						case CTRL_JUMP: return FlxG.keys.justPressed("NUMPADZERO"); break;
						case CTRL_SHOOT: return FlxG.keys.NUMPADTWO; break;
						default: return false; break;
					}

				}

			}

			return false;

		}

		override public function update():void {

			resetAcceleration();

			if(isControllerPressed(CTRL_LEFT)) {

				if(controlMode == CONTROL_MODE_JOYSTICK) {
					if(isControllerPressed(CTRL_UP)) { // Diagonal aiming (left + up)
						this.aimAt(225);
					} else { // Straight aiming (left)
						this.aimAt(180);
					}
				}

				// Sets his acceleration to the left
				walkLeft();

			} else if(isControllerPressed(CTRL_RIGHT)) {

				if(controlMode == CONTROL_MODE_JOYSTICK) {
					if(isControllerPressed(CTRL_UP)) { // Diagonal aiming (right + up)
						this.aimAt(-45);
					} else { // Straight aiming (right)
						this.aimAt(0);
					}
				}

				// Sets his acceleration to the right
				walkRight();

			} else if(isControllerPressed(CTRL_UP)) {

				if(controlMode == CONTROL_MODE_JOYSTICK) {
					this.aimAt(-90);
				}

			} else {

				if(this.isTouching(FLOOR)) {
					play("idle");
				}

			}

			if(controlMode == CONTROL_MODE_MOUSE) {
				this.aimAt(FlxU.getAngle(this.getMidpoint(), FlxG.mouse.getWorldPosition()) - 90);
			}

			if(isControllerPressed(CTRL_JUMP) && this.isTouching(FlxObject.FLOOR)) {
				play("jumping", true);
				this.jump();
			}

			if(isControllerPressed(CTRL_SHOOT)) {
				this.shoot();
			} else {
				this.releaseTrigger();
			}

			trace(this.y);

			super.update();

			if(this.y > 2000) {
				this.kill();
			}

			if(this.x > 22000) {
				GameState(FlxG.state).triggerVictory();
			}

		}

		public static function findClosestToPoint(point:FlxPoint, maxDistance:Number = 0):Player {

			var shortestDistance:Number = 0;
			var closestPlayer:Player = null;

			for(var i in GameState.players.members) {

				var player:Player = Player(GameState.players.members[i]);

				if(!player || !player.alive || player.inChopper) { continue; }

				var distance:Number = FlxU.getDistance(player.getMidpoint(), point);

				if(shortestDistance == 0 || distance <= shortestDistance) {
					shortestDistance = distance;
					closestPlayer = player;
				}

			}

			if(maxDistance != 0 && shortestDistance > maxDistance) {
				return null;
			}

			return closestPlayer;

		}

		override public function onDeath():void {
			GameState(FlxG.state).onPlayerDeath(this);
		}

	}
}
