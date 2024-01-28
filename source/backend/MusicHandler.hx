package backend;

class MusicHandler extends FlxSound
{
  public var bpm(default,set):Float = 120;
  function set_bpm(f:Float) {
    bpm = f;
    beatSecond = 60 / f;
    stepSecond = beatSecond / 4;
    return f;
  }

  public var beatSecond(default,null):Float = 0.5;
  public var stepSecond(default,null):Float = 0.125;

  public var beat(default,null):Int = 0;
  public var step(default,null):Int = 0;

  public function new(music:String, bpm:Float)
  {
    super();
    loadEmbedded(music);
    this.bpm = bpm;
    Global.sound.list.add(this);
  }

  public function resetVar()
  {
    beat = 0; step = 0;
    stepHit(); beatHit();
  }

  override function play(ForceRestart:Bool = false, StartTime:Float = 0.0, ?EndTime:Float):FlxSound
  {
    if (ForceRestart) resetVar();
    return super.play(ForceRestart, StartTime, EndTime);
  }

  /*dynamic public function stepHit(){}
  dynamic public function beatHit(){}*/
  public var stepHit:()->Void=function(){};
  public var beatHit:()->Void=function(){};

  override function update(elapsed:Float)
  {
    if (playing)
    {
      if (time/1000 >= beatSecond * beat)
      {
        beat++;
        beatHit();
      }

      if (time/1000 >= stepSecond * step)
      {
        step++;
        stepHit();
      }
    }

    super.update(elapsed);
  }
}