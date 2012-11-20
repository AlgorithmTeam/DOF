package cn.rayyee.sd
{
	import cn.rayyee.sd.animator.SkeletonAnimator;
	import cn.rayyee.sd.core.Mesh;
	import cn.rayyee.sd.core.Scene3D;
	import cn.rayyee.sd.math.Vector3;
	import cn.rayyee.sd.parser.Md5AnimParser;
	import cn.rayyee.sd.parser.Md5MeshParser;
	import cn.rayyee.sd.parser.ObjParser;
	import cn.rayyee.sd.primitives.Cube;
	import cn.rayyee.sd.primitives.Plane;
	import cn.rayyee.sd.utils.KeyboardState;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...入口
	 * this is a demo.
	 * @example 启动一个3D程序
	 * @author rayyee
	 */
	public class Entrance3D extends Sprite
	{
		[Embed(source='../../../katarina.obj',mimeType='application/octet-stream')]
		private var MONKEY:Class;
		[Embed(source='../../../lostsoul.md5mesh',mimeType='application/octet-stream')]
		private var HEAD:Class;
		[Embed(source='../../../walk1.md5anim',mimeType='application/octet-stream')]
		private var ANIM:Class;
		
		private var scene:Scene3D;
		
		public function Entrance3D()
		{
			stage.scaleMode = "noScale";
			stage.align = StageAlign.TOP_LEFT;
			this.scene = new Scene3D();
			stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, function(e:Event):void
				{
					scene.createContext(e);
					
					//makeLol(0, -100, -350);
					//makeLol(-50, -100, -350);
					//makeLol(50, -100, -350);
					makeLol(-100, -0, -500);
					//makeLol(-150, -100, -350);
					//makeLol(-200, -100, -350);
					//makeLol(-250, -100, -350);
					
					//makeMD5();
					
					makePlane();
					
					//this.makeCubeSoft();
					//makeCubeHard();
					
					stage.addEventListener(Event.ENTER_FRAME, loop);
				});
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyboardUp);
			stage.stage3Ds[0].requestContext3D();
		}
		
		private function onKeyboardDown(e:KeyboardEvent):void
		{
			if (e.keyCode == 37)
				KeyboardState.LEFT_CLICK = true;
			if (e.keyCode == 38)
				KeyboardState.UP_CLICK = true;
			if (e.keyCode == 39)
				KeyboardState.RIGHT_CLICK = true;
			if (e.keyCode == 40)
				KeyboardState.DOWN_CLICK = true;
			if (e.keyCode == 88)
				KeyboardState.X_CLICK = true;
			if (e.keyCode == 90)
				KeyboardState.Z_CLICK = true;
		}
		
		private function onKeyboardUp(e:KeyboardEvent):void
		{
			trace(e.keyCode);
			if (e.keyCode == 37)
				KeyboardState.LEFT_CLICK = false;
			if (e.keyCode == 38)
				KeyboardState.UP_CLICK = false;
			if (e.keyCode == 39)
				KeyboardState.RIGHT_CLICK = false;
			if (e.keyCode == 40)
				KeyboardState.DOWN_CLICK = false;
			if (e.keyCode == 88)
				KeyboardState.X_CLICK = false;
			if (e.keyCode == 90)
				KeyboardState.Z_CLICK = false;
		}
		
		private function makePlane():void
		{
			var _p:Plane = new Plane();
			_p.sca.set(100, 1, 300);
			_p.rot.set(180, 0, 0);
			_p.pos.set(0, 0, -200);
			this.scene.addMesh(_p);
		}
		
		private function makeMD5():void
		{
			var _parser:Md5MeshParser = new Md5MeshParser(HEAD);
			var _anim:Md5AnimParser = new Md5AnimParser(ANIM);
			//var _animtor:SkeletonAnimator = new SkeletonAnimator(_parser, anim.frames,_anim.baseFrames,_anim.hierarchys);
			//_animtor.play();
			scene.addMesh(_parser);
			_parser.pos.set(-50, -0, -350);
		}
		
		private function makeLol(_x:int, _y:int, _z:int):Mesh
		{
			var _parser:ObjParser = new ObjParser(MONKEY, 1, false, true);
			
			scene.addMesh(_parser);
			_parser.pos.set(_x, _y, _z);
			_parser.sca.set(.2, .2, .2);
			
			return _parser;
		}
		
		private function loop(ev:Event):void
		{
			this.scene.update();
		}
		
		private function makeCubeSoft():void
		{
			var _cube:Cube = new Cube();
			_cube.sca.set(20, 20, 20);
			_cube.pos.set(0, 0, -100);
			//_cube.rot.set(45, 0, 0);
			this.scene.addMesh(_cube);
		}
		
		private function makeCubeHard():void
		{
			var _cube:Cube = new Cube();
			_cube.sca.set(20, 20, 20);
			_cube.pos.set(-10, 0, -100);
			//_cube.addChild(makeLol(-10, -10, 250));
			this.scene.addMesh(_cube);
		
		}
	
	}

}