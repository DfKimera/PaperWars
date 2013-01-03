package {
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;

	public class MenuState extends FlxState {

		[Embed("../assets/paper_crisis.mp3")]
		public var MUSIC_PAPER_CRISIS:Class;

		[Embed("../assets/menu_screen.png")]
		public var MENU_BACKGROUND:Class;

		public var background:FlxSprite = new FlxSprite(0,0);

		public var itemGroup:FlxGroup = new FlxGroup();
		public var items:Array = new Array();

		public var currentItem:int = 0;

		public static var isPlayingMusic:Boolean = false;

		override public function create():void {

			if(!isPlayingMusic) {
				FlxG.playMusic(MUSIC_PAPER_CRISIS, 1);
				isPlayingMusic = true;
			}

			background.loadGraphic(MENU_BACKGROUND, false, false, 1280, 720);
			background.immovable = true;
			background.solid = false;
			add(background);

			FlxG.bgColor = 0xFFFFFF;

			var play:MenuItem = new MenuItem(MenuItem.ITEM_PLAY);
			var instructions:MenuItem = new MenuItem(MenuItem.ITEM_INSTRUCTIONS);
			var credits:MenuItem = new MenuItem(MenuItem.ITEM_CREDITS);

			play.x = 640 - 128; play.y = 200;
			instructions.x = 640 - 128; instructions.y = 300;
			credits.x = 640 - 128; credits.y = 400;

			items.push(play);
			items.push(instructions);
			items.push(credits);

			itemGroup.add(play);
			itemGroup.add(instructions);
			itemGroup.add(credits);

			add(itemGroup);

			selectItem(0);

			super.create();

		}

		override public function update():void {

			if(Startup.ARCADE_MODE) {

				if(FlxG.keys.justPressed("Q") || FlxG.keys.justPressed("T")) {
					moveSelectionUp();
				} else if(FlxG.keys.justPressed("W") || FlxG.keys.justPressed("Y")) {
					moveSelectionDown();
				} else if(FlxG.keys.justPressed("ONE") || FlxG.keys.justPressed("TWO") || FlxG.keys.justPressed("A") || FlxG.keys.justPressed("Z")) {
					triggerSelection();
				}

			} else {

				if(FlxG.keys.justPressed("W") || FlxG.keys.justPressed("UP")) {
					moveSelectionUp();
				} else if(FlxG.keys.justPressed("S") || FlxG.keys.justPressed("DOWN")) {
					moveSelectionDown();
				} else if(FlxG.keys.justPressed("ENTER") || FlxG.keys.justPressed("SHIFT") || FlxG.keys.justPressed("SPACE") || FlxG.keys.justPressed("CONTROL") || FlxG.keys.justPressed("NUMPADZERO")) {
					triggerSelection();
				}

			}

		}

		public function moveSelectionUp():void {
			if(items[currentItem]) {
				MenuItem(items[currentItem]).deselect();
			}

			currentItem--;

			if(currentItem < 0) {
				currentItem = items.length - 1;
			}

			selectItem(currentItem);
		}

		public function moveSelectionDown():void {

			if(items[currentItem]) {
				MenuItem(items[currentItem]).deselect();
			}

			currentItem++;

			if(currentItem >= items.length) {
				currentItem = 0;
			}

			selectItem(currentItem);

		}

		public function selectItem(item:int):void {

			trace("Select item #"+item+": "+items[currentItem]);

			currentItem = item;
			MenuItem(items[currentItem]).select();

		}

		public function triggerSelection():void {

			trace("Trigger item #"+currentItem+": "+MenuItem(items[currentItem]).type);

			switch(MenuItem(items[currentItem]).type) {

				case MenuItem.ITEM_PLAY:
					FlxG.switchState(new LoadingState());
					break;

				case MenuItem.ITEM_INSTRUCTIONS:
					FlxG.switchState(new HelpState());
					break;

				case MenuItem.ITEM_CREDITS:
					FlxG.switchState(new CreditsState());
					break;

			}

		}

	}
}
