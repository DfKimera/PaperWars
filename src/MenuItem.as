package {
	import org.flixel.FlxSprite;

	public class MenuItem extends FlxSprite {

		[Embed("../assets/menu.png")]
		public var MENU_ITEM_SPRITE:Class;

		public static const ITEM_PLAY:int = 1;
		public static const ITEM_INSTRUCTIONS:int = 2;
		public static const ITEM_CREDITS:int = 3;

		public var frameOut:int = 0;
		public var frameOver:int = 0;

		public var type:int = 0;

		public var isSelected:Boolean = false;

		public function MenuItem(number:int) {

			loadGraphic(MENU_ITEM_SPRITE, true, false, 256, 64);

			this.type = number;

			switch(number) {

				case ITEM_PLAY: frameOut = 0; frameOver = 1; break;
				case ITEM_INSTRUCTIONS: frameOut = 2; frameOver = 3; break;
				case ITEM_CREDITS: frameOut = 4; frameOver = 5; break;

			}

			addAnimation("out", [frameOut], 0);
			addAnimation("over", [frameOver], 0);

			play("out");

		}

		public function select():void {
			play("over");
			this.isSelected = true;
		}

		public function deselect():void {
			play("out");
			this.isSelected = false;
		}

		override public function update():void {

			if(this.isSelected) {
				play("over");
			} else {
				play("out");
			}

			super.update();
		}

	}
}
