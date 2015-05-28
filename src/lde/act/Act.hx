package lde.act;

class Predicate
{
	static public function True() 
	{
		return true;
	}
	
	static public function False()
	{
		return false;
	}
	
	static public function Not(p : Void -> Bool)
	{
		return function()
		{
			return !p();
		}
	}
	
	static public function Counter(n : Int)
	{
		var i = n;
		return function ()
		{
			--i;
			return (i >= 0);
		};
	}
}

class Function
{
	static public function Nothing()
	{
	}
}

class LoopWhile extends Action
{
	var f : Void -> Void;
	var p : Void -> Bool;
	public function new(fn : Void -> Void, pred : Void -> Bool)
	{
		f = fn;
		p = pred;
	}
	
	override function step()
	{
		f();
		return p();
	}
}

class KeepAlive extends LoopWhile { public function new() { super(Function.Nothing, Predicate.False); } }

class DelayN extends LoopWhile { public function new(d : Int) { super(Function.Nothing, Predicate.Counter(d)); } }

class Call extends LoopWhile { public function new(f : Void -> Void) { super(f, Predicate.False); } }
class Loop extends LoopWhile { public function new(f : Void -> Void) { super(f, Predicate.True); } }

class Act
{
	static public function LoopWhile(f : Void -> Void, p : Void -> Bool) { return new LoopWhile(f, p); }
	
	static public function KeepAlive() { return new KeepAlive(); }
	static public function Call(f : Void -> Void) { return new Call(f); }
	static public function Loop(f : Void -> Void) { return new Loop(f); }
	static public function DelayN(d : Int) { return new DelayN(d); }
}
