package lde;
class TiledAnimation
{
	public var id : Int;
	public var indices : Array<Int>;
	public var tiler : Tiler;
	public function new()
	{
		currentFrame = 0;
		stop();
	}

	var isRunning : Bool;
	var startFrame : Int;
	var currentFrame : Int;
	public function get() : Int { return indices[currentFrame]; }
	
	public function update()
	{
		if (isRunning)
		{
			currentFrame =  Std.int((Watch.frameCount - startFrame) / slowBy) % indices.length;
		}
	}

	var slowBy : Int;
	public function start(slowed : Int = 1)
	{
		startFrame = Watch.frameCount - currentFrame;
		slowBy = slowed;
		isRunning = true;
	}
	
	public function stop()
	{
		isRunning = false;
	}
	
	public function toggle()
	{
		if (isRunning)
		{
			stop();
		}
		else
		{
			start();
		}
	}
}
