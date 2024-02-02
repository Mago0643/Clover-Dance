package states;

import backend.SongData.Song;

import shaders.FisheyeShader.FisheyeHandler;
import shaders.GlitchShader.GlitchHandler;
import shaders.Glitch2Shader.Glitch2Handler;

#if html5
import js.Browser;
#end

import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxStringUtil;

import hscript.Interp;
import hscript.Parser;

import openfl.Assets;
#if (!html5 && !flash)
import openfl.display.BitmapData;
#end
#if desktop
import openfl.system.Capabilities;
#end

/**
* how was the fall
*/
class PlayState extends MusicState
{
	var interp:Interp;
	
	var clover:FlxSprite;
	var cloverYellow:FlxSprite;
	var acid:FlxSprite;
	var infoBG:FlxSprite;

	var debugText:FlxText;
	var infoTxt:FlxText;

	var glitch2Shader = new Glitch2Handler();
	var glitchShader  = new GlitchHandler();
	var fisheyeShader = new FisheyeHandler();

	var debug:Bool = false;

	override public function create()
	{
		FlxText.defaultFont = "fonts/DMono.ttf";
		Global.save.bind("CD", "Lego0_77");

		var songdata = Song.getSongData(AssetPaths.songData__json);
		bpm = songdata.bpm;

		if (!Assets.exists('assets/music/${songdata.songFile}')) // song Couldn't found
		{
			#if sys
			openfl.Lib.application.window.alert('A Song Couldn\'t Found in\nassets/music/${songdata.songFile}!', 'Fatal Error!');
			#end
			return;
		}

		// doing this cuz haxe is STUPID.
		Global.sound.music = new FlxSound().loadEmbedded('assets/music/${songdata.songFile}', false);

		var cloverCache = new FlxSprite().loadGraphic(AssetPaths.cloverDance__png);
		clover = new FlxSprite().loadGraphic(AssetPaths.cloverDance__png, true, Math.floor(cloverCache.width / 7), Math.floor(cloverCache.height));
		clover.animation.add("danceL", [0, 1, 2], 0.745*(bpm/16), false);
		clover.animation.add("danceR", [3, 4, 5], 0.745*(bpm/16), false);
		clover.animation.add("idle", [6], 5, true);
		clover.animation.play("idle", true);
		clover.antialiasing = false;
		clover.setGraphicSize(clover.width * 3);
		clover.updateHitbox();
		clover.screenCenter();
		add(clover);

		cloverYellow = new FlxSprite().loadGraphic(AssetPaths.cloverDanceYellow__png, true, Math.floor(cloverCache.width / 7), Math.floor(cloverCache.height));
		cloverYellow.animation.add("danceL", [0, 1, 2], 0.745*(bpm/16), false);
		cloverYellow.animation.add("danceR", [3, 4, 5], 0.745*(bpm/16), false);
		cloverYellow.animation.add("idle", [6], 5, true);
		cloverYellow.animation.play("idle", true);
		cloverYellow.antialiasing = false;
		cloverYellow.setGraphicSize(cloverYellow.width * 3);
		cloverYellow.updateHitbox();
		cloverYellow.screenCenter();
		cloverYellow.alpha = 0;
		add(cloverYellow);

		acid = new FlxSprite().loadGraphic(AssetPaths.spr_hydrochlorid_acid__png);
		acid.antialiasing = false;
		acid.setGraphicSize(acid.width * 3);
		acid.updateHitbox();
		acid.screenCenter(X);
		acid.y = Global.height;
		add(acid);

		infoBG = new FlxSprite().makeGraphic(10, 10, FlxColor.GRAY);
		infoBG.alpha = 0.5;
		infoBG.screenCenter();
		add(infoBG);

		Global.camera.filters = [
			new ShaderFilter(fisheyeShader.shader), new ShaderFilter(glitchShader.shader),
			new ShaderFilter(glitch2Shader.shader)
		];

		// making user not jumpscared by music when opened the app
		infoTxt = new FlxText(0, 0, 0, "Press SPACE If you're ready.\nYou Can Change Volume with -, +\nThe Song NEVER Stops Until You close the Program.", 22);
		infoTxt.alignment = CENTER;
		infoTxt.antialiasing = false;
		infoTxt.screenCenter();
		add(infoTxt);
		infoBG.setPosition(infoTxt.x - 10, infoTxt.y - 10);
		infoBG.makeGraphic(Std.int(infoTxt.width + 20), Std.int(infoTxt.height + 20), FlxColor.GRAY);
		
		if (debug)
		{
			debugText = new FlxText(10, 10, Global.width/2-10, "", 16);
			add(debugText);
		}

		#if html5
		Browser.document.body.style.backgroundColor = "black";
		#end
		interp = new Interp();
		interp.variables.set("Math", Math);
		interp.variables.set("Global", Global);
		interp.variables.set("clover", clover);
		interp.variables.set("cloverYellow", cloverYellow);
		interp.variables.set("acid", acid);
		#if !html5
		interp.variables.set("Lib", openfl.Lib);
		#else
		interp.variables.set("document", Browser.document);
		#end
		interp.variables.set("FlxTween", FlxTween);
		interp.variables.set("FlxEase", FlxEase);
		#if desktop
		interp.variables.set("Desktop", Capabilities);
		#end
		interp.variables.set("FlxMath", FlxMath);
		interp.variables.set("fisheye", fisheyeShader);
		interp.variables.set("glitch2", glitch2Shader);
		interp.variables.set("glitch", glitchShader);
		interp.variables.set("songdata", songdata);

		if (Global.save.data.muted == null) Global.save.data.muted = false;
		if (Global.save.data.volume == null) Global.save.data.volume = 0.5;

		Global.sound.muted = Global.save.data.muted;
		Global.sound.volume = Global.save.data.volume;
		// PREVENTING JUMPSCARES
		Global.sound.music.volume = 0;
		// musicPlayer.volume = Global.save.data.volume;
		Global.mouse.useSystemCursor = true;
		Global.autoPause = false;

		var str = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n* See that heart?\n  No Shit!\n\n\n\n\n\n\n\n\n\n\n\n"+
		"\n--------SONG INFO--------"+
		"\nSong: " + songdata.artist + " - " + songdata.title +
		"\nBPM: " + songdata.bpm;
		
		#if sys
		Sys.println(str+"\n");
		#else
		trace(str+"\n");
		#end
		// this makes window scaling goes werid
		/*Global.drawFramerate = 240;
		Global.updateFramerate = 240;*/
		super.create();

		// show the volume tray
		Global.sound.changeVolume(0);
	}

