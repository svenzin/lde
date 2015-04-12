package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import haxe.Timer;
import lde.*;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.display.Tilesheet;
import openfl.events.EventDispatcher;
import openfl.events.KeyboardEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.ui.Keyboard;

import lde.Stats;
/**
 * ...
 * @author scorder
 */

class TilerCharacter extends Tiler
{
	static public var IDLE   = Id.get();
	static public var WALK_R = Id.get();
	static public var WALK_L = Id.get();
	static public var GRAB_R = Id.get();
	static public var GRAB_L = Id.get();
	static public var DEATH  = Id.get();
	
	public function new()
	{
		super(Assets.getBitmapData("gfx/Character.png"));
		slice([0, 0], [28, 28], [4, 6]);
		register(IDLE,   [  0,  1,  2,  3 ]);
		register(WALK_R, [  4,  5,  6,  7 ]);
		register(WALK_L, [  8,  9, 10, 11 ]);
		register(GRAB_R, [ 12, 13, 14, 15 ]);
		register(GRAB_L, [ 16, 17, 18, 19 ]);
		register(DEATH,  [ 20, 21, 22, 23 ]);
	}
}
class TilerArrow extends Tiler
{
	static public var ARROW_UP       = Id.get();
	static public var ARROW_ROTATION = Id.get();
	
	public function new()
	{
		super(Assets.getBitmapData("gfx/arrow.png"));
		slice([0, 0], [16, 16], [8, 1]);
		register(ARROW_UP, [ 0 ]);
		register(ARROW_ROTATION, [ 0, 1, 2, 3, 4, 5, 6, 7 ]);
	}
}
class Gfx extends Sprite
{
	var tiler : Tiler;
	public function new()
	{
		super();
		
		tiler = new TilerCharacter();
	}
	
	public function getAnimation(id : Int) : TiledAnimation
	{
		var a = new TiledAnimation();
		a.id = id;
		a.indices = tiler.get(id);
		return a;
	}
	
	public var viewport : Rectangle;
	var data : Array<Float> = new Array();
	
	public function draw(entities : Array<Entity>)
	{
		var active = entities
			.filter(function (e) return (e.animation != null))
			.filter(function (e) return (viewport.left - 50 <= e.x && e.x <= viewport.right  + 50))
			.filter(function (e) return (viewport.top  - 50 <= e.y && e.y <= viewport.bottom + 50));
		
		for (e in active)
		{
			e.animation.update();
			data = data.concat([e.x - viewport.x, e.y - viewport.y, e.animation.get()]);
		}
	}
	
	public function render()
	{
		graphics.clear();
		tiler.sheet.drawTiles(this.graphics, data);
		data = new Array();
	}
}

class Level
{
	var size = [ 34, 19 ];
	var level = [
[12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12],
[12,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,12],
[12,6,0,0,2,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,12],
[12,6,0,0,7,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,12],
[12,6,0,0,5,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,12],
[12,6,0,0,5,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,12],
[12,6,0,0,7,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,12],
[12,6,0,0,7,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,12],
[12,8,3,0,7,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,12],
[12,6,0,0,7,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,12],
[12,6,0,0,7,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,12],
[12,6,0,2,11,8,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,12],
[12,6,0,0,0,7,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,12],
[12,8,3,0,0,7,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,12],
[12,0,0,0,2,11,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,3,0,0,0,0,0,0,0,0,0,14,12],
[12,1,1,1,11,12,8,1,1,3,0,2,3,0,0,2,3,0,0,0,2,11,8,3,0,0,0,0,2,1,1,1,1,12],
[12,12,12,12,12,12,12,12,12,6,0,7,6,0,0,7,6,0,0,0,7,12,12,6,0,0,0,0,7,12,12,12,12,12],
[12,12,12,12,12,12,12,12,12,6,0,7,6,0,0,7,6,0,0,0,7,12,12,6,0,0,0,0,7,12,12,12,12,12],
[12,12,12,12,12,12,12,12,12,6,13,7,6,13,13,7,6,13,13,13,7,12,12,6,13,13,13,13,7,12,12,12,12,12],
	];
	
