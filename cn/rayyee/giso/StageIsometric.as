package cn.rayyee.giso
{
	import cn.rayyee.giso.display.GpuSprite;
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author rayyee
	 */
	public class StageIsometric
	{
		private var _context3D:Context3D;
		private var _childs:Vector.<GpuSprite>;
		
		public function StageIsometric()
		{
			this._childs = new Vector.<GpuSprite>;
		}
		
		public function initStage3D(stage:Stage,callback:Function):void
		{
			stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, function(e:Event):void
			{
				onCreateContext3D(e);
				callback();
			});
			stage.stage3Ds[0].requestContext3D();
		}
		
		private function onCreateContext3D(e:Event):void
		{
			_context3D = (e.target as Stage3D).context3D;
			_context3D.enableErrorChecking = true;
			_context3D.configureBackBuffer(760, 650, 2, true);
			createProgram();
		}
		
		public function addChild(sp:GpuSprite):void
		{
			_childs.push(sp);
		}
		
		private function createProgram():void
		{
			var _program3D:Program3D = _context3D.createProgram();
			var _vertexShader:AGALMiniAssembler = new AGALMiniAssembler();
			_vertexShader.assemble(Context3DProgramType.VERTEX,
									"m44 vt0 va0 vc0 \n" +
									"mov op vt0 \n" +
									"mov v1 va1 \n");
			var _fShader:AGALMiniAssembler = new AGALMiniAssembler();
			_fShader.assemble(Context3DProgramType.FRAGMENT,
								"tex ft2, v1, fs0<2d,clamp,linear> \n" +			
								"mov oc , ft2 ");
			_program3D.upload(_vertexShader.agalcode, _fShader.agalcode);
			_context3D.setProgram(_program3D);
		}
		
		public function render():void
		{
			_context3D.clear();
			var _cpuSprite:GpuSprite;
			for each(_cpuSprite in _childs)
			{
				_cpuSprite.render(_context3D);
			}
			_context3D.present();
		}
		
		public function get context3D():Context3D 
		{
			return _context3D;
		}
	
	}

}