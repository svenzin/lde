package lde.act;

class Sequence extends Action
{
	var _acts = new Array<Action>();
	
	public function new(a : Action) { _acts.push(a); }
	public override function then(a : Action) { _acts.push(a); return this; }

	override function step()
	{
		while ((_acts.length > 0) && (!_acts[0].next()))
		{
			_acts.shift();
		}
		return (_acts.length > 0);
	}
}
