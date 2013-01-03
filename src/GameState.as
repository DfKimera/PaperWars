package {

	import com.adobe.serialization.json.JSONDecoder;

	import enemies.RobotCannon;
	import enemies.Soldier;

	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import org.flixel.FlxCamera;

	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;

	import tokens.ChopperToken;

	public class GameState extends FlxState {

		public var level:Level;

		public var john:Player;
		public var terry:Player;

		public var johnHP:HealthMeter;
		public var terryHP:HealthMeter;

		public var player2PressStart:PressStartWidget;

		public var chopper:Chopper;
		public var camera:FlxCamera;

		public var playerBeingFollowed:FlxSprite;

		public static var isHalted:Boolean;


		public static var players:FlxGroup;
		public static var bullets:FlxGroup;
		public static var movingEnemies:FlxGroup;
		public static var staticEnemies:FlxGroup;

		public static var weapons:FlxGroup;
		public static var tokens:FlxGroup;

		public static var effects:FlxGroup;

		override public function create():void {

			players = new FlxGroup();
			bullets = new FlxGroup();
			movingEnemies = new FlxGroup();
			staticEnemies = new FlxGroup();
			weapons = new FlxGroup();
			tokens = new FlxGroup();
			effects = new FlxGroup();

			FlxG.bgColor = 0xFFFFFF;

			camera = FlxG.camera; //new FlxCamera(0, 0, 1280, 720);

			level = new Level();
			level.loadFromArray(MapData.tilegrid, MapData.mapWidth, MapData.mapHeight);

			john = new Player(Player.PLAYER_JOHN, 100,1000);
			johnHP = new HealthMeter(john, HealthMeter.BLUE_INK, 30, 30, false);
			players.add(john);

			player2PressStart = new PressStartWidget();
			player2PressStart.x = 900;
			player2PressStart.y = 30;


			createEnemiesFromLevel();

			// Z-order is ascending, so the last one added is the closest to the screen
			add(level);

			add(movingEnemies);
			add(staticEnemies);

			add(bullets);
			add(players);

			add(weapons);

			add(tokens);

			add(effects);

			add(johnHP);
			add(player2PressStart);

			FlxG.worldBounds.make(0, 0, 22000, level.height);

			setCameraOnPlayer(john);

			isHalted = false;

		}

		public function createEnemiesFromLevel():void {

			for(var i in MapData.soldiers) {
				var soldier:Soldier = new Soldier(MapData.soldiers[i].x, MapData.soldiers[i].y);
				movingEnemies.add(soldier);
			}

			for(var j in MapData.robots) {
				var robot:Soldier = new Soldier(MapData.robots[j].x, MapData.robots[j].y);
				movingEnemies.add(robot);
			}

			for(var k in MapData.cannons) {
				var cannon:RobotCannon = new RobotCannon(MapData.cannons[k].x, MapData.cannons[k].y);
				staticEnemies.add(cannon);
			}

			for(var l in MapData.tokens) {

				var token:Object = MapData.tokens[l];

				if(token.type == "chopper") {
					var chopperToken:ChopperToken = new ChopperToken(token.x, token.y);
					GameState.tokens.add(chopperToken);
				}

			}



		}

		override public function update():void {

			FlxG.collide(players, level);
			FlxG.collide(bullets, level, Projectile.onProjectileCollision);
			FlxG.collide(bullets, movingEnemies, Projectile.onProjectileCollision);
			FlxG.collide(bullets, staticEnemies, Projectile.onProjectileCollision);
			FlxG.collide(bullets, players, Projectile.onProjectileCollision);
			FlxG.collide(movingEnemies, level, Enemy.onEnemyCollision);
			FlxG.collide(tokens, players,  Token.onTokenCollected);

			if(!terry) {
				var didPressStart:Boolean = (Startup.ARCADE_MODE) ? FlxG.keys.justPressed("Z") : FlxG.keys.justPressed("ENTER");

				if(didPressStart) {
					onPressStart();
				}

			}

			camera.follow(playerBeingFollowed, FlxCamera.STYLE_PLATFORMER);
			camera.setBounds(0,0,22000,level.height);

			super.update();

		}

		public function onPressStart():void {

			player2PressStart.visible = false;
			remove(player2PressStart);

			terry = new Player(Player.PLAYER_TERRY, john.x, john.y);
			terryHP = new HealthMeter(terry, HealthMeter.RED_INK, 900, 30, true);
			players.add(terry);

			add(terryHP);

		}

		public function setCameraOnPlayer(player:FlxSprite):void {
			playerBeingFollowed = player;
		}

		public function onPlayerDeath(player:Player):void {

			if(!john.alive && (!terry || !terry.alive)) { // If both players are dead, trigger game over
				triggerGameOver();
			} else {

				if(john.alive) { // If one player in a two-player game is dead, focus camera on the other player
					trace("Now following john");
					setCameraOnPlayer(john);
				} else {
					trace("Now following terry");
					setCameraOnPlayer(terry);
				}

			}

		}

		public function activateChopper(player:Player):void {

			var chopperPos:FlxPoint = player.getMidpoint();

			chopper = new Chopper(player);
			chopper.x = chopperPos.x;
			chopper.y = chopperPos.y - 100;

			setCameraOnPlayer(chopper);

			add(chopper);

		}

		public function triggerGameOver():void {

			isHalted = true;

			trace("GAME OVER!");

			FlxG.switchState(new YouLoseState());

		}

		public function triggerVictory():void {

			isHalted = true;

			trace("VICTORY!");

			FlxG.switchState(new YouWinState());

		}

	}
}
