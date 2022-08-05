package;

import ui.FlxVirtualPad;
import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.math.FlxPoint;

class Config {
    var save:FlxSave;

    public function new() 
    {
        save = new FlxSave();
    	save.bind("saveconrtol");
    }

		// downscroll
		public var downscroll(get, set):Bool;

		function get_downscroll():Bool
			return getdownscroll();

		function set_downscroll(downscroll:Bool):Bool
			return setdownscroll(downscroll);

		// ghost tapping settings
		public var ghosttap(get, set):Bool;

		function get_ghosttap():Bool
			return getghosttap();

		function set_ghosttap(ghosttap:Bool):Bool
			return setghosttap(ghosttap);

		// practice mode settings
		public var practice(get, set):Bool;

		function get_practice():Bool
			return getpractice();

		function set_practice(practice:Bool):Bool
			return setpractice(practice);

		// panorama menu settings
		/*public var panorama(get, set):Bool;

		function get_panorama():Bool
			return getpanorama();
	
		function set_panorama(panorama:Bool):Bool
			return setpanorama(panorama);*/

		// no mods settings
		public var nomods(get, set):Bool;

		function get_nomods():Bool
			return getnomods();
	
		function set_nomods(nomods:Bool):Bool
			return setnomods(nomods);

		// no flashing settings
		public var noflashing(get, set):Bool;

		function get_noflashing():Bool
			return getnoflashing();
	
		function set_noflashing(noflashing:Bool):Bool
			return setnoflashing(noflashing);

		// splash settings
		public var splash(get, set):Bool;

		function get_splash():Bool
			return getsplash();
	
		function set_splash(splash:Bool):Bool
			return setsplash(splash);

		// light cpu strums settings
		public var cpustrums(get, set):Bool;

		function get_cpustrums():Bool
			return getcpustrums();
		
		function set_cpustrums(cpustrums:Bool):Bool
			return setcpustrums(cpustrums);

		// progress bar settings
		public var timebar(get, set):Bool;

		function get_timebar():Bool
			return gettimebar();
		
		function set_timebar(timebar:Bool):Bool
			return settimebar(timebar);

		// middlescroll settings
		public var middlescroll(get, set):Bool;

		function get_middlescroll():Bool
			return getmiddlescroll();
		
		function set_middlescroll(middlescroll:Bool):Bool
			return setmiddlescroll(middlescroll);

		// wyx remixes settings
		public var wyx(get, set):Bool;

		function get_wyx():Bool
			return getwyx();
		
		function set_wyx(wyx:Bool):Bool
			return setwyx(wyx);

		// clean font settings
		public var cleanfont(get, set):Bool;

		function get_cleanfont():Bool
			return getcleanfont();
		
		function set_cleanfont(cleanfont:Bool):Bool
			return setcleanfont(cleanfont);

		// jamey skin settings
		public var jamey(get, set):Bool;

			function get_jamey():Bool
				return getjamey();
			
			function set_jamey(jamey:Bool):Bool
				return setjamey(jamey);

		// catgirl gf skin settings
		public var catgirl(get, set):Bool;

			function get_catgirl():Bool
				return getcatgirl();
			
			function set_catgirl(catgirl:Bool):Bool
				return setcatgirl(catgirl);
		
		// no hud settings
		public var nohud(get, set):Bool;

			function get_nohud():Bool
				return getnohud();
			
			function set_nohud(nohud:Bool):Bool
				return setnohud(nohud);

		// zoomout settings
		public var zoomout(get, set):Bool;

		function get_zoomout():Bool
			return getzoomout();
	
		function set_zoomout(zoomout:Bool):Bool
			return setzoomout(zoomout);

		// hitsounds settings
		public var hitsounds(get, set):Bool;

		function get_hitsounds():Bool
			return gethitsounds();
	
		function set_hitsounds(hitsounds:Bool):Bool
			return sethitsounds(hitsounds);
	
		// cutscenes settings

		public var cutscenes(get, set):Bool;
	
		function get_cutscenes():Bool
			return getcutscenes();
	
		function set_cutscenes(cutscenes:Bool):Bool
			return setcutscenes(cutscenes);

		// ---- end

		public function setdownscroll(?value:Bool):Bool {
			if (save.data.isdownscroll == null) save.data.isdownscroll = false;
			
			save.data.isdownscroll = !save.data.isdownscroll;
			save.flush();
			return save.data.isdownscroll;
		}
	
