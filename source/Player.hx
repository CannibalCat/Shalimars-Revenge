package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import flixel.util.FlxAxes;
import flixel.util.FlxSpriteUtil;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;

class Player extends Entity 
{
	public static inline var RUN_SPEED:Int = 90;
	public static inline var GRAVITY:Int = 620; 
	public static inline var JUMP_SPEED:Int = 180; 
	public var immune:Bool = false;
	public var climbing:Bool = false;
	public var stunned:Bool = false;
	public var inventory:Array<Item.ItemType> = [];
	public var flares = 0;
	private var jumpTime:Float = -1;
	private var timesJumped:Int = 0;
	private var jumpKeys:Array<FlxKey> = [W, SPACE];
	private var shootKeys:Array<FlxKey> = [Z, CONTROL];
	private var onLadder:Bool = false;
	private var xgridleft:Int = 0;
	private var xgridright:Int = 0;
	private var ygrid:Int = 0;
	private var fallTime:Float = 0;
	private var parentState:PlayState;
	private var fryTime:Float = 0;
	
	private var gamepad(get, never):FlxGamepad;
	private function get_gamepad():FlxGamepad 
	{
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
		
		if (gamepad == null)
			gamepad = FlxG.gamepads.getByID(0);
			
		return gamepad;
	}
	
	public function new(X:Float=0, Y:Float=0, parentState:PlayState) 
	{
		super(X, Y);
		
		loadGraphic("assets/images/Player.png", true, 16, 16, false);
		animation.add("idle", [0], 1, false);
		animation.add("run", [1, 2], 8, true);
		animation.add("jump", [1], 1, false);
		animation.add("climb", [3, 4], 8, false); 
		animation.add("die", [6, 6], 1, false);
		animation.add("fall", [7], 1, false);
		animation.add("burned", [8], 1, true);
		animation.add("skinned", [9], 1, false);
		animation.add("shoot", [5, 0], 1, false);
		animation.add("knocked_out", [6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 0], 12, false);
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
		
		drag.set(RUN_SPEED * 8, RUN_SPEED * 8);
		maxVelocity.set(RUN_SPEED, JUMP_SPEED);
		acceleration.y = GRAVITY;
		this.parentState = parentState;
		
		// Shrink bounding box and recenter
		width = 12;
		height = 16;
		centerOffsets(true);
		centerOrigin();
		
		health = Globals.playerHealth;
		
		changeState(Entity.State.IDLE);
	}
	
	override public function reset(x:Float, y:Float):Void
	{
		super.reset(x, y); 
		facing = FlxObject.RIGHT;
		fallTime = 0;
		health = 6;	
		Globals.playerHealth = 6;
		changeState(Entity.State.IDLE);
		alive = true;
		immune = false;
		FlxSpriteUtil.fadeIn(this, 1);
	}
	
	override public function changeState(newState:Entity.State):Void
	{
		super.changeState(newState);
		
		if (newState == previousState)
			return;
			
		if (newState == Entity.State.DYING)
		{
			health = 0;
			Globals.playerHealth = 0;
			animation.play("die");
			animation.finishCallback = fadePlayer;
			alive = false;
			immune = true;
			Globals.playerLives--;	
			if (Globals.playerLives == 0)
				Globals.gameOver = true;
		}
		else if (newState == Entity.State.BURNING)
		{
			velocity.x = 0;
			velocity.y /= 4;
			animation.play("burned");
			alpha = 0.9;
			health = 0;
			Globals.playerHealth = 0;
		}
		else if (newState == Entity.State.MELTING)
		{
			velocity.x = 0;
			velocity.y /= 4;
			animation.play("skinned");
			alpha = 0.9;
			health = 0;
			Globals.playerHealth = 0;
		}
		else if (newState == Entity.State.CLIMBING)
		{
			animation.play("climb");
		}
		else if (newState == Entity.State.IDLE)
		{
			velocity.x = 0;
			velocity.y = 0;
			animation.play("idle");
		}
	}
	
	public override function destroy():Void
	{
		super.destroy();
	}
	
