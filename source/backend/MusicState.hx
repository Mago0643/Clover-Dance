package backend;

class MusicState extends FlxState
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

  public function new()
  {
    super();
  }

  public function resetVar()
  {
    beat = 0; step = 0;
    stepHit(); beatHit();
  }

  dynamic public function stepHit(){}
  dynamic public function beatHit(){}
  /*public var stepHit:()->Void=function(){};
  public var beatHit:()->Void=function(){};*/

  override function update(elapsed:Float)
  {
    if (Global.sound.music.playing)
    {
      if (Global.sound.music.time/1000 >= beatSecond * beat)
      {
        beat++;
        beatHit();
      }

      if (Global.sound.music.time/1000 >= stepSecond * step)
      {
        step++;
        stepHit();
      }
    }

    super.update(elapsed);
  }  
}