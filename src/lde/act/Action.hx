package lde.act;

class Action
{
	public function then(a : Action) { return new Sequence(this).then(a); }
	public function also(a : Action) { return new Parallel(this).also(a); }
	
	public var done(default, null) = false;
	public var started(default, null) = false;
	
	function start() { }
	function step() { return false; }
	function stop() { }
	
	public function next()
	{
		if (!started)
		{
			start();
			started = true;
		}
		
		done = !step();
		if (done) stop();
		return !done;
	}
}
