package parser;
using StringTools;
/**
 * ...
 * @author William Bundy
 */
class EqnParser
{
	
	public static function zip(variables:Array<String>, values:Array<Float>):Map<String, Float>
	{
		var m = new Map<String, Float>();
		for (i in 0...variables.length) 
		{
			m.set(variables[i], values[i]);
		}
		return m;
	}
	
	
	// technically, it's an expression
	// but shh..
	
	// Uses reverse polish notation:
	// so -2x + .25y becomes:
	// eg: -2.0 x * .25 y * +
	public static function parseRPN(line:String, variables:Array<String>):Equation
	{
		var strstack:Array<String> = line.split(" ");
		var eqn:Equation = new Equation();
		for (i in strstack)
		{
			//extract variable
			var vv = "";
			for (v in variables) {
				if (i == v)
				{
					vv = v;
					break;
				}
			}
			if (vv != "") {
				var e = new EqnObj();
				e.tag = EqnTag.Variable;
				e.variable = vv;
				eqn.add(e);
				continue;
			}
			
			//okay, so if it's not a variable it's a function, right?
			var ff = "";
			for (f in EqnFunc.Functions.keys()) {
				if (i == f)
				{
					ff = f;
					break;
				}
			}
			if (ff != "") {
				eqn.add(EqnFunc.Functions.get(ff).clone());
				continue;
			}
			
			//if it isn't a function, it has to be a variable!
			
			var val:Float = Std.parseFloat(i);
			var e = new EqnObj();
			e.tag = EqnTag.Constant;
			e.value = val;
			eqn.add(e);
		}
		return eqn;
	}
}