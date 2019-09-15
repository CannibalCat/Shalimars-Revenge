package;

class ChainTrap extends Entity 
{
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic("assets/images/ChainTrap.png", true, 16, 16, false);
		animation.add("default", [0, 1, 2, 3, 4, 5, 6, 7, 8, 8, 8, 8], 8, true);
		animation.play("default");
	}
	
	override public function update(elapsed:Float):Void
	{
		color = ColorCycler.WilliamsFlash1;
		super.update(elapsed);
	}
}