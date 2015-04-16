package lde;

import openfl.display.Sprite;

class Gfx extends Sprite
{
	public var tilers = new Array<Tiler>();
	
	public function new()
	{
		super();
	}
	
	public function getAnim(id : Int)
	{
		for (tiler in tilers)
		{
			var anim = tiler.get(id);
			if (anim != null) return anim;
		}
		return null;
	}
	
	public var entities = new Array<Entity>();
	public var custom = new Array<ICustomRenderer>();
	
	var datamap : Map<Tiler, Array<Float>>;
	public function render()
	{
		var active = entities
			.filter(function (e) return (e.animation != null))
			.filter(function (e) return (Lde.viewport.left - 50 <= e.x && e.x <= Lde.viewport.right  + 50))
			.filter(function (e) return (Lde.viewport.top  - 50 <= e.y && e.y <= Lde.viewport.bottom + 50));
		
		datamap = new Map();
		for (tiler in tilers)
		{
			datamap[tiler] = [];
		}
		
		for (tiler in datamap.keys())
		{
			var items = active.filter(function (e) { return e.animation.tiler == tiler; } );
			for (e in items)
			{
				e.animation.update();
				datamap[tiler] = datamap[tiler].concat([e.x - Lde.viewport.x, e.y - Lde.viewport.y, e.animation.get()]);
			}
		}
		
		graphics.clear();
		for (e in custom)
		{
			e.render(this.graphics);
		}
		for (tiler in datamap.keys())
		{
			tiler.sheet.drawTiles(this.graphics, datamap[tiler]);
		}
	}
}
