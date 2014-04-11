package parser;

/**
 * ...
 * @author William Bundy
 */
class EqnObj
{
	//tfw no union
	public var tag:EqnTag;
	public var value:Float;
	public var variable:String;
	public var func1:Float->Float;
	public var func2:Float->Float->Float;
	
	public function new() 
	{
		
	}
	
	public function clone():EqnObj 
	{
		var e:EqnObj = new EqnObj();
		e.tag = tag;
		e.value = value;
		e.variable = variable;
		e.func1 = func1;
		e.func2 = func2;
		return e;
	}
}