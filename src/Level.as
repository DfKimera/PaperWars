package {
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;

	public class Level extends FlxGroup {

		[Embed("../assets/level1_debug_tilemap.png")]
		public var TILESET_GRAPHIC:Class;

		[Embed("../assets/mapa.jpg")]
		public var BACKGROUND_GRAPHIC:Class;

		public var background:FlxSprite = new FlxSprite(0,0);

		public var map:FlxTilemap;
		public var tileSize:Number = 32;

		public var mapWidth:int;
		public var mapHeight:int;

		public var width:Number = 0;
		public var height:Number = 0;

		public function Level() {

			map = new FlxTilemap();
			map.immovable = true;
			map.moves = false;
			add(map);

			background = new FlxSprite();
			background.immovable = true;
			background.moves = false;
			background.solid = false;
			background.loadGraphic(BACKGROUND_GRAPHIC);
			add(background);

			width = 22000; //background.width;
			height = 2048; //background.height;

		}

		public function loadFromArray(mapData:Array, mapWidth:Number, mapHeight:Number):void {

			this.mapWidth = mapWidth;
			this.mapHeight = mapHeight;

			map.loadMap(FlxTilemap.arrayToCSV(mapData, mapWidth, false), TILESET_GRAPHIC, tileSize, tileSize, FlxTilemap.OFF);

			map.setTileProperties(0, FlxObject.NONE);
			map.setTileProperties(1, FlxObject.ANY);
			map.setTileProperties(2, FlxObject.NONE);

		}


	}
}