	// fnf reference LOLLLOLLOLLOL
	override function beatHit()
	{
		interp.variables.set("beat", beat);
		#if !html5
		var path = "assets/data/events.hx";
		#else
		var path = "assets/data/eventsHTML.hx";
		#end
		interp.execute(new Parser().parseString(Assets.getText(path)));
	}

	override function stepHit()
	{
		// this is useless but here you go
		interp.variables.set("step", step);	
	}

	var started:Bool = false;
	var cannotSpam:Bool = false;
	var timer:Float = 0;

	override public function update(elapsed:Float)
	{
		/*timer += elapsed;

		if (timer >= 1)
		{
			timer = 0;
			var str = "FPS: " + Main.fps.currentFPS;
			#if sys
			Sys.println(str);
			#else
			trace(str);
			#end
		}*/

		#if html5
		var style = Browser.document.getElementById('openfl-content').style;
		style.position = "relative";
		style.left = ((Browser.window.outerWidth - 640) / 2) + "px";
		style.top = ((Browser.window.outerHeight - 550) / 2) + "px";
		#end

		if (Global.keys.justPressed.SPACE && !started && !cannotSpam)
		{
			cannotSpam = true; // doing this to prevent spamming
			FlxTween.tween(infoTxt, {alpha: 0}, beatSecond, {onComplete: function(f)
				{
					infoTxt.destroy();
					infoBG.destroy();
					Global.sound.music.fadeIn(beatSecond);
					started = true;
				}
			});
			FlxTween.tween(infoBG, {alpha: 0}, beatSecond);
		}
			
		if (!Global.sound.music.playing && started)
		{
			resetVar();
			Global.sound.music.play(true);
		}

		#if debug
			Global.watch.addQuick("Current Song Time", FlxStringUtil.formatTime(Global.sound.music.time / 1000));
			Global.watch.addQuick("Current Step", step);
			Global.watch.addQuick("Current Beat", beat);
			Global.watch.addQuick("Beat To Seconds", beatSecond);
			Global.watch.addQuick("Step To Seconds", stepSecond);
		#end

		if (debug)
		{
			var s = "Song Time: " + Global.sound.music.time + "\nStep: " + step + "\nBeat: " + beat;
			debugText.text = s + "\n";
		}

		interp.variables.set("songTime", Global.sound.music.time);
		interp.variables.set("musicPlayer", this);

		Global.sound.volumeHandler = function(volume:Float)
		{
			Global.save.data.volume = volume;
			Global.save.flush();
		}

		if (Global.keys.anyJustPressed(Global.sound.muteKeys))
		{
			Global.save.data.muted = Global.sound.muted;
			Global.save.flush();
		}

		// secret: you can press esc to force exit (just in case for window's stuck in outside of desktop)
		#if sys
		if (Global.keys.justPressed.ESCAPE)
			Sys.exit(0);
		#end

		super.update(elapsed);
	}
}