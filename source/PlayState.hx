package;

#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import ui.FlxVirtualPad;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	var halloweenLevel:Bool = false;

	private var vocals:FlxSound;

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;
	private var SplashNote:NoteSplash;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	public static var instance:PlayState;

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;
	private var misses:Int = 0;
	private var shits:Int = 0;
	private var bads:Int = 0;
	private var goods:Int = 0;
	private var sicks:Int = 0;
	private var notehit:Int = 0;
	private var enemyhit:Int = 0;
	private var accuracy:Float = 0.00;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	var songPercent:Float = 0;

	private var timeBarBG:FlxSprite;
	private var timeBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;
	public static var changedDifficulty:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	public static var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var grpNoteSplashes:FlxTypedGroup<NoteSplash>;
	var fastCar:FlxSprite;
	var noteSplashOp:Bool; //chadbross is cool
	var cutsceneOp:Bool;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var timeTxt:FlxText;

	var scoreTxt:FlxText;
	var missesTxt:FlxText;
	var accuracyTxt:FlxText;
	var rateTxt:FlxText;
	var songTxt:FlxText;
	var diffTxt:FlxText;

	//tankStages Parts

	var tank0:FlxSprite;
	var tank1:FlxSprite;
	var tank2:FlxSprite;
	var tank3:FlxSprite;
	var tank4:FlxSprite;
	var tank5:FlxSprite;
	var tankRolling:FlxSprite;
	var tankX:Int = 400;
	var tankSpeed:Float = FlxG.random.float(5, 7);
	var tankAngle:Float = FlxG.random.float(-90, 45);
	var tankWatchtower:FlxSprite;
	var tankmanRun:FlxTypedGroup<TankmenBG>;

	// wity bg lol

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var wBg:FlxSprite;
	var nwBg:FlxSprite;
	var wstageFront:FlxSprite;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	var inCutscene:Bool = false;

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	var songLength:Float = 0;

	var downscroll_isenabled:Bool = false;
	var middlescroll_isenabled:Bool = false;
	var ghosttap_isenabled:Bool = false;
	var practice_isenabled:Bool = false;
	var splash_isenabled:Bool = false;
	var cpustrums_isenabled:Bool = false;
	var timebar_isenabled:Bool = false;
	var cleanfont_isenabled:Bool = false;
	var nohud_isenabled:Bool = false;
	var zoomout_isenabled:Bool = false;
	var hitsounds_isenabled:Bool = false;

	override public function create()
	{
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		instance = this;

		// part of mobile controls in 750 line
		// get downscroll settings
		downscroll_isenabled = config.getdownscroll();
		middlescroll_isenabled = config.getmiddlescroll();
		ghosttap_isenabled = config.getghosttap();
		practice_isenabled = config.getpractice();
		splash_isenabled = config.getsplash();
		cpustrums_isenabled = config.getcpustrums();
		timebar_isenabled = config.gettimebar();
		cleanfont_isenabled = config.getcleanfont();
		nohud_isenabled = config.getnohud();
		zoomout_isenabled = config.getzoomout();
		hitsounds_isenabled = config.gethitsounds();

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		if (nohud_isenabled)
		{
			// idk but works ig
			FlxG.cameras.reset(camGame);
			FlxG.cameras.add(camHUD);
			camHUD.alpha = 0;
		}
		else
		{
			FlxG.cameras.reset(camGame);
			FlxG.cameras.add(camHUD);
		}

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();
		var sploosh = new NoteSplash(100, 100, 0);
		sploosh.alpha = 0.6;
		grpNoteSplashes.add(sploosh);

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dadbattle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
			case 'headache':
				dialogue = CoolUtil.coolTextFile(Paths.txt('headache/headacheDialogue'));
			case 'nerves':
				dialogue = CoolUtil.coolTextFile(Paths.txt('nerves/nervesDialogue'));
			case 'release':
				dialogue = CoolUtil.coolTextFile(Paths.txt('release/releaseDialogue'));
			case 'fading':
				dialogue = CoolUtil.coolTextFile(Paths.txt('fading/fadingDialogue'));
			case 'lo-fight':
				dialogue = CoolUtil.coolTextFile(Paths.txt('lo-fight/pleaseSubscribe'));
			case 'overhead':
				dialogue = CoolUtil.coolTextFile(Paths.txt('overhead/pleaseSubscribe'));
		}


		#if desktop
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		#end

		switch (SONG.song.toLowerCase())
		{
                        case 'spookeez' | 'monster' | 'south': 
                        {
                                curStage = 'spooky';
	                          halloweenLevel = true;

							  if (zoomout_isenabled)
								{
									defaultCamZoom = 0.5;
								}
								else
								{
									defaultCamZoom = 1.05;
								}	

		                  var hallowTex = Paths.getSparrowAtlas('halloween_bg');

	                          halloweenBG = new FlxSprite(-200, -100);
		                  halloweenBG.frames = hallowTex;
	                          halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
	                          halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
	                          halloweenBG.animation.play('idle');
	                          halloweenBG.antialiasing = true;
	                          add(halloweenBG);

		                  isHalloween = true;
		          }
		          case 'pico' | 'blammed' | 'philly': 
                        {
		                  curStage = 'philly';

						  if (zoomout_isenabled)
							{
								defaultCamZoom = 0.5;
							}
							else
							{
								defaultCamZoom = 1.05;
							}

		                  var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky'));
		                  bg.scrollFactor.set(0.1, 0.1);
		                  add(bg);

	                          var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city'));
		                  city.scrollFactor.set(0.3, 0.3);
		                  city.setGraphicSize(Std.int(city.width * 0.85));
		                  city.updateHitbox();
		                  add(city);

		                  phillyCityLights = new FlxTypedGroup<FlxSprite>();
		                  add(phillyCityLights);

		                  for (i in 0...5)
		                  {
		                          var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i));
		                          light.scrollFactor.set(0.3, 0.3);
		                          light.visible = false;
		                          light.setGraphicSize(Std.int(light.width * 0.85));
		                          light.updateHitbox();
		                          light.antialiasing = true;
		                          phillyCityLights.add(light);
		                  }

		                  var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain'));
		                  add(streetBehind);

	                          phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train'));
		                  add(phillyTrain);

		                  trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
		                  FlxG.sound.list.add(trainSound);

		                  // var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

		                  var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street'));
	                          add(street);
		          }
		          case 'milf' | 'satin-panties' | 'high':
		          {
		                  curStage = 'limo';
						  if (zoomout_isenabled)
							{
								defaultCamZoom = 0.5;
							}
							else
							{
								defaultCamZoom = 0.90;
							}

		                  var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset'));
		                  skyBG.scrollFactor.set(0.1, 0.1);
		                  add(skyBG);

		                  var bgLimo:FlxSprite = new FlxSprite(-200, 480);
		                  bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo');
		                  bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
		                  bgLimo.animation.play('drive');
		                  bgLimo.scrollFactor.set(0.4, 0.4);
		                  add(bgLimo);

		                  grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
		                  add(grpLimoDancers);

		                  for (i in 0...5)
		                  {
		                          var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
		                          dancer.scrollFactor.set(0.4, 0.4);
		                          grpLimoDancers.add(dancer);
		                  }

		                  var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay'));
		                  overlayShit.alpha = 0.5;
		                  // add(overlayShit);

		                  // var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

		                  // FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

		                  // overlayShit.shader = shaderBullshit;

		                  var limoTex = Paths.getSparrowAtlas('limo/limoDrive');

		                  limo = new FlxSprite(-120, 550);
		                  limo.frames = limoTex;
		                  limo.animation.addByPrefix('drive', "Limo stage", 24);
		                  limo.animation.play('drive');
		                  limo.antialiasing = true;

		                  fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol'));
		                  // add(limo);
		          }
		          case 'cocoa' | 'eggnog':
		          {
	                          curStage = 'mall';

						  if (zoomout_isenabled)
							{
								defaultCamZoom = 0.5;
							}
							else
							{
								defaultCamZoom = 0.80;
							}

		                  var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls'));
		                  bg.antialiasing = true;
		                  bg.scrollFactor.set(0.2, 0.2);
		                  bg.active = false;
		                  bg.setGraphicSize(Std.int(bg.width * 0.8));
		                  bg.updateHitbox();
		                  add(bg);

		                  upperBoppers = new FlxSprite(-240, -90);
		                  upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop');
		                  upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
		                  upperBoppers.antialiasing = true;
		                  upperBoppers.scrollFactor.set(0.33, 0.33);
		                  upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
		                  upperBoppers.updateHitbox();
		                  add(upperBoppers);

		                  var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator'));
		                  bgEscalator.antialiasing = true;
		                  bgEscalator.scrollFactor.set(0.3, 0.3);
		                  bgEscalator.active = false;
		                  bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
		                  bgEscalator.updateHitbox();
		                  add(bgEscalator);

		                  var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree'));
		                  tree.antialiasing = true;
		                  tree.scrollFactor.set(0.40, 0.40);
		                  add(tree);

		                  bottomBoppers = new FlxSprite(-300, 140);
		                  bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop');
		                  bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
		                  bottomBoppers.antialiasing = true;
	                          bottomBoppers.scrollFactor.set(0.9, 0.9);
	                          bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
		                  bottomBoppers.updateHitbox();
		                  add(bottomBoppers);

		                  var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow'));
		                  fgSnow.active = false;
		                  fgSnow.antialiasing = true;
		                  add(fgSnow);

		                  santa = new FlxSprite(-840, 150);
		                  santa.frames = Paths.getSparrowAtlas('christmas/santa');
		                  santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
		                  santa.antialiasing = true;
		                  add(santa);
		          }
		          case 'winter-horrorland':
		          {
		                  curStage = 'mallEvil';
		                  var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG'));
		                  bg.antialiasing = true;
		                  bg.scrollFactor.set(0.2, 0.2);
		                  bg.active = false;
		                  bg.setGraphicSize(Std.int(bg.width * 0.8));
		                  bg.updateHitbox();
		                  add(bg);

		                  var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree'));
		                  evilTree.antialiasing = true;
		                  evilTree.scrollFactor.set(0.2, 0.2);
		                  add(evilTree);

		                  var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow"));
	                          evilSnow.antialiasing = true;
		                  add(evilSnow);
                        }
		          case 'senpai' | 'roses':
		          {
		                  curStage = 'school';

						  if (zoomout_isenabled)
							{
								defaultCamZoom = 0.5;
							}
							else
							{
								defaultCamZoom = 0.9;
							}
		                  // defaultCamZoom = 0.9;

		                  var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky'));
		                  bgSky.scrollFactor.set(0.1, 0.1);
		                  add(bgSky);

		                  var repositionShit = -200;

		                  var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool'));
		                  bgSchool.scrollFactor.set(0.6, 0.90);
		                  add(bgSchool);

		                  var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet'));
		                  bgStreet.scrollFactor.set(0.95, 0.95);
		                  add(bgStreet);

		                  var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack'));
		                  fgTrees.scrollFactor.set(0.9, 0.9);
		                  add(fgTrees);

		                  var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
		                  var treetex = Paths.getPackerAtlas('weeb/weebTrees');
		                  bgTrees.frames = treetex;
		                  bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
		                  bgTrees.animation.play('treeLoop');
		                  bgTrees.scrollFactor.set(0.85, 0.85);
		                  add(bgTrees);

		                  var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
		                  treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals');
		                  treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
		                  treeLeaves.animation.play('leaves');
		                  treeLeaves.scrollFactor.set(0.85, 0.85);
		                  add(treeLeaves);

		                  var widShit = Std.int(bgSky.width * 6);

		                  bgSky.setGraphicSize(widShit);
		                  bgSchool.setGraphicSize(widShit);
		                  bgStreet.setGraphicSize(widShit);
		                  bgTrees.setGraphicSize(Std.int(widShit * 1.4));
		                  fgTrees.setGraphicSize(Std.int(widShit * 0.8));
		                  treeLeaves.setGraphicSize(widShit);

		                  fgTrees.updateHitbox();
		                  bgSky.updateHitbox();
		                  bgSchool.updateHitbox();
		                  bgStreet.updateHitbox();
		                  bgTrees.updateHitbox();
		                  treeLeaves.updateHitbox();

		                  bgGirls = new BackgroundGirls(-100, 190);
		                  bgGirls.scrollFactor.set(0.9, 0.9);

		                  if (SONG.song.toLowerCase() == 'roses')
	                          {
		                          bgGirls.getScared();
		                  }

		                  bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
		                  bgGirls.updateHitbox();
		                  add(bgGirls);
		          }
		          case 'thorns':
		          {
		                  curStage = 'schoolEvil';

						  if (zoomout_isenabled)
							{
								defaultCamZoom = 0.5;
							}
							else
							{
								defaultCamZoom = 1.05;
							}

		                  var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
		                  var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

		                  var posX = 400;
	                          var posY = 200;

		                  var bg:FlxSprite = new FlxSprite(posX, posY);
		                  bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool');
		                  bg.animation.addByPrefix('idle', 'background 2', 24);
		                  bg.animation.play('idle');
		                  bg.scrollFactor.set(0.8, 0.9);
		                  bg.scale.set(6, 6);
		                  add(bg);

		                  /* 
		                           var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
		                           bg.scale.set(6, 6);
		                           // bg.setGraphicSize(Std.int(bg.width * 6));
		                           // bg.updateHitbox();
		                           add(bg);

		                           var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
		                           fg.scale.set(6, 6);
		                           // fg.setGraphicSize(Std.int(fg.width * 6));
		                           // fg.updateHitbox();
		                           add(fg);

		                           wiggleShit.effectType = WiggleEffectType.DREAMY;
		                           wiggleShit.waveAmplitude = 0.01;
		                           wiggleShit.waveFrequency = 60;
		                           wiggleShit.waveSpeed = 0.8;
		                    */

		                  // bg.shader = wiggleShit.shader;
		                  // fg.shader = wiggleShit.shader;

		                  /* 
		                            var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
		                            var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);

		                            // Using scale since setGraphicSize() doesnt work???
		                            waveSprite.scale.set(6, 6);
		                            waveSpriteFG.scale.set(6, 6);
		                            waveSprite.setPosition(posX, posY);
		                            waveSpriteFG.setPosition(posX, posY);

		                            waveSprite.scrollFactor.set(0.7, 0.8);
		                            waveSpriteFG.scrollFactor.set(0.9, 0.8);

		                            // waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
		                            // waveSprite.updateHitbox();
		                            // waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
		                            // waveSpriteFG.updateHitbox();

		                            add(waveSprite);
		                            add(waveSpriteFG);
		                    */
		          }

				  case 'ugh' | 'guns': 
					{
					curStage = 'tankStage';
						if (zoomout_isenabled)
						{
							defaultCamZoom = 0.5;
						}
						else
						{
							defaultCamZoom = 0.9;
						}
					var bg:FlxSprite = new FlxSprite(-400,-400);
					bg.loadGraphic(Paths.image("tank/tankSky",'week7'));
					bg.scrollFactor.set(0, 0);
					bg.antialiasing = true;
					//bg.setGraphicSize(Std.int(bg.width * 1.5));
					add(bg);

					var clouds:FlxSprite = new FlxSprite(FlxG.random.int(-700, -100), FlxG.random.int(-20, 20)).loadGraphic(Paths.image('tank/tankClouds','week7'));
					clouds.scrollFactor.set(0.1, 0.1);
					clouds.velocity.x = FlxG.random.float(5, 15);
					clouds.antialiasing = true;
					clouds.updateHitbox();
					add(clouds);

					var mountains:FlxSprite = new FlxSprite(-300,-20).loadGraphic(Paths.image('tank/tankMountains','week7'));
					mountains.scrollFactor.set(0.2, 0.2);
					mountains.setGraphicSize(Std.int(1.2 * mountains.width));
					mountains.updateHitbox();
					mountains.antialiasing = true;
					add(mountains);

					var buildings:FlxSprite = new FlxSprite(-200,0).loadGraphic(Paths.image('tank/tankBuildings','week7'));
					buildings.scrollFactor.set(0.3, 0.3);
					buildings.setGraphicSize(Std.int(buildings.width * 1.1));
					buildings.updateHitbox();
					buildings.antialiasing = true;
					add(buildings);

					var ruins:FlxSprite = new FlxSprite(-200,0).loadGraphic(Paths.image('tank/tankRuins','week7'));
					ruins.scrollFactor.set(0.35, 0.35);
					ruins.setGraphicSize(Std.int(ruins.width * 1.1));
					ruins.updateHitbox();
					ruins.antialiasing = true;
					add(ruins);


					var smokeLeft:FlxSprite = new FlxSprite(-200,-100);
					smokeLeft.frames = Paths.getSparrowAtlas('tank/smokeLeft','week7');
					smokeLeft.animation.addByPrefix('idle', 'SmokeBlurLeft ', 24, true);
					smokeLeft.scrollFactor.set(0.4, 0.4);
					smokeLeft.antialiasing = true;
					smokeLeft.animation.play('idle');
					
					add(smokeLeft);

					var smokeRight:FlxSprite = new FlxSprite(1100,-100);
					smokeRight.frames = Paths.getSparrowAtlas('tank/smokeRight','week7');
					smokeRight.animation.addByPrefix('idle', 'SmokeRight ', 24, true);
					smokeRight.scrollFactor.set(0.4, 0.4);
					smokeRight.antialiasing = true;
					smokeRight.animation.play('idle');
					
					add(smokeRight);


					tankWatchtower = new FlxSprite(100,30);
					tankWatchtower.frames = Paths.getSparrowAtlas('tank/tankWatchtower','week7');
					tankWatchtower.animation.addByPrefix('idle', 'watchtower gradient color instance 1', 24, false);
					tankWatchtower.scrollFactor.set(0.5, 0.5);
					tankWatchtower.antialiasing = true;
					
					
					add(tankWatchtower);

					
					tankRolling = new FlxSprite(300,300);
					tankRolling.frames = Paths.getSparrowAtlas('tank/tankRolling','week7');
					tankRolling.animation.addByPrefix('idle', 'BG tank w lighting ', 24, true);
					tankRolling.scrollFactor.set(0.5, 0.5);
					tankRolling.antialiasing = true;
					tankRolling.animation.play('idle');
					
					add(tankRolling);

					

					var ground:FlxSprite = new FlxSprite(-420,-150).loadGraphic(Paths.image('tank/tankGround','week7'));
					ground.scrollFactor.set();
					ground.antialiasing = true;
					ground.setGraphicSize(Std.int(ground.width * 1.15));
					ground.scrollFactor.set(1, 1);
					
					ground.updateHitbox();
					add(ground);

					moveTank();

					tank0 = new FlxSprite(-500,650);
					tank0.frames = Paths.getSparrowAtlas('tank/tank0','week7');
					tank0.animation.addByPrefix('idle', 'fg tankhead far right ', 24, false);
					tank0.scrollFactor.set(1.7, 1.5);
					tank0.antialiasing = true;
					
					tank0.updateHitbox();
					
					
					


					tank1 = new FlxSprite(-300,750);
					tank1.frames = Paths.getSparrowAtlas('tank/tank1','week7');
					tank1.animation.addByPrefix('idle', 'fg tankhead 5 ', 24, false);
					tank1.scrollFactor.set(2.0, 0.2);
					tank1.antialiasing = true;
					
					tank1.updateHitbox();
					
					
					


					tank2 = new FlxSprite(450,940);
					tank2.frames = Paths.getSparrowAtlas('tank/tank2','week7');
					tank2.animation.addByPrefix('idle', 'foreground man 3 ', 24, false);
					tank2.scrollFactor.set(1.5, 1.5);
					tank2.antialiasing = true;
					
					tank2.updateHitbox();
					
					


					tank3 = new FlxSprite(1300,1200);
					tank3.frames = Paths.getSparrowAtlas('tank/tank3','week7');
					tank3.animation.addByPrefix('idle', 'fg tankhead 4 ', 24, false);
					tank3.scrollFactor.set(3.5, 2.5);
					tank3.antialiasing = true;
					
					tank3.updateHitbox();
					
					


					tank4 = new FlxSprite(1300,900);
					tank4.frames = Paths.getSparrowAtlas('tank/tank4','week7');
					tank4.animation.addByPrefix('idle', 'fg tankman bobbin 3 ', 24, false);
					tank4.scrollFactor.set(1.5, 1.5);
					tank4.antialiasing = true;
					
					tank4.updateHitbox();
					
					

					tank5 = new FlxSprite(1620,700);
					tank5.frames = Paths.getSparrowAtlas('tank/tank5','week7');
					tank5.animation.addByPrefix('idle', 'fg tankhead far right ', 24, false);
					tank5.scrollFactor.set(1.5, 1.5);
					tank5.antialiasing = true;
					
					tank5.updateHitbox();
					
					

					
			}

			case 'stress': 
					{
					curStage = 'tankStage2';
						if (zoomout_isenabled)
						{
							defaultCamZoom = 0.5;
						}
						else
						{
							defaultCamZoom = 0.9;
						}
					var bg:FlxSprite = new FlxSprite(-400,-400);
					bg.loadGraphic(Paths.image("tank/tankSky",'week7'));
					bg.scrollFactor.set(0, 0);
					bg.antialiasing = true;
					//bg.setGraphicSize(Std.int(bg.width * 1.5));
					add(bg);

					var clouds:FlxSprite = new FlxSprite(FlxG.random.int(-700, -100), FlxG.random.int(-20, 20)).loadGraphic(Paths.image('tank/tankClouds','week7'));
					clouds.scrollFactor.set(0.1, 0.1);
					clouds.velocity.x = FlxG.random.float(5, 15);
					clouds.antialiasing = true;
					clouds.updateHitbox();
					add(clouds);

					var mountains:FlxSprite = new FlxSprite(-300,-20).loadGraphic(Paths.image('tank/tankMountains','week7'));
					mountains.scrollFactor.set(0.2, 0.2);
					mountains.setGraphicSize(Std.int(1.2 * mountains.width));
					mountains.updateHitbox();
					mountains.antialiasing = true;
					add(mountains);

					var buildings:FlxSprite = new FlxSprite(-200,0).loadGraphic(Paths.image('tank/tankBuildings','week7'));
					buildings.scrollFactor.set(0.3, 0.3);
					buildings.setGraphicSize(Std.int(buildings.width * 1.1));
					buildings.updateHitbox();
					buildings.antialiasing = true;
					add(buildings);

					var ruins:FlxSprite = new FlxSprite(-200,0).loadGraphic(Paths.image('tank/tankRuins','week7'));
					ruins.scrollFactor.set(0.35, 0.35);
					ruins.setGraphicSize(Std.int(ruins.width * 1.1));
					ruins.updateHitbox();
					ruins.antialiasing = true;
					add(ruins);


					var smokeLeft:FlxSprite = new FlxSprite(-200,-100);
					smokeLeft.frames = Paths.getSparrowAtlas('tank/smokeLeft','week7');
					smokeLeft.animation.addByPrefix('idle', 'SmokeBlurLeft ', 24, true);
					smokeLeft.scrollFactor.set(0.4, 0.4);
					smokeLeft.antialiasing = true;
					smokeLeft.animation.play('idle');
					
					add(smokeLeft);

					var smokeRight:FlxSprite = new FlxSprite(1100,-100);
					smokeRight.frames = Paths.getSparrowAtlas('tank/smokeRight','week7');
					smokeRight.animation.addByPrefix('idle', 'SmokeRight ', 24, true);
					smokeRight.scrollFactor.set(0.4, 0.4);
					smokeRight.antialiasing = true;
					smokeRight.animation.play('idle');
					
					add(smokeRight);


					tankWatchtower = new FlxSprite(100,30);
					tankWatchtower.frames = Paths.getSparrowAtlas('tank/tankWatchtower','week7');
					tankWatchtower.animation.addByPrefix('idle', 'watchtower gradient color instance 1', 24, false);
					tankWatchtower.scrollFactor.set(0.5, 0.5);
					tankWatchtower.antialiasing = true;
					
					
					add(tankWatchtower);

					
					tankRolling = new FlxSprite(300,300);
					tankRolling.frames = Paths.getSparrowAtlas('tank/tankRolling','week7');
					tankRolling.animation.addByPrefix('idle', 'BG tank w lighting ', 24, true);
					tankRolling.scrollFactor.set(0.5, 0.5);
					tankRolling.antialiasing = true;
					tankRolling.animation.play('idle');
					
					add(tankRolling);
					tankmanRun = new FlxTypedGroup<TankmenBG>();
					add(tankmanRun);

					var ground:FlxSprite = new FlxSprite(-420,-150).loadGraphic(Paths.image('tank/tankGround','week7'));
					ground.scrollFactor.set();
					ground.antialiasing = true;
					ground.setGraphicSize(Std.int(ground.width * 1.15));
					ground.scrollFactor.set(1, 1);
					
					ground.updateHitbox();
					add(ground);

					moveTank();

					tank0 = new FlxSprite(-500,650);
					tank0.frames = Paths.getSparrowAtlas('tank/tank0','week7');
					tank0.animation.addByPrefix('idle', 'fg tankhead far right ', 24, false);
					tank0.scrollFactor.set(1.7, 1.5);
					tank0.antialiasing = true;
					
					tank0.updateHitbox();
					
					
					


					tank1 = new FlxSprite(-300,750);
					tank1.frames = Paths.getSparrowAtlas('tank/tank1','week7');
					tank1.animation.addByPrefix('idle', 'fg tankhead 5 ', 24, false);
					tank1.scrollFactor.set(2.0, 0.2);
					tank1.antialiasing = true;
					
					tank1.updateHitbox();
					
					
					


					tank2 = new FlxSprite(450,940);
					tank2.frames = Paths.getSparrowAtlas('tank/tank2','week7');
					tank2.animation.addByPrefix('idle', 'foreground man 3 ', 24, false);
					tank2.scrollFactor.set(1.5, 1.5);
					tank2.antialiasing = true;
					
					tank2.updateHitbox();
					
					


					tank3 = new FlxSprite(1300,1200);
					tank3.frames = Paths.getSparrowAtlas('tank/tank3','week7');
					tank3.animation.addByPrefix('idle', 'fg tankhead 4 ', 24, false);
					tank3.scrollFactor.set(3.5, 2.5);
					tank3.antialiasing = true;
					
					tank3.updateHitbox();
					
					


					tank4 = new FlxSprite(1300,900);
					tank4.frames = Paths.getSparrowAtlas('tank/tank4','week7');
					tank4.animation.addByPrefix('idle', 'fg tankman bobbin 3 ', 24, false);
					tank4.scrollFactor.set(1.5, 1.5);
					tank4.antialiasing = true;
					
					tank4.updateHitbox();
					
					

					tank5 = new FlxSprite(1620,700);
					tank5.frames = Paths.getSparrowAtlas('tank/tank5','week7');
					tank5.animation.addByPrefix('idle', 'fg tankhead far right ', 24, false);
					tank5.scrollFactor.set(1.5, 1.5);
					tank5.antialiasing = true;
					
					tank5.updateHitbox();
					
					
				  }
				  case 'dollhouse':
					{
							if (zoomout_isenabled)
							{
								defaultCamZoom = 0.5;
							}
							else
							{
								defaultCamZoom = 0.9;
							}
							curStage = 'stage';
							var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('sb/stageback','week8'));
							bg.antialiasing = true;
							bg.scrollFactor.set(0.9, 0.9);
							bg.active = false;
							add(bg);
		
							var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('sb/stagefront','week8'));
							stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
							stageFront.updateHitbox();
							stageFront.antialiasing = true;
							stageFront.scrollFactor.set(0.9, 0.9);
							stageFront.active = false;
							add(stageFront);
		
							var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('sb/stagecurtains','week8'));
							stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
							stageCurtains.updateHitbox();
							stageCurtains.antialiasing = true;
							stageCurtains.scrollFactor.set(1.3, 1.3);
							stageCurtains.active = false;
		
							add(stageCurtains);
							
							
					}
					
				case 'faraday':
					{
							if (zoomout_isenabled)
							{
								defaultCamZoom = 0.5;
							}
							else
							{
								defaultCamZoom = 0.9;
							}
							curStage = 'playground';
							var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('sb/playgroundBack','week8'));
							bg.antialiasing = true;
							bg.scrollFactor.set(0.9, 0.9);
							bg.active = false;
							add(bg);
		
							var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('sb/playgroundFront','week8'));
							stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
							stageFront.updateHitbox();
							stageFront.antialiasing = true;
							stageFront.scrollFactor.set(0.9, 0.9);
							stageFront.active = false;
							add(stageFront);
					}
					
				case 'interaction':
					{
							if (zoomout_isenabled)
							{
								defaultCamZoom = 0.5;
							}
							else
							{
								defaultCamZoom = 0.9;
							}
							curStage = 'interactive';
							var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('sb/interactiveBack','week8'));
							bg.antialiasing = true;
							bg.scrollFactor.set(0.9, 0.9);
							bg.active = false;
							add(bg);
		
							var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('sb/interactiveFront','week8'));
							stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
							stageFront.updateHitbox();
							stageFront.antialiasing = true;
							stageFront.scrollFactor.set(0.9, 0.9);
							stageFront.active = false;
							add(stageFront);
					}
				case 'spyware':
					{
							if (zoomout_isenabled)
							{
								defaultCamZoom = 0.5;
							}
							else
							{
								defaultCamZoom = 0.9;
							}
							curStage = 'xp';
							var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('sb/xpBack','week8'));
							bg.antialiasing = true;
							bg.scrollFactor.set(0.9, 0.9);
							bg.active = false;
							add(bg);
		
							var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('sb/xpFront','week8'));
							stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
							stageFront.updateHitbox();
							stageFront.antialiasing = true;
							stageFront.scrollFactor.set(0.9, 0.9);
							stageFront.active = false;
							add(stageFront);
					}
					
				case 'mutiliation':
					{
							if (zoomout_isenabled)
							{
								defaultCamZoom = 0.5;
							}
							else
							{
								defaultCamZoom = 0.9;
							}
							curStage = 'lab';
							var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('sb/labBack','week8'));
							bg.antialiasing = true;
							bg.scrollFactor.set(0.9, 0.9);
							bg.active = false;
							add(bg);
		
							var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('sb/labFront','week8'));
							stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
							stageFront.updateHitbox();
							stageFront.antialiasing = true;
							stageFront.scrollFactor.set(0.9, 0.9);
							stageFront.active = false;
							add(stageFront);

					}

							case 'headache' | 'nerves':
								{
										if (zoomout_isenabled)
										{
											defaultCamZoom = 0.5;
										}
										else
										{
											defaultCamZoom = 0.9;
										}
										curStage = 'garAlley';
			  
										var bg:FlxSprite = new FlxSprite(-500, -170).loadGraphic(Paths.image('garStagebg','week9'));
										bg.antialiasing = true;
										bg.scrollFactor.set(0.7, 0.7);
										bg.active = false;
										add(bg);
			  
										var bgAlley:FlxSprite = new FlxSprite(-500, -200).loadGraphic(Paths.image('garStage','week9'));
										bgAlley.antialiasing = true;
										bgAlley.scrollFactor.set(0.9, 0.9);
										bgAlley.active = false;
										add(bgAlley);
			  
								}
								case 'release':
								{
										if (zoomout_isenabled)
										{
											defaultCamZoom = 0.5;
										}
										else
										{
											defaultCamZoom = 0.9;
										}
										curStage = 'garAlleyDead';
			  
										var bg:FlxSprite = new FlxSprite(-500, -170).loadGraphic(Paths.image('garStagebgAlt','week9'));
										bg.antialiasing = true;
										bg.scrollFactor.set(0.7, 0.7);
										bg.active = false;
										add(bg);
			  
										var smoker:FlxSprite = new FlxSprite(0, -290);
										smoker.frames = Paths.getSparrowAtlas('garSmoke','week9');
										smoker.setGraphicSize(Std.int(smoker.width * 1.7));
										smoker.alpha = 0.3;
										smoker.animation.addByPrefix('garsmoke', "smokey", 13);
										smoker.animation.play('garsmoke');
										smoker.scrollFactor.set(0.7, 0.7);
										add(smoker);
			  
										var bgAlley:FlxSprite = new FlxSprite(-500, -200).loadGraphic(Paths.image('garStagealt','week9'));
										bgAlley.antialiasing = true;
										bgAlley.scrollFactor.set(0.9, 0.9);
										bgAlley.active = false;
										add(bgAlley);
			  
										var corpse:FlxSprite = new FlxSprite(-230, 540).loadGraphic(Paths.image('gardead','week9'));
										corpse.antialiasing = true;
										corpse.scrollFactor.set(0.9, 0.9);
										corpse.active = false;
										add(corpse);
			  
								}
								case 'fading':
								{
										if (zoomout_isenabled)
										{
											defaultCamZoom = 0.5;
										}
										else
										{
											defaultCamZoom = 0.9;
										}
										curStage = 'garAlleyDip';
			  
										var bg:FlxSprite = new FlxSprite(-500, -170).loadGraphic(Paths.image('garStagebgRise','week9'));
										bg.antialiasing = true;
										bg.scrollFactor.set(0.7, 0.7);
										bg.active = false;
										add(bg);
			  
										var bgAlley:FlxSprite = new FlxSprite(-500, -200).loadGraphic(Paths.image('garStageRise','week9'));
										bgAlley.antialiasing = true;
										bgAlley.scrollFactor.set(0.9, 0.9);
										bgAlley.active = false;
										add(bgAlley);
			  
										var corpse:FlxSprite = new FlxSprite(-230, 540).loadGraphic(Paths.image('gardead','week9'));
										corpse.antialiasing = true;
										corpse.scrollFactor.set(0.9, 0.9);
										corpse.active = false;
										add(corpse);
				  }
		          default:
		          {
					  	if (zoomout_isenabled)
						{
							defaultCamZoom = 0.5;
						}
						else
						{
							defaultCamZoom = 0.9;
						}
		                  curStage = 'stage';
		                  var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
		                  bg.antialiasing = true;
		                  bg.scrollFactor.set(0.9, 0.9);
		                  bg.active = false;
		                  add(bg);

		                  var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
		                  stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		                  stageFront.updateHitbox();
		                  stageFront.antialiasing = true;
		                  stageFront.scrollFactor.set(0.9, 0.9);
		                  stageFront.active = false;
		                  add(stageFront);

		                  var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
		                  stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
		                  stageCurtains.updateHitbox();
		                  stageCurtains.antialiasing = true;
		                  stageCurtains.scrollFactor.set(1.3, 1.3);
		                  stageCurtains.active = false;

		                  add(stageCurtains);
		          }
				  case 'rolled':
				  {
						if (zoomout_isenabled)
						{
							defaultCamZoom = 0.5;
						}
						else
						{
							defaultCamZoom = 0.9;
						}
						curStage = 'stage';
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('rolled/rickback'));
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);

						var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('rolled/rickfront'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);
				  }
              }

		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'limo':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
			case 'tankStage':
				gfVersion = 'gf-tankmen';
			case 'tankStage2':
				gfVersion = 'picoSpeaker';
		}

		if (curStage == 'limo')
			gfVersion = 'gf-car';

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'tankman':
				
				dad.y += 180;
			case 'gman':
				camPos.x += 0;
			case 'human':
				camPos.x += 400;
				dad.x += 154;
				dad.y += 93;
			case 'ragdoll':
				camPos.x += 400;
				dad.x -= 78;
				dad.y += 179;
			case 'buddy':
				camPos.x += 400;
				dad.x -= 96;
				dad.y += 286;
			case 'bonzi':
				camPos.x += 400;
				dad.x -= 213;
				dad.y += 177;
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;

			case 'tankStage':
				gf.y += -55;
				gf.x -= 200;
	
				boyfriend.x += 40;
				dad.y += 60;
				dad.x -= 80;
			case 'tankStage2':
				//gf.y += 10;
				//gf.x -= 30;
				gf.y += -155;
				gf.x -= 90;
	
				boyfriend.x += 40;
				dad.y += 60;
				dad.x -= 80;
		}

		add(gf);

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(dad);
		add(boyfriend);

		if (curStage == 'tankStage' || curStage == 'tankStage2'){

			add(tank0);
			add(tank1);
			add(tank2);
			add(tank4);
			add(tank5);
			add(tank3);
		}

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		if (downscroll_isenabled)
			strumLine.y = FlxG.height - 165;

		if (timebar_isenabled)
		{
			if (cleanfont_isenabled)
			{
				timeTxt = new FlxText(strumLine.x + (strumLine.width / 2) - 248, strumLine.y - 30, 400, "", 32);
				timeTxt.setFormat(Paths.font("coolvetica.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				timeTxt.screenCenter(X);
				timeTxt.scrollFactor.set();
				timeTxt.alpha = 1;
				timeTxt.borderSize = 2;
				if(downscroll_isenabled) timeTxt.y = FlxG.height - 45;
			}
			else
			{
				timeTxt = new FlxText(strumLine.x + (strumLine.width / 2) - 248, strumLine.y - 30, 400, "", 32);
				timeTxt.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				timeTxt.screenCenter(X);
				timeTxt.scrollFactor.set();
				timeTxt.alpha = 1;
				timeTxt.borderSize = 2;
				if(downscroll_isenabled) timeTxt.y = FlxG.height - 45;
			}

			//timeBarBG = new FlxSprite(timeTxt.x, timeTxt.y + (timeTxt.height / 4)).loadGraphic(Paths.image('healthBar'));
			timeBarBG = new FlxSprite(0, timeTxt.y + (timeTxt.height / 4)).loadGraphic(Paths.image('healthBar'));
			timeBarBG.screenCenter(X);
			timeBarBG.scrollFactor.set();
			timeBarBG.alpha = 1;
			add(timeBarBG);

			timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), this,
				'songPercent', 0, 1);
			timeBar.scrollFactor.set();
			//timeBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
			timeBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
			timeBar.numDivisions = 800; //How much lag this causes?? Should i tone it down to idk, 400 or 200?
			timeBar.alpha = 1;
			add(timeBar);
			add(timeTxt);
		}
		else
		{
			timeTxt = new FlxText(strumLine.x + (strumLine.width / 2) - 248, strumLine.y - 30, 400, "", 32);
			timeTxt.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			timeTxt.screenCenter(X);
			timeTxt.scrollFactor.set();
			timeTxt.alpha = 1;
			timeTxt.borderSize = 2;
			if(downscroll_isenabled) timeTxt.y = FlxG.height - 45;

			//timeBarBG = new FlxSprite(timeTxt.x, timeTxt.y + (timeTxt.height / 4)).loadGraphic(Paths.image('healthBar'));
			timeBarBG = new FlxSprite(0, timeTxt.y + (timeTxt.height / 4)).loadGraphic(Paths.image('healthBar'));
			timeBarBG.screenCenter(X);
			timeBarBG.scrollFactor.set();
			timeBarBG.alpha = 1;

			timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), this,
				'songPercent', 0, 1);
			timeBar.scrollFactor.set();
			//timeBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
			timeBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
			timeBar.numDivisions = 800; //How much lag this causes?? Should i tone it down to idk, 400 or 200?
			timeBar.alpha = 1;
		}

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);
		add(grpNoteSplashes);
		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();


		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, MusicBeatState.camMove);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;


		var ybar:Float = downscroll_isenabled ? FlxG.height * 0.1 : FlxG.height * 0.9;

		healthBarBG = new FlxSprite(0, FlxG.height * (downscroll_isenabled ? 0.1 : 0.9)).loadGraphic(Paths.image('healthBar'));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		// healthBar
		add(healthBar);

		if(SONG.song.toLowerCase()=='headache' || SONG.song.toLowerCase()=='nerves' || SONG.song.toLowerCase()=='release' || SONG.song.toLowerCase()=='fading'  )
		{
			healthBar.createFilledBar(0xFF8E40A5, 0xFF66FF33);
		}
		// healthBar
		add(healthBar);

		// Add Light Engine watermark
		/*var mlEngineWatermark = new FlxText(4,healthBarBG.y + 50,0,SONG.song + " " + (storyDifficulty == 2 ? "Hard" : storyDifficulty == 1 ? "Normal" : "Easy") + (Main.watermarks ? " - LIGHT " + MainMenuState.mlEngineVer : ""), 16);
		mlEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		mlEngineWatermark.scrollFactor.set();
		add(mlEngineWatermark);*/

		if (cleanfont_isenabled)
		{
			scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width - 190, healthBarBG.y + 25, 0, "", 20);
			scoreTxt.setFormat(Paths.font("coolvetica.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			scoreTxt.scrollFactor.set();

			missesTxt = new FlxText(healthBarBG.x + healthBarBG.width - 190, healthBarBG.y + -30, 0, "", 20);
			missesTxt.setFormat(Paths.font("coolvetica.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			missesTxt.scrollFactor.set();

			accuracyTxt = new FlxText(healthBarBG.x + 200 + healthBarBG.width - 190, healthBarBG.y + -5, 0, "", 20);
			accuracyTxt.setFormat(Paths.font("coolvetica.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			accuracyTxt.scrollFactor.set();

			rateTxt = new FlxText(healthBarBG.x + -555 + healthBarBG.width - 190, healthBarBG.y + -5, 0, "", 20);
			rateTxt.setFormat(Paths.font("coolvetica.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			rateTxt.scrollFactor.set();
		
			songTxt = new FlxText(timeBarBG.x + 200 + timeBarBG.width - 190, timeBarBG.y + -5, 0, "", 20);
			songTxt.setFormat(Paths.font("coolvetica.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songTxt.scrollFactor.set();

			diffTxt = new FlxText(timeBarBG.x + -500 + timeBarBG.width - 190, timeBarBG.y + -5, 0, "", 20);
			diffTxt.setFormat(Paths.font("coolvetica.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			diffTxt.scrollFactor.set();
		}
		else
		{
			scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width - 190, healthBarBG.y + 25, 0, "", 20);
			scoreTxt.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			scoreTxt.scrollFactor.set();

			missesTxt = new FlxText(healthBarBG.x + healthBarBG.width - 190, healthBarBG.y + -30, 0, "", 20);
			missesTxt.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			missesTxt.scrollFactor.set();

			accuracyTxt = new FlxText(healthBarBG.x + 200 + healthBarBG.width - 190, healthBarBG.y + -5, 0, "", 20);
			accuracyTxt.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			accuracyTxt.scrollFactor.set();

			rateTxt = new FlxText(healthBarBG.x + -555 + healthBarBG.width - 190, healthBarBG.y + -5, 0, "", 20);
			rateTxt.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			rateTxt.scrollFactor.set();

			songTxt = new FlxText(timeBarBG.x + 200 + timeBarBG.width - 190, timeBarBG.y + -5, 0, "", 20);
			songTxt.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songTxt.scrollFactor.set();

			diffTxt = new FlxText(timeBarBG.x + -500 + timeBarBG.width - 190, timeBarBG.y + -5, 0, "", 20);
			diffTxt.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			diffTxt.scrollFactor.set();
		}

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		add(scoreTxt);
		add(missesTxt);
		add(accuracyTxt);
		add(rateTxt);
		add(songTxt);
		add(diffTxt);

		strumLineNotes.cameras = [camHUD];
		grpNoteSplashes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		//mlEngineWatermark.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		missesTxt.cameras = [camHUD];
		accuracyTxt.cameras = [camHUD];
		rateTxt.cameras = [camHUD];
		songTxt.cameras = [camHUD];
		diffTxt.cameras = [camHUD];
		timeBar.cameras = [camHUD];
		timeBarBG.cameras = [camHUD];
		timeTxt.cameras = [camHUD];
		doof.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				
				/*case 'ugh':
					ughIntro();
				case 'guns':
					gunsIntro();
				case 'stress':
					stressIntro();*/
				case 'headache':
					var introText:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('garIntroText','week9'));
					introText.setGraphicSize(Std.int(introText.width * 1.5));
					introText.scrollFactor.set();
					camHUD.visible = false;
	
					add(introText);
					FlxG.sound.playMusic(Paths.music('city_ambience'), 0);
					FlxG.sound.music.fadeIn(1, 0, 0.8);
	
					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						// FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						
						new FlxTimer().start(3, function(tmr:FlxTimer)
						{
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									FlxG.sound.music.fadeOut(2.2, 0);
									remove(introText);
									camHUD.visible = true;
									garIntro(doof);
								}
							});
						});
					});
				case 'nerves':
					garIntro(doof);
				case 'release':
					garIntro(doof);
				case 'fading':
					garIntro(doof);
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		super.create();
	}

	/*function ughIntro()
		{
			var video = new VideoPlayer(0, 0, 'videos/ughcutscene.webm');
			video.finishCallback = () -> {
				remove(video);
				startCountdown();
			}
			video.ownCamera();
			video.setGraphicSize(Std.int(video.width * 2));
			video.updateHitbox();
			add(video);
			video.play();
		}
		function gunsIntro()
		{
			var video = new VideoPlayer(0, 0, 'videos/gunscutscene.webm');
			video.finishCallback = () -> {
				remove(video);
				startCountdown();
			}
			video.ownCamera();
			video.setGraphicSize(Std.int(video.width * 2));
			video.updateHitbox();
			add(video);
			video.play();
		}
		function stressIntro()
		{
			var video = new VideoPlayer(0, 0, 'videos/stresscutscene.webm');
			video.finishCallback = () -> {
				remove(video);
				startCountdown();
			}
			video.ownCamera();
			video.setGraphicSize(Std.int(video.width * 2));
			video.updateHitbox();
			add(video);
			video.play();
		}*/

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	function garIntro(?dialogueBox:DialogueBox):Void
		{
			var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
			black.scrollFactor.set();
			add(black);
	
			var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
			red.scrollFactor.set();
	
			var sexycutscene:FlxSprite = new FlxSprite();
			sexycutscene.antialiasing = true;
			sexycutscene.frames = Paths.getSparrowAtlas('GAR_CUTSCENE','week9');
			sexycutscene.animation.addByPrefix('video', 'garcutscene', 15, false);
			sexycutscene.setGraphicSize(Std.int(sexycutscene.width * 2));
			sexycutscene.scrollFactor.set();
			sexycutscene.updateHitbox();
			sexycutscene.screenCenter();
	
			if (SONG.song.toLowerCase() == 'nerves' || SONG.song.toLowerCase() == 'release')
			{
				remove(black);
	
				if (SONG.song.toLowerCase() == 'release')
				{
					add(red);
				}
			}
	
			new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{
				black.alpha -= 0.15;
	
				if (black.alpha > 0)
				{
					tmr.reset(0.1);
				}
				else
				{
					if (dialogueBox != null)
					{
						inCutscene = true;
	
						if (SONG.song.toLowerCase() == 'release')
						{
							camHUD.visible = false;
							add(red);
							add(sexycutscene);
							sexycutscene.animation.play('video');
	
							FlxG.sound.play(Paths.sound('Garcello_Dies'), 1, false, null, true, function()
								{
									remove(red);
									remove(sexycutscene);
									FlxG.sound.play(Paths.sound('Wind_Fadeout'));
	
									FlxG.camera.fade(FlxColor.WHITE, 5, true, function()
									{
										add(dialogueBox);
										camHUD.visible = true;
									}, true);
								});
						}
						else
						{
							add(dialogueBox);
						}
					}
					else
						startCountdown();
	
					remove(black);
				}
			});
		}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3'), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2'), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1'), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo'), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;
	var theFunneNumber:Float = 1;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;
		/*FlxTween.tween(timeBarBG, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		FlxTween.tween(timeBar, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		FlxTween.tween(timeTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut});*/

		#if desktop
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);
	
				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				if (!gottaHitNote && middlescroll_isenabled)
					continue;

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else {}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			if (middlescroll_isenabled && player == 0)
				continue;

			switch (curStage)
			{
				case 'school' | 'schoolEvil':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}

				default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			if (middlescroll_isenabled)
			{
				babyArrow.x -= 275;
			}

			//strumLineNotes.add(babyArrow);

			cpuStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});
	
			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if desktop
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
		}
		#end

		super.onFocus();
	}
	
	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	
	function generateRanking():String
		{
			var ranking:String = "N/A";
			
			if (misses == 0 && bads == 0 && shits == 0 && goods == 0) // Marvelous (SICK) Full Combo
				ranking = "(MFC)";
			else if (misses == 0 && bads == 0 && shits == 0 && goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
				ranking = "(GFC)";
			else if (misses == 0) // Regular FC
				ranking = "(FC)";
			else if (misses < 10) // Single Digit Combo Breaks
				ranking = "(SDCB)";
			else
				ranking = "(Clear)";
	
			return ranking;
		}
	function funiRank():String
	{
		var funirank:String = "?";

		/*if (health == 2)
			funirank = "AAAAA";
		else if (health >= 1.9)
			funirank = "AAAA:";
		else if (health >= 1.8)
			funirank = "AAAA.";
		else if (health >= 1.7)
			funirank = "AAAA";
		else if (health >= 1.6)
			funirank = "AAA:";
		else if (health >= 1.5)
			funirank = "AAA.";
		else if (health >= 1.4)
			funirank = "AAA";
	    else if (health >= 1.3)
			funirank = "AA:";
		else if (health >= 1.2)
			funirank = "AA.";
		else if (health >= 1.1)
			funirank = "AA";
		else if (health == 1)
			funirank = "A:";
		else if (health >= 0.9)
			funirank = "A.";
		else if (health >= 0.8)
			funirank = "A";
		else if (health >= 0.6)
			funirank = "B";
		else if (health >= 0.4)
			funirank = "C";
		else if (health >= 0.2)
			funirank = "D";*/

		if (accuracy >= 100)
			funirank = "S+";
		else if (accuracy >= 95)
			funirank = "S";
		else if (accuracy >= 90)
			funirank = "A+";
		else if (accuracy >= 85)
			funirank = "A";
		else if (accuracy >= 80)
			funirank = "B+";
		else if (accuracy >= 70)
			funirank = "B";
		else if (accuracy >= 60)
			funirank = "C+";
		else if (accuracy >= 50)
			funirank = "C";
		else if (accuracy >= 40)
			funirank = "D+";
		else if (accuracy >= 30)
			funirank = "D";
		else if (accuracy >= 20)
			funirank = "F+";
		else if (accuracy >= 10)
			funirank = "F";

		return funirank;
	}

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
			case 'tankStage':
				moveTank();
			case 'tankStage2':
				moveTank();
		}

		super.update(elapsed);

		//scoreTxt.text = "Score: " + songScore + "| Accuracy: " + accuracy + "%" + " | Ranking: " + generateRanking() + " " + funiRank();

		scoreTxt.text = "Score: " + songScore;
		missesTxt.text = "Misses: " + misses;
		accuracyTxt.text = "Accuracy: " + accuracy + "%";
		songTxt.text = "" + SONG.song;
		diffTxt.text = "" + (storyDifficulty == 2 ? "Hard" : storyDifficulty == 1 ? "Normal" : "Easy");
		rateTxt.text = "" + generateRanking() + " " + funiRank();
		//watermarkTxt.text = "LIGHT " + MainMenuState.mlEngineVer;

		//notestatsTxt.text = "< STATISTICS >" + "\n\nCPU Notehits: " + enemyhit + "\n\nNotehits: " + notehit + "\n\nSicks: " + sicks + "\n\nGoods: " + goods + "\n\nBads: " + bads + "\n\nShits: " + shits + "\n\nMisses: " + misses + "\n\n</>";

		#if android
		var enterPressed = FlxG.keys.justPressed.ENTER || FlxG.android.justReleased.BACK;
		#else
		var enterPressed = FlxG.keys.justPressed.ENTER;
		#end

		if (enterPressed && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				if (nohud_isenabled)
				{
					openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
					camHUD.alpha = 1; // bruh idk had no choice ...
				}
				else
				{
					openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
		
			#if desktop
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new ChartingState());

			#if desktop
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		//#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(SONG.player2));
		//#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}

				var curTime:Float = FlxG.sound.music.time;
				if(curTime < 0) curTime = 0;
				songPercent = (curTime / songLength);

				if(!endingSong) {
					var secondsTotal:Int = Math.floor((songLength - curTime) / 1000);
					if(secondsTotal < 0) secondsTotal = 0;

					var minutesRemaining:Int = Math.floor(secondsTotal / 60);
					var secondsRemaining:String = '' + secondsTotal % 60;
					if(secondsRemaining.length < 2) secondsRemaining = '0' + secondsRemaining; //Dunno how to make it display a zero first in Haxe lol
					timeTxt.text = minutesRemaining + ':' + secondsRemaining;
				} else if(timeTxt != null) {
					timeTxt.text = '0:00';
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (curBeat % 4 == 0)
			{
				// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			}

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					tweenCamIn();
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}
		// better streaming of shit

		// RESET = Quick Game Over Screen
		if (controls.RESET)
		{
			health = 0;
			trace("RESET = True");
		}

		// CHEAT = brandon's a pussy
		if (controls.CHEAT)
		{
			health += 1;
			trace("User is cheating!");
		}

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			
			#if desktop
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}
	
				// i am so fucking sorry for this if condition
				var center:Float = strumLine.y + Note.swagWidth / 2;
				if (downscroll_isenabled) {
					daNote.y = (strumLine.y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(SONG.speed, 2));
					if (daNote.isSustainNote) {
						if (daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null) {
							daNote.y += daNote.prevNote.height;
						} else {
							daNote.y += daNote.height / 2;
						}
	
							if(daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center
							&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
						{
							var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
							swagRect.height = (center - daNote.y) / daNote.scale.y;
							swagRect.y = daNote.frameHeight - swagRect.height;
	
							daNote.clipRect = swagRect;
						}
					}
				} else {
					daNote.y = (strumLine.y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(SONG.speed, 2));
	
					if (daNote.isSustainNote
						&& daNote.y + daNote.offset.y * daNote.scale.y <= center
						&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
					{
						var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
						swagRect.y = (center - daNote.y) / daNote.scale.y;
						swagRect.height -= swagRect.y;
	
						daNote.clipRect = swagRect;
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}

					switch (Math.abs(daNote.noteData))
					{
						case 0:
							dad.playAnim('singLEFT' + altAnim, true);
						case 1:
							dad.playAnim('singDOWN' + altAnim, true);
						case 2:
							dad.playAnim('singUP' + altAnim, true);
						case 3:
							dad.playAnim('singRIGHT' + altAnim, true);
					}

					cpuStrums.forEach(function(spr:FlxSprite)
						{
							if (cpustrums_isenabled)
							{
								if (Math.abs(daNote.noteData) == spr.ID)
								{
									enemyhit++;
									spr.animation.play('confirm', true);
								}
							}
							else
							{
								if (Math.abs(daNote.noteData) == spr.ID)
								{
									enemyhit++;
									//spr.animation.play('confirm', true);
								}
							}
							if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
							{
								spr.centerOffsets();
								spr.offset.x -= 13;
								spr.offset.y -= 13;
							}
							else
								spr.centerOffsets();
						});

					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				if (middlescroll_isenabled)
					{
						daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					else if (middlescroll_isenabled)
					{
						daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					

				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
				
				var doKill:Bool = daNote.y < -daNote.height;
				if(downscroll_isenabled) doKill = daNote.y > FlxG.height;

				if (doKill)
				{
					if (daNote.mustPress)
					{
						if (daNote.tooLate || !daNote.wasGoodHit)
						{
							if (practice_isenabled)
							{
								if(!endingSong) {
									health -= 0; //For testing purposes
									misses++;
									combo = 0;
									accuracy -= 12;
									if (health == 2)
									{
										accuracy -= 6;
									}
								}
								vocals.volume = 0;
							}
							else
							{
							if(!endingSong) {
								health -= 0.0475; //For testing purposes
								misses++;
								combo = 0;
								accuracy -= 12;
								if (health == 2)
								{
									accuracy -= 6;
								}
							}
							vocals.volume = 0;
						}
					}
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				cpuStrums.forEach(function(spr:FlxSprite)
					{
						if (spr.animation.finished)
						{
							spr.animation.play('static');
							spr.centerOffsets();
						}
					});
				
			});
		}

		if (!inCutscene)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	public function endSong():Void
	{
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);
			#end
		}

		if (isStoryMode)
		{
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				FlxG.switchState(new StoryMenuState());
			

				// if ()
				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore)
				{
					#if !mobile
					NGio.unlockMedal(60961);
					#end
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
				}

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
				changedDifficulty = false;

			}
			else
			{
				var difficulty:String = "";

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';

				trace('LOADING NEXT SONG');
				trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

				if (SONG.song.toLowerCase() == 'eggnog')
				{
					var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
						-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					blackShit.scrollFactor.set();
					add(blackShit);
					camHUD.visible = false;

					FlxG.sound.play(Paths.sound('Lights_Shut_off'));
				}

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				prevCamFollow = camFollow;

				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
				FlxG.sound.music.stop();

				LoadingState.loadAndSwitchState(new PlayState());
			}
		}
		else
		{
			trace('WENT BACK TO FREEPLAY??');
			FlxG.switchState(new FreeplayState());

			changedDifficulty = false;
		}
	}

	var endingSong:Bool = false;

	//private function popUpScore(strumtime:Float):Void
	private function popUpScore(daNote:Note):Void
	{
		var noteDiff:Float = Math.abs(Conductor.songPosition - daNote.strumTime);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		//var daRating:String = "sick";

		/*if (noteDiff > Conductor.safeZoneOffset * 0.90)
		{
			daRating = 'shit';
			//score = -300;
			//health -= 0.2;
			//misses++;
			//combo = 0;
			//combobreaks += 1;
			score = 50;
			shits++;
			//sicks--;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.75)
		{
				daRating = 'bad';
				//score = 0;
				score = 100;
				health -= 0.06;
				bads++;
				//sicks--;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.2)
		{
			daRating = 'good';
			score = 200;
			//if (health < 2)
				//health += 0.04;
			goods++;
			//sicks--;
		}
		if(daRating == 'sick')
		{
			var recycledNote = grpNoteSplashes.recycle(NoteSplash);
				recycledNote.setupNoteSplash(daNote.x, daNote.y, daNote.noteData);
				grpNoteSplashes.add(recycledNote);
			sicks++;
		}*/

		// thx zack :O
		var daRating = daNote.rating;

		if (practice_isenabled)
		{
			switch(daRating)
			{
				case 'shit':
					shits++;
				case 'bad':
					daRating = 'bad';
					bads++;
				case 'good':
					daRating = 'good';
					score = 200;
					if (health < 2)
						health += 0.04;
					goods++;
				case 'sick':
					if (health < 2)
						health += 0.1;
					sicks++;
					if (splash_isenabled)
					{
						var recycledNote = grpNoteSplashes.recycle(NoteSplash);
						recycledNote.setupNoteSplash(daNote.x, daNote.y, daNote.noteData);
						grpNoteSplashes.add(recycledNote);
					}
			}
		}
		else
		{

		}
			switch(daRating)
			{
				case 'shit':
					score = -300;
					combo = 0;
					misses += 1;
					health -= 0.2;
					shits++;
					accuracy -= 12;
					if (health == 2)
					{
						accuracy -= 6;
					}
				case 'bad':
					daRating = 'bad';
					score = 0;
					health -= 0.06;
					bads++;
					accuracy -= 6;
					if (health == 2)
					{
						accuracy -= 3;
					}
				case 'good':
					daRating = 'good';
					score = 200;
					if (health < 2)
						health += 0.04;
					goods++;
					accuracy += 3;
					if (health == 2)
					{
						accuracy += 6;
					}
				case 'sick':
					if (health < 2)
						health += 0.1;
					sicks++;
					accuracy += 6;
					if (splash_isenabled)
					{
						var recycledNote = grpNoteSplashes.recycle(NoteSplash);
			        	recycledNote.setupNoteSplash(daNote.x, daNote.y, daNote.noteData);
			        	grpNoteSplashes.add(recycledNote);
					}
					if (health == 2)
					{
						accuracy += 12;
					}
			}

			if (accuracy >= 100)
			{
				accuracy = 100;
			}

		songScore += score;

		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (curStage.startsWith('school'))
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		add(rating);

		if (!curStage.startsWith('school'))
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = true;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = true;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		seperatedScore.push(Math.floor(combo / 100));
		seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			if (!curStage.startsWith('school'))
			{
				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (combo >= 10 || combo == 0)
				add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		curSection += 1;
	}

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		// FlxG.watch.addQuick('asdfa', upP);
		if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					// the sorting probably doesn't need to be in here? who cares lol
					possibleNotes.push(daNote);
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

					ignoreList.push(daNote.noteData);
				}
			});

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				if (perfectMode)
					noteCheck(true, daNote);

				// Jump notes
				if (possibleNotes.length >= 2)
				{
					if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
					{
						for (coolNote in possibleNotes)
						{
							if (controlArray[coolNote.noteData])
								goodNoteHit(coolNote);
							else
							{
								var inIgnoreList:Bool = false;
								for (shit in 0...ignoreList.length)
								{
									if (controlArray[ignoreList[shit]])
										inIgnoreList = true;
								}
								if (!inIgnoreList)
									badNoteCheck();
							}
						}
					}
					else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
					{
						noteCheck(controlArray[daNote.noteData], daNote);
					}
					else
					{
						for (coolNote in possibleNotes)
						{
							noteCheck(controlArray[coolNote.noteData], coolNote);
						}
					}
				}
				else // regular notes?
				{
					noteCheck(controlArray[daNote.noteData], daNote);
				}
				/* 
					if (controlArray[daNote.noteData])
						goodNoteHit(daNote);
				 */
				// trace(daNote.noteData);
				/* 
						switch (daNote.noteData)
						{
							case 2: // NOTES YOU JUST PRESSED
								if (upP || rightP || downP || leftP)
									noteCheck(upP, daNote);
							case 3:
								if (upP || rightP || downP || leftP)
									noteCheck(rightP, daNote);
							case 1:
								if (upP || rightP || downP || leftP)
									noteCheck(downP, daNote);
							case 0:
								if (upP || rightP || downP || leftP)
									noteCheck(leftP, daNote);
						}

					//this is already done in noteCheck / goodNoteHit
					if (daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				 */
			}
			else
			{
				badNoteCheck();
			}
		}

		if ((up || right || down || left) && !boyfriend.stunned && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{
					switch (daNote.noteData)
					{
						// NOTES YOU ARE HOLDING
						case 0:
							if (left)
								goodNoteHit(daNote);
						case 1:
							if (down)
								goodNoteHit(daNote);
						case 2:
							if (up)
								goodNoteHit(daNote);
						case 3:
							if (right)
								goodNoteHit(daNote);
					}
				}
			});
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.playAnim('idle');
			}
		}

		playerStrums.forEach(function(spr:FlxSprite)
		{
			switch (spr.ID)
			{
				case 0:
					if (leftP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (leftR)
						spr.animation.play('static');
				case 1:
					if (downP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (downR)
						spr.animation.play('static');
				case 2:
					if (upP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (upR)
						spr.animation.play('static');
				case 3:
					if (rightP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (rightR)
						spr.animation.play('static');
			}

			if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
		});
	}

	function noteMiss(direction:Int = 1):Void
	{
		if (practice_isenabled)
		{
			if (!boyfriend.stunned)
			{
				health -= 0;
				
				songScore -= 0;
						
				boyfriend.stunned = true;
						
				// get stunned for 5 seconds
				new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
				{
					boyfriend.stunned = false;
				});
			} 
		}
		if (ghosttap_isenabled)
		{
			if (!boyfriend.stunned)
			{
				health -= 0;

				songScore -= 0;
					
				boyfriend.stunned = true;
					
				// get stunned for 5 seconds
				new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
				{
					boyfriend.stunned = false;
				});
			}
		}
		if (!boyfriend.stunned)
		{
			health -= 0.04;

			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}

			misses++;

			combo = 0;

			songScore -= 10;

			accuracy -= 12;
			if (health == 2)
			{
				accuracy -= 6;
			}

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			boyfriend.stunned = true;

			// get stunned for 5 seconds
			new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
			{
				boyfriend.stunned = false;
			});

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}
		}
	}

	function badNoteCheck()
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		if (leftP)
			noteMiss(0);
		if (downP)
			noteMiss(1);
		if (upP)
			noteMiss(2);
		if (rightP)
			noteMiss(3);
	}

	function noteCheck(keyP:Bool, note:Note):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);
			note.rating = Ratings.CalculateRating(noteDiff);
		if (keyP)
			goodNoteHit(note);
		else
		{
			badNoteCheck();
		}
	}

	function goodNoteHit(note:Note):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);
			note.rating = Ratings.CalculateRating(noteDiff);
		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note);
				combo += 1;
				notehit++;
				if (hitsounds_isenabled)
				{
					FlxG.sound.play(Paths.sound('hitSound'));
				}

			}

			if (note.noteData >= 0)
				health += 0.023;
			else
				health += 0.004;

			switch (note.noteData)
			{
				case 0:
					boyfriend.playAnim('singLEFT', true);
				case 1:
					boyfriend.playAnim('singDOWN', true);
				case 2:
					boyfriend.playAnim('singUP', true);
				case 3:
					boyfriend.playAnim('singRIGHT', true);
			}

			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}
	
	function moveTank(){
		if(!inCutscene){
			tankAngle += FlxG.elapsed * tankSpeed;
			tankRolling.angle = tankAngle - 90 + 15;
			tankRolling.x = tankX + 1500 * Math.cos(Math.PI / 180 * (1 * tankAngle + 180));
			tankRolling.y = 1300 + 1100 * Math.sin(Math.PI / 180 * (1 * tankAngle + 180));
		}
		
		

	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}
		if (dad.curCharacter == 'tankman' && SONG.song.toLowerCase() == 'stress')
			{
				if (curStep == 735)
				{
					dad.addOffset("singDOWN", 45, 20);
					dad.animation.getByName('singDOWN').frames = dad.animation.getByName('prettyGoodAnim').frames;
					dad.playAnim('prettyGoodAnim', true);
				}
	
				if (curStep == 736 || curStep == 737)
				{
					
					dad.playAnim('prettyGoodAnim', true);
				}
	
				if (curStep == 767)
				{
					dad.addOffset("singDOWN", 98, -90);
					dad.animation.getByName('singDOWN').frames = dad.animation.getByName('oldSingDOWN').frames;
				}
			}
	
			//picoSpeaker and running tankmen
	
			if(SONG.song.toLowerCase() == 'stress')
			{
	
				
	
	
				//RIGHT
	
				if (curStep == 2 || 
					curStep == 3 || 
					curStep == 5 || 
					curStep == 9 || 
					curStep == 10 || 
					curStep == 16 || 
					curStep == 22 || 
					curStep == 25 || 
					curStep == 26 || 
					curStep == 34 || 
					curStep == 35 || 
					curStep == 37 || 
					curStep == 41 || 
					curStep == 42 || 
					curStep == 48 || 
					curStep == 54 || 
					curStep == 57 || 
					curStep == 58 || 
					curStep == 66 || 
					curStep == 67 || 
					curStep == 69 || 
					curStep == 73 || 
					curStep == 74 || 
					curStep == 80 || 
					curStep == 86 || 
					curStep == 89 || 
					curStep == 90 || 
					curStep == 98 || 
					curStep == 99 || 
					curStep == 101 || 
					curStep == 105 ||
					 curStep == 106 || 
					 curStep == 112 || 
					 curStep == 118 || 
					 curStep == 121 || 
					 curStep == 122 || 
					 curStep == 253 || 
					 curStep == 260 || 
					 curStep == 268 || 
					 curStep == 280 || 
					 curStep == 284 || 
					 curStep == 292 || 
					 curStep == 300 || 
					 curStep == 312 || 
					 curStep == 316 || 
					 curStep == 317 || 
					 curStep == 318 || 
					 curStep == 320 || 
					 curStep == 332 || 
					 curStep == 336 || 
					 curStep == 344 || 
					 curStep == 358 || 
					 curStep == 360 || 
					 curStep == 362 || 
					 curStep == 364 || 
					 curStep == 372 || 
					 curStep == 376 || 
					 curStep == 388 || 
					 curStep == 396 || 
					 curStep == 404 || 
					 curStep == 408 || 
					 curStep == 412 || 
					 curStep == 420 || 
					 curStep == 428 || 
					 curStep == 436 || 
					 curStep == 440 || 
					 curStep == 444 || 
					 curStep == 452 || 
					 curStep == 456 || 
					 curStep == 460 || 
					 curStep == 468 || 
					 curStep == 472 || 
					 curStep == 476 || 
					 curStep == 484 || 
					 curStep == 488 || 
					 curStep == 492 || 
					 curStep == 508 || 
					 curStep == 509 || 
					 curStep == 510 || 
					 curStep == 516 || 
					 curStep == 520 || 
					 curStep == 524 || 
					 curStep == 532 || 
					 curStep == 540 || 
					 curStep == 552 || 
					 curStep == 556 || 
					 curStep == 564 || 
					 curStep == 568 || 
					 curStep == 572 || 
					 curStep == 580 || 
					 curStep == 584 || 
					 curStep == 588 || 
					 curStep == 596 || 
					 curStep == 604 || 
					 curStep == 612 || 
					 curStep == 616 || 
					 curStep == 620 || 
					 curStep == 636 || 
					 curStep == 637 || 
					 curStep == 638 || 
					 curStep == 642 || 
					 curStep == 643 || 
					 curStep == 645 || 
					 curStep == 649 || 
					 curStep == 650 || 
					 curStep == 656 || 
					 curStep == 662 || 
					 curStep == 665 || 
					 curStep == 666 || 
					 curStep == 674 || 
					 curStep == 675 || 
					 curStep == 677 || 
					 curStep == 681 || 
					 curStep == 682 || 
					 curStep == 688 || 
					 curStep == 694 || 
					 curStep == 697 || 
					 curStep == 698 || 
					 curStep == 706 || 
					 curStep == 707 || 
					 curStep == 709 || 
					 curStep == 713 || 
					 curStep == 714 || 
					 curStep == 720 || 
					 curStep == 726 || 
					 curStep == 729 || 
					 curStep == 730 || 
					 curStep == 738 || 
					 curStep == 739 || 
					 curStep == 741 || 
					 curStep == 745 || 
					 curStep == 746 || 
					 curStep == 753 || 
					 curStep == 758 || 
					 curStep == 761 || 
					 curStep == 762 || 
					 curStep == 768 || 
					 curStep == 788 || 
					 curStep == 792 || 
					 curStep == 796 || 
					 curStep == 800 || 
					 curStep == 820 || 
					 curStep == 824 || 
					 curStep == 828 || 
					 curStep == 829 || 
					 curStep == 830 || 
					 curStep == 832 || 
					 curStep == 852 || 
					 curStep == 856 || 
					 curStep == 860 || 
					 curStep == 861 || 
					 curStep == 862 || 
					 curStep == 864 || 
					 curStep == 865 || 
					 curStep == 866 || 
					 curStep == 884 || 
					 curStep == 885 || 
					 curStep == 886 || 
					 curStep == 887 || 
					 curStep == 892 || 
					 curStep == 900 || 
					 curStep == 912 || 
					 curStep == 916 || 
					 curStep == 924 || 
					 curStep == 926 || 
					 curStep == 936 || 
					 curStep == 948 || 
					 curStep == 958 || 
					 curStep == 962 || 
					 curStep == 966 || 
					 curStep == 970 || 
					 curStep == 974 || 
					 curStep == 976 || 
					 curStep == 980 || 
					 curStep == 984 || 
					 curStep == 988 || 
					 curStep == 990 || 
					 curStep == 1000 || 
					 curStep == 1004 || 
					 curStep == 1006 || 
					 curStep == 1008 || 
					 curStep == 1012 || 
					 curStep == 1019 || 
					 curStep == 1028 || 
					 curStep == 1036 || 
					 curStep == 1044 || 
					 curStep == 1052|| 
					 curStep == 1060 || 
					 curStep == 1068 || 
					 curStep == 1076 || 
					 curStep == 1084 || 
					 curStep == 1092 || 
					 curStep == 1100 || 
					 curStep == 1108 || 
					 curStep == 1116 || 
					 curStep == 1124 || 
					 curStep == 1132 || 
					 curStep == 1148 || 
					 curStep == 1149 || 
					 curStep == 1150 || 
					 curStep == 1156 || 
					 curStep == 1160 || 
					 curStep == 1164 || 
					 curStep == 1172 || 
					 curStep == 1180 || 
					 curStep == 1188 || 
					 curStep == 1192 || 
					 curStep == 1196 || 
					 curStep == 1204 || 
					 curStep == 1208 || 
					 curStep == 1212 || 
					 curStep == 1220 || 
					 curStep == 1224 || 
					 curStep == 1228 || 
					 curStep == 1236 || 
					 curStep == 1244 || 
					 curStep == 1252 || 
					 curStep == 1256 || 
					 curStep == 1260 || 
					 curStep == 1276 || 
					 curStep == 1296 || 
					 curStep == 1300 || 
					 curStep == 1304 || 
					 curStep == 1308 || 
					 curStep == 1320 || 
					 curStep == 1324 || 
					 curStep == 1328 || 
					 curStep == 1332 || 
					 curStep == 1340 || 
					 curStep == 1352 || 
					 curStep == 1358 || 
					 curStep == 1364 || 
					 curStep == 1372 || 
					 curStep == 1374 || 
					 curStep == 1378 || 
					 curStep == 1388 || 
					 curStep == 1392 || 
					 curStep == 1400 || 
					 curStep == 1401 || 
					 curStep == 1405 || 
					 curStep == 1410 || 
					 curStep == 1411 || 
					 curStep == 1413 || 
					 curStep == 1417 || 
					 curStep == 1418 || 
					 curStep == 1424 || 
					 curStep == 1430 || 
					 curStep == 1433 || 
					 curStep == 1434)
					 
				{
					gf.playAnim('shoot' + FlxG.random.int(1, 2), true);
					
					var tankmanRunner:TankmenBG = new TankmenBG();
					
					
					
					
					
				}
	
				//LEFT
				if (curStep == 0 || 
					curStep == 7 || 
					curStep == 12 || 
					curStep == 14 || 
					curStep == 15 || 
					curStep == 18 || 
					curStep == 19 || 
					curStep == 24 || 
					curStep == 28 || 
					curStep == 32 || 
					curStep == 39 || 
					curStep == 44 || 
					curStep == 46 || 
					curStep == 47 || 
					curStep == 50 || 
					curStep == 51 || 
					curStep == 56 || 
					curStep == 60 || 
					curStep == 61 || 
					curStep == 62 || 
					curStep == 64 || 
					curStep == 71 || 
					curStep == 76 || 
					curStep == 78 || 
					curStep == 79 || 
					curStep == 82 || 
					curStep == 83 || 
					curStep == 88 || 
					curStep == 92 || 
					curStep == 96 || 
					curStep == 103 ||
					 curStep == 108 || 
					 curStep == 110 || 
					 curStep == 111 || 
					 curStep == 114 || 
					 curStep == 115 || 
					 curStep == 120 || 
					 curStep == 124 || 
					 curStep == 252 || 
					 curStep == 254 || 
					 curStep == 256 || 
					 curStep == 264 || 
					 curStep == 272 || 
					 curStep == 276 || 
					 curStep == 288 || 
					 curStep == 296 || 
					 curStep == 304 || 
					 curStep == 308 || 
					 curStep == 324 || 
					 curStep == 328 || 
					 curStep == 340 || 
					 curStep == 348 || 
					 curStep == 352 || 
					 curStep == 354 || 
					 curStep == 356 || 
					 curStep == 366 || 
					 curStep == 368 || 
					 curStep == 378 || 
					 curStep == 384 || 
					 curStep == 392 || 
					 curStep == 394 || 
					 curStep == 400 || 
					 curStep == 410 || 
					 curStep == 416 || 
					 curStep == 424 || 
					 curStep == 426 || 
					 curStep == 432 || 
					 curStep == 442 || 
					 curStep == 448 || 
					 curStep == 458 || 
					 curStep == 464 || 
					 curStep == 474 || 
					 curStep == 480 || 
					 curStep == 490 || 
					 curStep == 496 || 
					 curStep == 500 || 
					 curStep == 504 || 
					 curStep == 506 || 
					 curStep == 512 || 
					 curStep == 522 || 
					 curStep == 528 || 
					 curStep == 536 || 
					 curStep == 538 || 
					 curStep == 544 || 
					 curStep == 554 || 
					 curStep == 560 || 
					 curStep == 570 || 
					 curStep == 576 || 
					 curStep == 586 || 
					 curStep == 592 || 
					 curStep == 600 || 
					 curStep == 602 || 
					 curStep == 608 || 
					 curStep == 618 || 
					 curStep == 624 || 
					 curStep == 628 || 
					 curStep == 632 || 
					 curStep == 634 || 
					 curStep == 640 || 
					 curStep == 647 || 
					 curStep == 652 || 
					 curStep == 654 || 
					 curStep == 655 || 
					 curStep == 658 || 
					 curStep == 659 || 
					 curStep == 664 || 
					 curStep == 668 || 
					 curStep == 672 || 
					 curStep == 679 || 
					 curStep == 684 || 
					 curStep == 686 || 
					 curStep == 687 || 
					 curStep == 690 || 
					 curStep == 691 || 
					 curStep == 696 || 
					 curStep == 700 || 
					 curStep == 701 || 
					 curStep == 702 || 
					 curStep == 704 || 
					 curStep == 711 || 
					 curStep == 716 || 
					 curStep == 718 || 
					 curStep == 719 || 
					 curStep == 722 || 
					 curStep == 723 || 
					 curStep == 728 || 
					 curStep == 732 || 
					 curStep == 736 || 
					 curStep == 743 || 
					 curStep == 748 || 
					 curStep == 750 || 
					 curStep == 751 || 
					 curStep == 754 || 
					 curStep == 755 || 
					 curStep == 760 || 
					 curStep == 764 || 
					 curStep == 772 || 
					 curStep == 776 || 
					 curStep == 780 || 
					 curStep == 784 || 
					 curStep == 804 || 
					 curStep == 808 || 
					 curStep == 812 || 
					 curStep == 816 || 
					 curStep == 836 || 
					 curStep == 840 || 
					 curStep == 844 || 
					 curStep == 848 || 
					 curStep == 868 || 
					 curStep == 869 || 
					 curStep == 870 || 
					 curStep == 872 || 
					 curStep == 873 || 
					 curStep == 874 || 
					 curStep == 876 || 
					 curStep == 877 || 
					 curStep == 878 || 
					 curStep == 880 || 
					 curStep == 881 || 
					 curStep == 882 || 
					 curStep == 883 || 
					 curStep == 888 || 
					 curStep == 889 || 
					 curStep == 890 || 
					 curStep == 891 || 
					 curStep == 896 || 
					 curStep == 904 || 
					 curStep == 908 || 
					 curStep == 920 || 
					 curStep == 928 || 
					 curStep == 932 || 
					 curStep == 940 || 
					 curStep == 944 || 
					 curStep == 951 || 
					 curStep == 952 || 
					 curStep == 953 || 
					 curStep == 955 || 
					 curStep == 960 || 
					 curStep == 964 || 
					 curStep == 968 || 
					 curStep == 972 || 
					 curStep == 978 || 
					 curStep == 982 || 
					 curStep == 986 || 
					 curStep == 992 || 
					 curStep == 994 || 
					 curStep == 996 || 
					 curStep == 1016 || 
					 curStep == 1017 || 
					 curStep == 1021 || 
					 curStep == 1024 || 
					 curStep == 1034 || 
					 curStep == 1040 || 
					 curStep == 1050 || 
					 curStep == 1056 || 
					 curStep == 1066 || 
					 curStep == 1072 || 
					 curStep == 1082 || 
					 curStep == 1088 || 
					 curStep == 1098 || 
					 curStep == 1104 || 
					 curStep == 1114 || 
					 curStep == 1120 || 
					 curStep == 1130 || 
					 curStep == 1136 || 
					 curStep == 1140 || 
					 curStep == 1144 || 
					 curStep == 1146 || 
					 curStep == 1152 || 
					 curStep == 1162 || 
					 curStep == 1168 || 
					 curStep == 1176 || 
					 curStep == 1178 || 
					 curStep == 1184 || 
					 curStep == 1194 || 
					 curStep == 1200 || 
					 curStep == 1210 || 
					 curStep == 1216 || 
					 curStep == 1226 || 
					 curStep == 1232 || 
					 curStep == 1240 || 
					 curStep == 1242 || 
					 curStep == 1248 || 
					 curStep == 1258 || 
					 curStep == 1264 || 
					 curStep == 1268 || 
					 curStep == 1272 || 
					 curStep == 1280 || 
					 curStep == 1284 || 
					 curStep == 1288 || 
					 curStep == 1292 || 
					 curStep == 1312 || 
					 curStep == 1314 || 
					 curStep == 1316 || 
					 curStep == 1336 || 
					 curStep == 1344 || 
					 curStep == 1356 || 
					 curStep == 1360 || 
					 curStep == 1368 || 
					 curStep == 1376 || 
					 curStep == 1380 || 
					 curStep == 1384 || 
					 curStep == 1396 || 
					 curStep == 1404 || 
					 curStep == 1408 || 
					 curStep == 1415 || 
					 curStep == 1420 || 
					 curStep == 1422 || 
					 curStep == 1423 || 
					 curStep == 1426 || 
					 curStep == 1427 || 
					 curStep == 1432 || 
					 curStep == 1436 || 
					 curStep == 1437 || 
					 curStep == 1438)
				{
					gf.playAnim('shoot' + FlxG.random.int(3, 4), true);
					
	
						
					
					
					
					
				}
	
	
	
				//Left spawn
	
				if (curStep == 2 || 
					
					curStep == 9 || 
					
					curStep == 22 || 
					
					curStep == 34 || 
					
					curStep == 41 || 
					
					curStep == 54 || 
					
					curStep == 66 || 
					 
					curStep == 73 || 
					
					curStep == 86 || 
					
					curStep == 98 || 
					
					curStep == 105 ||
					  
					 curStep == 118 || 
					 
					 curStep == 253 || 
					  
					 curStep == 280 || 
					 
					 curStep == 300 || 
					 
					 curStep == 317 || 
					  
					 curStep == 332 || 
					  
					 curStep == 358 || 
					  
					 curStep == 364 || 
					  
					 curStep == 388 || 
					 
					 curStep == 408 || 
					  
					 curStep == 428 || 
					  
					 curStep == 444 || 
					  
					 curStep == 460 || 
					 
					 curStep == 476 || 
					 
					 curStep == 492 || 
					  
					 curStep == 510 || 
					 
					 curStep == 524 || 
					  
					 curStep == 552 || 
					 
					 curStep == 568 || 
					  
					 curStep == 584 || 
					  
					 curStep == 604 || 
					 
					 curStep == 620 || 
					 
					 curStep == 638 || 
					 
					 curStep == 645 || 
					  
					 curStep == 656 || 
					 
					 curStep == 666 || 
					  
					 curStep == 677 || 
					  
					 curStep == 688 || 
					 
					 curStep == 698 || 
					  
					 curStep == 709 || 
					 
					 curStep == 720 || 
					  
					 curStep == 730 || 
					 
					 curStep == 741 || 
					  
					 curStep == 753 || 
					 
					 curStep == 762 || 
					 
					 curStep == 792 || 
					 
					 curStep == 820 || 
					  
					 curStep == 829 || 
					 
					 curStep == 852 || 
					  
					 curStep == 861 || 
					 
					 curStep == 865 || 
					 
					 curStep == 885 || 
					 
					 curStep == 892 || 
					  
					 curStep == 916 || 
					  
					 curStep == 936 || 
					 
					 curStep == 962 || 
					 
					 curStep == 974 || 
					 
					 curStep == 984 || 
					 
					 curStep == 1000 || 
					 
					 curStep == 1008 || 
					  
					 curStep == 1028 || 
					 
					 curStep == 1052|| 
					 
					 curStep == 1076 || 
					 
					 curStep == 1100 || 
					  
					 curStep == 1124 || 
					  
					 curStep == 1149 || 
					 
					 curStep == 1160 || 
					 
					 curStep == 1180 
					  
					 
					 )
					 
				{
					
					
					var tankmanRunner:TankmenBG = new TankmenBG();
					tankmanRunner.resetShit(FlxG.random.int(630, 730) * -1, 265, true, 1, 1.5);
	
					tankmanRun.add(tankmanRunner);
					
					
					
					
				}
	
				//Right spawn
				if (curStep == 0 || 
					
					curStep == 14 || 
					
					curStep == 19 || 
					
					curStep == 32 || 
					
					curStep == 46 || 
					
					curStep == 51 || 
					
					curStep == 61 || 
					 
					curStep == 71 || 
					
					curStep == 79 || 
					
					curStep == 88 || 
					
					curStep == 103 ||
					  
					 curStep == 111 || 
					 
					 curStep == 120 || 
					 
					 curStep == 254 || 
					 
					 curStep == 272 || 
					 
					 curStep == 296 || 
					  
					 curStep == 324 || 
					 
					 curStep == 348 || 
					 
					 curStep == 356 || 
					 
					 curStep == 378 || 
					  
					 curStep == 394 || 
					 
					 curStep == 416 || 
					  
					 curStep == 432 || 
					 
					 curStep == 458 || 
					 
					 curStep == 480 || 
					 
					 curStep == 500 || 
					 
					 curStep == 512 || 
					 
					 curStep == 536 || 
					 
					 curStep == 554 || 
					  
					 curStep == 576 || 
					 
					 curStep == 600 || 
					 
					 curStep == 618 || 
					  
					 curStep == 632 || 
					 
					 curStep == 647 || 
					 
					 curStep == 655 || 
					 
					 curStep == 664 || 
					 
					 curStep == 679 || 
					 
					 curStep == 687 || 
					 
					 curStep == 696 || 
					 
					 curStep == 702 || 
					 
					 curStep == 716 || 
					 
					 curStep == 722 || 
					 
					 curStep == 732 || 
					 
					 curStep == 748 || 
					 
					 curStep == 754 || 
					 
					 curStep == 764 || 
					 
					 curStep == 780 || 
					 
					 curStep == 808 || 
					 
					 curStep == 836 || 
					 
					 curStep == 848 || 
					 
					 curStep == 870 || 
					 
					 curStep == 874 || 
					 
					 curStep == 878 || 
					 
					 curStep == 882 || 
					 
					 curStep == 889 || 
					 
					 curStep == 896 || 
					 
					 curStep == 920 || 
					 
					 curStep == 940 || 
					 
					 curStep == 952 || 
					 
					 curStep == 960 || 
					 
					 curStep == 972 || 
					 
					 curStep == 986 || 
					 
					 curStep == 996 || 
					 
					 curStep == 1021 || 
					 
					 curStep == 1040 || 
					 
					 curStep == 1066 || 
					 
					 curStep == 1088 || 
					 
					 curStep == 1114 || 
					 
					 curStep == 1136 || 
					 
					 curStep == 1146 || 
					 
					 curStep == 1168 || 
					 
					 curStep == 1184
					
					 
					 )
				{
					
					
	
						
					var tankmanRunner:TankmenBG = new TankmenBG();
					tankmanRunner.resetShit(FlxG.random.int(1500, 1700) * 1, 285, false, 1, 1.5);
					tankmanRun.add(tankmanRunner);
					
					
					
				}
			}
	
			if (dad.curCharacter == 'tankman' && SONG.song.toLowerCase() == 'ugh')
			{
				
				if (curStep == 59 || curStep == 443 || curStep == 523 || curStep == 827) // -1
				{
					dad.addOffset("singUP", 45, 0);
					
					dad.animation.getByName('singUP').frames = dad.animation.getByName('ughAnim').frames;
				}
	
				if (curStep == 64 || curStep == 448 || curStep == 528 || curStep == 832) // +4
				{
					dad.addOffset("singUP", 24, 56);
					dad.animation.getByName('singUP').frames = dad.animation.getByName('oldSingUP').frames;
				}
	
				
			}

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}
		if (dad.curCharacter == 'garcellodead' && SONG.song.toLowerCase() == 'release')
		{
			if (curStep == 838)
			{
			dad.playAnim('garTightBars', true);
			}
		}
	
		if (dad.curCharacter == 'garcelloghosty' && SONG.song.toLowerCase() == 'fading')
		{
			if (curStep == 247)
			{
				dad.playAnim('garFarewell', true);
			}
		}
	
		if (dad.curCharacter == 'garcelloghosty' && SONG.song.toLowerCase() == 'fading')
		{
			if (curStep == 240)
			{
				new FlxTimer().start(0.1, function(tmr:FlxTimer)
				{
					dad.alpha -= 0.05;
					iconP2.alpha -= 0.05;
	
					if (dad.alpha > 0)
					{
						tmr.reset(0.1);
					}
				});
			}
		}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			boyfriend.playAnim('hey', true);
			dad.playAnim('cheer', true);
		}

		switch (curStage)
		{
			case 'school':
				bgGirls.dance();

			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
				case "tankStage2":
					if(curBeat % 2 == 0){
						tankWatchtower.animation.play('idle', true);
						tank0.animation.play('idle', true);
						tank1.animation.play('idle', true);
						tank2.animation.play('idle', true);
						tank3.animation.play('idle', true);
						tank4.animation.play('idle', true);
						tank5.animation.play('idle', true);
					}
		
						
							
						
							
						
		
					case "tankStage":
					if(curBeat % 2 == 0){
						tankWatchtower.animation.play('idle', true);
						tank0.animation.play('idle', true);
						tank1.animation.play('idle', true);
						tank2.animation.play('idle', true);
						tank3.animation.play('idle', true);
						tank4.animation.play('idle', true);
						tank5.animation.play('idle', true);
					}
						
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}

	var curLight:Int = 0;
}
