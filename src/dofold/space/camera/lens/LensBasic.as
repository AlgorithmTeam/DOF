package dofold.space.camera.lens
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import dofold.space.camera.CameraBasic;
	
	/**
	 * ...
	 * @author rayyee
	 */
	public class LensBasic
	{
		private var _camera:CameraBasic;
		private var _mSpeed:int = 10;
		private var _stage:Stage;
		private var _oldMousePostition:Vector.<Number> = new Vector.<Number>(2);
		
		public function LensBasic(stage:Stage, camera:CameraBasic)
		{
			this._stage = stage;
			this._camera = camera;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onDownKeyboardHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, onUpKeyboardHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onDownMouseHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUpMouseHandler);
		}
		
		private function onUpMouseHandler(e:MouseEvent):void 
		{
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoveMouseHandler);
		}
		
		private function onDownMouseHandler(e:MouseEvent):void 
		{
			_oldMousePostition = Vector.<Number>([_stage.mouseX, _stage.mouseY]);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoveMouseHandler);
		}
		
		private function onMoveMouseHandler(e:MouseEvent):void 
		{
			
		}
		
		private function onUpKeyboardHandler(e:KeyboardEvent):void
		{
		
		}
		
		private function onDownKeyboardHandler(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case 37:
					_camera.view.appendTranslation(_mSpeed,0,0);
					break;
				case 38:
					_camera.view.appendTranslation(0,_mSpeed,0);
					break;
				case 39:
					_camera.view.appendTranslation(-_mSpeed,0,0);
					break;
				case 40:
					_camera.view.appendTranslation(0,-_mSpeed,0);
					break;
				default:
					
					break;
			}
		}
	
	}

}