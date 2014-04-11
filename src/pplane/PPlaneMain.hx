package pplane;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.ui.Keyboard;
import parser.EqnParser;
import parser.EqnSystem;

/**
 * ...
 * @author William Bundy
 */
class PPlaneMain extends Sprite
{
	public var renderer:PPlaneRenderer;
	public var rendererContainer:Sprite;
	public var sys:EqnSystem;
	public var hud:Sprite;
	
	
	//ui stuff
	public var eqn1Tf:TextField;
	public var eqn2Tf:TextField;
	public var eqn1id:TextField;
	public var eqn2id:TextField;
	public var bigTextFormat:TextFormat;
	public var bigInputFormat:TextFormat;
	public var smallTextFormat:TextFormat;
	public var smallInputFormat:TextFormat;
	public var viewportX_input:TextField;
	public var viewportX_id:TextField;
	public var viewportY_input:TextField;
	public var viewportY_id:TextField;
	public var fields:Array<TextField>;
	public var rebuildTf:TextField;
	public var rebuildButton:Sprite;
	
	
	
	public function new() 
	{
		super();
		hud = new Sprite();
		
		sys = new EqnSystem();
		sys.eqn1 = EqnParser.parseRPN("x y 2 * -", ["x", "y"]);
		sys.eqn2 = EqnParser.parseRPN("x y +", ["x", "y"]);
		
		renderer = new PPlaneRenderer(sys);
		this.rendererContainer = new Sprite();
		this.addChild(rendererContainer);
		rendererContainer.addChild(renderer);
		renderer.setViewport( -10, 10, 10, -10, false);
		renderer.start();
		
		
		fields = new Array<TextField>();
		bigTextFormat = new TextFormat("_typewriter", 24, 0, true);
		bigInputFormat = new TextFormat("_typewriter", 24, 0x333333);
		smallTextFormat = new TextFormat("_typewriter", 12, 0);
		smallInputFormat = new TextFormat("_typewriter", 12, 0x333333);
		
		eqn1Tf = styleBigTf("x y -2 * +", true );
		eqn2Tf = styleBigTf("x y +", true);
		eqn1id = styleBigTf("x'=", false);
		eqn2id = styleBigTf("y'=", false);
		
		eqn1Tf.x = 16;
		eqn1Tf.y = 16;
		eqn1Tf.width = 256;
		eqn1Tf.height = eqn1Tf.textHeight + 2;
		eqn2Tf.x = 16;
		eqn2Tf.y = eqn1Tf.height + 32;
		eqn2Tf.width = 256;
		eqn2Tf.height = eqn2Tf.textHeight + 2;
		eqn1id.x = eqn1Tf.x + eqn1Tf.width + 8;
		eqn1id.y = eqn1Tf.y;
		eqn2id.x = eqn1id.x;
		eqn2id.y = eqn2Tf.y;
		
		viewportX_id = styleSmallTf("minX,maxX=", false);
		viewportX_input = styleSmallTf("-16,16", true);
		viewportY_id = styleSmallTf("minY,maxY=", false);
		viewportY_input = styleSmallTf("-12,12", true);
		viewportX_id.x = 16;
		viewportX_id.y = eqn2id.y + eqn2Tf.height + 16;
		viewportX_input.x = 96;
		viewportX_input.y = viewportX_id.y;
		viewportY_id.x = viewportX_input.x + viewportX_input.width + 16;
		viewportY_id.y = eqn2id.y + eqn2Tf.height + 16;
		viewportY_input.x =  viewportX_input.x + viewportX_input.width + viewportY_id.width + 16;
		viewportY_input.y = viewportX_id.y;
		
		rebuildTf =  new TextField();
		rebuildTf.defaultTextFormat = new TextFormat("_typewriter", 20, 0xEEEEEE);
		rebuildTf.selectable = false;
		rebuildTf.type = TextFieldType.DYNAMIC;
		rebuildTf.autoSize = TextFieldAutoSize.LEFT;
		rebuildTf.background = true;
		rebuildTf.backgroundColor = 0x333333;
		rebuildTf.x = 16;
		rebuildTf.y = viewportX_id.y + 16 + viewportX_id.height;
		rebuildTf.text = "Rebuild Phase Plane"; 
		hud.addChild(rebuildTf);
		rebuildButton = new Sprite();
		rebuildButton.x = rebuildTf.x;
		rebuildButton.y = rebuildTf.y;
		rebuildTf.width += 4;
		rebuildTf.height += 4;
		var g:Graphics = rebuildButton.graphics;
		g.beginFill(0, 0);
		g.drawRect(0, 0, rebuildTf.width, rebuildTf.height);
		g.endFill();
		hud.addChild(rebuildButton);
		
		rebuildButton.addEventListener(MouseEvent.CLICK, function(e) {this_keyDown(null); } );
		
		addChild(hud);
		
		hud.addEventListener(MouseEvent.CLICK, function(e) { e.stopPropagation(); } );
		
		Lib.current.stage.stageFocusRect = false;
		this.addEventListener(KeyboardEvent.KEY_DOWN, this_keyDown);
		this.addEventListener(Event.ENTER_FRAME, this_enterFrame);
	}
	
	private function this_enterFrame(e:Event):Void 
	{
		//stage.focus = this;
		
	}
	
	private function parseXY(text:String):Point
	{
		//text = StringTools.trim(text);
		var terms_dirty = text.split(",");
		var terms_clean:Array<String> = new Array<String>();
		for (term in terms_dirty) terms_clean.push(StringTools.trim(term));
		var p = new Point();
		p.x = Std.parseFloat(terms_clean[0]);
		p.y = Std.parseFloat(terms_clean[1]);
		return p;
	}
	
	private function this_keyDown(e:KeyboardEvent):Void 
	{
		if (e == null || e.keyCode == Keyboard.ENTER) {
			sys.eqn1 = EqnParser.parseRPN(eqn1Tf.text, ["x", "y"]);
			sys.eqn2 = EqnParser.parseRPN(eqn2Tf.text, ["x", "y"]);
			renderer.stop();
			rendererContainer.removeChild(renderer);
			renderer = new PPlaneRenderer(sys);
			rendererContainer.addChild(renderer);
			var px = parseXY(viewportX_input.text);
			var py = parseXY(viewportY_input.text);
			renderer.setViewport(px.x, px.y, py.y, py.x, false);
			renderer.start();
		}
	}
	
	
	private function styleBigTf(text:String, isInput:Bool):TextField 
	{
		var tf:TextField = new TextField();
		if (isInput) 
		{
			tf.defaultTextFormat = bigInputFormat;
			tf.backgroundColor = 0xe3e3e3;
			tf.background = true;
			tf.border = true;
			tf.borderColor = 0x222222;
			tf.type = TextFieldType.INPUT;
		}
		else
		{
			tf.defaultTextFormat = bigTextFormat;
			tf.selectable = false;
		}
		hud.addChild(tf);
		tf.text = text;
		return tf;
	}
	
	private function styleSmallTf(text:String, isInput:Bool):TextField 
	{
		var tf:TextField = new TextField();
		if (isInput)
		{
			tf.defaultTextFormat = smallInputFormat;
			tf.background = true;
			tf.backgroundColor = 0xDDDDDD;
			tf.border = true;
			tf.borderColor = 0x222222;
			tf.type = TextFieldType.INPUT;
			tf.height = 18;
			tf.width = 68;
		}
		else 
		{
			tf.defaultTextFormat = smallTextFormat;
			tf.selectable = false;
			tf.height = 18;
			tf.width = 80;
		}
		hud.addChild(tf);
		tf.text = text;
		return tf;
	}
	
	
	
}