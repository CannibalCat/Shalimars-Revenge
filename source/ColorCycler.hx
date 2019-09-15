package ;

class ColorCycler
{
	private static var RGBTimer:Float = 0;
	private static var RWBTimer:Float = 0;
	private static var WilliamsFlashTimer:Float = 0;
	private static var WilliamsUltraFlashTimer:Float = 0;
	private static var SternFlashTimer:Float = 0;
	private static var RedPulseTimer:Float = 0;
	private static var BluePulseTimer:Float = 0;
	private static var RedYellowFlashTimer:Float = 0;
	private static var ExplosionFlashTimer:Float = 0;
	private static var BlasterTextTimer:Float = 0;
	private static var RainbowFlashTimer:Float = 0;
	private static var RGBIndex:Int = 0;
	private static var RWBIndex1:Int = 0;
	private static var RWBIndex2:Int = 1;
	private static var RWBIndex3:Int = 2;
	private static var RWBIndex4:Int = 3;
	private static var RWBIndex5:Int = 4;
	private static var RWBIndex6:Int = 5;
	private static var WilliamsFlashIndex1:Int = 0;
	private static var WilliamsFlashIndex2:Int = 1;
	private static var WilliamsFlashIndex3:Int = 2;
	private static var WilliamsFlashIndex4:Int = 3;
	private static var WilliamsFlashIndex5:Int = 4;
	private static var WilliamsFlashIndex6:Int = 5;
	private static var WilliamsFlashIndex7:Int = 6;
	private static var WilliamsFlashIndex8:Int = 7;
	private static var WilliamsUltraFlashIndex:Int = 0;
	private static var SternFlashIndex1:Int = 0;
	private static var SternFlashIndex2:Int = 1;
	private static var SternFlashIndex3:Int = 2;
	private static var SternFlashIndex4:Int = 3;
	private static var SternFlashIndex5:Int = 4;
	private static var SternFlashIndex6:Int = 5;
	private static var SternFlashIndex7:Int = 6;
	private static var SternFlashIndex8:Int = 7;
	private static var RedPulseIndex:Int = 0;
	private static var BluePulseIndex:Int = 0;
	private static var RedYellowFlashIndex:Int = 0;
	private static var ExplosionFlashIndex:Int = 0;
	private static var BlasterTextIndex:Int = 0;
	private static var RainbowFlashIndex:Int = 0;
	private static inline var RGBFrameDelay:Float = 0.05;
	private static inline var RWBFrameDelay:Float = 0.05;
	private static inline var WilliamsFlashFrameDelay:Float = 0.04; 
	private static inline var WilliamsUltraFlashFrameDelay:Float = 0.06;
	private static inline var SternFlashFrameDelay:Float = 0.04;
	private static inline var RedPulseFrameDelay:Float = 0.07;
	private static inline var BluePulseFrameDelay:Float = 0.07;
	private static inline var RedYellowFlashFrameDelay:Float = 0.2; 
	private static inline var ExplosionFlashFrameDelay:Float = 0.02;
	private static inline var BlasterTextFrameDelay:Float = 0.06;
	private static inline var RainbowFlashFrameDelay:Float = 0.02;
	private static var RWBList:Array<Int> = [0xFFFF1717, 0xFFFF2F2F, 0xFFFF4F4F, 0xFFFF6F6F, 0xFFFF8F8F, 0xFFFFAFAF, 0xFFFFCFCF,
											 0xFFF6EEF6, 0xFFCFCFFF, 0xFFAFAFFF, 0xFF8F8FFF, 0xFF6F6FFF, 0xFF4F4FFF, 0xFF2F2FFF,
											 0xFF0F0FFF, 0xFF2F2FFF, 0xFF4F4FFF, 0xFF6F6FFF, 0xFF8F8FFF, 0xFFAFAFFF, 0xFFCFCFFF,
											 0xFFF6EEF6, 0xFFFFCFCF, 0xFFFFAFAF, 0xFFFF8F8F, 0xFFFF6F6F, 0xFFFF4F4F, 0xFFFF2F2F];
	private static var RGBList:Array<Int> = [0xFFFF0000, 0xFF00FF00, 0xFF0000FF];
	private static var WilliamsFlashList:Array<Int> = [0xFF0052FF, 0xFF0073A5, 0xFF00FF00, 0xFF73DE00, 0xFFFFDE00, 
													   0xFFFFAD00, 0xFFFF8C00, 0xFFFF7300, 0xFFFF5200, 0xFFFF005A, 
													   0xFFFF00A5, 0xFFFE00FF, 0xFFDE00FF, 0xFFAD00FF, 0xFF8C21FF, 
													   0xFF7321FF, 0xFF5221FF, 0xFF0000FF];
	private static var WilliamsUltraFlashList:Array<Int> = [0xFF0052FF, 0xFFFFFFFF, 0xFF0073A5, 0xFFFFFFFF, 0xFF00FF00, 0xFFFFFFFF,
															0xFF73DE00,	0xFFFFFFFF, 0xFFFFDE00, 0xFFFFFFFF, 0xFFFFAD00,	0xFFFFFFFF,
															0xFFFF8C00, 0xFFFFFFFF, 0xFFFF7300, 0xFFFFFFFF,	0xFFFF5200, 0xFFFFFFFF,
															0xFFFF005A, 0xFFFFFFFF, 0xFFFF00A5, 0xFFFFFFFF, 0xFFFE00FF, 0xFFFFFFFF,
															0xFFDE00FF, 0xFFFFFFFF, 0xFFAD00FF,	0xFFFFFFFF, 0xFF8C21FF,	0xFFFFFFFF,
															0xFF7321FF,	0xFFFFFFFF,	0xFF5221FF, 0xFFFFFFFF,	0xFF0000FF,	0xFFFFFFFF];
	private static var SternFlashList:Array<Int> = [0xFFE00000, 0xFFE05B00,	0xFFE0E000, 0xFF00E000, 
													0xFF00A2D9, 0xFF0000D9,	0xFFA20094, 0xFFA20000];
	private static var RedPulseList:Array<Int> = [0xFFFF0000, 0xFFFF535F, 0xFFFF8BA3, 0xFFFFFFFF, 0xFFFF8BA3, 0xFFFF535F];
	private static var BluePulseList:Array<Int> = [0xFF0000FF, 0xFF5353FF, 0xFF8B8BFF, 0xFFFFFFFF, 0xFF8B8BFF, 0xFF5353FF];
	private static var RedYellowFlashList:Array<Int> = [0xFFFF0000, 0xFFFFFF00];
	private static var ExplosionFlashList:Array<Int> = [0xFFDE0000, 0xFFDE6800,	0xFFB8B800, 0xFF00DE00, 0xFF00B897,
														0xFF0068DE,	0xFF0000DE,	0xFFB868DE,	0xFF979797,	0xFFDEDEDE];
	private static var BlasterTextList:Array<Int> = [0xFFFF2600, 0xFFFF0000, 0xFFFF005F, 0xFFFF00A0, 0xFFFF00FF, 0xFF8900FF,
													 0xFF5100FF, 0xFF0000FF, 0xFF00AEA0, 0xFF00D95F, 0xFF00FF00, 0xFF51FF00,
													 0xFF89AE00, 0xFFD9AE00, 0xFFD98900, 0xFFFF7600];
	private static var RainbowFlashList:Array<Int> = [0xFF25FF06, 0xFFA5FF00, 0xFFFFD700, 0xFFFF5500, 0xFFFF0029, 0xFFFF00A4,
													  0xFFE406FF, 0xFF5500FF, 0xFF002AFD, 0xFF00A6FF, 0xFF00FFD9, 0xFF00FF59];
	public static var RGB:Int;
	public static var RWB1:Int;
	public static var RWB2:Int;
	public static var RWB3:Int;
	public static var RWB4:Int;
	public static var RWB5:Int;
	public static var RWB6:Int;
	public static var WilliamsFlash1:Int;
	public static var WilliamsFlash2:Int;
	public static var WilliamsFlash3:Int;
	public static var WilliamsFlash4:Int;
	public static var WilliamsFlash5:Int;
	public static var WilliamsFlash6:Int;
	public static var WilliamsFlash7:Int;
	public static var WilliamsFlash8:Int;
	public static var WilliamsUltraFlash:Int;
	public static var SternFlash1:Int;
	public static var SternFlash2:Int;
	public static var SternFlash3:Int;
	public static var SternFlash4:Int;
	public static var SternFlash5:Int;
	public static var SternFlash6:Int;
	public static var SternFlash7:Int;
	public static var SternFlash8:Int;
	public static var RedPulse:Int;
	public static var BluePulse:Int;
	public static var RedYellowFlash:Int;
	public static var ExplosionFlash:Int;
	public static var BlasterText:Int;
	public static var RainbowFlash:Int;
	
