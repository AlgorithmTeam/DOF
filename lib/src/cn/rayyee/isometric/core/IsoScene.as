package cn.rayyee.isometic.core 
{
	
	import cn.rayyee.ds.QuadTree;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...场景管理
	 * @author rayyee
	 */
	public class IsoScene extends Sprite
	{
		
		private var _renderBuffer:BitmapData;
		
		private var _quadTreeManager:QuadTree;
		
		private var _isoObjects:Vector.<IsoObject>;
		
		public function IsoScene() 
		{
			init();
		}
			
		private function init():void 
		{
			_renderBuffer = new BitmapData(800, 600, true, 0);
			_quadTreeManager = new QuadTree(5, new Rectangle(-100000, -100000, 300000, 300000));
			_isoObjects = new Vector.<IsoObject>();
			var _appearBitMap:Bitmap = new Bitmap(_renderBuffer);
			addChild(_appearBitMap);
		}
		
		public function addObject(_obj:IsoObject):void
		{
			_isoObjects.push(_obj);
		}
		
		public function removeObject(_obj:IsoObject):void
		{
			_isoObjects.splice(_isoObjects.indexOf(_obj), 1);
		}
		
		public function sortScene():void
		{
			
		}
		
		public function render():void
		{
			var i:int, count:int = _isoObjects.length;
			var rectPos:Point = this.globalToLocal(new Point(0, 0));
			//trace(rectPos);
			var rect:Rectangle = new Rectangle(rectPos.x, rectPos.y, 800, 600);
			_renderBuffer.fillRect(rect, 0xffffff);
			for (i = 0; i < count; i += 1)
			{
				//如果物体有过改动，渲染
				if (_isoObjects[i].source.rect.intersects(rect))
				{
					_renderBuffer.copyPixels(_isoObjects[i].source, _isoObjects[i].source.rect, _isoObjects[i].screenPos, _isoObjects[i].source, new Point(0, 0), true);
				}
			}
		}
		
	}

}