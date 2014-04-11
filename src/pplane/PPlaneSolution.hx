package pplane;

import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Point;
import flash.Lib;

/**
 * I wrote this code very quickly in differential equations class.
 * It's kinda messy
 * 
 * @author William Bundy
 */
class PPlaneSolution extends Sprite
{
	public var renderer:PPlaneRenderer;
	
	public var currentPos:Point;
	public var currentNeg:Point;
	public var initial:Point;
	
	public var h:Float;
	public var posTime:Float;
	public var negTime:Float;
	
	public var posShape:Shape;
	public var negShape:Shape;
	
	public var graphicsScaleX:Float;
	public var graphicsScaleY:Float;
	
	
	public var posColor:Int;
	public var negColor:Int;
	
	public function new(renderer:PPlaneRenderer) 
	{
		super();
		this.renderer = renderer;
		
		currentPos = new Point();
		currentNeg = new Point();
		initial = new Point();
		
		h = 0.01;
		posTime = 0;
		negTime = 0;
		
		posColor = 0x0C9ADE;
		negColor = 0xFA3D05;
		
		//this.scaleX = -1;
		//this.scaleY = -1;
		
		this.x = 0;
		this.y = 0;
		
		posShape = new Shape();
		negShape = new Shape();
		
		graphicsScaleX = Lib.current.stage.stageWidth / (renderer.maxX - renderer.minX);
		graphicsScaleY = Lib.current.stage.stageHeight / (renderer.maxY - renderer.minY);
		//graphicsScaleX = 1.0 / graphicsScaleX;
		//graphicsScaleY = 1.0 / graphicsScaleY;
		
		this.addChild(posShape);
		this.addChild(negShape);
	}
	
	public function start(xx, yy)
	{
		initial.x = xx;
		initial.y = yy;
		currentPos.x = xx;
		currentPos.y = yy;
		currentNeg.x = xx;
		currentNeg.y = yy;
		this.x = 0;
		this.y = 0;
		posShape.graphics.moveTo(xx * graphicsScaleX+ renderer.x, yy * graphicsScaleY + renderer.y);
		negShape.graphics.moveTo(xx * graphicsScaleX+ renderer.x, yy * graphicsScaleY + renderer.y);
		posShape.graphics.lineStyle(1.5, posColor, 1);
		negShape.graphics.lineStyle(1.5, negColor, 1);
			
		this.x = 0;
		this.y = 0;
		
		//for (i in 0...100)
		//{
		//	stepBoth();
		//}
	}
	
	
	public function stepForward() 
	{
		posTime += h;
		
		posShape.graphics.lineStyle(1.5, posColor, 1);
		posShape.graphics.lineTo((currentPos.x) * graphicsScaleX + renderer.x, (currentPos.y) * graphicsScaleY + renderer.y);
		renderer.bmpData.draw(posShape);
		posShape.graphics.clear();
		posShape.graphics.moveTo((currentPos.x * graphicsScaleX) + renderer.x, (currentPos.y * graphicsScaleY) + renderer.y);
		
		var p = renderer.system.evaluate2(currentPos);
		p.x *= h;
		p.y *= h;
		var pos1 = p.clone();
		pos1.x += currentPos.x;
		pos1.y += currentPos.y;
		var p2 = renderer.system.evaluate2(pos1);
		p2.x *= h;
		p2.y *= h;
		
		currentPos.x += (p.x + p2.x) / 2.0;
		currentPos.y += (p.y + p2.y) / 2.0;
		
	}
	
	public function stepBackward()
	{
		negTime -= h;
		negShape.graphics.lineStyle(1.5, negColor, 1);
		negShape.graphics.lineTo((currentNeg.x) * graphicsScaleX + renderer.x, (currentNeg.y) * graphicsScaleY + renderer.y);
		renderer.bmpData.draw(negShape);
		negShape.graphics.clear();
		negShape.graphics.moveTo((currentNeg.x * graphicsScaleX) + renderer.x, (currentNeg.y * graphicsScaleY) + renderer.y);
		
		var p = renderer.system.evaluate2(currentNeg);
		p.x *= h;
		p.y *= h;
		var neg1 = p.clone();
		neg1.x += currentNeg.x;
		neg1.y += currentNeg.y;
		var p2 = renderer.system.evaluate2(neg1);
		p2.x *= h;
		p2.y *= h;
		currentNeg.x -= (p.x + p2.x) / 2.0;
		currentNeg.y -= (p.y + p2.y) / 2.0;
	}
	
	
	public function stepBoth()
	{
		stepBackward();
		stepForward();
	}
	
}