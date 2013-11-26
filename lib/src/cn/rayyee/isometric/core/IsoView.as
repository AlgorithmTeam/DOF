package cn.rayyee.isometic.core 
{
	import cn.rayyee.isometic.graphic.IsoGraphic;
	import com.shinezone.isometic.Point3D;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author rayyee
	 */
	public class IsoView extends Sprite
	{
		private var _mapScene:IsoScene;
		
		public function IsoView() 
		{
			init();
		}
		
		private function init():void 
		{
			_mapScene = new IsoScene();
			//_objScene:IsoScene = new IsoScene();
			addChild(_mapScene);
			
			initMap();
			initDrag();
		}
		
		private function initDrag():void 
		{
			addEventListener(MouseEvent.MOUSE_DOWN, onDownView);
			addEventListener(MouseEvent.MOUSE_UP, onUpView);
		}
		
		private function onUpView(e:MouseEvent):void 
		{
			this.stopDrag();
			_mapScene.render();
		}
		
		private function onDownView(e:MouseEvent):void 
		{
			this.startDrag();
		}
		
		private function initMap():void 
		{
			var i:int, count:int = 10;
			var tempObject:IsoObject;
			var _isoGraphicUtil:IsoGraphic = new IsoGraphic();
			var tempSource:BitmapData = _isoGraphicUtil.drawIsoPlane(200);
			//tempSource.noise(Math.random() * 100, 10, 25, BitmapDataChannel.ALPHA, true);
			for (i = 0; i < count; i += 1)
			{
				tempObject = new IsoObject();
				_mapScene.addObject(tempObject);
				tempObject.source = tempSource;
				tempObject.position = new Point3D((i % 6) * 200, 0, ((i / 6) >> 0) * 200);
			}
			
			_mapScene.render();
		}
		
	}

}