package shaders;

class GlitchHandler
{
  public var shader(default,never) = new GlitchShader();
  public var shift(default,set):Float = 0;
  function set_shift(f) {
    shift = f;
    shader.shift.value=[f];
    return f;
  }

  public function new(){shader.shift.value=[0];}
}

// by me
class GlitchShader extends FlxShader
{
  @:glFragmentSource('
  #pragma header

  uniform float shift;

  void main()
  {
    vec2 u = openfl_TextureCoordv;
    vec4 tex = texture2D(bitmap, u);
    if (shift != 0.0)
    {
      tex.r = texture2D(bitmap, vec2(u.x-shift,u.y)).r;
      tex.b = texture2D(bitmap, vec2(u.x+shift,u.y)).b;
    }
    gl_FragColor = tex;
  }')
  public function new(){super();}
}