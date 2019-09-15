package;

import flixel.FlxSprite;

enum LockType
{
	SKELETON;
	SILVER;
	GOLD;
}

class Lock extends FlxSprite 
{
	public var lockType:LockType;
	
	public function new(?X:Float=0, ?Y:Float=0, lockType:LockType) 
	{
		super(X, Y);
		
		loadGraphic("assets/images/Locks.png", true, 16, 16, false); 
		
		switch (lockType) 
		{
			case SKELETON:
				animation.add("default", [2], 1, false);
			
			case SILVER:
				animation.add("default", [1], 1, false);
				
			case GOLD:
				animation.add("default", [0], 1, false);
		}
		
		animation.play("default");
		immovable = true;
		solid = true;
		this.lockType = lockType;
	}
	
	public function unlock():Void
	{
		//FlxG.sound.play("Unlock");
		kill();
	}
}