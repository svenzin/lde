package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import lde.Keys;
import openfl.events.EventDispatcher;
import openfl.events.KeyboardEvent;
import openfl.text.TextField;
import openfl.ui.Keyboard;

import lde.Stats;
/**
 * ...
 * @author scorder
 */

class Main extends Sprite 
{
	var inited:Bool;

	/* ENTRY POINT */
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	var kbd : Keys = new Keys();
	var stats : Stats = new Stats(10, 10, 0xFFFFFF);
	
		var t : TextField = new TextField();
	function init() 
	{
		if (inited) return;
		inited = true;

		// (your code here)
		addEventListener(Event.ENTER_FRAME, step);
		
		kbd.addEventListener(Keys.CONSOLE, switchConsole);
		
		t.x = 200;
		t.y = 10;
		t.width = 400;
		t.height = 20;
		t.textColor = 0xFFFFFF;
		addChild(t);
		// Stage:
		// stage.stageWidth x stage.stageHeight @ stage.dpiScale
		
		// Assets:
		// nme.Assets.getBitmapData("img/assetname.jpg");
	}

	
	var on : Bool = false;
	function switchConsole(_) { if (!on) { addChild(stats); on = true; } else { removeChild(stats); on = false; } }
	
	function step(_)
	{
		t.text = "";
		for (i in 0...255)
			if (kbd.isKeyDown(i))
				t.text = t.text + " " + i;
	}

	/* SETUP */

	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
