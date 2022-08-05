package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import ui.FlxVirtualPad;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Skip Song', 'Change Difficulty', 'Chart Editor', 'Animation Debug' ,'Menus'];
	var menuItemsOG:Array<String> = ['Resume', 'Restart Song', 'Skip Song', 'Change Difficulty', 'Chart Editor', 'Animation Debug', 'Menus'];
	var difficultyChoices = ['EASY', 'NORMAL', 'HARD', 'BACK'];
	var menuChoices = ['MAIN MENU', 'OPTIONS MENU', 'FREEPLAY MENU', 'STORY MENU', 'BACK'];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	
	var scoreText:FlxText;
	var levelInfo:FlxText;
	var levelDifficulty:FlxText;

	var config:Config = new Config();
	var cleanfont_isenabled:Bool = false;
	var nohud_isenabled:Bool = false;

	public function new(x:Float, y:Float)
	{
		super();

		cleanfont_isenabled = config.getcleanfont();
		nohud_isenabled = config.getnohud();

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		if (cleanfont_isenabled)
		{
			levelInfo = new FlxText(20, 15, 0, "", 32);
			levelInfo.text += PlayState.SONG.song;
			levelInfo.scrollFactor.set();
			levelInfo.setFormat(Paths.font("coolvetica.ttf"), 32);
			levelInfo.updateHitbox();
			add(levelInfo);

			levelDifficulty = new FlxText(20, 15 + 32, 0, "", 32);
			levelDifficulty.text += CoolUtil.difficultyString();
			levelDifficulty.scrollFactor.set();
			levelDifficulty.setFormat(Paths.font('coolvetica.ttf'), 32);
			levelDifficulty.updateHitbox();
			add(levelDifficulty);

		}
		else
		{
			levelInfo = new FlxText(20, 15, 0, "", 32);
			levelInfo.text += PlayState.SONG.song;
			levelInfo.scrollFactor.set();
			levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
			levelInfo.updateHitbox();
			add(levelInfo);

			levelDifficulty = new FlxText(20, 15 + 32, 0, "", 32);
			levelDifficulty.text += CoolUtil.difficultyString();
			levelDifficulty.scrollFactor.set();
			levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
			levelDifficulty.updateHitbox();
			add(levelDifficulty);
		}

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);
		/*
		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;
		*/

		#if android
		if (FlxG.android.justReleased.BACK == true){
			close();
		}
		#end

		if (controls.UP_P)
		{
			changeSelection(-1);
		}
		if (controls.DOWN_P)
		{
			changeSelection(1);
		}

		if (controls.ACCEPT)
		{
			var daSelected:String = menuItems[curSelected];

			
			switch (daSelected)
			{
				case "Resume":
					close();
					if (nohud_isenabled)
					{
						PlayState.camHUD.alpha = 0;
					}
				case "Restart Song":
					FlxG.resetState();
				case "Skip Song":
					close();
					PlayState.instance.endSong();
				case 'Change Difficulty':
					menuItems = difficultyChoices;
					regenMenu();
				case "Chart Editor":
					FlxG.switchState(new ChartingState());
				case "Animation Debug":
					FlxG.switchState(new AnimationDebug(PlayState.SONG.player2));
				case 'Menus':
					menuItems = menuChoices;
					regenMenu();
				case 'EASY' | 'NORMAL' | 'HARD':
					var name:String = PlayState.SONG.song.toLowerCase();
					var poop = Highscore.formatSong(name, curSelected);
					PlayState.SONG = Song.loadFromJson(poop, name);
					PlayState.storyDifficulty = curSelected;
					FlxG.resetState();
					FlxG.sound.music.volume = 0;
					PlayState.changedDifficulty = true;
				case 'MAIN MENU':
					FlxG.switchState(new MainMenuState());
				case 'OPTIONS MENU':
					FlxG.switchState(new OptionsMenu());
				case 'FREEPLAY MENU':
					FlxG.switchState(new FreeplayState());
				case 'STORY MENU':
					FlxG.switchState(new StoryMenuState());
				case 'BACK':
					menuItems = menuItemsOG;
					regenMenu();
		}
	}

		if (FlxG.keys.justPressed.J)
		{
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
	function regenMenu():Void {
		for (i in 0...grpMenuShit.members.length) {
			this.grpMenuShit.remove(this.grpMenuShit.members[0], true);
		}
		for (i in 0...menuItems.length) {
			var item = new Alphabet(0, 70 * i + 30, menuItems[i], true, false);
			item.isMenuItem = true;
			item.targetY = i;
			grpMenuShit.add(item);
		}
		curSelected = 0;
		changeSelection();
	}
}