	public override function update(elapsed:Float):Void
	{
		acceleration.x = 0;
		
		if (Globals.pauseGame)
			return;
			
 		if (currentState != Entity.State.BURNING && currentState != Entity.State.MELTING && currentState != Entity.State.DYING && !stunned)
		{
			if (!climbing)
				acceleration.y = GRAVITY;
			else
				acceleration.y = 0;
				
			var gamepad = get_gamepad();
			
			// Player shoot projectile
			if ((FlxG.keys.anyJustPressed(shootKeys) || gamepad.anyJustPressed([FlxGamepadInputID.B])) && flares > 0)
			{
				if (facing == FlxObject.LEFT)
					shootLeft();
				else
					shootRight();
			}
			
			if ((FlxG.keys.anyPressed([LEFT, A]) || gamepad.analog.value.LEFT_STICK_X < 0 || gamepad.pressed.DPAD_LEFT) && currentState != Entity.State.JUMPING && !climbing)
			{
				acceleration.x = -drag.x;
				changeState(Entity.State.RUNNING);
				facing = FlxObject.LEFT;
			}
			
			if ((FlxG.keys.anyPressed([RIGHT, D]) || gamepad.analog.value.LEFT_STICK_X > 0 || gamepad.pressed.DPAD_RIGHT) && currentState != Entity.State.JUMPING && !climbing)
			{
				acceleration.x = drag.x;
				changeState(Entity.State.RUNNING);
				facing = FlxObject.RIGHT;
			}
			
			jump(elapsed);
			
			// Can only climb when not jumping
			if (jumpTime < 0)
				climb();
			
			if (velocity.x > 0 || velocity.x < 0) 
				animation.play("run"); 
			else if (velocity.x == 0 && !climbing)
				animation.play("idle"); 
			
			if (velocity.y < 0)
			{
				if (climbing)
					animation.play("climb");
				else
					animation.play("jump"); 
			}
			else if (velocity.y > 0)
			{
				if (climbing)
					animation.play("climb"); 
				else
				{
					animation.play("fall");
					fallTime += elapsed;
				}
			}
				
			// Convert pixel positions to grid positions
			xgridleft = Std.int((x + 3) / 16);   
			xgridright = Std.int((x + width - 3) / 16);
			ygrid = Std.int((y + height - 1) / 16);   
			
			if (parentState.level.climbableTiles.getTile(xgridleft, ygrid) > 0 && 
				parentState.level.climbableTiles.getTile(xgridright, ygrid) > 0) 
			{
				onLadder = true;
			}
			else 
			{
				onLadder = false;
				climbing = false;
			}
			
			if (isTouching(FlxObject.FLOOR) && !FlxG.keys.anyPressed(jumpKeys) && !gamepad.anyPressed([FlxGamepadInputID.A]))
			{
				jumpTime = -1;
				timesJumped = 0;
				
				if (fallTime >= 0.45)
				{
					FlxG.sound.play("HitGround");
					FlxG.camera.shake(0.02, 0.25, null, true, FlxAxes.Y);
					if (currentState != Entity.State.DYING)
						changeState(Entity.State.DYING);
				}
				
				fallTime = 0;
			}
		}
		else
		{
			if (currentState == Entity.State.BURNING || currentState == Entity.State.MELTING)
			{
				if (velocity.y > 4)
					velocity.y /= 2;
					
				if (isTouching(FlxObject.FLOOR))
				{
					fryTime += elapsed;
					if (fryTime > 3)
					{
						fryTime = 0;
						fadePlayer(null);
					}
				}
			}
		}
		
		super.update(elapsed);
	}
	
	private function climb():Void
	{
		if (FlxG.keys.anyPressed([UP, W]) || gamepad.analog.value.LEFT_STICK_Y < 0 || gamepad.pressed.DPAD_UP)
		{
			if (onLadder) 
			{
				x = (Math.round(x / 16) * 16) + 2;
				climbing = true;
				fallTime = 0;
				timesJumped = 0;
			}
			
			if (climbing && (parentState.level.climbableTiles.getTile(xgridleft, ygrid - 1)) > 0) 
				velocity.y = - RUN_SPEED;
		}
		else if (FlxG.keys.anyPressed([DOWN, S]) || gamepad.analog.value.LEFT_STICK_Y > 0 || gamepad.pressed.DPAD_DOWN)
		{
			if (currentState == Entity.State.IDLE && !climbing)
				return; 
				
			if (onLadder) 
			{
				if (justTouched(FlxObject.FLOOR) || isTouching(FlxObject.FLOOR)) 
				{
					FlxG.keys.reset();
					onLadder = false;
					climbing = false;
					changeState(Entity.State.IDLE);
				}
				else
				{
					x = (Math.round(x / 16) * 16) + 2;
					climbing = true;
					fallTime = 0;
					timesJumped = 0;
				}
			}
			
			if (climbing) 
				velocity.y = RUN_SPEED;
		}
	}
	
    private function shootRight():Void
	{
		var bullet = Globals.globalGameState.playerProjectiles.recycle();
		bullet.x = x + 6;
		bullet.y = y + 8;
		bullet.facing = FlxObject.RIGHT;
		flares--;
		//FlxG.sound.play("PlayerShoot");
    }
	
	private function shootLeft():Void
	{
		var bullet = Globals.globalGameState.playerProjectiles.recycle();
		bullet.x = x - 2;
		bullet.y = y + 8;
		bullet.facing = FlxObject.LEFT;
		flares--;
		//FlxG.sound.play("PlayerShoot");
    }
	
	private function jump(elapsed:Float):Void
	{
		if (FlxG.keys.anyJustPressed(jumpKeys) || gamepad.anyJustPressed([FlxGamepadInputID.A]))
		{
			if ((velocity.y == 0) || (timesJumped < 1)) 
			{
				//FlxG.sound.play("PlayerJump");
				timesJumped++;
				jumpTime = 0;
				onLadder = false;
			}
		}
		
		// You can also use space or any other key you want
		if ((FlxG.keys.anyPressed(jumpKeys) || gamepad.anyPressed([FlxGamepadInputID.A])) && jumpTime >= 0) 
		{
			climbing = false;
			jumpTime += elapsed;
			
			// You can't jump for more than 0.25 seconds
			if (jumpTime > 0.25) 
				jumpTime = -1;
			else if (jumpTime > 0)
				velocity.y = - 0.6 * maxVelocity.y;
		}
		else
			jumpTime = -1.0;
	}
	
	//override public function hurt(damage:Float):Void
	//{
		//health -= damage;
		//Globals.playerHealth -= Std.int(damage);
			//
		//if (health <= 0)
			//changeState(Entity.State.DYING);
		//else
		//{
			//FlxG.sound.play("PlayerHit");			
			//FlxSpriteUtil.flicker(this, 2, Globals.playerFlickerRate, true, true, toggleImmunityOff); 
		//}
	//}	
	
	private function toggleImmunityOff(effect:FlxFlicker):Void
	{
		immune = false;
	}
	
	private function fadePlayer(animationName:String):Void
	{
		animation.finishCallback = null;
		FlxSpriteUtil.fadeOut(this, 1, resetPlayer);
	}
	
	private function resetPlayer(tween:FlxTween):Void
	{
		reset(Globals.lastPlayerCheckpoint.x, Globals.lastPlayerCheckpoint.y);
	}
}