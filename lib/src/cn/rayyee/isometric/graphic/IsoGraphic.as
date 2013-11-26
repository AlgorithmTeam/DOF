package cn.rayyee.isometic.graphic 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author rayyee
	 */
	public class IsoGraphic
	{
		
		private const ISO_DEGREE:Number = Math.PI * 45 / 180;
		
		public function IsoGraphic() 
		{
			
		}
		
		public function drawIsoPlane(_size:int):BitmapData
		{
			var _sp:Shape = new Shape();
			_sp.graphics.beginFill(0x619507);
			//_sp.graphics.lineStyle(2, 0x333333);
			_sp.graphics.moveTo(_size, 0);
			_sp.graphics.lineTo(_size * 2, _size * .5);
			_sp.graphics.lineTo(_size, _size);
			_sp.graphics.lineTo(0, _size * .5);
			_sp.graphics.endFill();
			//var _mtx:Matrix = _sp.transform.matrix;
			//_mtx.rotate(ISO_DEGREE);
			//_mtx.scale(1, .5);
			//_mtx.translate(150, 0);
			var _bmd:BitmapData = new BitmapData(_size * 2, _size, true, 0);
			_bmd.draw(_sp);
			
			return _bmd;
		}
		
	}

}