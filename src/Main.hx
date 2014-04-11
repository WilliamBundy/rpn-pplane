package ;

import flash.display.Sprite;
import flash.display.StageDisplayState;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import parser.EqnParser;
import parser.EqnSystem;
import pplane.PPlaneFlowPointer;
import pplane.PPlaneMain;
import pplane.PPlaneRenderer;

/**
 * ...
 * @author William Bundy
 */

class Main
{
	static var tf:TextField;
	static function main()
	{
		var stage = Lib.current.stage;
		stage.addEventListener(MouseEvent.CLICK, ff);
		tf = new TextField();
		tf.autoSize = TextFieldAutoSize.CENTER;
		tf.defaultTextFormat = new TextFormat("_typewriter", 36, 0, true);
		tf.text = "Click To Start Fullscreen";
		stage.addChild(tf);
		tf.x = stage.stageWidth / 2 - tf.width /2;
		tf.y = stage.stageHeight / 2 -tf.height/2;
		
		/*
		var sys = new EqnSystem();
		sys.eqn1 = EqnParser.parseRPN("x -1 y * + ", ["x", "y"]);
		sys.eqn2 = EqnParser.parseRPN("-2 y * 3 x * -", ["x", "y"]);
		
		var renderer = new PPlaneRenderer(sys);
		stage.addChild(renderer);
		renderer.setViewport( -4, 4, 3, -3);
		renderer.start();
		*/
	}
	
	static function ff(e) 
	{
		Lib.current.stage.removeChild(tf);
		Lib.current.stage.removeEventListener(MouseEvent.CLICK, ff);
		Lib.current.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		var pm = new PPlaneMain();
		Lib.current.addChild(pm);
	}
}
