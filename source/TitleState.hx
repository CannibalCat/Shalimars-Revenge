package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class TitleState extends FlxState 
{
	private var titleLogo:FlxSprite;
	
	override public function create():Void
	{
		bgColor = 0xFF000000; 
		titleLogo = new FlxSprite(0, 0, "assets/images/TitleLogo.png");
		titleLogo.setPosition(FlxG.width / 2 - titleLogo.width / 2, 50);
		add(titleLogo); 
		
		FlxG.cameras.fade(0xFF000000, 1, true);
	}
	
	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.ENTER) // || gamepad.justPressed.START)
		{
			Globals.resetGameGlobals(); 
			FlxG.switchState(new PlayState());
		}
	}
	
	override public function destroy():Void
	{
		titleLogo = null;
	
		super.destroy();
	}
}