package lde;

import openfl.display.BitmapData;
import openfl.display.Tilesheet;
import openfl.geom.Rectangle;

class Tiler
{
	public var sheet : Tilesheet;
	
	var animations : Map<Int, Array<Int>>;

	public function new(tilesheet : BitmapData)
	{
		sheet = new Tilesheet(tilesheet);
		animations = new Map();
	}
	
	public function slice(origin : Array<Int>, size : Array<Int>, count : Array<Int>) : Array<Int>
	{
		var tiles = new Array<Int>();
		for (y in 0...count[1])
		{
			for (x in 0...count[0])
			{
				tiles.push(sheet.addTileRect(new Rectangle(origin[0] + x * size[0], origin[1] + y * size[1], size[0], size[1])));
			}
		}
		return tiles;
	}
	
	public function register(id : Int, indices : Array<Int>)
	{
		animations[id] = indices;
	}
	
	public function get(id : Int) : TiledAnimation
	{
		if (!animations.exists(id)) return null;
		
		var a = new TiledAnimation();
		a.id = id;
		a.indices = animations[id];
		a.tiler = this;
		return a;
	}
}
