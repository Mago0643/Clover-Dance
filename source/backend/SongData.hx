package backend;

import openfl.Assets;

import haxe.Json;

typedef SongData = {
  var title:String;
  var artist:String;
  var bpm:Float;
}

class Song
{
  public static function getSongData(id:String):SongData
  {
    return cast Json.parse(Assets.getText(id));
  }
}