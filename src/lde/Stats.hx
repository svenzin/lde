package lde ;

import haxe.Timer;
import openfl.Assets;
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
		
		embedFonts = true;
		defaultTextFormat = new TextFormat(Assets.getFont("fonts/bored6x8.ttf").fontName, 16, color);
		
		times = [];
		addEventListener(Event.ENTER_FRAME, onEnter);
		width = 200;
		height = 64;
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
			text = "Fps:  " + times.length + "\n" +
			       "Mem:  " + mem + " MB\n" +
				   "Peak: " + memPeak + " MB";	
		}
	}
	
}