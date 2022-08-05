package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;
import ui.FlxVirtualPad;

class CreditSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var cleanfont_isenabled:Bool = false;

	override function create()
	{
		cleanfont_isenabled = config.getcleanfont();

		super.create();

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('stageback', 'shared'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 0.8));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);   
		
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"HEY! Thanks for Downloading Alpha 0.3.3 of the Light Engine!\nThe Engine is still being Developed.\nSo you might encounter bugs, and if you do...\nPlease Report them to me (Wyxos)."
			+ "\n! Press Space/A to go to Wyxos' Channel, or ESCAPE/B to ignore this!!"
			+ "\n- Wyxos and the Dev Team.", 32);
			if (cleanfont_isenabled)
			{
				txt.setFormat(Paths.font("coolvetica.ttf"), 32, FlxColor.fromRGB(200, 200, 200), CENTER);
				txt.borderColor = FlxColor.BLACK;
				txt.borderSize = 3;
				txt.borderStyle = FlxTextBorderStyle.OUTLINE;
				txt.screenCenter();
				add(txt);
			}
			else
			{
				txt.setFormat("VCR OSD Mono", 32, FlxColor.fromRGB(200, 200, 200), CENTER);
				txt.borderColor = FlxColor.BLACK;
				txt.borderSize = 3;
				txt.borderStyle = FlxTextBorderStyle.OUTLINE;
				txt.screenCenter();
				add(txt);
			}
	}

	override function update(elapsed:Float)
	{	

		if (controls.ACCEPT)
		{
			FlxG.openURL("https://youtube.com/c/Wyxos");
		}
		if (controls.BACK)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
