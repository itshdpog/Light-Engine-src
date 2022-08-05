package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var iconScale:Float = 1;
	public var iconSize:Float;
	public var defualtIconScale:Float = 1;

	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);


		animation.add('bf', [0, 1], 0, false, isPlayer);
		animation.add('nobody', [0, 1], 0, false, isPlayer);
		animation.add('rick', [0, 1], 0, false, isPlayer);
		animation.add('bf-holding-gf', [0, 1], 0, false, isPlayer);
		animation.add('bf-car', [0, 1], 0, false, isPlayer);
		animation.add('bf-christmas', [0, 1], 0, false, isPlayer);
		animation.add('bf-pixel', [21, 21], 0, false, isPlayer);
		animation.add('spooky', [2, 3], 0, false, isPlayer);
		animation.add('pico', [4, 5], 0, false, isPlayer);
		animation.add('mom', [6, 7], 0, false, isPlayer);
		animation.add('mom-car', [6, 7], 0, false, isPlayer);
		animation.add('tankman', [8, 9], 0, false, isPlayer);
		animation.add('face', [10, 11], 0, false, isPlayer);
		animation.add('dad', [12, 13], 0, false, isPlayer);
		animation.add('senpai', [22, 22], 0, false, isPlayer);
		animation.add('senpai-angry', [22, 22], 0, false, isPlayer);
		animation.add('spirit', [23, 23], 0, false, isPlayer);
		animation.add('bf-old', [14, 15], 0, false, isPlayer);
		animation.add('gf', [16], 0, false, isPlayer);
		animation.add('gf-tankmen', [16], 0, false, isPlayer);
		animation.add('gf-christmas', [16], 0, false, isPlayer);
		animation.add('gf-pixel', [16], 0, false, isPlayer);
		animation.add('parents-christmas', [17, 18], 0, false, isPlayer);
		animation.add('monster', [19, 20], 0, false, isPlayer);
		animation.add('monster-christmas', [19, 20], 0, false, isPlayer);

		animation.add('human', [24, 25], 0, false, isPlayer);
		animation.add('ragdoll', [26, 27], 0, false, isPlayer);
		animation.add('buddy', [28, 29], 0, false, isPlayer);
		animation.add('bonzi', [30, 31], 0, false, isPlayer);
		animation.add('secret', [32, 33], 0, false, isPlayer);
		animation.add('gman', [34, 35], 0, false, isPlayer);
		animation.add('garcello', [36, 37], 0, false, isPlayer);
		animation.add('garcellotired', [38, 39], 0, false, isPlayer);
		animation.add('garcellodead', [40, 41], 0, false, isPlayer);
		animation.add('garcelloghosty', [41, 41], 0, false, isPlayer);
		animation.play(char);

		iconScale = defualtIconScale;
		iconSize = width;

		switch(char){
			case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit' | 'gf-pixel':
				{

				}
			default:
				{
					antialiasing = true;
				}
		}
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}