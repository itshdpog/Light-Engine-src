package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;
import ui.FlxVirtualPad;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class SecretState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var tSpr:FlxSprite;

	var txt:FlxText;

	var cleanfont_isenabled:Bool = false;

	public static var rickrolled:Bool = false;

	private var shakeCam:Bool = false;

	override function create()
	{
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		FlxG.sound.playMusic(Paths.music('glitchMenu'));

		new FlxTimer().start(2.6, function(tmr:FlxTimer)
		{
			shakeCam = true;
			add(tSpr);
			add(txt);
		});

		cleanfont_isenabled = config.getcleanfont();

		super.create();

		tSpr = new FlxSprite(0, 0).loadGraphic(Paths.image('troll'));
		tSpr.setGraphicSize(Std.int(tSpr.width * 0.2));
		tSpr.updateHitbox();
		tSpr.screenCenter(X);
		tSpr.screenCenter();
		tSpr.antialiasing = true;
		tSpr.visible = false;

		txt = new FlxText(0, 0, FlxG.width, "There are no secrets :P\nDO NOT PRESS A.", 32);
			if (cleanfont_isenabled)
			{
				txt.setFormat(Paths.font("coolvetica.ttf"), 32, FlxColor.fromRGB(200, 200, 200), CENTER);
				txt.borderColor = FlxColor.BLACK;
				txt.borderSize = 3;
				txt.borderStyle = FlxTextBorderStyle.OUTLINE;
				txt.screenCenter();
			}
			else
			{
				txt.setFormat("VCR OSD Mono", 32, FlxColor.fromRGB(200, 200, 200), CENTER);
				txt.borderColor = FlxColor.BLACK;
				txt.borderSize = 3;
				txt.borderStyle = FlxTextBorderStyle.OUTLINE;
				txt.screenCenter();
			}
	}

	override function update(elapsed:Float)
	{	
		if (shakeCam)
		{
			FlxG.camera.shake(0.05, 0.05);
		}

		if (controls.ACCEPT)
		{
			txt.text = "You have no choice now.\nGoodluck! ^_^";
			tSpr.visible = true;


			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				PlayState.SONG = Song.loadFromJson('rolled-hard','rolled'.toLowerCase());
				LoadingState.loadAndSwitchState(new PlayState());
				// unlocked it on freeplay. (buggy sometimes idk lmao)
				rickrolled = true;
			});
		}
		if (controls.BACK)
		{
			txt.text = "Where do you think you're trying to go? hmmmm...";
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				txt.text = "There are no secrets :P\nDO NOT PRESS A.";
			});
		}
		super.update(elapsed);
	}
}
