package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledImageLayer;
import flixel.addons.editors.tiled.TiledImageTile;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTilePropertySet;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.tile.FlxTileSpecial;
import flixel.addons.tile.FlxTilemapExt;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import haxe.io.Path;

class TiledLevel extends TiledMap
{
	// For each "Tile Layer" in the map, you must define a "tileset" property which contains the name of a tile sheet image 
	// used to draw tiles in that layer (without file extension). The image file must be located in the directory specified bellow.
	private inline static var PATH_LEVEL_TILESHEETS = "assets/images/";
	
	// Array of tilemaps used for collision
	public var foregroundTiles:FlxGroup;
	public var objectsLayer:FlxGroup;
	public var backgroundLayer:FlxGroup;
	public var overlayLayer:FlxGroup;
	public var climbableTiles:FlxTilemap;
	public var lavaTiles:FlxGroup;
	public var collisionMarkers:FlxGroup;
	private var collidableTileLayers:Array<FlxTilemap>;
	
	// Sprites of images layers
	public var imagesLayer:FlxGroup;
	
	public function new(tiledLevel:Dynamic, state:PlayState)
	{
		super(tiledLevel);
		
		imagesLayer = new FlxGroup();
		foregroundTiles = new FlxGroup();
		objectsLayer = new FlxGroup();
		backgroundLayer = new FlxGroup();
		overlayLayer = new FlxGroup();
		climbableTiles = new FlxTilemap();
		lavaTiles = new FlxGroup();
		
		FlxG.camera.setScrollBoundsRect(0, 0, fullWidth, fullHeight, true);
		
		loadImages();
		loadObjects(state);
		
		// Load Tile Maps
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.TILE) 
				continue;
				
			var tileLayer:TiledTileLayer = cast layer;
			var tileSheetName:String = tileLayer.properties.get("tileset");
			
			if (tileSheetName == null)
				throw "'tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.";
				
			var tileSet:TiledTileSet = null;
			for (ts in tilesets)
			{
				if (ts.name == tileSheetName)
				{
					tileSet = ts;
					break;
				}
			}
			
			if (tileSet == null)
				throw "Tileset '" + tileSheetName + " not found. Did you misspell the 'tilesheet' property in " + tileLayer.name + "' layer?";
				
			var imagePath = new Path(tileSet.imageSource);
			var processedPath = PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;
			
			// could be a regular FlxTilemap if there are no animated tiles
			var tilemap = new FlxTilemapExt();
			//tilemap.useScaleHack = true;
			
			if (tileLayer.properties.contains("climbable"))
			{
				climbableTiles.loadMapFromArray(tileLayer.tileArray, width, height, processedPath,
					tileSet.tileWidth, tileSet.tileHeight, OFF, tileSet.firstGID, 1, 1);
			}
			else
			{
				tilemap.loadMapFromArray(tileLayer.tileArray, width, height, processedPath,
					tileSet.tileWidth, tileSet.tileHeight, OFF, tileSet.firstGID, 1, 1);
			}
			
			if (tileLayer.properties.contains("animated"))
			{
				var tileset = tilesets["Tiles"];
				var specialTiles:Map<Int, TiledTilePropertySet> = new Map();
				for (tileProp in tileset.tileProps)
				{
					if (tileProp != null && tileProp.animationFrames.length > 0)
					{
						specialTiles[tileProp.tileID + tileset.firstGID] = tileProp;
					}
				}
				
				var tileLayer:TiledTileLayer = cast layer;
				tilemap.setSpecialTiles([
					for (tile in tileLayer.tiles)
						if (tile != null && specialTiles.exists(tile.tileID))
							getAnimatedTile(specialTiles[tile.tileID], tileset)
						else null
				]);
			}
			
			// NOTE: add 'scrollfactor" as a custom property to tile layer(s) for parallax scrolling, etc.
			if (tileLayer.properties.contains("scrollfactor"))
			{
				var scrollFactor:Float = Std.parseFloat(tileLayer.properties.get("scrollfactor"));
				tilemap.scrollFactor.set(scrollFactor, scrollFactor);
			}

