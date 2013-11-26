package cn.rayyee.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author rayyee
	 */
	public class CreateIsoDisplayObject 
	{
		
		public static function create(_size:int):BitmapData
		{
			var _shape:Shape = new Shape();
			var _bitmapData:BitmapData = new BitmapData(_size * 2, _size, true, 0);
			var _drawSize:int = Math.sqrt(_size * _size * 2);
			var _matrix:Matrix = new Matrix();
			_matrix.rotate(45 * Math.PI / 180);
			_matrix.scale(1, .5);
			_matrix.translate(_size, 0);
			_shape.graphics.beginFill(0xff0000);
			_shape.graphics.drawRect(0, 0, _drawSize, _drawSize);
			_shape.graphics.endFill();
			
			_bitmapData.draw(_shape, _matrix);
			return _bitmapData;
		}
		
		public static function addIsoToContainer(_container:DisplayObjectContainer,_size:int):void
		{
			var _bmp:Bitmap = new Bitmap(create(_size));
			_container.addChild(_bmp);
		}		
		
	}

}