package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import ui.FlxVirtualPad;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class ToBeContinuedState extends MusicBeatState
{
	var txt:FlxText;

	var cleanfont_isenabled:Bool = false;

	override function create()
	{
		new FlxTimer().start(5, function(tmr:FlxTimer)
        {
			txt.alpha -= 0.05;

			if (txt.alpha > 0)
			{
				tmr.reset(0.1);
			}

			new FlxTimer().start(5, function(tmr:FlxTimer)
			{
				FlxG.sound.music.stop();
				PlayState.SONG = Song.loadFromJson('trapped-hard','trapped'.toLowerCase());
            	LoadingState.loadAndSwitchState(new PlayState());
			});

        });

		cleanfont_isenabled = config.getcleanfont();

		txt = new FlxText(0, 0, FlxG.width, "To Be Continued...", 32);
		if (cleanfont_isenabled)
		{
			txt.setFormat(Paths.font("coolvetica.ttf"), 32, FlxColor.fromRGB(200, 200, 200), CENTER);
			txt.borderColor = FlxColor.BLACK;
			txt.borderSize = 3;
			txt.borderStyle = FlxTextBorderStyle.OUTLINE;
			txt.screenCenter();
			txt.alpha = 1;
		}
		else
		{
			txt.setFormat("VCR OSD Mono", 32, FlxColor.fromRGB(200, 200, 200), CENTER);
			txt.borderColor = FlxColor.BLACK;
			txt.borderSize = 3;
			txt.borderStyle = FlxTextBorderStyle.OUTLINE;
			txt.screenCenter();
			txt.alpha = 1;
		}

		add(txt);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}