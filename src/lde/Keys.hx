package lde ;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.KeyboardEvent;
import openfl.Lib;
import openfl.ui.Keyboard;

class Keys extends EventDispatcher
{
	public function isKeyDown(key : Int) : Bool { return isDown[key]; }
	public function isKeyPushed(key : Int) : Bool { return isChanged[key]; }
	
	public function remap(event : String, key : Int)
	{
		for (key in keyMap.keys())
		{
			if (keyMap[key] == event) keyMap.remove(key);
		}
		keyMap[key] = event;
	}
	
	var keyMap : Map<Int, String>;
	var isDown : Array<Bool>;
	var isChanged : Array<Bool>;
	var isChangedAccumulator : Array<Bool>;
	
	public function new()
	{
		super();
		
		isDown = new Array();
		isChangedAccumulator = new Array();
		isChanged = new Array();
		
		keyMap = new Map();
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, step, false, 1);
	}
	
	function step(_)
	{
		isChanged = isChangedAccumulator;
		isChangedAccumulator = new Array();
	}
	
	function keyDown(e : KeyboardEvent)
	{
		if (!isDown[e.keyCode])
		{
			isDown[e.keyCode] = true;
			isChangedAccumulator[e.keyCode] = true;
		}
		
		for (key in keyMap.keys())
		{
			if (isChangedAccumulator[key]) dispatchEvent(new KeyboardEvent(keyMap[key]));
		}
	}
	
	function keyUp(e : KeyboardEvent)
	{
		if (isDown[e.keyCode])
		{
			isDown[e.keyCode] = false;
		}
	}
}
