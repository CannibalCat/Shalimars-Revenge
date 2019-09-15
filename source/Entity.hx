package;

import flixel.FlxSprite;

enum State
{
	IDLE;
	WANDERING;
	RUNNING;
	CHASING;
	EVADING;
	COLLECTED;
	CLIMBING;
	JUMPING;
	DYING;
	DEAD;
	BURNING;
	MELTING;
}

class Entity extends FlxSprite
{
	public var currentState:State;
	public var previousState:State;
	public var followTarget:Bool = false;
	public var target:Entity;
	public var scoreValue:Int = 0;
	public var offset_x:Float;
	public var offset_y:Float;

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		currentState = IDLE;
		previousState = IDLE;
		offset_x = 0;
		offset_y = 0;
		super(X, Y);
	}
	
	public function changeState(newState:Entity.State):Void
	{
		previousState = currentState;
		currentState = newState;
	}
}