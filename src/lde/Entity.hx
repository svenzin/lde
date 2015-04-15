package lde;
import openfl.geom.Rectangle;

class Entity
{
	// Physics
	public var x : Float = 0.0;
	public var y : Float = 0.0;
	
	public var box : Rectangle = new Rectangle();
	public var anchored : Bool = false;
	
	// Graphics
	public var animation : TiledAnimation;
	
	public function new() { }
}
