package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;
import ui.FlxVirtualPad;

import flixel.util.FlxTimer;

class HackedState extends MusicBeatState
{
	public static var leftState:Bool = false;
	public static var subscribed:Bool = false;
	public static var sussyPress:Bool = false;

	var tSpr:FlxSprite;
	var menuBG:FlxSprite;

	var txt:FlxText;

	var cleanfont_isenabled:Bool = false;

	override function create()
	{
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		FlxG.sound.playMusic(Paths.music('dreamscapeMenu'));

		cleanfont_isenabled = config.getcleanfont();

		super.create();

		menuBG = new FlxSprite().loadGraphic(Paths.image('stageback', 'shared'));
		menuBG.color = FlxColor.RED;
		menuBG.setGraphicSize(Std.int(menuBG.width * 0.8));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		tSpr = new FlxSprite().loadGraphic(Paths.image('troll'));
		add(tSpr);
		tSpr.visible = false;
		tSpr.setGraphicSize(Std.int(tSpr.width * 0.3));
		tSpr.updateHitbox();
		tSpr.screenCenter(X);
		tSpr.screenCenter();
		tSpr.antialiasing = true;

			txt = new FlxText(0, 0, FlxG.width, "HEY! ImHD has hacked your game!\nThats very unfortunate...\nThe only way to go back to playing is by subscribing to ImHD.\n(Pressing B is useless until subscribing)", 32);
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
			FlxG.openURL("https://www.youtube.com/channel/UCytrUvU8dtwHZeyLRXTt45A");
			subscribed = true;
		}
		if (controls.BACK)
		{
			leftState = true;
			if (subscribed)
			{
				FlxG.switchState(new MainMenuState());
			}
			else
			{
				tSpr.visible = true;
				txt.text = "Please subscribe to ImHD first.";
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					txt.text = "HEY! ImHD has hacked your game!\nThats very unfortunate...\nThe only way to go back to playing is by subscribing to ImHD.\n(Pressing B is useless until subscribing)";
					tSpr.visible = false;
				});
			}
		}
		super.update(elapsed);
	}
}