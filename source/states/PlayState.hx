package states;

import backend.SongData.Song;

import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import hscript.Interp;
import hscript.Parser;

import openfl.Assets;
import openfl.system.Capabilities;
import openfl.display.BitmapData;

/**
* how was the fall
*/
class PlayState extends FlxState
{
	var interp:Interp;
	var musicPlayer:MusicHandler;
	
	var clover:FlxSprite;
	var cloverYellow:FlxSprite;
	var acid:FlxSprite;
	var infoBG:FlxSprite;
	var updateBG:FlxSprite;

	var debugText:FlxText;
	var infoTxt:FlxText;
	var updateTxt:FlxText;

	var debug:Bool = false;
	var shouldUpdate:Bool = false;
	var currentVersion:Float = 1.0;

	override public function create()
	{
		FlxText.defaultFont = "fonts/DMono.ttf";
		Global.save.bind("CD", "Lego0_77");

		// making it jic
		var data = new haxe.Http("https://raw.githubusercontent.com/Mago0643/Clover-Dance/main/version.txt?token=GHSAT0AAAAAACJFBOU4VZ4AK2EHD34QKP7CZNWVTQQ");
		data.onData = function(data)
		{
			if (currentVersion < Std.parseFloat(data))
			{
				shouldUpdate = true;

				updateBG = new FlxSprite().makeGraphic(Global.width, Global.height, FlxColor.BLACK);
				add(updateBG);

				updateTxt = new FlxText(0, 0, 0, "The App is Updated!\nPress SPACE to Go to a Download Page!", 25);
				updateTxt.alignment = CENTER;
				updateTxt.antialiasing = false;
				updateTxt.screenCenter();
				add(updateTxt);
				return;
			}
		};
		data.onError = function(msg)
		{
			var str = "ERROR WHILE CHECKING UPDATE: " + msg;
			#if sys
			Sys.println(str);
			#else
			trace(str);
			#end
		};

		data.request();

		var songdata = Song.getSongData(AssetPaths.songData__json);
		musicPlayer = new MusicHandler(AssetPaths.Song__ogg, songdata.bpm);

		var cloverCache = BitmapData.fromFile(AssetPaths.cloverDance__png);
		clover = new FlxSprite().loadGraphic(AssetPaths.cloverDance__png, true, Math.floor(cloverCache.width / 7), cloverCache.height);
		clover.animation.add("danceL", [0, 1, 2], 0.745*(songdata.bpm/16), false);
		clover.animation.add("danceR", [3, 4, 5], 0.745*(songdata.bpm/16), false);
		clover.animation.add("idle", [6], 5, true);
		clover.animation.play("idle", true);
		clover.antialiasing = false;
		clover.setGraphicSize(clover.width * 3);
		clover.updateHitbox();
		clover.screenCenter();
		add(clover);

		cloverYellow = new FlxSprite().loadGraphic(AssetPaths.cloverDanceYellow__png, true, Math.floor(cloverCache.width / 7), cloverCache.height);
		cloverYellow.animation.add("danceL", [0, 1, 2], 0.745*(songdata.bpm/16), false);
		cloverYellow.animation.add("danceR", [3, 4, 5], 0.745*(songdata.bpm/16), false);
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

		// making user not jumpscared by music when opened the program
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

		interp = new Interp();
		interp.variables.set("Math", Math);
		interp.variables.set("Global", Global);
		interp.variables.set("clover", clover);
		interp.variables.set("cloverYellow", cloverYellow);
		interp.variables.set("acid", acid);
		interp.variables.set("Lib", openfl.Lib);
		interp.variables.set("FlxTween", FlxTween);
		interp.variables.set("FlxEase", FlxEase);
		interp.variables.set("Desktop", Capabilities);
		interp.variables.set("FlxMath", FlxMath);
		interp.variables.set("songdata", songdata);
		musicPlayer.beatHit = function(){
			interp.variables.set("beat", musicPlayer.beat);
			interp.execute(new Parser().parseString(Assets.getText("assets/data/events.hx")));
		};
		musicPlayer.stepHit = function()
		{
			// this is useless but here you go
			interp.variables.set("step", musicPlayer.step);	
		}

		if (Global.save.data.muted == null) Global.save.data.muted = false;
		if (Global.save.data.volume == null) Global.save.data.volume = 0.5;

		Global.sound.muted = Global.save.data.muted;
		Global.sound.volume = Global.save.data.volume;
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

		if (!shouldUpdate)
		{
			if (Global.keys.justPressed.SPACE && !started && !cannotSpam)
			{
				cannotSpam = true; // doing this to prevent spamming
				FlxTween.tween(infoTxt, {alpha: 0}, musicPlayer.beatSecond, {onComplete: function(f)
					{
						infoTxt.destroy();
						infoBG.destroy();
						musicPlayer.fadeIn(musicPlayer.beatSecond);
						started = true;
					}
				});
				FlxTween.tween(infoBG, {alpha: 0}, musicPlayer.beatSecond);
			}
			
			if (!musicPlayer.playing && started)
			{
				musicPlayer.resetVar();
				musicPlayer.play(true);
			}

			if (debug)
			{
				var s = "Song Time: " + musicPlayer.time + "\nStep: " + musicPlayer.step + "\nBeat: " + musicPlayer.beat;
				debugText.text = s + "\n";
			}

			interp.variables.set("songTime", musicPlayer.time);
			interp.variables.set("musicPlayer", musicPlayer);
		} else {
			if (Global.keys.justPressed.SPACE)
			{
				Global.openURL("https://github.com/Mago0643/Clover-Dance");
				#if sys Sys.exit(0); #end
			}
		}

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

		// secret: you can press esc to force exit
		#if sys
		if (Global.keys.justPressed.ESCAPE)
			Sys.exit(0);
		#end

		super.update(elapsed);
	}
}