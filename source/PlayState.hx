package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.ui.FlxBar;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxCollision;
import flixel.util.FlxSpriteUtil;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText;

// TODO: Need player lives substate, with player moving into position like MZ?

class PlayState extends FlxState
{
	public var level:TiledLevel;
	public var gems:FlxGroup;
	public var items:FlxGroup;
	public var chests:FlxGroup;
	public var locks:FlxGroup;
	public var vials:FlxGroup;
	public var markers:FlxGroup;	
	public var lava:FlxGroup;
	public var acid:FlxGroup;
	public var enemies:FlxGroup;
	public var traps:FlxGroup;
	public var player:Player;
	public var playerProjectiles:FlxTypedGroup<PlayerShot>;
	private var hudGroup:FlxTypedGroup<FlxSprite>;
	private var hudInventoryWindow:FlxSprite;
	private var hudInventoryFrame:FlxSprite;
	private var hudInventoryBorder:FlxSprite;
	private var hudScoreWindow:FlxSprite;
	private var ankhIcon:FlxSprite;
	private var torchIcon:FlxSprite;
	private var statueIcon:FlxSprite;
	private var goldKeyIcon:FlxSprite;
	private var silverKeyIcon:FlxSprite;
	private var skeletonKeyIcon:FlxSprite;
	private var fullHeartIcon:FlxSprite;
	private var halfHeartIcon:FlxSprite;
	private var scoreText:FlxBitmapText;
	private var hudFont:FlxBitmapFont;
	private var ammoBar:FlxBar;
	
	override public function create():Void
	{
		Globals.globalGameState = this;
		
		player = new Player(0, 0, this);
		gems = new FlxGroup();
		items = new FlxGroup();
		chests = new FlxGroup();
		locks = new FlxGroup();
		enemies = new FlxGroup();
		markers = new FlxGroup();
		vials = new FlxGroup();
		lava = new FlxGroup();
		acid = new FlxGroup();
		traps = new FlxGroup();
		hudGroup = new FlxTypedGroup<FlxSprite>();
		playerProjectiles = new FlxTypedGroup<PlayerShot>(Globals.maxPlayerProjectiles);

		// Load the level 
		level = new TiledLevel("assets/data/WorldMap1.tmx", this);
		
		add(level.backgroundLayer);
		add(gems);
		add(items);
		add(enemies);
		add(chests);
		add(locks);
		add(vials);
		add(markers);
		add(traps);
		add(level.foregroundTiles);
		
		add(player);
		FlxG.camera.follow(player);
		FlxG.camera.style = SCREEN_BY_SCREEN; 
		
		add(level.overlayLayer);

		ankhIcon = new FlxSprite();
		ankhIcon.loadGraphic("assets/images/Items.png", true, 16, 16, false);
		ankhIcon.animation.add("default", [5], 1, false);
		ankhIcon.animation.play("default");
		
		statueIcon = new FlxSprite();
		statueIcon.loadGraphic("assets/images/Items.png", true, 16, 16, false);
		statueIcon.animation.add("default", [6], 1, false);
		statueIcon.animation.play("default");
		
		torchIcon = new FlxSprite();
		torchIcon.loadGraphic("assets/images/Items.png", true, 16, 16, false);
		torchIcon.animation.add("default", [3], 1, false);
		torchIcon.animation.play("default");
		
		goldKeyIcon = new FlxSprite();
		goldKeyIcon.loadGraphic("assets/images/Items.png", true, 16, 16, false);
		goldKeyIcon.animation.add("default", [0], 1, false);
		goldKeyIcon.animation.play("default");
		
		silverKeyIcon = new FlxSprite();
		silverKeyIcon.loadGraphic("assets/images/Items.png", true, 16, 16, false);
		silverKeyIcon.animation.add("default", [1], 1, false);
		silverKeyIcon.animation.play("default");
		
		skeletonKeyIcon = new FlxSprite();
		skeletonKeyIcon.loadGraphic("assets/images/Items.png", true, 16, 16, false);
		skeletonKeyIcon.animation.add("default", [2], 1, false);
		skeletonKeyIcon.animation.play("default");
		
		fullHeartIcon = new FlxSprite();
		fullHeartIcon.loadGraphic("assets/images/FullHeart.png", false, 8, 7, false);
		
		halfHeartIcon = new FlxSprite();
		halfHeartIcon.loadGraphic("assets/images/HalfHeart.png", false, 8, 7, false);
		
		hudInventoryBorder = new FlxSprite(10, 3, "assets/images/InventoryWindowBorder.png");
		hudGroup.add(hudInventoryBorder);
		
		hudInventoryWindow = new FlxSprite(12, 5, "assets/images/InventoryWindow.png");
		hudInventoryFrame = new FlxSprite(0, 0, "assets/images/InventoryWindowFrame.png");		
		hudInventoryWindow.stamp(hudInventoryFrame, 0, 0);
		hudGroup.add(hudInventoryWindow);
		
		hudScoreWindow = new FlxSprite(200, 3, "assets/images/ScoreWindow.png");
		hudGroup.add(hudScoreWindow);
		
		var charSize = FlxPoint.get(16, 16);
		hudFont = FlxBitmapFont.fromMonospace("assets/fonts/HUDFont.png", Globals.HUDTextSet, charSize);
		
		scoreText = new FlxBitmapText(hudFont);
		scoreText.letterSpacing = 1;
		scoreText.autoSize = false;
		scoreText.setSize(85, 16);
		scoreText.setPosition(305, 7);
		scoreText.alignment = FlxTextAlign.RIGHT;
		scoreText.text = Std.string(Globals.playerScore);
		hudGroup.add(scoreText);

		ammoBar = new FlxBar(80, 21, FlxBarFillDirection.LEFT_TO_RIGHT, 35, 2); 
		ammoBar.setRange(0, 10);
		ammoBar.createFilledBar(0xFF404040, 0xFFEF8C31);
		ammoBar.visible = true;
		ammoBar.value = 0;
		hudGroup.add(ammoBar);
		
		hudGroup.forEach(function(member:FlxSprite)
		{
			member.scrollFactor.set(0, 0);
			member.cameras = [FlxG.camera];
		});
		
		add(hudGroup);
		
		// Initialize player projectiles pool
		var playerShot:PlayerShot;
		for (i in 0...Globals.maxPlayerProjectiles)
		{
			playerShot = new PlayerShot();
			playerProjectiles.add(playerShot);
			playerShot.kill();
		}
		
		add(playerProjectiles);
		
		super.create();
	}
	
