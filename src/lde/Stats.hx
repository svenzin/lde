package lde ;

import haxe.Timer;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.events.Event;
import openfl.system.System;

class Stats extends TextField
{

	private var times   : Array<Float>;
	private var memPeak : Float = 0;
	
	public function new(X : Float, Y : Float, color : Int) 
	{
		super();
		
		x = X;
		y = Y;
		selectable = false;
		
		defaultTextFormat = new TextFormat("_sans", 12, color);
		
		times = [];
		addEventListener(Event.ENTER_FRAME, onEnter);
		width = 150;
		height = 70;
	}

	private function onEnter(_)
	{	
		var now = Timer.stamp();
		times.push(now);
		
		while (times[0] <= now - 1)
			times.shift();
			
		var mem : Float = Math.round(System.totalMemory / 1024 / 1024 * 100) / 100;
		if (mem > memPeak) memPeak = mem;
		
		if (visible)
		{	
			text = "FPS: " + times.length + "\nMEM: " + mem + " MB\nMEM peak: " + memPeak + " MB";	
		}
	}
	
}