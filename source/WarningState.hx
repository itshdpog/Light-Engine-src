package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import ui.FlxVirtualPad;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class WarningState extends MusicBeatState
{
	var txt:FlxText;

	private var shakeCam:Bool = true;
	var cleanfont_isenabled:Bool = false;

	override function create()
	{
		new FlxTimer().start(5, function(tmr:FlxTimer)
        {
			FlxG.switchState(new CreditsMenu());
        });

		cleanfont_isenabled = config.getcleanfont();

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		FlxG.sound.playMusic(Paths.music('deadMenu'));


		txt = new FlxText(0, 0, FlxG.width, "Try to run away...", 32);
		if (cleanfont_isenabled)
		{
			txt.setFormat(Paths.font("coolvetica.ttf"), 32, FlxColor.fromRGB(200, 200, 200), CENTER);
			txt.borderColor = FlxColor.BLACK;
			txt.borderSize = 3;
			txt.borderStyle = FlxTextBorderStyle.OUTLINE;
			txt.screenCenter();
			txt.alpha = 0.1;
		}
		else
		{
			txt.setFormat("VCR OSD Mono", 32, FlxColor.fromRGB(200, 200, 200), CENTER);
			txt.borderColor = FlxColor.BLACK;
			txt.borderSize = 3;
			txt.borderStyle = FlxTextBorderStyle.OUTLINE;
			txt.screenCenter();
			txt.alpha = 0.1;
		}

		add(txt);

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			txt.text = "no";
			shakeCam = false;
			FlxG.sound.music.stop();
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				PlayState.SONG = Song.loadFromJson('nolol-hard','nolol'.toLowerCase());
				LoadingState.loadAndSwitchState(new PlayState());
			});
		}

		if (shakeCam)
		{
			FlxG.camera.shake(0.02, 0.02);
		}

		super.update(elapsed);
	}
}