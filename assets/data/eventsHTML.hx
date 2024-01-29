var excludes = [7, 8, 31, 32, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 87, 88];
if (excludes.indexOf(beat) == -1)
{
  clover.animation.play(musicPlayer.beat % 2 == 0 ? "danceL" : "danceR", true);
  cloverYellow.animation.play(musicPlayer.beat % 2 == 0 ? "danceL" : "danceR", true);
  // Lib.application.window.title = (musicPlayer.beat % 2 == 0 ? "(/'-')/" : "\\('-'\\)");
  document.title = (musicPlayer.beat % 2 == 0 ? "(/'-')/" : "\\('-'\\)");
} else {
  clover.animation.play("idle", true);
  cloverYellow.animation.play("idle", true);
  document.title = "('-')";
}

if (beat == 57)
{
  FlxTween.tween(cloverYellow, {alpha: 1}, musicPlayer.beatSecond*6, {ease: FlxEase.linear});
  FlxTween.tween(acid, {y: (Global.height - acid.height) / 2 + 20}, musicPlayer.beatSecond*6, {ease: FlxEase.circOut, onComplete: function(f)
    {
      FlxTween.tween(acid, {angle: 360*5, alpha: 0}, musicPlayer.beatSecond*2, {ease: FlxEase.circIn, onComplete: function(t)
        {
          acid.angle = 0;
          acid.alpha = 1;
          acid.y = Global.height;
          FlxTween.tween(cloverYellow, {alpha: 0}, musicPlayer.beatSecond*8, {ease: FlxEase.circOut});
        }
      });
    }
  });
}

// do the cute jump
var EEK = [8, 32, 88];
if (EEK.indexOf(beat) != -1)
{
  FlxTween.tween(clover, {y: (Global.height - clover.height) / 2 - 100}, musicPlayer.beatSecond/2, {ease: FlxEase.quadOut, onComplete: function(f)
    {
      FlxTween.tween(clover, {y: (Global.height - clover.height) / 2}, musicPlayer.beatSecond/2, {ease: FlxEase.quadIn});
    }
  });

  clover.angle = -360;
  FlxTween.tween(clover, {angle: 0}, musicPlayer.beatSecond, {ease: FlxEase.quadOut});
}