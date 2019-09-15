package;

import flixel.FlxState;
import flixel.math.FlxPoint;

class Globals 
{
	public static inline var GAME_VERSION:Float = 1.0;
	public static var HUDTextSet:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,':!?()-";
	public static var highScores:Array<HighScoreData>;
	public static var playerInitials:Array<String> = [ "A", "A", "A" ];
	public static var lastHighScoreEntryNumber:Int = 0;
	public static var pauseGame:Bool = false;
	public static var gameOver:Bool = false;
	public static var globalGameState:PlayState;
	public static var playerScore:Int = 0;
	public static var playerLives:Int = 3;
	public static var playerHealth:Int = 6;
	public static var playerFlickerRate:Float = 0.07;
	public static var maxPlayerProjectiles:Int = 10;
	public static var analogMovementThreshold:Float = 0.2;
	public static var analogStickDelay:Float = 0;
	public static var lastPlayerCheckpoint:FlxPoint = new FlxPoint(0, 0);
	
	public static function resetGameGlobals():Void
	{
		playerScore = 0;
		playerLives = 3;
	}
}