		public function getdownscroll():Bool {
			if (save.data.isdownscroll != null) return save.data.isdownscroll;
			return false;
		}

		public function setghosttap(?value:Bool):Bool {
			if (save.data.isghosttap == null) save.data.isghosttap = false;
			
			save.data.isghosttap = !save.data.isghosttap;
			save.flush();
			return save.data.isghosttap;
		}
	
		public function getghosttap():Bool {
			if (save.data.isghosttap != null) return save.data.isghosttap;
			return false;
		}

		public function setpractice(?value:Bool):Bool {
			if (save.data.ispractice == null) save.data.ispractice = false;
			
			save.data.ispractice = !save.data.ispractice;
			save.flush();
			return save.data.ispractice;
		}
	
		public function getpractice():Bool {
			if (save.data.ispractice != null) return save.data.ispractice;
			return false;
		}

		/*public function setpanorama(?value:Bool):Bool {
			if (save.data.ispanorama == null) save.data.ispanorama = false;
			
			save.data.ispanorama = !save.data.ispanorama;
			save.flush();
			return save.data.ispanorama;
		}*/
	
		public function getpanorama():Bool {
			if (save.data.ispanorama != null) return save.data.ispanorama;
			return false;
		}

		public function setnomods(?value:Bool):Bool {
			if (save.data.isnomods == null) save.data.isnomods = false;
			
			save.data.isnomods = !save.data.isnomods;
			save.flush();
			return save.data.isnomods;
		}
	
		public function getnomods():Bool {
			if (save.data.isnomods != null) return save.data.isnomods;
			return false;
		}

		public function setnoflashing(?value:Bool):Bool {
			if (save.data.isnoflashing == null) save.data.noflashing = false;
			
			save.data.isnoflashing = !save.data.isnoflashing;
			save.flush();
			return save.data.isnoflashing;
		}
	
		public function getnoflashing():Bool {
			if (save.data.isnoflashing != null) return save.data.isnoflashing;
			return false;
		}

		public function setsplash(?value:Bool):Bool {
			if (save.data.issplash == null) save.data.issplash = false;
			
			save.data.issplash = !save.data.issplash;
			save.flush();
			return save.data.issplash;
		}
	
		public function getsplash():Bool {
			if (save.data.issplash != null) return save.data.issplash;
			return false;
		}

		public function setcpustrums(?value:Bool):Bool {
			if (save.data.iscpustrums == null) save.data.iscpustrums = false;
			
			save.data.iscpustrums = !save.data.iscpustrums;
			save.flush();
			return save.data.iscpustrums;
		}
	
		public function getcpustrums():Bool {
			if (save.data.iscpustrums != null) return save.data.iscpustrums;
			return false;
		}

		public function settimebar(?value:Bool):Bool {
			if (save.data.istimebar == null) save.data.istimebar = false;
			
			save.data.istimebar = !save.data.istimebar;
			save.flush();
			return save.data.istimebar;
		}
	
		public function gettimebar():Bool {
			if (save.data.istimebar != null) return save.data.istimebar;
			return false;
		}

		public function setmiddlescroll(?value:Bool):Bool {
			if (save.data.ismiddlescroll == null) save.data.ismiddlescroll = false;
			
			save.data.ismiddlescroll = !save.data.ismiddlescroll;
			save.flush();
			return save.data.ismiddlescroll;
		}
	
		public function getmiddlescroll():Bool {
			if (save.data.ismiddlescroll != null) return save.data.ismiddlescroll;
			return false;
		}

		public function setwyx(?value:Bool):Bool {
			if (save.data.iswyx == null) save.data.iswyx = false;
			
			save.data.iswyx = !save.data.iswyx;
			save.flush();
			return save.data.iswyx;
		}
	
		public function getwyx():Bool {
			if (save.data.iswyx != null) return save.data.iswyx;
			return false;
		}

		public function setcleanfont(?value:Bool):Bool {
			if (save.data.iscleanfont == null) save.data.iscleanfont = false;
			
			save.data.iscleanfont = !save.data.iscleanfont;
			save.flush();
			return save.data.iscleanfont;
		}
	
		public function getcleanfont():Bool {
			if (save.data.iscleanfont != null) return save.data.iscleanfont;
			return false;
		}