	var tiler : Tiler;
	public function new()
	{
		tiler = new Tiler(Assets.getBitmapData("gfx/Level.png"));
		tiler.slice([0, 0], [32, 32], [4, 4]);
	}
	
	public var data = new Array<Float>();
	public var viewport = new Rectangle(0, 0, 960, 540);
	public function render(graphics : Graphics)
	{
		var ix0 = Math.floor(viewport.left / 32);
		var iy0 = Math.floor(viewport.top / 32);
		var ix1 = Math.ceil(viewport.right / 32);
		var iy1 = Math.ceil(viewport.bottom / 32);
		
		if (ix0 < 0) ix0 = 0;
		if (ix1 > size[0]) ix1 = size[0];
		if (iy0 < 0) iy0 = 0;
		if (iy1 > size[1]) iy1 = size[1];
		
		var count = 3 * (ix1 - ix0) * (iy1 - iy0);
		if (data.length < count)
		{
			//trace("increase by " + (count - data.length));
			data[count - 1] = 0.0;
		}
		if (data.length > count)
		{
			//trace("reduce by " + (data.length - count));
			data.splice(count, data.length);
		}
		
		var index = 0;
		for (y in iy0...iy1)
		{
			for (x in ix0...ix1)
			{
				data[index] = 32 * x - viewport.left;
				data[index + 1] = 32 * y - viewport.top;
				data[index + 2] = level[y][x];
				index += 3;
			}
		}
		tiler.sheet.drawTiles(graphics, data);
	}
}

class Main extends Sprite 
{
	var inited:Bool;

	/* ENTRY POINT */
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	var gfx : Gfx;
	var kbd : Keys;
	
	var stats : Stats = new Stats(10, 10, Colors.GREY_75);
	
	var t : TextField = new TextField();
	function init() 
	{
		if (inited) return;
		inited = true;

		// (your code here)
		Watch.init();
		
		kbd = new Keys();
		kbd.addEventListener(Keys.CONSOLE, switchConsole);
		
		gfx = new Gfx();
		addChild(gfx);
		
		Lib.current.stage.color = Colors.GREY_25;
		
		addEventListener(Event.ENTER_FRAME, step);
		
		
		t.x = 200;
		t.y = 10;
		t.width = 400;
		t.height = 20;
		t.textColor = Colors.GREY_75;
		addChild(t);
		
		chr.x = 200;
		chr.y = 200;
		chr.animation = gfx.getAnimation(TilerCharacter.IDLE);
		chr.animation.start(16);
	}

	
	var on : Bool = false;
	function switchConsole(_) { if (!on) { addChild(stats); on = true; } else { removeChild(stats); on = false; } }
	
	var id : Int = 0;
	var f : Bool = true;
	var lvl = new Level();
	var chr = new Entity();
	var viewport = new Rectangle(0, 0, 960, 540);
	function step(_)
	{
		if (kbd.isKeyDown(Keyboard.LEFT))
		{
			chr.x -= 2;
			viewport.x -= 2;
			if (chr.animation.id != TilerCharacter.WALK_L)
			{
				chr.animation = gfx.getAnimation(TilerCharacter.WALK_L);
				chr.animation.start(8);
			}
		}
		else if (kbd.isKeyDown(Keyboard.RIGHT))
		{
			chr.x += 2;
			viewport.x += 2;
			if (chr.animation.id != TilerCharacter.WALK_R)
			{
				chr.animation = gfx.getAnimation(TilerCharacter.WALK_R);
				chr.animation.start(8);
			}
		}
		else
		{
			if (chr.animation.id != TilerCharacter.IDLE)
			{
				chr.animation = gfx.getAnimation(TilerCharacter.IDLE);
				chr.animation.start(16);
			}
		}
		if (kbd.isKeyDown(Keyboard.UP))
		{
			viewport.y -= 1;
		}
		else if (kbd.isKeyDown(Keyboard.DOWN))
		{
			viewport.y += 1;
		}
		if (kbd.isKeyChanged(Keyboard.SPACE))
		{
			chr.animation = gfx.getAnimation(TilerCharacter.DEATH);
			chr.animation.start(16);
		}
		
		gfx.viewport = viewport;
		gfx.draw([chr]);
		gfx.render();
		lvl.viewport = viewport;
		lvl.render(gfx.graphics);
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
