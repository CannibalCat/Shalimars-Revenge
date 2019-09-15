package;

import flixel.FlxSprite;

enum VialType
{
	ICE;
	FIRE;
}

class Vial extends FlxSprite 
{
	public var vialType:VialType;
	
	public function new(?X:Float=0, ?Y:Float=0, vialType:VialType) 
	{
		super(X, Y);
		
		loadGraphic("assets/images/Vials.png", true, 16, 16, false); 
		
		switch (vialType) 
		{
			case ICE:
				animation.add("default", [0, 1, 2, 1, 0, 0, 0, 0], 4, true);
			
			case FIRE:
				animation.add("default", [3, 4, 5, 4, 3, 3, 3, 3], 4, true);
		}
		
		animation.play("default");
		this.vialType = vialType;
	}
}