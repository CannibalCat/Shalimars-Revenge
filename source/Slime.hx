package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.math.FlxPoint;

class Slime extends Entity 
{
	private var maxSpeed:Int = 40;
	private var maxFallSpeed:Int = 800;
	private var gravity:Int = 1000;
	private var homePosition:FlxPoint;
	
	public function new(?X:Float=0, ?Y:Float=0, ?facing:Int=FlxObject.RIGHT) 
	{
		super(X, Y);
		homePosition = new FlxPoint(X, Y);
		
		loadGraphic("assets/images/Slime.png", true, 16, 16, false);
		
		animation.add("idle", [0], 1, false);
		animation.add("walk", [0, 1, 2, 1], 15, true);
		animation.add("jump", [3], 1, false);
		animation.add("death", [4], 1, false);
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
		
		acceleration.y = gravity;
		maxVelocity.y = maxFallSpeed;
		this.facing = facing;
		if (facing == FlxObject.RIGHT)
			velocity.x = maxSpeed;
		else
			velocity.x = -maxSpeed;
		
		animation.play("walk");
	}
	
	override public function update(elapsed:Float):Void
	{
		if (justTouched(FlxObject.RIGHT)) 
			velocity.x = -maxSpeed;
		else if (justTouched(FlxObject.LEFT)) 
			velocity.x = maxSpeed;
		
		if (followTarget)
		{
			if (Globals.globalGameState.player != null && Globals.globalGameState.player.isOnScreen() && Globals.globalGameState.player.alive)
			{
				if (Globals.globalGameState.player.y <= y + height && Globals.globalGameState.player.y >= y) 
				{
					if (Globals.globalGameState.player.x < x)  
						velocity.x = -maxSpeed
					else
						velocity.x = maxSpeed;
				}
			}
		}
		
		if (isOnScreen()) 
			super.update(elapsed);
			
		if (!isOnScreen() && alive)
		{
			velocity.y = 0;
			velocity.x = maxSpeed;
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