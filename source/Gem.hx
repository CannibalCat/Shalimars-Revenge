package;

import flixel.FlxSprite;

enum GemType
{
	ONYX;
	EMERALD;
	SAPPHIRE;
	RUBY;
	DIAMOND;
}

class Gem extends FlxSprite 
{
	public var gemType:GemType;
	public var value:Int;
	
	public function new(?X:Float=0, ?Y:Float=0, gemType:GemType) 
	{
		super(X, Y);
		
		loadGraphic("assets/images/Gems.png", true, 16, 16, false);
		
		switch (gemType)
		{
			case ONYX:
				animation.add("default", [0], 1, false);
				value = 100;
				
			case EMERALD:
				animation.add("default", [1], 1, false);
				value = 300;
				
			case SAPPHIRE:
				animation.add("default", [2], 1, false);
				value = 200;
				
			case RUBY:
				animation.add("default", [3], 1, false);
				value = 400;
				
			case DIAMOND:
				animation.add("default", [4], 1, false);
				value = 500;
		}
		
		this.gemType = gemType;
		
		animation.play("default");
	}
}