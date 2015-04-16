package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import haxe.Timer;
import lde.*;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.display.Tilesheet;
import openfl.events.EventDispatcher;
import openfl.events.KeyboardEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
import openfl.text.TextField;
import openfl.ui.Keyboard;

import lde.Stats;
/**
 * ...
 * @author scorder
 */

class Ctrl
{
	static public var EVENT_CONSOLE : String = "CONSOLE";
	static public var EVENT_VOLUME_UP : String = "VOLUME_UP";
	static public var EVENT_VOLUME_DOWN : String = "VOLUME_DOWN";
	
	static public var KEY_CONSOLE = 223;
	static public var KEY_VOLUME_UP = Keyboard.PAGE_UP;
	static public var KEY_VOLUME__DOWN = Keyboard.PAGE_DOWN;
	
	static public var P1_UP    = Keyboard.UP;
	static public var P1_DOWN  = Keyboard.DOWN;
	static public var P1_LEFT  = Keyboard.LEFT;
	static public var P1_RIGHT = Keyboard.RIGHT;
	static public var P1_START = Keyboard.ENTER;
}
class Sfx
{
	public static var BGM  = Audio.load("sfx/bgm.mp3");
	public static var JUMP = Audio.load("sfx/jump.mp3");
}
class Chr extends Tiler
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
class Menu extends Tiler
{
	static public var PLAY_NORMAL   = Id.get();
	static public var PLAY_SELECTED = Id.get();
	static public var TITLE         = Id.get();
	
	public function new()
	{
		super(Assets.getBitmapData("gfx/MainMenu.png"));
		slice([0,   0], [160,  64], [1, 1]);
		slice([0,  64], [160,  64], [1, 1]);
		slice([0, 128], [640, 128], [1, 1]);
		register(PLAY_NORMAL, [ 0 ]);
		register(PLAY_SELECTED, [ 1 ]);
		register(TITLE, [ 2 ]);
	}
}


class Level implements ICustomRenderer
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
	
	public var extent : Rectangle;
	public var platforms : Array<Entity> = new Array<Entity>();
	
	var tiler : Tiler;
	public function new()
	{
		extent = new Rectangle(0, 0, size[0] * 32, size[1] * 32);
		
		tiler = new Tiler(Assets.getBitmapData("gfx/Level.png"));
		tiler.slice([0, 0], [32, 32], [4, 4]);
		
		for (y in 0...size[1])
		{
			for (x in 0...size[0])
			{
				var type = level[y][x];
				if (1 <= type && type <= 13)
				//if (type == 1)
				{
					var e = new Entity();
					e.x = 32 * x;
					e.y = 32 * y;
					e.box = new Rectangle(0, 0, 32, 32);
					platforms.push(e);
				}
			}
		}
	}
	
	public var data = new Array<Float>();
	public function render(graphics : Graphics)
	{
		var ix0 = Math.floor(Lde.viewport.left / 32);
		var iy0 = Math.floor(Lde.viewport.top / 32);
		var ix1 = Math.ceil(Lde.viewport.right / 32);
		var iy1 = Math.ceil(Lde.viewport.bottom / 32);
		
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
				data[index] = Math.round(32 * x - Lde.viewport.left);
				data[index + 1] = Math.round(32 * y - Lde.viewport.top);
				data[index + 2] = level[y][x];
				index += 3;
			}
		}
		tiler.sheet.drawTiles(graphics, data);
	}
}
class LevelOne extends Chapter
{
	public function new()
	{}
	
	public override function quit()
	{}
	
	public override function start()
	{
		Lib.current.stage.color = Colors.GREY_25;
		
		Lde.gfx.tilers = [ new Chr() ];
		
		Audio.volume = 0.0;
		Audio.playMusic(Sfx.BGM);
		
		chr = new Entity();
		chr.x = 32;
		chr.y = 452;
		chr.box = new Rectangle(8, 8, 12, 19);
		chr.animation = Lde.gfx.getAnim(Chr.IDLE);
		chr.animation.start(16);
		
		old = new Point(chr.x, chr.y);
		old2 = old.clone();
		
		lvl = new Level();
		
		Lde.phx.entities = lvl.platforms.concat([ chr ]);
		Lde.gfx.entities = [ chr ];
		Lde.gfx.custom = [ lvl ];
		//Lde.phx.entities = [ chr ];
	}
	
	public var chr : Entity;
	public var lvl : Level;
	
