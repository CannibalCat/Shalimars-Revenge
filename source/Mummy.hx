package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.math.FlxPoint;

class Mummy extends Entity 
{
	private var maxSpeed:Int = 60;
	private var maxFallSpeed:Int = 800;
	private var gravity:Int = 1000;
	private var homePosition:FlxPoint;
	
	public function new(?X:Float=0, ?Y:Float=0, ?facing:Int=FlxObject.RIGHT) 
	{
		super(X, Y);
		homePosition = new FlxPoint(X, Y);
		
		loadGraphic("assets/images/Mummy.png", true, 16, 16, false);
		
		animation.add("idle", [0], 1, false);
		animation.add("walk", [1, 2], 6, true);
		animation.add("climb", [3, 4], 6, true);
		animation.add("attack", [5], 1, false);
		animation.add("death", [6], 1, false);

		acceleration.y = gravity;
		maxVelocity.y = maxFallSpeed;
		this.facing = facing;
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
		
		if (facing == FlxObject.RIGHT)
			velocity.x = maxSpeed;
		else
			velocity.x = -maxSpeed;
			
		// Shrink bounding box and recenter
		width = 12;
		height = 16;
		centerOffsets(true);
		centerOrigin();
		
		animation.play("walk");
	}
	
	override public function update(elapsed:Float):Void
	{
		if (justTouched(FlxObject.RIGHT)) 
			velocity.x = -maxSpeed;
		else if (justTouched(FlxObject.LEFT)) 
			velocity.x = maxSpeed;
		
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