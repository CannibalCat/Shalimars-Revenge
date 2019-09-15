package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;

class Bat extends Entity 
{
	private var maxSpeed:Int = 80;
	
	public function new(?X:Float = 0, ?Y:Float = 0, ?elite:Bool=false, ?facing:Int=FlxObject.RIGHT) 
	{
		super(X, Y);
		
		loadGraphic("assets/images/Rat.png", true, 16, 16, false);
		
		if (elite)
		{
			animation.add("idle", [0], 1, false);
			animation.add("walk", [0, 1, 2], 10, true);
			animation.add("attack", [3], 1, false);
			animation.add("death", [4], 1, false);
		}
		else
		{
			animation.add("idle", [5], 1, false);
			animation.add("walk", [5, 6, 7], 10, true);
			animation.add("attack", [8], 1, false);
			animation.add("death", [9], 1, false);			
		}
		
		this.facing = facing;
		if (facing == FlxObject.RIGHT)
			velocity.x = maxSpeed;
		else
			velocity.x = -maxSpeed;
		
		animation.play("idle");
	}
	
	override public function update(elapsed:Float):Void
	{
		
		super.update(elapsed);
	}
}