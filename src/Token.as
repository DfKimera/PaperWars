package {

	import org.flixel.FlxSprite;

	public class Token extends FlxSprite {

		public function onCollect(player:Player):void {
			// This function is expected to be overridden
		}

		public static function onTokenCollected(token:Token, player:Player):void {
			token.onCollect(player);
		}

	}
}
