package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import dofold.render.Viewport;
	import dofold.space.primitive.impl.Cube;
	import dofold.space.primitive.impl.Teapot;
	
	/**
	 * ...这次一定要进行到最后
	 * Flash3D,我来了！
	 * @author rayyee
	 */
	[SWF(width="800", height="600", frameRate="60")]
	public class Main extends Sprite
	{
		private var _ray3d:Viewport;
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			_ray3d = new Viewport(800, 600, 16);
			addChild(_ray3d);
			var i:int, count:int = 10;
			for (i = 0; i < count; i += 1)
			{
				_ray3d.scene.addChild(new Teapot());
			}
			
			_ray3d.scene.addChild(new Cube(5));
			
			addEventListener(Event.ENTER_FRAME, onRender);
		}
		
		private function onRender(e:Event):void
		{
			_ray3d.render();
		}
	
	}

}