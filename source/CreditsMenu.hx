package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import ui.FlxVirtualPad;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;

class CreditsMenu extends MusicBeatState
{
    var textMenuItems:Array<String> = ['Just Maddie', 'Poyo', 'Wyxos', 'Xinox', 'Luckydog7', 'ZacksGamerz', 'ShadowMario', 'Kade Dev', 'Tr1NgleBoss'];
    var textMenuItemsOG:Array<String> = ['Just Maddie', 'Poyo', 'Wyxos', 'Xinox', 'Luckydog7', 'ZacksGamerz', 'ShadowMario', 'Kade Dev', 'Tr1NgleBoss'];
    var deadMenuItems:Array<String> = ['DEAD0', 'DEAD1', 'DEAD2', 'DEAD3', 'DEAD4', 'DEAD5', 'DEAD6', 'DEAD7', 'DEAD8'];
    var secretItems:Array<String> = ['Just Maddie', 'Poyo', 'Wyxos', 'Xinox', 'Luckydog7', 'ZacksGamerz', 'ShadowMario', 'Kade Dev', 'Tr1NgleBoss', 'RUN AWAY'];

    private var desc:FlxText;
    var txt:FlxText;
    var optionText:FlxText;
    var deadText:FlxText;

    //var selector:FlxSprite;
    var selector:FlxText;
	var curSelected:Int = 0;

    var lineidk:FlxSprite;
    var logobg:FlxSprite;
    var logobgred:FlxSprite;
    var lelogo:FlxSprite;
    var menuBG:FlxSprite;

    var grpOptionsTexts:FlxTypedGroup<FlxText>;

    var cleanfont_isenabled:Bool = false;
    public static var step1:Bool = false;
    public static var step2:Bool = false;
    public static var step3:Bool = false;
    public static var step4:Bool = false;

    public static var deadstep1:Bool = false;
    public static var deadstep2:Bool = false;
    public static var deadstep3:Bool = false;
    public static var deadstep4:Bool = false;
    
    public static var trapped:Bool = false;
    private var shakeCam:Bool = false;

