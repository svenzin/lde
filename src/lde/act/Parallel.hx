package lde.act;

class Parallel extends Action
{
	var _acts = new Array<Action>();
	
	public function new(a : Action) { _acts.push(a); }
	public override function also(a : Action) { _acts.push(a); return this; }

	override function step()
	{
		_acts = [ for (a in _acts) if (a.next()) a ];
		return (_acts.length > 0);
	}
}
