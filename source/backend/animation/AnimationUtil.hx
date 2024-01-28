package backend.animation;

import flixel.animation.FlxAnimationController;

/**
* An `FlxSprite`'s Animation Helper.
*/
class AnimationUtil
{
  /**
  * Same as `animation.addByIndices`, But you can put Float in Framerate.
  */
  public static function addByIndicesF(Sprite:FlxAnimationController, Name:String, Prefix:String, Indices:Array<Int>, Postfix:String, FrameRate:Float = 30, Looped:Bool = true, FlipX:Bool = false, FlipY = false)
  {
    Sprite.addByIndices(Name, Prefix, Indices, Postfix, 0, Looped, FlipX, FlipY);
  }

  /**
  * Same as `animation.addByPrefix`, But you can put Float in Framerate.
  */
  public static function addByPrefixF(Sprite:FlxAnimationController, Name:String, Prefix:String, FrameRate:Float = 30, Looped:Bool = true, FlipX:Bool = false, FlipY = false)
  {
    Sprite.addByPrefix(Name, Prefix, 0, Looped, FlipX, FlipY);
  }

  /**
  * Same as `animation.addByNames`, but you can put Float in Framerate.
  */
  public static function addByNamesF(Sprite:FlxAnimationController, Name:String, FrameNames:Array<String>, FrameRate:Float = 30, Looped:Bool = true, FlipX:Bool = false, FlipY = false)
  {
    Sprite.addByNames(Name, FrameNames, 0, Looped, FlipX, FlipY);
  }

  /**
  * Same as `animation.addByStringIndices`, but you can put Float in Framerate.
  */
  public static function addByStringIndicesF(Sprite:FlxAnimationController, Name:String, Prefix:String, Indices:Array<String>, Postfix:String, FrameRate:Float = 30, Looped:Bool = true, FlipX:Bool = false, FlipY = false)
  {
    Sprite.addByStringIndices(Name, Prefix, Indices, Postfix, 0, Looped, FlipX, FlipY);
  }

  /**
  * Returns an `FlxAnimation` Type by Name.
  */
  public static function findAnimationByName(Sprite:FlxAnimationController, Name:String)
  {
    @:privateAccess
    return Sprite._animations.get(Name);
  }

  /**
  * Sets an Framerate to Existing Animation.
  */
  public static function setFramerate(Sprite:FlxAnimationController, Name:String, FrameRate:Float = 1)
  {
    @:privateAccess
    if (Sprite._animations.get(Name) != null)
    {
      Sprite._animations.get(Name).frameRate = FrameRate;

      var found = false;
      for (i in 0...animOGFrames.length)
      {
        if (animOGFrames[i][0] == Sprite._animations.get(Name))
        {
          animOGFrames[i] = [Sprite._animations.get(Name), FrameRate];
          found = true;
          break;
        }
      }
      
      if (!found) animOGFrames.push([Sprite._animations.get(Name), FrameRate]);
    } else {
      Global.log.warn("Cannot Find Animation With Name: " + Name);
      return;
    }
  }

  static var animOGFrames:Array<Array<Dynamic>> = [];
  /**
  * Sets Animation's Rate.
  *
  * (This is NOT same as `setFramerate`!!1)
  */
  public static function rate(Sprite:FlxAnimationController, Name:String, Rate:Float = 1)
  {
    @:privateAccess
    {
      var anim = Sprite._animations.get(Name);
      if (anim != null)
      {
        var found = false;
        for (i in 0...animOGFrames.length)
        {
          if (animOGFrames[i][0] == anim)
          {
            Sprite._animations.get(Name).frameRate = animOGFrames[i][1] * Rate;
            found = true;
            break;
          }
        }
        
        if (!found)
        {
          animOGFrames.push([anim, anim.frameRate]);
          Sprite._animations.get(Name).frameRate *= Rate;
        }
      } else {
        Global.log.warn("Cannot Find Animation With Name: " + Name);
        return;
      }
    }
  }
}