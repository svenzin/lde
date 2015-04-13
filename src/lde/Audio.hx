package lde;

import openfl.Assets;
import openfl.events.Event;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;

class Audio
{
	public static var volume(get, set) : Float;
	
	static var _volume = 1.0;
	static var _transform = new SoundTransform(_volume);
	static function get_volume()
	{
		return _volume;
	}
	static function set_volume(v : Float)
	{
		_volume = Math.max(0.0, Math.min(1.0, v));
		
		_transform = new SoundTransform(_volume);
		for (sc in sounds)
		{
			sc.soundTransform = _transform;
		}
		
		return _volume;
	}

	static var sounds = new Array<SoundChannel>();
	static function cleanup(e : Event)
	{
		sounds.remove(e.target);
	}
	
	public static function load(name : String)
	{
		return function ()
		{
			return Assets.getSound(name);
		};
	}
	
	static var music : SoundChannel = null;
	static var musicSource : Void -> Sound = null;
	static function replay(e : Event)
	{
		music = musicSource().play(0.0, 1, _transform);
		music.addEventListener(Event.SOUND_COMPLETE, replay);
		trace(sounds.length);
	}
	
	public static function playMusic(sound : Void -> Sound)
	{
		if (music != null)
		{
			music.stop();
			sounds.remove(music);
		}
		
		musicSource = sound;
		
		music = musicSource().play(0.0, 1, _transform);
		music.addEventListener(Event.SOUND_COMPLETE, replay);
		sounds.push(music);
		trace(sounds.length);
	}
	
	public static function play(sound : Void -> Sound, start : Float = 0.0, loops : Int = 1)
	{
		var s = sound().play(start, loops, _transform);
		s.addEventListener(Event.SOUND_COMPLETE, cleanup);
		sounds.push(s);
		trace(sounds.length);
	}
}
