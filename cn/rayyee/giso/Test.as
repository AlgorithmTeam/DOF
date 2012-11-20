package cn.rayyee.giso
{
	import cn.rayyee.giso.display.GpuSprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author rayyee
	 */
	public class Test extends Sprite
	{
		[Embed(source = "../../../build1.png")]
		private var BUILD:Class;
		
		private var _iso:StageIsometric;
		
		public function Test()
		{
			stage.scaleMode = "noScale";
			stage.align = "TL";
			
			_iso = new StageIsometric();
			_iso.initStage3D(stage, function():void
			{
				var bitmap:Bitmap = new BUILD();
				var bmd:BitmapData = new BitmapData(128, 128, true, 0);
				bmd.copyPixels(bitmap.bitmapData, bmd.rect, new Point());
				
				var _sp:GpuSprite = new GpuSprite();
				_sp.init(_iso.context3D);
				_iso.addChild(_sp);
				_sp.createTexture(_iso.context3D, bmd);
				
				addEventListener(Event.ENTER_FRAME, onRender);
			});
		}
		
		private function onRender(e:Event):void 
		{
			_iso.render();
		}
	
	}

}