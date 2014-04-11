package pplane;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import parser.EqnSystem;

/**
 * Has all the viewport stuff and stores the solutions to be rendered.
 * @author William Bundy
 */
class PPlaneRenderer extends Sprite
{
	private var bg:Shape;
	public var minX:Float;
	public var maxX:Float;
	public var minY:Float;
	public var maxY:Float;
	public var aspectRatio:Float;
	
	public var system:EqnSystem;
	
	public var flowPointers:Array<PPlaneFlowPointer>;
	public var flowPointerLayer:Sprite;
	public var solutions:Array<PPlaneSolution>;
	public var solutionLayer:Sprite;
	public var hudLayer:Sprite;
	
	public var mouseTf:TextField;
	
	public var doForwardStep:Bool;
	public var doBackwardsStep:Bool;
	
	
	public var bmpData:BitmapData;
	public var bitmapContainer:Bitmap;

	public function new(system:EqnSystem) 
	{
		super();
		this.system = system;
	
		
		var s = Lib.current.stage;
		aspectRatio = s.stageWidth / s.stageHeight;
		minX = -s.stageWidth / 50;
		maxX = s.stageWidth / 50;
		minY = minX / aspectRatio;
		maxY = maxX / aspectRatio;
		bg = new Shape();
		var g = bg.graphics;
		g.lineStyle(0, 0, 0);
		g.beginFill(0, 0);
		g.drawRect(0, 0, s.stageWidth, s.stageHeight);
		g.endFill();
		
		
		this.x = s.stageWidth / 2;// + 16;
		this.y = s.stageHeight / 2;// + 16;
		
		
		
		flowPointers = new Array<PPlaneFlowPointer>();
		flowPointerLayer = new Sprite();
	//	flowPointerLayer.scaleY = -1.0;
		
		solutions = new Array<PPlaneSolution>();
		solutionLayer = new Sprite();
	//	solutionLayer.scaleY = -1.0;
		doForwardStep = true;
		doBackwardsStep = true;
		
		hudLayer = new Sprite();
		mouseTf = new TextField();
		mouseTf.defaultTextFormat = new TextFormat("_typewriter", 12, 0);
		mouseTf.autoSize = TextFieldAutoSize.LEFT;
		mouseTf.selectable = false;
		mouseTf.text = "X,Y(0, 0) dx/dy(0, 0)";
		mouseTf.backgroundColor = 0xefefef;
		mouseTf.background = true;
		hudLayer.addChild(mouseTf);
		
		
		bmpData = new BitmapData(s.stageWidth, s.stageHeight, true, 0);
		bitmapContainer = new Bitmap(bmpData);
		bitmapContainer.x = -x;
		bitmapContainer.y = -y;
		solutionLayer.addChild(bitmapContainer);
		
		this.addChild(flowPointerLayer);
		this.addChild(solutionLayer);
		this.addChild(hudLayer);
	}
	
	
	public function setViewport(left, right, top, bottom, ?forceAspectRatio:Bool):Void
	{
		minX = left;
		maxX = right;
		if (forceAspectRatio)
		{
			minY = minX / aspectRatio;
			maxY = maxX / aspectRatio;
		}
		else
		{
			minY = top;
			maxY = bottom;
		}
		var graphicsScaleX = Lib.current.stage.stageWidth / (maxX - minX);
		var graphicsScaleY = Lib.current.stage.stageHeight / (maxY - minY);
		this.x = -minX ;
		this.x *= graphicsScaleX;
		this.y = -minY;
		this.y *= graphicsScaleY;
		
		bitmapContainer.x = -x;
		bitmapContainer.y = -y;
		
		var s = new Shape();
		var g = s.graphics;
		g.beginFill(0x87BC3F, 1);
		g.drawCircle(0, 0, 2);
		g.endFill();
		addChild(s);
		
	}
	
	private function onClick(e:MouseEvent):Void
	{
		var w = maxX - minX;
		var h = maxY - minY;
		
		
		var graphicsScaleX = Lib.current.stage.stageWidth / (maxX - minX);
		var graphicsScaleY = Lib.current.stage.stageHeight / (maxY - minY);
		
		var mx = this.mouseX / graphicsScaleX;
		var my = this.mouseY / graphicsScaleY;
		//mx += minX;
		//my += minY;
		
		var sol:PPlaneSolution = new PPlaneSolution(this);
		this.solutionLayer.addChild(sol);
		this.solutions.push(sol);
		sol.start(mx, my);
	}
	
	public function start():Void
	{
		var w = maxX - minX;
		var h = maxY - minY;
		//make dfield background
		var nx = Std.int(Lib.current.stage.stageWidth / 64);
		var ny = Std.int(Lib.current.stage.stageHeight / 64);
		for (i in 0...ny) 
		{
			for (j in 0...nx) 
			{
				var cx = minX + (w/nx) * (j + .5);
				var cy = minY + (h/ny) * (i + .5);
				var flowPointer:PPlaneFlowPointer = new PPlaneFlowPointer(this.system, new Point(cx, cy));
				flowPointer.x = cx / w * Lib.current.stage.stageWidth;
				flowPointer.y = cy / h * Lib.current.stage.stageHeight;
				flowPointer.redraw();
				this.flowPointerLayer.addChild(flowPointer);
				this.flowPointers.push(flowPointer);
				
			}
		}
		Lib.current.stage.addEventListener(MouseEvent.CLICK, onClick);
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	public function stop():Void
	{
		stage.removeEventListener(MouseEvent.CLICK, onClick);
		stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	private function r(number:Float, precision:Int):Float 
	{
		var num = number; 
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
	}
	
	private function onEnterFrame(e:Event):Void 
	{
		var times = 2;
		for (sol in solutions) {
			if (sol.posTime < 20  && sol.currentPos.x < maxX * 2 && sol.currentPos.x > minX * 2 && sol.currentPos.y > maxY * 2 && sol.currentPos.y < minY * 2) {
				for(i in 0...times) sol.stepForward();
			}
			if (sol.negTime > -20 && sol.currentNeg.x < maxX * 2 && sol.currentNeg.x > minX * 2 && sol.currentNeg.y > maxY * 2 && sol.currentNeg.y < minY * 2) {
				for(i in 0...times) sol.stepBackward();
			}
		}
		
		mouseTf.x = mouseX;// - mouseTf.height;
		mouseTf.y = mouseY - mouseTf.height - 8;
		var mx = mouseX / Lib.current.stage.stageWidth * (maxX - minX);
		var my = mouseY / Lib.current.stage.stageHeight * (maxY - minY);
		var p = system.evaluate2(new Point(mx, my));
		mouseTf.text = 'X, Y (${r(mx,4)},${r(my,4)})\nx\',y\'(${r(p.x,4)},${r(p.y,4)})';
		
		
	}
	
	
	
}