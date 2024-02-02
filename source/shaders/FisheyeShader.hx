package shaders;

class FisheyeHandler
{
  public var shader(default,never) = new FisheyeShader();
  /**
  * This Controlls Fisheye's Amplifier.
  */
  public var amp(default,set):Float = 0;
  function set_amp(f) {
    shader.amp.value=[f];
    amp = f;
    return f;
  }
  public function new(){shader.amp.value=[0];}
}

// shader by https://www.shadertoy.com/view/4s2GRR
class FisheyeShader extends FlxShader
{
  @:glFragmentSource('
  #pragma header

  uniform float amp;

  //Inspired by http://stackoverflow.com/questions/6030814/add-fisheye-effect-to-images-at-runtime-using-opengl-es
  void main()//Drag mouse over rendering area
  {
    vec2 p = gl_FragCoord.xy / openfl_TextureSize.x;//normalized coords with some cheat
                                                            //(assume 1:1 prop)
    float prop = openfl_TextureSize.x / openfl_TextureSize.y;//screen proroption
    vec2 m = vec2(0.5, 0.5 / prop);//center coords
    vec2 d = p - m;//vector from center to current fragment
    float r = sqrt(dot(d, d)); // distance of pixel from center

    float power = ( 2.0 * 3.141592 / (2.0 * sqrt(dot(m, m))) ) * amp;//amount of effect

    float bind;//radius of 1:1 effect
    if (power > 0.0) bind = sqrt(dot(m, m));//stick to corners
    else {if (prop < 1.0) bind = m.x; else bind = m.y;}//stick to borders

    //Weird formulas
    vec2 uv;
    if (power > 0.0)//fisheye
      uv = m + normalize(d) * tan(r * power) * bind / tan( bind * power);
    else if (power < 0.0)//antifisheye
      uv = m + normalize(d) * atan(r * -power * 10.0) * bind / atan(-power * bind * 10.0);
    else uv = p;//no effect for power = 1.0
    if (amp == 0.0) // fix stupid blurry thing
      gl_FragColor = texture2D(bitmap, openfl_TextureCoordv);
    else
      gl_FragColor = texture2D(bitmap, vec2(uv.x, -uv.y * prop));
  }')
  public function new(){super();}
}