	var old : Point;
	var old2 : Point;
	var g : Float = 0.3;
	public override function step()
	{
		//if (Lde.keys.isKeyPushed(Keyboard.SPACE)){
		if (true){
		
		var delta = new Point();
		old2.x = old.x;
		old2.y = old.y;
		old.x = chr.x;
		old.y = chr.y;
		
		if (Lde.keys.isKeyDown(Ctrl.P1_LEFT))
		{
			delta.x = -1.5;
			if (chr.animation.id != Chr.WALK_L)
			{
				chr.animation = Lde.gfx.getAnim(Chr.WALK_L);
				chr.animation.start(8);
			}
		}
		else if (Lde.keys.isKeyDown(Ctrl.P1_RIGHT))
		{
			delta.x = 1.5;
			if (chr.animation.id != Chr.WALK_R)
			{
				chr.animation = Lde.gfx.getAnim(Chr.WALK_R);
				chr.animation.start(8);
			}
		}
		else
		{
			if (chr.animation.id != Chr.IDLE)
			{
				chr.animation = Lde.gfx.getAnim(Chr.IDLE);
				chr.animation.start(16);
			}
		}
		if (Lde.keys.isKeyPushed(Ctrl.P1_UP))
		{
			Audio.play(Sfx.JUMP);
			delta.y -= 5;
		}
		else if (Lde.keys.isKeyPushed(Ctrl.P1_DOWN))
		{
		}
		
		//if (old.y != old2.y) trace([ old.y, old2.y ]);
		delta.y += g + old.y - old2.y;
		
		chr.y += delta.y;
		//Lde.phx.step();
		var hits = Lde.phx.hits(chr);
		if (hits.length > 0)
		{
			var f = function (e : Entity) : Rectangle { var r = e.box.clone(); r.offset(e.x, e.y); return r; };
			//var or = f(chr);
			//or.offset(old.x - chr.x, old.y - chr.y);
			//trace(or);
			//if (delta.y < 0) trace([ chr ].concat(hits).map(function (e) { var r = e.box.clone(); r.offset(e.x, e.y); return r; } ));
			chr.y = old.y;
		}

		chr.x += delta.x;
		//Lde.phx.step();
		
		var hits = Lde.phx.hits(chr);
		if (hits.length > 0)
		{
			var f = function (e : Entity) : Rectangle { var r = e.box.clone(); r.offset(e.x, e.y); return r; };
			//var or = f(chr);
			//or.offset(old.x - chr.x, old.y - chr.y);
			//trace(or);
			//trace([ chr ].concat(hits).map(function (e) { var r = e.box.clone(); r.offset(e.x, e.y); return r; } ));
			chr.x = old.x;
		}
		
		// Center on character
		Lde.viewport.x = chr.x - Lde.viewport.width / 2;
		Lde.viewport.y = chr.y - Lde.viewport.height / 2;
		
		// Clamp to level extent
		if (Lde.viewport.left < lvl.extent.left) Lde.viewport.x += lvl.extent.left - Lde.viewport.left;
		if (Lde.viewport.top < lvl.extent.top) Lde.viewport.y += lvl.extent.top - Lde.viewport.top;
		if (Lde.viewport.right > lvl.extent.right) Lde.viewport.x += lvl.extent.right - Lde.viewport.right;
		if (Lde.viewport.bottom > lvl.extent.bottom) Lde.viewport.y += lvl.extent.bottom - Lde.viewport.bottom;
	} }
}
class MainMenu extends Chapter
{
	var play = new Entity();
	var title = new Entity();
	
	public function new() {}
		
	override public function start() 
	{
		Lib.current.stage.color = Colors.GREY_25;
		
		Lde.gfx.tilers = [ new Menu() ];
		
		Audio.volume = 0.0;
		Audio.playMusic(Sfx.BGM);
		
		play.x = 240;
		play.y = 200;
		play.animation = Lde.gfx.getAnim(Menu.PLAY_NORMAL);
		
		title.x = 0;
		title.y = 0;
		title.animation = Lde.gfx.getAnim(Menu.TITLE);
		
		Lde.gfx.entities = [ title, play ];
	}
	
	override public function step() 
	{
		if (Lde.keys.isKeyPushed(Ctrl.P1_DOWN))
		{
			play.animation = Lde.gfx.getAnim(Menu.PLAY_SELECTED);
		}
		
		if (Lde.keys.isKeyPushed(Ctrl.P1_START))
		{
			play.animation = Lde.gfx.getAnim(Menu.PLAY_SELECTED);
			Lde.open(new LevelOne());
		}
	}
	
	override public function quit() 
	{
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
	
	var chapter : Chapter;
	
	var stats : Stats = new Stats(10, 10, Colors.GREY_75);
	
	function init() 
	{
		if (inited) return;
		inited = true;

		// (your code here)

		addEventListener(Event.ENTER_FRAME, step);
		
		Lde.initialize();
		Lde.viewport = new Rectangle(0, 0, 960, 540);
		
		Lde.keys.remap(Ctrl.EVENT_CONSOLE, Ctrl.KEY_CONSOLE);
		Lde.keys.remap(Ctrl.EVENT_VOLUME_UP, Ctrl.KEY_VOLUME_UP);
		Lde.keys.remap(Ctrl.EVENT_VOLUME_DOWN, Ctrl.KEY_VOLUME__DOWN);
		Lde.keys.addEventListener(Ctrl.EVENT_CONSOLE, switchChild(stats));
		Lde.keys.addEventListener(Ctrl.EVENT_VOLUME_UP, function (_) { Audio.volume = Audio.volume + 0.1; });
		Lde.keys.addEventListener(Ctrl.EVENT_VOLUME_DOWN, function (_) { Audio.volume = Audio.volume - 0.1; });

		Lde.keys.remap("LAYER_GFX", Keyboard.F1);
		Lde.keys.addEventListener("LAYER_GFX", switchChild(Lde.gfx));
		
		Lde.keys.remap("LAYER_PHX", Keyboard.F2);
		Lde.keys.addEventListener("LAYER_PHX", switchChild(Lde.phx));
		
		addChild(Lde.gfx);
		addChild(Lde.phx);

		Lde.open(new MainMenu());
	}

	function switchChild(e : DisplayObject) { return function (_) { if (contains(e)) removeChild(e); else addChild(e); }; }
	
	function step(_)
	{
		Lde.step();
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
