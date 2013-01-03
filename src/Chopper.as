package {
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;

	public class Chopper extends FlxSprite {

		[Embed("../assets/chopper.png")]
		public static var CHOPPER_SKIN:Class;

		[Embed("../assets/bullet.png")]
		public var CHOPPER_BULLET:Class;

		public var playerOnBoard:Player;
		public var gravity:Number = 20;
		public var speed:Number = 400;
		public var cannonAngle:Number = 30;

		public function Chopper(playerOnBoard:Player) {

			super(playerOnBoard.x, 100);

			this.playerOnBoard = playerOnBoard;
			playerOnBoard.visible = false;
			playerOnBoard.y = -10000;
			playerOnBoard.immovable = true;
			playerOnBoard.moves = false;
			playerOnBoard.solid = false;
			playerOnBoard.inChopper = true;

			this.antialiasing = true;

			loadGraphic(CHOPPER_SKIN, true, false, 192, 128);

			addAnimation("flying", [0,1], 24, true);
			play("flying");

			this.drag.x = 0.2;
			this.drag.y = 0.2;

			this.maxVelocity.x = 500;
			this.maxVelocity.y = 500;

		}

		override public function update():void {

			this.acceleration.x = 0;
			this.acceleration.y = gravity;

			if(playerOnBoard.isControllerPressed(Player.CTRL_UP)) {
				this.acceleration.y = -speed;
			} else if(playerOnBoard.isControllerPressed(Player.CTRL_DOWN)) {
				this.acceleration.y = speed;
			}

			if(playerOnBoard.isControllerPressed(Player.CTRL_LEFT)) {
				this.acceleration.x = -speed;
			} else if(playerOnBoard.isControllerPressed(Player.CTRL_RIGHT)) {
				this.acceleration.x = speed;
			}

			if(playerOnBoard.isControllerPressed(Player.CTRL_SHOOT)) {
				this.shoot();
			}

			if(this.y > 1800) {
				this.y = 1800;
				this.velocity.y = -speed / 3;
			} else if(this.y < 900) {
				this.y = 900;
			}

			if(this.x > 22000) {
				GameState(FlxG.state).triggerVictory();
			}

			angle = (this.velocity.y / 500) * 25;

			super.update();

		}

		public function shoot():void {

			var cannonAngleRad:Number = (cannonAngle * Math.PI) / 180;
			var angleRad:Number = (angle * Math.PI) / 180;

			var wLen:Number = Math.sqrt((width*width) + (height*height));
			var thetaX:Number = wLen * Math.cos(cannonAngleRad + angleRad);
			var thetaY:Number = wLen * Math.sin(cannonAngleRad + angleRad);

			// x=120, y=85

			Projectile.create(CHOPPER_BULLET, this.x + thetaX, this.y + thetaY, cannonAngle + angle, 1000, 100, Projectile.OWNER_PLAYER);

		}

	}
}
