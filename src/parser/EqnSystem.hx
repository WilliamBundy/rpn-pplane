package parser;
import flash.geom.Point;

/**
 * ...
 * @author William Bundy
 */
class EqnSystem
{
	public var eqn1:Equation;
	public var eqn2:Equation;
	
	public function new()
	{
		
	}
	
	public function evaluate2(point:Point):Point
	{
		var p = new Point();
		var v = EqnParser.zip(["x", "y"], [point.x, point.y]);
		p.x = eqn1.evaluate(v);
		p.y = eqn2.evaluate(v);
		return p;
	}
}