	override public function destroy():Void
	{
		gems.destroy();
		items.destroy();
		chests.destroy();
		locks.destroy();
		vials.destroy();
		enemies.destroy();
		markers.destroy();
		lava.destroy();
		acid.destroy();
		traps.destroy();
		player.destroy();
		level = null;
		playerProjectiles = null;
		hudInventoryWindow = null;
		hudInventoryBorder = null;
		hudInventoryFrame = null;
		hudScoreWindow = null;
		ankhIcon = null;
		torchIcon = null;
		goldKeyIcon = null;
		silverKeyIcon = null;
		skeletonKeyIcon = null;
		statueIcon = null;
		fullHeartIcon = null;
		halfHeartIcon = null;
		scoreText = null;
		ammoBar = null;
		
		super.destroy();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		ColorCycler.Update(elapsed);
		
		FlxG.overlap(gems, player, getGem);
		FlxG.overlap(items, player, getItem);
		FlxG.overlap(locks, player, openLock);
		FlxG.overlap(chests, player, openChest);
		FlxG.overlap(markers, enemies, reverseDirection);
		FlxG.overlap(lava, player, burnPlayer);
		FlxG.overlap(acid, player, meltPlayer);
		//FlxG.overlap(traps, player, checkTrap);
		
		//FlxG.overlap(level.foregroundTiles, playerProjectiles, projectileHit);

		// Collide with foreground tile layer
		level.collideWithLevel(player);
		
		for (i in 0...playerProjectiles.length)
		{
			var projectile = playerProjectiles.members[i];
			
			if (!projectile.alive)
				continue;
				
			// Roll through enemies list here and do a pixel perfect check
			for (j in 0...enemies.length)
			{
				var entity = cast(enemies.members[j], FlxSprite);

				if (!entity.alive)
					continue;	
					
				if (FlxCollision.pixelPerfectCheck(projectile, entity))	
				{
					projectile.kill();
					entity.kill();
				}
			}
				
			level.collideWithLevel(projectile, projectileHit);
		}
		
		for (i in 0...enemies.length)
		{
			var entity = cast(enemies.members[i], FlxSprite);

			if (!entity.alive)
				continue;	
				
			if (FlxCollision.pixelPerfectCheck(player, entity))	
				killPlayer();
		}
		
		for (i in 0...traps.length)
		{
			var trap = cast(traps.members[i], FlxSprite);
				
			if (FlxCollision.pixelPerfectCheck(player, trap))	
				killPlayer();
		}
		
		drawHUD();
	}
	
	private function projectileHit(tile:FlxObject, projectile:FlxObject):Void
	{
		projectile.kill();
		// Add appropriate splash sprite and sound
	}
	
	private function reverseDirection(marker:FlxObject, enemy:FlxObject):Void
	{
		enemy.velocity.x *= -1;
		FlxObject.separate(marker, enemy);
	}
	
	private function killPlayer():Void
	{
		player.changeState(Entity.State.DYING);
	}
	
	//private function hurtPlayer(enemy:FlxObject, Player:FlxObject):Void
	//{
		//if (player.immune)
			//return;
			//
		//var thisEnemy:Entity = cast (enemy, Entity);
		//FlxObject.separate(enemy, player);
		//player.hurt(1);
		//
		//if (player.health > 0)
		//{
			//player.immune = true;
			//player.stunned = true;
			//if (enemy.velocity.x < 0)	
			//{
				//FlxTween.tween(player, { x:player.x - 16, y:player.y - 8 }, .1, { onComplete:unStunPlayer });
				//FlxTween.tween(enemy, { x:enemy.x + 16, y:enemy.y - 8 }, .1);
			//}
			//else if (enemy.velocity.x > 0)
			//{
				//FlxTween.tween(player, { x:player.x + 16, y:player.y - 8 }, .1, { onComplete:unStunPlayer });
				//FlxTween.tween(enemy, { x:enemy.x - 16, y:enemy.y - 8 }, .1);
			//}
		//}
	//}	
	
