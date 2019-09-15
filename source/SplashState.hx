package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.graphics.FlxGraphic;
import flixel.addons.effects.FlxTrail;
import flixel.system.scaleModes.PixelPerfectScaleMode;

class SplashState extends FlxState 
{
	private var ccLogo:FlxSprite;
	private var presents:FlxSprite;
	private var splashTimer:FlxTimer;
	private var tween:FlxTween;
	private var ccTrail:FlxTrail;
	private var presentsTrail:FlxTrail;

	override public function create():Void
	{
		bgColor = 0xFF000000; 
		FlxG.mouse.visible = false;
		FlxG.scaleMode = new PixelPerfectScaleMode();	
		FlxG.autoPause = false;
		
		ccLogo = new FlxSprite(0, 0, "assets/images/CCLogo.png");
		add(ccLogo); 
		
		presents = new FlxSprite(0, 0, "assets/images/Presents.png");
		presents.setPosition(400, 400);
		add(presents); 
		
		ccTrail = new FlxTrail(ccLogo, null, 12, 0, 0.4, 0.02);
		add(ccTrail);
		
		presentsTrail = new FlxTrail(presents, null, 12, 0, 0.4, 0.02);
		add(presentsTrail);
		
		tween = FlxTween.quadMotion(ccLogo, -100, -100, 10, 240, 70, 75, 1, true, { type: FlxTween.ONESHOT, ease: FlxEase.sineInOut }); 
		tween.onComplete = nextTween;
	}
	
	private function nextTween(tween:FlxTween):Void
	{
		tween = FlxTween.quadMotion(presents, 400, 400, 10, 240, 97, 125, 1, true, { type: FlxTween.ONESHOT, ease: FlxEase.sineInOut }); 
		tween.onComplete = startFadeTimer;		
	}
	
	private function startFadeTimer(tween:FlxTween):Void
	{
		splashTimer = new FlxTimer();
		splashTimer.start(1, fadeOut, 1);
	}
	
	private function fadeOut(timer:FlxTimer):Void
	{
		FlxG.cameras.fade(0xFF000000, 1, false, onFinalFade);
	}
	
	private function onFinalFade():Void
	{
		FlxG.switchState(new TitleState());
	}

	override public function destroy():Void
	{
		ccLogo = null;
		presents = null;
		tween.destroy();
		ccTrail.destroy();
		presentsTrail.destroy();
		splashTimer.destroy();
		super.destroy();
	}
}