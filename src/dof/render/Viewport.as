package dof.render
{
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	import dof.math.Matrix44;
	import dof.render.renderer.BasicRenderer;
	import dof.render.renderer.IRenderer;
	import dof.shader.AgalCode;
	import dof.shader.AGALMiniAssembler;
	import dof.space.camera.CameraBasic;
	import dof.space.camera.lens.LensBasic;
	import dof.space.primitive.IPrimitive;
	import dof.space.scene.Scene;
	
	/**
	 * ...
	 * @author rayyee
	 */
	public class Viewport extends Sprite
	{
		
		//整个程序的stage3D实例
		private var _stage3d:Stage3D;
		
		//Stage3D视口宽度
		private var _width:int;
		
		//Stage3D视口高度
		private var _height:int;
		
		//渲染质量,抗锯齿强度
		private var _antiAlias:int;
		
		//场景，类似2D里面的Stage
		private var _scene:Scene;
		
		//渲染处理器,每帧渲染的时候处理
		private var _renderer:IRenderer;
		
		//test................
		private var _mtx:Matrix3D = new Matrix3D;
		private var _camera:CameraBasic;
		private var t:Number = 0;
		private var rotate:Number = 0;
		private var normalMatrix:Matrix3D = new Matrix3D;
		private var finalMatrix:Matrix3D = new Matrix3D;
		private var _rotateMtx:Matrix3D = new Matrix3D;
		
		public function Viewport(_w:int, _h:int, _a:int = 2)
		{
			this._width = _w;
			this._height = _h;
			this._antiAlias = _a;
			addEventListener(Event.ADDED_TO_STAGE, onAddToStageHandler);
		}
		
		private function onAddToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStageHandler);
			
			init();
		}
		
		private function init():void
		{
			if (!_stage3d)
			{
				//从stage3DS列表中，找出可以创建Context3D的Stage3D
				var stageId:int = 0;
				_stage3d = stage.stage3Ds[stageId];
				while (_stage3d.willTrigger(Event.CONTEXT3D_CREATE))
					_stage3d = stage.stage3Ds[int(++stageId)];
				//创建Context3D，侦听创建结果
				_stage3d.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreateHandler);
				_stage3d.requestContext3D(Context3DRenderMode.AUTO);
			}
			
			_scene = new Scene();
			_camera = new CameraBasic(.1, 10240);
			_camera.perspectiveFieldOfViewRH(45 * Math.PI / 180, _width / _height);
			_camera.view.appendTranslation(0, 180.0, -300.0);
			//_camera.view.appendRotation( -45, Vector3D.X_AXIS);
			var _lens:LensBasic = new LensBasic(stage, _camera);
		}
		
		private function onContext3DCreateHandler(e:Event):void
		{
			_renderer = new BasicRenderer(_stage3d.context3D);
			update();
		}
		
		/**
		 * 每一次刷新屏幕的时候渲染
		 */
		public function render():void
		{
			_stage3d.context3D.clear(0, 0, 0);
			
			var child:IPrimitive;
			var i:int, count:int = _scene.childs.length;
			for (i = 0; i < count; i += 1)
			{
				child = _scene.childs[i];
				child.model.identity();
				//child.model.appendRotation(t * 0.7, Vector3D.Y_AXIS);
				//child.model.appendRotation(t * 0.6, Vector3D.X_AXIS);
				//child.model.appendRotation(t * 1.0, Vector3D.Y_AXIS);
				//child.model.appendRotation(t * 1.0, Vector3D.Z_AXIS);
				child.model.appendTranslation(-200.0 + i % 6 * 40, -200 + int(i / 6) * 40, 100.0);
				//child.model.appendRotation(-90.0, Vector3D.X_AXIS);
				t += 2.0;
				finalMatrix.identity();
				finalMatrix.append(child.model);
				finalMatrix.append(_camera.vp);
				//child.model.append(_camera.vp); //mvp
				draw(child);
			}
			
			_stage3d.context3D.present();
		}
		
		private function draw(child:IPrimitive):void
		{
			var _vertexBuffer:VertexBuffer3D = _stage3d.context3D.createVertexBuffer(child.vertices.length / 6, 6);
			_vertexBuffer.uploadFromVector(child.vertices, 0, child.vertices.length / 6);
			var _indexBuffer:IndexBuffer3D = _stage3d.context3D.createIndexBuffer(child.indices.length);
			_indexBuffer.uploadFromVector(child.indices, 0, child.indices.length);
			
			_stage3d.context3D.setVertexBufferAt(0, _vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3); //va0
			_stage3d.context3D.setVertexBufferAt(1, _vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_3); //va1
			
			//var _vec:Vector3D = new Vector3D(0.57735, -0.57735, -0.57735, 1);//direction
			var _vec:Vector3D = new Vector3D(100, -200, 0, 1);//postition
			_rotateMtx.appendRotation(1, Vector3D.X_AXIS);
			_vec = _rotateMtx.transformVector(_vec);
			normalMatrix.copyFrom(child.model);
			normalMatrix.transpose();
			normalMatrix.invert();
			_stage3d.context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, finalMatrix, true); //vc0	
			_stage3d.context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, normalMatrix, true); //vc4			
			//_stage3d.context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 8, Vector.<Number>([0.57735, -0.57735, -0.57735, 1])); //vc8	light direction		静态	
			_stage3d.context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 8, Vector.<Number>([_vec.x, _vec.y, _vec.z, _vec.w])); //vc8	light direction			动态
			_stage3d.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([0, 1, 1, 1])); //fc0		light color	
			var _program:Program3D = _stage3d.context3D.createProgram();
			var agalAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			var _coder:AgalCode = new AgalCode(agalAssembler);
			_coder.add("m44 vt0, va0, vc0"); //透视投影变换,vc0=mvp
			_coder.add("mov op, vt0"); //输出postition
			_coder.add("m44 vt1, va1, vc4"); // 对法线做变换
			_coder.add("nrm vt1.xyz, vt1.xyz"); // 对结果进行归一化
			_coder.add("sub vt2, vc8, vt0"); //VectorToLight 
			_coder.add("nrm vt2.xyz, vt2.xyz"); //归一化VectorToLight
			_coder.add("dp3 vt1.w, vt1.xyz, vt2.xyz"); //变换过的法线和光线向量进行点乘
			_coder.add("sat vt1, vt1.w"); // 去除结果中小于0的部分  此时vt1.w的值为光照强度
			_coder.add("mov v0, vt1"); // 输出到Fragment Shader
			var _fragmentCoder:AgalCode = new AgalCode(agalAssembler);
			_fragmentCoder.add("mul ft0, fc0, v0.w"); //乘以光照系数
			_fragmentCoder.add("mov oc, ft0"); // 输出color
			_program.upload(_coder.assemble(Context3DProgramType.VERTEX), _fragmentCoder.assemble(Context3DProgramType.FRAGMENT));
			_stage3d.context3D.setProgram(_program);
			_stage3d.context3D.drawTriangles(_indexBuffer, 0, child.indices.length / 3);
		}
		
		private function update():void
		{
			_stage3d.context3D.configureBackBuffer(_width, _height, _antiAlias);
			//_stage3d.context3D.setCulling("back");
		}
		
		public function get scene():Scene
		{
			return _scene;
		}
	
	}

}