			if (tileLayer.properties.contains("overlay"))
			{
				overlayLayer.add(tilemap);
			}
			else if (tileLayer.properties.contains("nocollide"))
			{
				backgroundLayer.add(tilemap);
			}
			else if (tileLayer.properties.contains("climbable"))
			{
				backgroundLayer.add(climbableTiles);
			}
			else if (tileLayer.properties.contains("lava"))
			{
				lavaTiles.add(tilemap);
			}
			else
			{
				if (collidableTileLayers == null)
					collidableTileLayers = new Array<FlxTilemap>();
				
				foregroundTiles.add(tilemap);
				collidableTileLayers.push(tilemap);
			}
		}
	}

	private function getAnimatedTile(props:TiledTilePropertySet, tileset:TiledTileSet):FlxTileSpecial
	{
		var special = new FlxTileSpecial(1, false, false, 0);
		var n:Int = props.animationFrames.length;
		//var offset = Std.random(n);
		var offset = 0;
		special.addAnimation(
			[for (i in 0 ... n) props.animationFrames[(i + offset) % n].tileID + tileset.firstGID],
			(1000 / props.animationFrames[0].duration)
		);
		return special;
	}
	
	public function loadObjects(state:PlayState)
	{
		var layer:TiledObjectLayer;
		
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.OBJECT)
				continue;
				
			var objectLayer:TiledObjectLayer = cast layer;

			//collection of images layer
			if (layer.name == "images")
			{
				for (o in objectLayer.objects)
				{
					loadImageObject(o);
				}
			}
			
			//objects layer
			if (layer.name == "objects")
			{
				for (o in objectLayer.objects)
				{
					loadObject(state, o, objectLayer, objectsLayer);
				}
			}
		}
	}
	
	private function loadImageObject(object:TiledObject)
	{
		var tilesImageCollection:TiledTileSet = this.getTileSet("imageCollection");
		var tileImagesSource:TiledImageTile = tilesImageCollection.getImageSourceByGid(object.gid);
		
		// Background layer sprites
		var levelsDir:String = "assets/images/";
		
		var decoSprite:FlxSprite = new FlxSprite(0, 0, levelsDir + tileImagesSource.source);
		if (decoSprite.width != object.width ||
			decoSprite.height != object.height)
		{
			decoSprite.antialiasing = true;
			decoSprite.setGraphicSize(object.width, object.height);
		}
		decoSprite.setPosition(object.x, object.y - decoSprite.height);
		decoSprite.origin.set(0, decoSprite.height);
		if (object.angle != 0)
		{
			decoSprite.angle = object.angle;
			decoSprite.antialiasing = true;
		}
		
		//Custom Properties
		if (object.properties.contains("depth"))
		{
			var depth = Std.parseFloat( object.properties.get("depth"));
			decoSprite.scrollFactor.set(depth,depth);
		}

		backgroundLayer.add(decoSprite);
	}
	
	private function loadObject(state:PlayState, o:TiledObject, g:TiledObjectLayer, group:FlxGroup)
	{
		var x:Int = o.x;
		var y:Int = o.y;
		
		// objects in tiled are aligned bottom-left (top-left in flixel)
		if (o.gid != -1)
			y -= g.map.getGidOwner(o.gid).tileHeight;
		
		switch (o.type.toLowerCase())
		{
			case "player_start":
				state.player.x = x; 
				state.player.y = y;
				Globals.lastPlayerCheckpoint.x = x;
				Globals.lastPlayerCheckpoint.y = y;
				//FlxG.camera.follow(state.player);
				//state.add(state.player);
				//group.add(state.player);
				
			case "trap":
				switch (o.name.toLowerCase())
				{
					case "chain_trap":
						var trap:ChainTrap = new ChainTrap(x, y);
						trap.solid = true;
						trap.immovable = true;
						state.traps.add(trap);						
				}
				
			case "enemy":
				switch (o.name.toLowerCase())
				{
					case "scorpion":
						var scorpion:Scorpion = new Scorpion(x, y, false, o.flippedHorizontally ? FlxObject.LEFT : FlxObject.RIGHT);
						state.enemies.add(scorpion);
						
					case "elite_scorpion":
						var scorpion:Scorpion = new Scorpion(x, y, true, o.flippedHorizontally ? FlxObject.LEFT : FlxObject.RIGHT);
						state.enemies.add(scorpion);
						
					case "rat":
						var rat:Rat = new Rat(x, y, false, o.flippedHorizontally ? FlxObject.LEFT : FlxObject.RIGHT);
						state.enemies.add(rat);
						
					case "elite_rat":
						var rat:Rat = new Rat(x, y, true, o.flippedHorizontally ? FlxObject.LEFT : FlxObject.RIGHT);
						state.enemies.add(rat);
						
					case "bat":
						var bat:Bat = new Bat(x, y, false, o.flippedHorizontally ? FlxObject.LEFT : FlxObject.RIGHT);
						state.enemies.add(bat);
						
					case "demon":
						var demon:Demon = new Demon(x, y, false, o.flippedHorizontally ? FlxObject.LEFT : FlxObject.RIGHT);
						state.enemies.add(demon);
						
					case "skeleton":
						var skeleton:Skeleton = new Skeleton(x, y, false, o.flippedHorizontally ? FlxObject.LEFT : FlxObject.RIGHT);
						state.enemies.add(skeleton);
						
					case "slime":
						var slime:Slime = new Slime(x, y, o.flippedHorizontally ? FlxObject.LEFT : FlxObject.RIGHT);
						state.enemies.add(slime);
						
					case "zombie":
						var zombie:Zombie = new Zombie(x, y, false, o.flippedHorizontally ? FlxObject.LEFT : FlxObject.RIGHT);
						state.enemies.add(zombie);
						
					case "spider":
						var spider:Spider = new Spider(x, y, o.flippedHorizontally ? FlxObject.LEFT : FlxObject.RIGHT);
						state.enemies.add(spider); 
					
					case "zombie":
						var spider:Spider = new Spider(x, y, o.flippedHorizontally ? FlxObject.LEFT : FlxObject.RIGHT);
						state.enemies.add(spider);
						
					case "mummy":
						var mummy:Mummy = new Mummy(x, y, o.flippedHorizontally ? FlxObject.LEFT : FlxObject.RIGHT);
						state.enemies.add(mummy);
						
					case "skeleton":
						var skeleton:Skeleton = new Skeleton(x, y, false, o.flippedHorizontally ? FlxObject.LEFT : FlxObject.RIGHT);
						state.enemies.add(skeleton);
						
					case "elite_skeleton":
						var skeleton:Skeleton = new Skeleton(x, y, true, o.flippedHorizontally ? FlxObject.LEFT : FlxObject.RIGHT);
						state.enemies.add(skeleton);
						
					case "rolling_skull":
						var skull:Skull = new Skull(x, y, true, o.flippedHorizontally ? FlxObject.LEFT : FlxObject.RIGHT);
						state.enemies.add(skull);
				}
				
			case "gem":
				var gem:FlxSprite = null;
				switch (o.name.toLowerCase())
				{
					case "onyx":
						gem = new Gem(x, y, Gem.GemType.ONYX);
						
					case "emerald":
						gem = new Gem(x, y, Gem.GemType.EMERALD);
						
					case "sapphire":
						gem = new Gem(x, y, Gem.GemType.SAPPHIRE);
						
					case "ruby":
						gem = new Gem(x, y, Gem.GemType.RUBY);
						
					case "diamond":
						gem = new Gem(x, y, Gem.GemType.DIAMOND);
				}
				state.gems.add(gem);
				
			case "item":
				var item:Item = null;
				switch (o.name.toLowerCase())
				{
					case "ankh":
						item = new Item(x, y, Item.ItemType.ANKH);
						
					case "torch":
						item = new Item(x, y, Item.ItemType.TORCH);
						
					case "statue":
						item = new Item(x, y, Item.ItemType.STATUE);
						
					case "ammo":
						item = new Item(x, y, Item.ItemType.AMMO);
				}
				state.items.add(item);
				
			case "lock":
				var lock:Lock = null;
				switch (o.name.toLowerCase())
				{
					case "skeleton_lock":
						lock = new Lock(x, y, Lock.LockType.SKELETON);

					case "silver_lock":
						lock = new Lock(x, y, Lock.LockType.SILVER);
						
					case "gold_lock":
						lock = new Lock(x, y, Lock.LockType.GOLD);
				}
				state.locks.add(lock);	
				
			case "chest":
				var chest:Chest = null;
				switch (o.name.toLowerCase())
				{
					case "wooden_chest":
						chest = new Chest(x, y, Chest.ChestType.WOODEN);

					case "silver_chest":
						chest = new Chest(x, y, Chest.ChestType.SILVER);
						
					case "gold_chest":
						chest = new Chest(x, y, Chest.ChestType.GOLD);
				}
				state.chests.add(chest);				
				
			case "collision_marker":
				var marker = new FlxObject(x, y, o.width, o.height);
				marker.solid = true;
				marker.immovable = true;
				state.markers.add(marker);
				
			case "lava":
				var lavaBlock = new FlxObject(x, y, o.width, o.height);
				lavaBlock.immovable = true;
				state.lava.add(lavaBlock);
				
			case "acid":
				var acidBlock = new FlxObject(x, y, o.width, o.height);
				acidBlock.immovable = true;
				state.acid.add(acidBlock);
				
			case "key":
				var key:Item = null; 
				switch (o.name.toLowerCase())
				{
					case "gold_key":
						key = new Item(x, y, Item.ItemType.GOLD_KEY);
						
					case "silver_key":
						key = new Item(x, y, Item.ItemType.SILVER_KEY);
						
					case "skeleton_key":
						key = new Item(x, y, Item.ItemType.SKELETON_KEY);
						
				}
				state.items.add(key);
				//state.keys.add(key);
		}
	}

	public function loadImages()
	{
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.IMAGE)
				continue;

			var image:TiledImageLayer = cast layer;
			var sprite = new FlxSprite(image.x, image.y, PATH_LEVEL_TILESHEETS + image.imagePath);
			imagesLayer.add(sprite);
		}
	}
	
	public function collideWithLevel(obj:FlxObject, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool
	{
		if (collidableTileLayers == null)
			return false;

		for (map in collidableTileLayers)
		{
			// IMPORTANT: Always collide the map with objects, not the other way around. 
			//			  This prevents odd collision errors (collision separation code off by 1 px).
			if (FlxG.overlap(map, obj, notifyCallback, processCallback != null ? processCallback : FlxObject.separate))
			{
				return true;
			}
		}
		return false;
	}
}