package {

	import com.adobe.serialization.json.JSON;

	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;

	public class LoadingState extends FlxState{

		public var loader:URLLoader;

		override public function create():void {

			FlxG.bgColor = 0xFFFFFF;

			var loadingText:FlxText = new FlxText(512, 100, 256, "Carregando...", true);
			loadingText.color = 0xFF0000;
			add(loadingText);

			loader = new URLLoader(new URLRequest("level1_json.json"));
			loader.addEventListener("complete", onLoadComplete);

		}

		public function onLoadComplete(ev:Event):void {

			var jsonString:String = loader.data;

			var dataObject:Object = com.adobe.serialization.json.JSON.decode(jsonString, false) as Object;

			MapData.tilegrid = dataObject.layers[0].data;
			MapData.mapWidth = dataObject.layers[0].width;
			MapData.mapHeight = dataObject.layers[0].height;

			MapData.soldiers = dataObject.layers[1].objects;
			MapData.robots = dataObject.layers[2].objects;
			MapData.cannons = dataObject.layers[3].objects;
			MapData.tokens = dataObject.layers[4].objects;

			FlxG.switchState(new GameState());

		}

	}
}