    override function create()
    {   
        if (trapped)
        {
            new FlxTimer().start(48, function(tmr:FlxTimer)
            {
                PlayState.SONG = Song.loadFromJson('toolate-hard','toolate'.toLowerCase());
                LoadingState.loadAndSwitchState(new PlayState());
            });
        }
        
        if (step4)
        {
            textMenuItems = secretItems;
        }

        menuBG = new FlxSprite().loadGraphic(Paths.image('stageback', 'shared'));
	    menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 0.8));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
        menuBG.alpha = 1;
		add(menuBG);
        add(logobg);
        add(lineidk); 
        add(lelogo);
        add(desc);
        add(grpOptionsTexts);
        add(selector);

        if (trapped)
        {
            textMenuItems = deadMenuItems;
            regenMenu();
            shakeCam = true;
            logobg.alpha = 0;
            lineidk.alpha = 0;
            lelogo.color = FlxColor.RED;
            add(logobgred);
        }

        cleanfont_isenabled = config.getcleanfont();

        super.create();

        if (cleanfont_isenabled)
        {
            desc.setFormat(Paths.font("coolvetica.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
            desc.screenCenter();
            desc.x = 0;
            desc.y = FlxG.height - 56;
            desc.alpha = 1;
        }
        else 
        {
            desc.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
            desc.screenCenter();
            desc.x = 0;
            desc.y = FlxG.height - 56;
            desc.alpha = 1;
        }
    }

	public function new()
	{
        super();

        desc = new FlxText(0, 0, 0,"Just Maddie, Current Owner And Coder of the Light Engine.", 24);

		grpOptionsTexts = new FlxTypedGroup<FlxText>();

        lineidk = new FlxSprite().makeGraphic(5, 1000);
        lineidk.screenCenter();

        logobg = new FlxSprite(640, 0).makeGraphic(1000, 1000, FlxColor.CYAN);
        logobg.alpha = 0.5;

        logobgred = new FlxSprite(0, 0).makeGraphic(2000, 2000, FlxColor.RED);
        logobgred.alpha = 0.4;

        lelogo = new FlxSprite(500, 0);
		lelogo.frames = Paths.getSparrowAtlas('lelogoV2');
		lelogo.antialiasing = true;
	    lelogo.animation.addByPrefix('bump', 'logo bumpin', 24);
		lelogo.animation.play('bump');
        lelogo.screenCenter(X);
		lelogo.updateHitbox();

        if (trapped)
        {
            //selector = new FlxSprite(0, 25).makeGraphic(15, 15, FlxColor.BLUE);
            selector = new FlxText(0, 25, ">");
            selector.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
            selector.color = FlxColor.RED;
        }
        else
        {
            //selector = new FlxSprite(0, 25).makeGraphic(15, 15, FlxColor.BLUE);
            selector = new FlxText(0, 25, ">");
            selector.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
            selector.color = FlxColor.CYAN;

        }

		for (i in 0...textMenuItems.length)
		{
			optionText = new FlxText(20, 20 + (i * 50), 0, textMenuItems[i], 32);
            //optionText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			optionText.ID = i;
			grpOptionsTexts.add(optionText);
        }

    }

    override function update(elapsed:Float)
    {
		if (shakeCam)
        {
            FlxG.camera.shake(0.02, 0.02);
        }

        super.update(elapsed);

        if (controls.BACK #if android || FlxG.android.justReleased.BACK #end) {
            if (trapped)
            {
                // NOTHING LMFAO
            }
            if (step4)       
            {
                FlxG.switchState(new OptionsMenu());
            }        
            else
            {
                FlxG.switchState(new OptionsMenu());
                step1 = false;
                step2 = false;
                step3 = false;
                step4 = false;
            }
		}
        
        if (controls.UP_P)
            changeSelection(-1);
    
        if (controls.DOWN_P)
            changeSelection(1);

        grpOptionsTexts.forEach(function(txt:FlxText)
        {
            txt.color = FlxColor.WHITE;
    
            if (trapped)
            {
                if (txt.ID == curSelected)
                    txt.color = FlxColor.RED;
            }
            else
            {
                if (txt.ID == curSelected)
                    txt.color = FlxColor.CYAN;
            }
        });
    
        if (controls.ACCEPT)
        {
            FlxG.sound.play(Paths.sound('confirmMenu'));
            switch (textMenuItems[curSelected])
            {
                case "Just Maddie":
                    FlxG.openURL("www.youtube.com/c/JustMaddieBaddie");
                    step1 = true;
                case "Poyo":
                    FlxG.openURL("https://www.youtube.com/channel/UCRB_pRbpYPjrUpnQyPUVG5w");
                    if (step1)
                    {
                        step2 = true;
                    }
                case "Wyxos":
                    FlxG.openURL("https://youtube.com/c/Wyxos");
                    if (step2)
                    {
                        step3 = true;
                    }
                case "Xinox":
                    FlxG.openURL("https://www.youtube.com/channel/UCvvHeK6_QrXFhWaXT8jONGw");
                    step1 = false;
                    step2 = false;
                    step3 = false;
                    step4 = false;
                case "Luckydog7":
                    FlxG.openURL("https://www.youtube.com/channel/UCeHXKGpDKo2eqYKVkqCUdaA");
                    step1 = false;
                    step2 = false;
                    step3 = false;
                    step4 = false;
                case "ZacksGamerz":
                    FlxG.openURL("https://www.youtube.com/channel/UCbWNOpUvvruwi3pbYVC_yWQ");
                    step1 = false;
                    step2 = false;
                    step3 = false;
                    step4 = false;
                case "ShadowMario":
                    FlxG.openURL("https://www.youtube.com/channel/UCpWQtkY8Ps1uDsU_Py8WANw");
                    step1 = false;
                    step2 = false;
                    step3 = false;
                    step4 = false;
                case "Kade Dev":
                    FlxG.openURL("https://www.youtube.com/channel/UCoYksltIxNuSHz_ERzoRP6g");
                    if (step3)
                    {
                        step4 = true;
                    }
                case "Tr1NgleBoss":
                    FlxG.openURL("https://www.youtube.com/channel/UCBYzkyK0aYiyX47rAMKZswA");
                    step1 = false;
                    step2 = false;
                    step3 = false;
                    step4 = false;
                case "RUN AWAY":
                    FlxG.switchState(new WarningState());
                    step1 = false;
                    step2 = false;
                    step3 = false;
                    step4 = false;
                    trapped = true;
                case "DEAD0":
                    FlxG.openURL("https://www.youtube.com/channel/666");
                    if (deadstep3)
                    {
                        deadstep4 = true;
                    }
                    if (deadstep4)
                    {
                        FlxG.switchState(new ToBeContinuedState());
                    }
                case "DEAD1":
                    FlxG.openURL("https://www.youtube.com/channel/666");
                    if (deadstep2)
                    {
                        deadstep3 = true;
                    }
                case "DEAD2":
                    FlxG.openURL("https://www.youtube.com/channel/666");
                    if (deadstep1)
                    {
                        deadstep2 = true;
                    }
                case "DEAD3":
                    FlxG.openURL("https://www.youtube.com/channel/666");
                    deadstep1 = false;
                    deadstep2 = false;
                    deadstep3 = false;
                    deadstep4 = false;
                case "DEAD4":
                    FlxG.openURL("https://www.youtube.com/channel/666");
                    deadstep1 = false;
                    deadstep2 = false;
                    deadstep3 = false;
                    deadstep4 = false;
                case "DEAD5":
                    FlxG.openURL("https://www.youtube.com/channel/666");
                    deadstep1 = false;
                    deadstep2 = false;
                    deadstep3 = false;
                    deadstep4 = false;
                case "DEAD6":
                    FlxG.openURL("https://www.youtube.com/channel/666");
                    deadstep1 = false;
                    deadstep2 = false;
                    deadstep3 = false;
                    deadstep4 = false;
                case "DEAD7":
                    FlxG.openURL("https://www.youtube.com/channel/666");
                    deadstep1 = true;
                case "DEAD8":
                    FlxG.openURL("https://www.youtube.com/channel/666");
                    deadstep1 = false;
                    deadstep2 = false;
                    deadstep3 = false;
                    deadstep4 = false;
            }
        }
    }

    function changeSelection(change:Int = 0)
    {
        FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

        curSelected += change;

		if (curSelected < 0)
			curSelected =  textMenuItems.length - 1;
		if (curSelected >= textMenuItems.length)
			curSelected = 0;

        selector.y = (50 * curSelected) + 30;

		var daSelected:String = textMenuItems[curSelected];

            trace(curSelected);

        switch(textMenuItems[curSelected]) {
            case 'Just Maddie':
                desc.text = "Maddie, The Current owner and a Coder of the Light Engine.";
            case 'Poyo':
                desc.text = "Poyo, Co owner and a Coder of the Light Engine.";
            case 'Wyxos':
                desc.text = "Wyxos, The Creator and Former owner of the Light Engine.";
            case 'Xinox':
                desc.text = "Xinox, A Friend and the one who made the new Logo.";
            case 'Luckydog7':
                desc.text = "Luckydog7, The one who Ported FNF to Android devices and made the Options Menu code.";
            case 'ZacksGamerz':
                desc.text = "ZacksGamerz, The one who made the Input and Middlescroll code.";
            case 'ShadowMario':
                desc.text = "ShadowMario, The one who made the Downscroll and Progress Bar code.";
            case 'Kade Dev':
                desc.text = "Kade Dev, The one who made the Note Glow/Light CPU Strums code.";
            case 'Tr1NgleBoss':
                desc.text = "Tr1NgleBoss, The one who Re-coded Week 7.";
            case 'RUN AWAY':
                desc.text = "Why have you come here.";
            case 'DEAD0':
                desc.text = "666\n666\n666";
            case 'DEAD1':
                desc.text = "666\n666\n666"; 
            case 'DEAD2':
                desc.text = "666\n666\n666";
            case 'DEAD3':
                desc.text = "666\n666\n666";
            case 'DEAD4':
                desc.text = "666\n666\n666"; 
            case 'DEAD5':
                desc.text = "666\n666\n666";
            case 'DEAD6':
                desc.text = "666\n666\n666";
            case 'DEAD7':
                desc.text = "666\n666\n666";
            case 'DEAD8':
                desc.text = "666\n666\n666";
        }
    }

    function regenMenu():Void {
		for (i in 0...grpOptionsTexts.members.length) {
			this.grpOptionsTexts.remove(this.grpOptionsTexts.members[0], true);
		}
		for (i in 0...textMenuItems.length) {
            optionText = new FlxText(20, 20 + (i * 50), 0, textMenuItems[i], 32);
            //optionText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			optionText.ID = i;
			grpOptionsTexts.add(optionText);
		}
		curSelected = 0;
		changeSelection();
	}
}