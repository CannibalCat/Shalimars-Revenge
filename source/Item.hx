package;

import flixel.FlxSprite;

enum ItemType
{
	GOLD_KEY;
	SILVER_KEY;
	SKELETON_KEY;
	TORCH;
	ANKH;
	STATUE;
	AMMO;
}

class Item extends FlxSprite 
{
	public var itemType:ItemType;
	
	public function new(?X:Float=0, ?Y:Float=0, itemType:ItemType) 
	{
		super(X, Y);
		
		loadGraphic("assets/images/Items.png", true, 16, 16, false); 
		
		switch (itemType) 
		{
			case GOLD_KEY:
				animation.add("default", [0], 1, false);
				
			case SILVER_KEY:
				animation.add("default", [1], 1, false);
				
			case SKELETON_KEY:
				animation.add("default", [2], 1, false);
				
			case TORCH:
				animation.add("default", [3, 4], 4, true);
				
			case ANKH:
				animation.add("default", [5], 1, false);
				
			case STATUE:
				animation.add("default", [6], 1, false);
				
			case AMMO:
				animation.add("default", [7], 1, false);
		}
		
		this.itemType = itemType;
		
		animation.play("default");
	}
}