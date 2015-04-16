package lde;

import openfl.display.Sprite;

class Phx extends Sprite
{
	public static var COLOR_CENTER = Colors.GREEN;
	public static var COLOR_BOX = Colors.RED;
	
	public function new()
	{
		super();
	}
	
	public var entities = new Array<Entity>();
	
	public function step()
	{
	}
	
	public function sort()
	{
		entities.sort(function (a, b)
		{
			var aa = a.x + a.box.left;
			var bb = b.x + b.box.left;
			
			if (bb > aa) return 1
			else if (bb == aa) return 0
			else return -1;
		});
	}
	function binary_search(items : Array<Entity>, f : Entity -> Int) : Int
	{
		if (items.length == 0) return -1;
		if (f(items[0]) > 0) return -1;
		
		var l = 0;
		var r = items.length - 1;
		while ((r - l) > 2)
		{
			var i = (l + r) << 1;
			if (f(items[i]) >= 0) r = i;
			else l = i;
		}
		return l;
	}
	function find_first(items : Array<Entity>, predicate : Entity -> Bool) : Int
	{
		var i = 0;
		while (i < items.length)
		{
			if (predicate(items[i])) return i;
			++i;
		}
		return i;
	}
	public function hits(target : Entity) : Array<Entity>
	{
		if (entities.indexOf(target) == -1) return new Array<Entity>();

		var hitters = entities
//			.filter(function (e) { return (e.x + e.box.right) >= (target.x + target.box.left); } )
//			.filter(function (e) { return (e.x + e.box.left) <= (target.x + target.box.right); } )
//			.filter(function (e) { return (e.y + e.box.bottom) >= (target.y + target.box.top); } )
//			.filter(function (e) { return (e.y + e.box.top) <= (target.y + target.box.bottom); } );
			.filter(function (e) { return (e.x + e.box.right) > (target.x + target.box.left); } )
			.filter(function (e) { return (e.x + e.box.left) < (target.x + target.box.right); } )
			.filter(function (e) { return (e.y + e.box.bottom) > (target.y + target.box.top); } )
			.filter(function (e) { return (e.y + e.box.top) < (target.y + target.box.bottom); } );
		hitters.remove(target);
		
		return hitters;
	}
	
	public function render()
	{
		var active = entities
			.filter(function (e) return (e.box != null))
			.filter(function (e) return (Lde.viewport.left - 50 <= e.x && e.x <= Lde.viewport.right  + 50))
			.filter(function (e) return (Lde.viewport.top  - 50 <= e.y && e.y <= Lde.viewport.bottom + 50));
		
		graphics.clear();
		for (e in active)
		{
			graphics.beginFill(COLOR_BOX);
			graphics.drawRect(e.x + e.box.left - Lde.viewport.x, e.y + e.box.top - Lde.viewport.y, e.box.width, e.box.height);
			graphics.endFill();
			
			graphics.beginFill(COLOR_CENTER);
			graphics.drawRect(e.x - Lde.viewport.x, e.y - Lde.viewport.y, 1, 1);
			graphics.endFill();
		}
	}
}
