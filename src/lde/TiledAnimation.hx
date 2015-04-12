package lde;
class TiledAnimation
{
	public var indices : Array<Int>;
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
			currentFrame = (Watch.frameCount - startFrame) % indices.length;
		}
	}

	public function start()
	{
		startFrame = Watch.frameCount - currentFrame;
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
