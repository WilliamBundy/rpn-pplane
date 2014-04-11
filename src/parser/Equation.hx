package parser;

/**
 * ...
 * @author William Bundy
 */ 
 
class Equation
{
	public var independentVar:String;
	public var stack:Array<EqnObj>;
	
	public function new() 
	{
		stack = new Array<EqnObj>();
	}
	
	public function add(e:EqnObj):Void
	{
		stack.push(e);
	}
	
	//tfw no error checking
	public function evaluate(variables:Map<String, Float>):Float
	{
		var lstack:Array<EqnObj> = new Array<EqnObj>();
		for (i in 0...stack.length)
		{
			var e:EqnObj = stack[i];
			switch (e.tag) 
			{
				case EqnTag.Constant: //constants go on the stack
					lstack.push(e);
				case EqnTag.Variable: // we aren't trying to solve here--substitute variables
					var n = new EqnObj();
					n.tag = EqnTag.Constant;
					n.value = variables.get(e.variable);
					lstack.push(n);
				
				case EqnTag.Func1:
					var n = new EqnObj();
					n.tag = EqnTag.Constant;
					n.value = e.func1(lstack.pop().value);
					lstack.push(n);
				case EqnTag.Func2:
					var n = new EqnObj();
					n.tag = EqnTag.Constant;
					var v1 = lstack.pop();
					var v2 = lstack.pop();
					n.value = e.func2(v1.value, v2.value);
					lstack.push(n);

			}
		}
		
		//hope
		return lstack[0].value;
	}
}