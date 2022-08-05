package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

//#if mobile
import mobilecontrols.Mobilecontrols;
import ui.FlxVirtualPad;
//#end

/**
	*DEBUG MODE
 */
class AnimationDebug extends FlxState
{
	var bf:Boyfriend;
	var dad:Character;
	var char:Character;
	var textAnim:FlxText;
	var dumbTexts:FlxTypedGroup<FlxText>;
	var animList:Array<String> = [];
	var curAnim:Int = 0;
	var isDad:Bool = true;
	var daAnim:String = 'spooky';
	var camFollow:FlxObject;

	//#if mobile
	var mcontrols:Mobilecontrols; 
	var _pad:FlxVirtualPad;
	//#end

	var controls:Controls;

	public function new(daAnim:String = 'spooky')
	{
		super();
		this.daAnim = daAnim;
	}

	override function create()
	{
		FlxG.sound.music.stop();

		var gridBG:FlxSprite = FlxGridOverlay.create(10, 10);
		gridBG.scrollFactor.set(0.5, 0.5);
		add(gridBG);

		if (daAnim == 'bf')
			isDad = false;

		if (isDad)
		{
			dad = new Character(0, 0, daAnim);
			dad.screenCenter();
			dad.debugMode = true;
			add(dad);

			char = dad;
			dad.flipX = false;
		}
		else
		{
			bf = new Boyfriend(0, 0);
			bf.screenCenter();
			bf.debugMode = true;
			add(bf);

			char = bf;
			bf.flipX = false;
		}

		dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);

		textAnim = new FlxText(300, 16);
		textAnim.size = 26;
		textAnim.scrollFactor.set();
		add(textAnim);

		genBoyOffsets();

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow);

		super.create();

		//#if mobile
		mcontrols = new Mobilecontrols();
		add(mcontrols);
		_pad = new FlxVirtualPad(UP_DOWN, B);
		_pad.alpha = 0.75;
		this.add(_pad);
		//#end
	}

	function genBoyOffsets(pushList:Bool = true):Void
	{
		var daLoop:Int = 0;

		for (anim => offsets in char.animOffsets)
		{
			var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, anim + ": " + offsets, 15);
			text.scrollFactor.set();
			text.color = FlxColor.BLUE;
			dumbTexts.add(text);

			if (pushList)
				animList.push(anim);

			daLoop++;
		}
	}

	function updateTexts():Void
	{
		dumbTexts.forEach(function(text:FlxText)
		{
			text.kill();
			dumbTexts.remove(text, true);
		});
	}

	override function update(elapsed:Float)
	{
		var UP_P = _pad.buttonUp.justPressed;
		var DOWN_P = _pad.buttonDown.justPressed;
		var BACK = _pad.buttonB.justPressed;
		textAnim.text = char.animation.curAnim.name;

		if (FlxG.keys.justPressed.E)
			FlxG.camera.zoom += 0.25;
		if (FlxG.keys.justPressed.Q)
			FlxG.camera.zoom -= 0.25;

		if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L)
		{
			if (FlxG.keys.pressed.I)
				camFollow.velocity.y = -90;
			else if (FlxG.keys.pressed.K)
				camFollow.velocity.y = 90;
			else
				camFollow.velocity.y = 0;

			if (FlxG.keys.pressed.J)
				camFollow.velocity.x = -90;
			else if (FlxG.keys.pressed.L)
				camFollow.velocity.x = 90;
			else
				camFollow.velocity.x = 0;
		}
		else
		{
			camFollow.velocity.set();
		}

		if (FlxG.keys.justPressed.W || UP_P)
		{
			curAnim -= 1;
		}

		if (FlxG.keys.justPressed.S || DOWN_P)
		{
			curAnim += 1;
		}
		
		if (BACK)
		{
			FlxG.switchState(new PlayState());
		}
		

		if (curAnim < 0)
			curAnim = animList.length - 1;

		if (curAnim >= animList.length)
			curAnim = 0;

		if (FlxG.keys.justPressed.S || DOWN_P || FlxG.keys.justPressed.W || UP_P || FlxG.keys.justPressed.SPACE)
		{
			char.playAnim(animList[curAnim]);

			updateTexts();
			genBoyOffsets(false);
		}

		//#if mobile

		var upPlol = mcontrols.UP_P;
		var rightPlol = mcontrols.RIGHT_P;
		var downPlol = mcontrols.DOWN_P;
		var leftPlol = mcontrols.LEFT_P;

		var upP = FlxG.keys.anyJustPressed([UP]);
		var rightP = FlxG.keys.anyJustPressed([RIGHT]);
		var downP = FlxG.keys.anyJustPressed([DOWN]);
		var leftP = FlxG.keys.anyJustPressed([LEFT]);

		var holdShift = FlxG.keys.pressed.SHIFT;
		var multiplier = 1;
		if (holdShift)
			multiplier = 10;

		if (upP || upPlol || rightP || rightPlol || downP || downPlol || leftP || leftPlol)
		{
			updateTexts();
			if (upP || upPlol)
				char.animOffsets.get(animList[curAnim])[1] += 1 * multiplier;
			if (downP || downPlol)
				char.animOffsets.get(animList[curAnim])[1] -= 1 * multiplier;
			if (leftP || leftPlol)
				char.animOffsets.get(animList[curAnim])[0] += 1 * multiplier;
			if (rightP || rightPlol)
				char.animOffsets.get(animList[curAnim])[0] -= 1 * multiplier;

			updateTexts();
			genBoyOffsets(false);
			char.playAnim(animList[curAnim]);
		}

		super.update(elapsed);
	}
}
