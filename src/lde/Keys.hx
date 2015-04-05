package lde ;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

/**
 * ...
 * @author scorder
 */
class Keys extends EventDispatcher
{
	static public var CONSOLE : String = "CONSOLE";
	static public var UP    : String = "UP";
	static public var DOWN  : String = "DOWN";
	static public var LEFT  : String = "LEFT";
	static public var RIGHT : String = "RIGHT";
	static public var START : String = "START";
	
	public function isKeyDown(key : Int) : Bool { return isDown[key]; }
	public function isKeyChanged(key : Int) : Bool { return isChanged[key]; }
	
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
	
	function new()
	{
		super();
		
		isDown = new Array();
		isChanged = new Array();
		
		keyMap = new Map();
		remap(CONSOLE, 223);
		remap(UP, Keyboard.UP);
		remap(DOWN, Keyboard.UP);
		remap(LEFT, Keyboard.DOWN);
		remap(LEFT, Keyboard.LEFT);
		remap(RIGHT, Keyboard.RIGHT);
		remap(START, Keyboard.ENTER);
		
		flash.Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		flash.Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		flash.Lib.current.stage.addEventListener(Event.EXIT_FRAME, step);
	}
	
	function step(_)
	{
		isChanged = new Array();
	}
	
	function keyDown(e : KeyboardEvent)
	{
		if (!isDown[e.keyCode])
		{
			isDown[e.keyCode] = true;
			isChanged[e.keyCode] = true;
		}
		
		for (key in keyMap.keys())
		{
			if (isChanged[key]) dispatchEvent(new KeyboardEvent(keyMap[key]));
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