		public function setjamey(?value:Bool):Bool {
			if (save.data.isjamey == null) save.data.isjamey = false;
			
			save.data.isjamey = !save.data.isjamey;
			save.flush();
			return save.data.isjamey;
		}
	
		public function getjamey():Bool {
			if (save.data.isjamey != null) return save.data.isjamey;
			return false;
		}

		public function setcatgirl(?value:Bool):Bool {
			if (save.data.iscatgirl == null) save.data.iscatgirl = false;
			
			save.data.iscatgirl = !save.data.iscatgirl;
			save.flush();
			return save.data.iscatgirl;
		}
	
		public function getcatgirl():Bool {
			if (save.data.iscatgirl != null) return save.data.iscatgirl;
			return false;
		}

		public function setnohud(?value:Bool):Bool {
			if (save.data.isnohud == null) save.data.isnohud = false;
			
			save.data.isnohud = !save.data.isnohud;
			save.flush();
			return save.data.isnohud;
		}
	
		public function getnohud():Bool {
			if (save.data.isnohud != null) return save.data.isnohud;
			return false;
		}

		public function setzoomout(?value:Bool):Bool {
			if (save.data.iszoomout == null) save.data.iszoomout = false;
			
			save.data.iszoomout = !save.data.iszoomout;
			save.flush();
			return save.data.iszoomout;
		}
	
		public function getzoomout():Bool {
			if (save.data.iszoomout != null) return save.data.iszoomout;
			return false;
		}

		public function sethitsounds(?value:Bool):Bool {
			if (save.data.ishitsounds == null) save.data.ishitsounds = false;
			
			save.data.ishitsounds = !save.data.ishitsounds;
			save.flush();
			return save.data.ishitsounds;
		}
	
		public function gethitsounds():Bool {
			if (save.data.ishitsounds != null) return save.data.ishitsounds;
			return false;
		}

		public function setcutscenes(?value:Bool):Bool {
			if (save.data.cutscenes == null) save.data.cutscenes = true;
			
			save.data.cutscenes = !save.data.cutscenes;
			save.flush();
			return save.data.cutscenes;
		}

		public function getcutscenes():Bool {
			if (save.data.cutscenes != null) return save.data.cutscenes;
			return false;
		}
	
	public function camSave(value:Float):Float {
		if (save.data.cam == null) save.data.cam = 0.06;
		
		save.data.cam = value;
		save.flush();
		return save.data.cam;
	}
	
	public function camLoad():Float {
		if (save.data.cam != null) {
			return save.data.cam;
		}
		else {
			return 0.06;
		}
	}

    public function getcontrolmode():Int {
        // load control mode num from FlxSave
		if (save.data.buttonsmode != null) return save.data.buttonsmode[0];
        return 0;
    }

    public function setcontrolmode(mode:Int = 0):Int {
        // save control mode num from FlxSave
		if (save.data.buttonsmode == null) save.data.buttonsmode = new Array();
        save.data.buttonsmode[0] = mode;
        save.flush();

        return save.data.buttonsmode[0];
    }

    public function savecustom(_pad:FlxVirtualPad) {
		trace("saved");

		if (save.data.buttons == null)
		{
			save.data.buttons = new Array();

			for (buttons in _pad)
			{
				save.data.buttons.push(FlxPoint.get(buttons.x, buttons.y));
			}
		}else
		{
			var tempCount:Int = 0;
			for (buttons in _pad)
			{
				save.data.buttons[tempCount] = FlxPoint.get(buttons.x, buttons.y);
				tempCount++;
			}
		}
		save.flush();
	}

	public function loadcustom(_pad:FlxVirtualPad):FlxVirtualPad {
		//load pad
		if (save.data.buttons == null) return _pad;
		var tempCount:Int = 0;

		for(buttons in _pad)
		{
			buttons.x = save.data.buttons[tempCount].x;
			buttons.y = save.data.buttons[tempCount].y;
			tempCount++;
		}	
        return _pad;
	}

	public function setFrameRate(fps:Int = 60) {
		if (fps < 10) return;
		
		FlxG.stage.frameRate = fps;
		save.data.framerate = fps;
		save.flush();
	}

	public function getFrameRate():Int {
		if (save.data.framerate != null) return save.data.framerate;
		return 60;
	}
}