package {
	import flash.utils.setTimeout;

	import org.flixel.FlxSprite;

	public class Effect extends FlxSprite {

		public function Effect(startX:Number, startY:Number, width:Number, height:Number, sprite:Class, numFrames:int) {

			var frames:Array = [];

			for(var i:int = 0; i < numFrames; i++) {
				frames.push(i);
			}

			loadGraphic(sprite,  true, false, width, height);

			this.x = startX - (width / 2);
			this.y = startY - (height / 2);

			addAnimation("effect", frames, 30, false);

			GameState.effects.add(this);

			play("effect");

		}

		override public function update():void {

			if(finished) {
				this.kill();
			}

			super.update();
		}

	}
}
