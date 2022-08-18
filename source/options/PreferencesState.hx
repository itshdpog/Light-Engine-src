package options;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import ui.Checkbox;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import Config;
import ui.FlxVirtualPad;

class PreferencesState extends MusicBeatState
{
    private var grptext:FlxTypedGroup<Alphabet>;

    private var checkboxGroup:FlxTypedGroup<Checkbox>;

    var curSelected:Int = 0;

	var menuItems:Array<String> = ['downscroll', 'middlescroll', 'ghost tapping', 'practice', 'no mods', 'no flashing', 'no hud', 'camzoom out', 'notesplash', 'light cpu strums', 'progress bar', 'clean font', 'wyx remixes', 'jamey skin', 'catgirl gf skin', 'hitsounds', 'pause button'];

	var notice:FlxText;
	private var notice2:FlxText;

	var cleanfont_isenabled:Bool = false;

	var controlLabel:Alphabet;

    override public function create() 
    {
		cleanfont_isenabled = config.getcleanfont();

        //var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('stageback', 'shared'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 0.8));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);   

        grptext = new FlxTypedGroup<Alphabet>();
		add(grptext);

        checkboxGroup = new FlxTypedGroup<Checkbox>();
		add(checkboxGroup);

		for (i in 0...menuItems.length)
		{ 
			controlLabel = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			grptext.add(controlLabel);

            var ch = new Checkbox(controlLabel.x + controlLabel.width + 10, controlLabel.y - 20);
            checkboxGroup.add(ch);
            add(ch);

			switch (menuItems[i]){
				case "downscroll":
					ch.change(config.downscroll);
				case "middlescroll":
					ch.change(config.middlescroll);
				case "ghost tapping":
					ch.change(config.ghosttap);
				case "practice":
					ch.change(config.practice);
				//case "panorama menu":
					//ch.change(config.panorama);
				case "no mods":
					ch.change(config.nomods);
				case "no flashing":
					ch.change(config.noflashing);
				case "no hud":
					ch.change(config.nohud);
				case "camzoom out":
					ch.change(config.zoomout);
				case "notesplash":
					ch.change(config.splash);
				case "light cpu strums":
					ch.change(config.cpustrums);
				case "progress bar":
					ch.change(config.timebar);
				case "clean font":
					ch.change(config.cleanfont);
				case "wyx remixes":
					ch.change(config.wyx);
				case "jamey skin":
					ch.change(config.jamey);
				case "catgirl gf skin":
					ch.change(config.catgirl);
				case "hitsounds":
					ch.change(config.hitsounds);
				case "pause button":
					//nothing yet
			}

			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		var noticebg = new FlxSprite(0, FlxG.height - 56).makeGraphic(FlxG.width, 30, FlxColor.BLACK);
		noticebg.alpha = 0.25;


		notice = new FlxText(0, 0, 0,"Cam Speed: " + MusicBeatState.camMove + "Press LEFT or RIGHT to change values\n", 24);

		notice2 = new FlxText(0, 0, 0,"sus uwu", 24);

		if (cleanfont_isenabled)
		{
			//notice.x = (FlxG.width / 2) - (notice.width / 2);
			notice.setFormat(Paths.font("coolvetica.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);				notice.screenCenter();
			//notice.y = FlxG.height - 56;
			notice.y = FlxG.height - 666;
			notice.alpha = 0.6;
			add(notice);
	 
			//notice.x = (FlxG.width / 2) - (notice.width / 2);
			notice2.setFormat(Paths.font("coolvetica.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			notice2.screenCenter();
			notice2.x = 0;
			notice2.y = FlxG.height - 56;
			notice2.alpha = 1;
			add(noticebg);    
			add(notice2);
		}
		else
		{
			//notice.x = (FlxG.width / 2) - (notice.width / 2);
			notice.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);				notice.screenCenter();
			//notice.y = FlxG.height - 56;
			notice.y = FlxG.height - 666;
			notice.alpha = 0.6;
			add(notice);
	 
			//notice.x = (FlxG.width / 2) - (notice.width / 2);
			notice2.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			notice2.screenCenter();
			notice2.x = 0;
			notice2.y = FlxG.height - 56;
			notice2.alpha = 1;
			add(noticebg);    
			add(notice2);
		}

		changeSelection();

    }

    override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.RIGHT) {
		    MusicBeatState.camMove = floatToStringPrecision(Math.abs(MusicBeatState.camMove + 0.01), 2);
		    config.camSave(MusicBeatState.camMove);
		}
		if (controls.LEFT) {
		    MusicBeatState.camMove = floatToStringPrecision(Math.abs(MusicBeatState.camMove - 0.01), 2);
		    config.camSave(MusicBeatState.camMove);
		}

		notice.text = "Cam Speed: " + MusicBeatState.camMove + "Press LEFT or RIGHT to change values\n";

        for (i in 0...checkboxGroup.length)
        {
            checkboxGroup.members[i].x = grptext.members[i].x + grptext.members[i].width + 10;
            checkboxGroup.members[i].y = grptext.members[i].y - 20;
        } 

		if (controls.ACCEPT)
		{
			var daSelected:String = menuItems[curSelected];

            trace(curSelected);

			switch (daSelected)
			{
				case "downscroll":
					config.downscroll = checkboxGroup.members[curSelected].change();
				case "middlescroll":
					config.middlescroll = checkboxGroup.members[curSelected].change();
				case "ghost tapping":
					config.ghosttap = checkboxGroup.members[curSelected].change();
				case "practice":
					config.practice = checkboxGroup.members[curSelected].change();
				//case "panorama menu":
					//config.panorama = checkboxGroup.members[curSelected].change();
				case "no mods":
					config.nomods = checkboxGroup.members[curSelected].change();
				case "no flashing":
					config.noflashing = checkboxGroup.members[curSelected].change();
				case "no hud":
					config.nohud = checkboxGroup.members[curSelected].change();
				case "camzoom out":
					config.zoomout = checkboxGroup.members[curSelected].change();
				case "notesplash":
					config.splash = checkboxGroup.members[curSelected].change();
				case "light cpu strums":
					config.cpustrums = checkboxGroup.members[curSelected].change();
				case "progress bar":
					config.timebar = checkboxGroup.members[curSelected].change();
				case "clean font":
					config.cleanfont = checkboxGroup.members[curSelected].change();
				case "wyx remixes":
					config.wyx = checkboxGroup.members[curSelected].change();
				case "jamey skin":
					config.jamey = checkboxGroup.members[curSelected].change();
				case "catgirl gf skin":
					config.catgirl = checkboxGroup.members[curSelected].change();
				case "hitsounds":
					config.hitsounds = checkboxGroup.members[curSelected].change();
			}
		}

		if (controls.BACK #if android || FlxG.android.justReleased.BACK #end) {
			FlxG.switchState(new OptionsMenu());
		}

		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);

	}

    function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grptext.length - 1;
		if (curSelected >= grptext.length)
			curSelected = 0;

		var daSelected:String = menuItems[curSelected];

            trace(curSelected);

			switch(menuItems[curSelected]) {
					case 'downscroll':
						notice2.text = "If checked, notes go down instead of up, simple enough.";
					case 'middlescroll':
						notice2.text = "If checked, notes will be on the middle of the screen";
					case 'ghost tapping':
						notice2.text = "If checked, tapping a direction won't give you a miss.";
					case 'practice':
						notice2.text = "If checked, you will never lose health, for practicing purposes.";
					//case 'panorama menu':
						//notice2.text = "If checked, the menu will have a panorama-type look to it, still a W.I.P.";
					case 'no mods':
						notice2.text = "If checked, there will be no mods in-game, mostly on the menus.";
					case 'no flashing':
						notice2.text = "If checked, there will be no flashing lights on the menus.";
					case 'no hud':
						notice2.text = "If checked, there will be no hud during gameplay.";
					case 'camzoom out':
						notice2.text = "If checked, the camera will be zoomed out during gameplay.";
					case 'notesplash':
						notice2.text = "If checked, particles will pop up if you hit a sick.";
					case 'light cpu strums':
						notice2.text = "If checked, the enemy's strums will light up when they hit a note.";
					case 'progress bar':
						notice2.text = "If checked, a progress bar will be on the screen.";
					case 'clean font':
						notice2.text = "If checked, fonts will become quite smooth and clean like not pixelated.";
					case 'wyx remixes':
						notice2.text = "If checked, only wyxos' remixes will be on freeplay and story mode.";
					case 'jamey skin':
						notice2.text = "If checked, boyfriend will become jamey, a bf recolor made by Poyo.";
					case 'catgirl gf skin':
						notice2.text = "If checked, girlfriend will become a catgirl.";
					case 'hitsounds':
						notice2.text = "If checked, a sound will play when u hit a note.";
					case 'pause button':
						notice2.text = "If checked, a pause button will show up during gameplay.";
					/*case 'always show easter eggs':
						notice2.text = "If checked, every easter egg will 100% show up everytime.";*/
			}

		var bullShit:Int = 0;

		for (item in grptext.members)
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

	// code from here https://stackoverflow.com/questions/23689001/how-to-reliably-format-a-floating-point-number-to-a-specified-number-of-decimal
	public static function floatToStringPrecision(n:Float, prec:Int){
		n = Math.round(n * Math.pow(10, prec));
		var str = ''+n;
		var len = str.length;
		if(len <= prec){
		  while(len < prec){
			str = '0'+str;
			len++;
		  }
		  return Std.parseFloat('0.'+str);
		}
		else{
		  return Std.parseFloat(str.substr(0, str.length-prec) + '.'+str.substr(str.length-prec));
		}
	  }
}