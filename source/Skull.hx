package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.math.FlxPoint;

class Skull extends Entity 
{
	private var maxSpeed:Int = 40;
	private var maxFallSpeed:Int = 800;
	private var gravity:Int = 1000;
	private var homePosition:FlxPoint;
	
	public function new(?X:Float=0, ?Y:Float=0, ?roll:Bool=false, ?facing:Int=FlxObject.RIGHT) 
	{
		super(X, Y);
		homePosition = new FlxPoint(X, Y);
		
		loadGraphic("assets/images/GraySkull.png", true, 16, 16, false);
		
		animation.add("idle", [0], 1, false);
		animation.add("roll", [0, 1, 2, 3, 4, 5, 6, 7], 12, true);
		
		acceleration.y = gravity;
		maxVelocity.y = maxFallSpeed;
		this.facing = facing;
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
		
		if (facing == FlxObject.RIGHT)
			velocity.x = maxSpeed;
		else
			velocity.x = -maxSpeed;
		
		if (roll)
			animation.play("roll");
		else 
			animation.play("idle");
	}
	
	override public function update(elapsed:Float):Void
	{
		if (justTouched(FlxObject.RIGHT)) 
			velocity.x = -maxSpeed;
		else if (justTouched(FlxObject.LEFT)) 
			velocity.x = maxSpeed;
		
		if (isOnScreen()) 
			super.update(elapsed);
			
		if (!isOnScreen() && alive)
		{
			velocity.y = 0;
			setPosition(homePosition.x, homePosition.y - 1);
		}

		if (x < FlxG.camera.scroll.x)
			velocity.x = maxSpeed;
		 
		if 	(x + frameWidth > FlxG.camera.scroll.x + FlxG.width)
			velocity.x = -maxSpeed;
			
		if (velocity.x < 0)
			facing = FlxObject.LEFT;
		else if (velocity.x > 0)
			facing = FlxObject.RIGHT;
			
		Globals.globalGameState.level.collideWithLevel(this);
	}
}