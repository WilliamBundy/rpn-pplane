package pplane;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;
import parser.EqnSystem;

/**
 * ...
 * @author William Bundy
 */
class PPlaneFlowPointer extends Sprite
{
	public var system:EqnSystem;
	public var position:Point;
	public var color:Int;
	public var thickness:Float;
	public var length:Float;
	
	public function new(system:EqnSystem, position:Point) 
	{
		this.system = system;
		this.position = position;
		color =0x87BC3F;
		length =16;
		thickness = 0.0;
		super();
	}
	
	public function redraw():Void
	{
		var g:Graphics = this.graphics;
		g.clear();
		var p = system.evaluate2(position);
		var angle = Math.atan2(-p.y, p.x);
		g.lineStyle(thickness, color);
		g.lineTo(Math.cos(angle) * length, Math.sin(angle) * length);
		g.lineTo(
			Math.cos(angle) * length + Math.cos(angle - Math.PI / 8) * -.25 * length, 
			Math.sin(angle) * length + Math.sin(angle - Math.PI / 8) * -.25 * length);
		g.moveTo(Math.cos(angle) * length, Math.sin(angle) * length);
		g.lineTo(
			Math.cos(angle) * length + Math.cos(angle + Math.PI / 8) * -.25 * length, 
			Math.sin(angle) * length + Math.sin(angle + Math.PI / 8) * -.25 * length);
	}
	
}