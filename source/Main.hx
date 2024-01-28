package;

import openfl.display.FPS;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var fps:FPS;

	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, states.PlayState, 60, 60, true));

		fps = new FPS(-100, -100, 0xFFFFFF00);
		addChild(fps);
	}
}
