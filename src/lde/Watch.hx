package lde;

class Watch
{
	static public var frameCount : Int = 0;
	static public var isRunning : Bool;
	
	static public function init()
	{
		frameCount = 0;
		openfl.Lib.current.stage.addEventListener(
			openfl.events.Event.ENTER_FRAME,
			update
		);
		
		start();
	}
	
	static function update(_)
	{
		if (isRunning)
		{
			step();
		}
	}
	
	static public function start() { isRunning = true; }
	static public function stop() { isRunning = false; }
	static public function step() { ++frameCount; }
}