	public static function Update(elapsed:Float):Void
	{
		RGBTimer += elapsed;
		RWBTimer += elapsed;
		WilliamsFlashTimer += elapsed;
		WilliamsUltraFlashTimer += elapsed;
		SternFlashTimer += elapsed;
		RedPulseTimer += elapsed;
		BluePulseTimer += elapsed;
		RedYellowFlashTimer += elapsed;
		ExplosionFlashTimer += elapsed;
		BlasterTextTimer += elapsed;
		RainbowFlashTimer += elapsed;
		
		if (RGBTimer > RGBFrameDelay)
		{
			RGBTimer = 0;
			RGBIndex++;
			if (RGBIndex > 2)
				RGBIndex = 0;
			RGB = RGBList[RGBIndex];
		}
		
		if (RWBTimer > RWBFrameDelay)
		{
			RWBTimer = 0;
			RWBIndex1++;
			RWBIndex2++;
			RWBIndex3++;
			RWBIndex4++;
			RWBIndex5++;
			RWBIndex6++;
			if (RWBIndex1 > 27)
				RWBIndex1 = 0;
			if (RWBIndex2 > 27)
				RWBIndex2 = 0;
			if (RWBIndex3 > 27)
				RWBIndex3 = 0;
			if (RWBIndex4 > 27)
				RWBIndex4 = 0;
			if (RWBIndex5 > 27)
				RWBIndex5 = 0;
			if (RWBIndex6 > 27)
				RWBIndex6 = 0;
			RWB1 = RWBList[RWBIndex1];
			RWB2 = RWBList[RWBIndex2];
			RWB3 = RWBList[RWBIndex3];
			RWB4 = RWBList[RWBIndex4];
			RWB5 = RWBList[RWBIndex5];
			RWB6 = RWBList[RWBIndex6];
		}		
		
		if (WilliamsFlashTimer > WilliamsFlashFrameDelay)
		{
			WilliamsFlashTimer = 0;
			WilliamsFlashIndex1++;
			WilliamsFlashIndex2++;
			WilliamsFlashIndex3++;
			WilliamsFlashIndex4++;
			WilliamsFlashIndex5++;
			WilliamsFlashIndex6++;
			WilliamsFlashIndex7++;
			WilliamsFlashIndex8++;
			if (WilliamsFlashIndex1 > 17)
				WilliamsFlashIndex1 = 0;
			if (WilliamsFlashIndex2 > 17)
				WilliamsFlashIndex2 = 0;
			if (WilliamsFlashIndex3 > 17)
				WilliamsFlashIndex3 = 0;
			if (WilliamsFlashIndex4 > 17)
				WilliamsFlashIndex4 = 0;
			if (WilliamsFlashIndex5 > 17)
				WilliamsFlashIndex5 = 0;
			if (WilliamsFlashIndex6 > 17)
				WilliamsFlashIndex6 = 0;
			if (WilliamsFlashIndex7 > 17)
				WilliamsFlashIndex7 = 0;
			if (WilliamsFlashIndex8 > 17)
				WilliamsFlashIndex8 = 0;
			WilliamsFlash1 = WilliamsFlashList[WilliamsFlashIndex1];			
			WilliamsFlash2 = WilliamsFlashList[WilliamsFlashIndex2];	
			WilliamsFlash3 = WilliamsFlashList[WilliamsFlashIndex3];	
			WilliamsFlash4 = WilliamsFlashList[WilliamsFlashIndex4];	
			WilliamsFlash5 = WilliamsFlashList[WilliamsFlashIndex5];	
			WilliamsFlash6 = WilliamsFlashList[WilliamsFlashIndex6];	
			WilliamsFlash7 = WilliamsFlashList[WilliamsFlashIndex7];	
			WilliamsFlash8 = WilliamsFlashList[WilliamsFlashIndex8];	
		}
		
		if (WilliamsUltraFlashTimer > WilliamsUltraFlashFrameDelay)
		{
			WilliamsUltraFlashTimer = 0;
			WilliamsUltraFlashIndex++;
			if (WilliamsUltraFlashIndex > 35)
				WilliamsUltraFlashIndex = 0;
			WilliamsUltraFlash = WilliamsUltraFlashList[WilliamsUltraFlashIndex];
		}
		
		if (SternFlashTimer > SternFlashFrameDelay)
		{
			SternFlashTimer = 0;
			SternFlashIndex1++;
			SternFlashIndex2++;
			SternFlashIndex3++;
			SternFlashIndex4++;
			SternFlashIndex5++;
			SternFlashIndex6++;
			SternFlashIndex7++;
			SternFlashIndex8++;
			if (SternFlashIndex1 > 7)
				SternFlashIndex1 = 0;
			if (SternFlashIndex2 > 7)
				SternFlashIndex2 = 0;
			if (SternFlashIndex3 > 7)
				SternFlashIndex3 = 0;
			if (SternFlashIndex4 > 7)
				SternFlashIndex4 = 0;
			if (SternFlashIndex5 > 7)
				SternFlashIndex5 = 0;
			if (SternFlashIndex6 > 7)
				SternFlashIndex6 = 0;
			if (SternFlashIndex7 > 7)
				SternFlashIndex7 = 0;
			if (SternFlashIndex8 > 7)
				SternFlashIndex8 = 0;
			SternFlash1 = SternFlashList[SternFlashIndex1];			
			SternFlash2 = SternFlashList[SternFlashIndex2];	
			SternFlash3 = SternFlashList[SternFlashIndex3];	
			SternFlash4 = SternFlashList[SternFlashIndex4];	
			SternFlash5 = SternFlashList[SternFlashIndex5];	
			SternFlash6 = SternFlashList[SternFlashIndex6];	
			SternFlash7 = SternFlashList[SternFlashIndex7];	
			SternFlash8 = SternFlashList[SternFlashIndex8];	
		}
		
		if (RedPulseTimer > RedPulseFrameDelay)
		{
			RedPulseTimer = 0;
			RedPulseIndex++;
			if (RedPulseIndex > 5)
				RedPulseIndex = 0;
			RedPulse = RedPulseList[RedPulseIndex];
		}
		
		if (BluePulseTimer > BluePulseFrameDelay)
		{
			BluePulseTimer = 0;
			BluePulseIndex++;
			if (BluePulseIndex > 5)
				BluePulseIndex = 0;
			BluePulse = BluePulseList[BluePulseIndex];
		}
		
		if (RedYellowFlashTimer > RedYellowFlashFrameDelay)
		{
			RedYellowFlashTimer = 0;
			RedYellowFlashIndex++;
			if (RedYellowFlashIndex > 1)
				RedYellowFlashIndex = 0;
			RedYellowFlash = RedYellowFlashList[RedYellowFlashIndex];
		}
		
		if (ExplosionFlashTimer > ExplosionFlashFrameDelay)
		{
			ExplosionFlashTimer = 0;
			ExplosionFlashIndex++;
			if (ExplosionFlashIndex > 9)
				ExplosionFlashIndex = 0;
			ExplosionFlash = ExplosionFlashList[ExplosionFlashIndex];
		}
		
		if (BlasterTextTimer > BlasterTextFrameDelay)
		{
			BlasterTextTimer = 0;
			BlasterTextIndex++;
			if (BlasterTextIndex > 15)
				BlasterTextIndex = 0;
			BlasterText = BlasterTextList[BlasterTextIndex];
		}
		
		if (RainbowFlashTimer > RainbowFlashFrameDelay)
		{
			RainbowFlashTimer = 0;
			RainbowFlashIndex++;
			if (RainbowFlashIndex > 11)
				RainbowFlashIndex = 0;
			RainbowFlash = RainbowFlashList[RainbowFlashIndex];
		}
	}
}