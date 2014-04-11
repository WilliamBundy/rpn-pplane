package parser;

/**
 * ...
 * @author William Bundy
 */
class EqnFunc
{
	public static var FuncAdd:EqnObj;
	public static var FuncSub:EqnObj;
	public static var FuncMul:EqnObj;
	public static var FuncDiv:EqnObj;
	public static var FuncExp:EqnObj;
	
	
	
	public static var FuncSqrt:EqnObj;
	
	public static var FuncSin:EqnObj;
	public static var FuncCos:EqnObj;
	public static var FuncTan:EqnObj;
	
	public static var FuncLog:EqnObj;
	
	public static var Func0_e:EqnObj;
	public static var Func0_pi:EqnObj;
	
	public static var Functions:Map<String, EqnObj>;
	
	static function __init__()
	{
		Functions = new Map<String, EqnObj>();
		
		//Func0_e = new EqnObj();
		//Func0_e.tag = EqnTag.Func0;
		//Func0_e.variable = "e";
		//Func0_e.func0 = function() {
			//return Math.exp(1);
		//}
		//Functions.set(Func0_e.variable, Func0_e);
		//
		//Func0_pi = new EqnObj();
		//Func0_pi.tag = EqnTag.Func0;
		//Func0_pi.variable = "pi";
		//Func0_pi.func0 = function() {
			//return Math.PI;
		//}
		//Functions.set(Func0_pi.variable, Func0_pi);
		
		FuncAdd = new EqnObj();
		FuncAdd.tag = EqnTag.Func2;
		FuncAdd.variable = "+";
		FuncAdd.func2 = function(y, x) {
			return x + y;
		}
		Functions.set(FuncAdd.variable, FuncAdd);
		
		FuncSub = new EqnObj();
		FuncSub.tag = EqnTag.Func2;
		FuncSub.variable = "-";
		FuncSub.func2 = function(y, x) {
			return x - y;
		}
		Functions.set(FuncSub.variable, FuncSub);
		
		FuncMul = new EqnObj();
		FuncMul.tag = EqnTag.Func2;
		FuncMul.variable = "*";
		FuncMul.func2 = function(y, x) {
			return x * y;
		}
		Functions.set(FuncMul.variable, FuncMul);
		
		FuncDiv = new EqnObj();
		FuncDiv.tag = EqnTag.Func2;
		FuncDiv.variable = "/";
		FuncDiv.func2 = function(y, x) {
			return x / y;
		}
		Functions.set(FuncDiv.variable, FuncDiv);
		
		
		FuncExp = new EqnObj();
		FuncExp.tag = EqnTag.Func2;
		FuncExp.variable = "^";
		FuncExp.func2 = function(y, x) {
			return Math.pow(y, x);
		}
		Functions.set(FuncExp.variable, FuncExp);
		
		FuncSqrt = new EqnObj();
		FuncSqrt.tag = EqnTag.Func1;
		FuncSqrt.variable = "sqrt";
		FuncSqrt.func1 = function(x) {
			return Math.sqrt(x);
		}
		Functions.set(FuncSqrt.variable, FuncSqrt);
		
		FuncSin = new EqnObj();
		FuncSin.tag = EqnTag.Func1;
		FuncSin.variable = "sin";
		FuncSin.func1 = function(x) {
			return Math.sin(x);
		}
		Functions.set(FuncSin.variable, FuncSin);
		
		FuncCos = new EqnObj();
		FuncCos.tag = EqnTag.Func1;
		FuncCos.variable = "cos";
		FuncCos.func1 = function(x) {
			return Math.cos(x);
		}
		Functions.set(FuncCos.variable, FuncCos);
		
		FuncTan = new EqnObj();
		FuncTan.tag = EqnTag.Func1;
		FuncTan.variable = "tan";
		FuncTan.func1 = function(x) {
			return Math.tan(x);
		}
		Functions.set(FuncTan.variable, FuncTan);
		
		FuncLog = new EqnObj();
		FuncLog.tag = EqnTag.Func1;
		FuncLog.variable = "log";
		FuncLog.func1 = function(x) {
			return Math.log(x);
		}
		Functions.set(FuncLog.variable, FuncLog);

	}
	
	
	
}