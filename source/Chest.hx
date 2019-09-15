package;

import flixel.FlxG;
import flixel.FlxSprite;

enum ChestType
{
	WOODEN;
	SILVER;
	GOLD;
}

class Chest extends FlxSprite 
{
	public var opened:Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0, chestType:ChestType) 
	{
		super(X, Y);
		
		loadGraphic("assets/images/Chests.png", true, 16, 16, false); 
		
		switch (chestType) 
		{
			case WOODEN:
				animation.add("closed", [0], 1, false);
				animation.add("open", [1], 1, false);
				
			case SILVER:
				animation.add("closed", [2], 1, false);
				animation.add("open", [3], 1, false);
				
			case GOLD:
				animation.add("closed", [4], 1, false);
				animation.add("open", [5], 1, false);
		}
		
		animation.play("closed");
	}
	
	public function open():Item.ItemType
	{
		animation.play("open");
		FlxG.sound.play("OpenChest");
		opened = true;
		
		var contents:Item.ItemType = null;
		var selection:Int = FlxG.random.weightedPick([10, 10, 10, 1, 69]);
		
		switch (selection) 
		{
			case 0:
				contents = Item.ItemType.TORCH;
				
			case 1:
				contents = Item.ItemType.GOLD_KEY;
				
			case 2:
				contents = Item.ItemType.SILVER_KEY;
				
			case 3:
				contents = Item.ItemType.SKELETON_KEY;
				
			case 4: 
				contents = null;
		}
		
		return contents;
	}
}