	private function unStunPlayer(tween:FlxTween):Void
	{
		player.stunned = false;
	}
	
	private function burnPlayer(lava:FlxObject, enemy:FlxObject):Void
	{
		//FlxG.sound.play("Sizzle");
		if (player.currentState != Entity.State.BURNING)
			player.changeState(Entity.State.BURNING);
	}
	
	private function meltPlayer(acid:FlxObject, enemy:FlxObject):Void
	{
		//FlxG.sound.play("Sizzle");
		if (player.currentState != Entity.State.MELTING)
			player.changeState(Entity.State.MELTING);
	}
	
	private function getGem(gem:FlxObject, Player:FlxObject):Void
	{
		var thisGem:Gem = cast (gem, Gem);
		Globals.playerScore += thisGem.value;
		gem.kill();
	}

	private function openChest(chest:FlxObject, Player:FlxObject):Void
	{
		var thisChest:Chest = cast (chest, Chest);
		if (!thisChest.opened)
		{
			var lootItem = thisChest.open();
			if (lootItem != null)
			{
				if (player.inventory.length < 3)
					player.inventory.push(lootItem);
			}
		}
	}
	
	private function openLock(lock:FlxObject, Player:FlxObject):Void
	{
		var thisLock:Lock = cast (lock, Lock);
		
		if (thisLock.lockType == Lock.LockType.GOLD && player.inventory.indexOf(Item.ItemType.GOLD_KEY) >= 0)
		{
			thisLock.unlock();
			player.inventory.remove(Item.ItemType.GOLD_KEY);
		}
		else if (thisLock.lockType == Lock.LockType.SILVER && player.inventory.indexOf(Item.ItemType.SILVER_KEY) >= 0)
		{
			thisLock.unlock();
			player.inventory.remove(Item.ItemType.SILVER_KEY);		
		}
		else if (thisLock.lockType == Lock.LockType.SKELETON && player.inventory.indexOf(Item.ItemType.SKELETON_KEY) >= 0)
		{
			thisLock.unlock();
			player.inventory.remove(Item.ItemType.SKELETON_KEY);		
		}
		else
		{
			FlxG.sound.play("Locked");
			FlxObject.separate(lock, player);
		}
	}
	
	private function getItem(item:FlxObject, Player:FlxObject):Void
	{
		var thisItem:Item = cast (item, Item);
		
		if (thisItem.itemType == Item.ItemType.AMMO)
			player.flares = 10;		
		else
		{
			if (player.inventory.length < 3)
				player.inventory.push(thisItem.itemType);
		}
			
		item.kill();
	}
	
	private function drawHUD():Void
	{
		// Update player score display
		scoreText.text = Std.string(Globals.playerScore);
		
		ammoBar.value = player.flares;

		// Update player inventory box
		FlxSpriteUtil.fill(hudInventoryWindow, 0x00000000);
		hudInventoryWindow.stamp(hudInventoryFrame, 0, 0);
		
		var x_pos:Int = 2;
		var y_pos:Int = 3;
		
		for (i in 0...player.inventory.length)
		{
			switch (player.inventory[i]) 
			{
				case Item.ItemType.ANKH:
					hudInventoryWindow.stamp(ankhIcon, x_pos, y_pos);
					
				case Item.ItemType.STATUE:
					hudInventoryWindow.stamp(statueIcon, x_pos, y_pos);
					
				case Item.ItemType.TORCH:
					hudInventoryWindow.stamp(torchIcon, x_pos, y_pos);

				case Item.ItemType.GOLD_KEY:
					hudInventoryWindow.stamp(goldKeyIcon, x_pos, y_pos);
					
				case Item.ItemType.SILVER_KEY:
					hudInventoryWindow.stamp(silverKeyIcon, x_pos, y_pos);
					
				case Item.ItemType.SKELETON_KEY:
					hudInventoryWindow.stamp(skeletonKeyIcon, x_pos, y_pos);
					
				default:
			}
			
			x_pos += 22;
		}
		
		// Update player health
		var fullHeartCount = Std.int(Globals.playerHealth / 2);
		
		x_pos = 72;
		y_pos = 2;
		
		for (i in 0...fullHeartCount)
		{
			hudInventoryWindow.stamp(fullHeartIcon, x_pos, y_pos);
			x_pos += 10;
		}
		
		if (Globals.playerHealth % 2 != 0) 
		{
			if (Globals.playerHealth > 2)
				hudInventoryWindow.stamp(halfHeartIcon, x_pos + 10, y_pos);
			else 
				hudInventoryWindow.stamp(halfHeartIcon, x_pos, y_pos);
		}
	}
}