package;
 
import flixel.FlxG;
import flixel.FlxObject;

class PlayerShot extends Entity
{
    private static var speed:Float = 250;
 
    public function new()
	{
		super();
		
		loadGraphic("assets/images/PlayerShot.png", true, 8, 2, false);
		animation.add("default", [0, 1, 2, 3, 4, 5, 6, 7], 12, true);
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
		
		animation.play("default");
    }

    override public function update(elapsed:Float):Void
    {
        if (facing == FlxObject.LEFT)
            velocity.x = -speed;    

		if (facing == FlxObject.RIGHT)
            velocity.x = speed;    
		
		if ((facing == FlxObject.RIGHT && x > FlxG.camera.scroll.x + FlxG.width) || 
			(facing == FlxObject.LEFT && x + frameWidth < FlxG.camera.scroll.x))
			kill();		
			
		super.update(elapsed);
    }
}