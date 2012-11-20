package cn.rayyee.isometic.core 
{
	import cn.rayyee.ds.ITreeObject;
	import com.shinezone.isometic.IsoTransform;
	import com.shinezone.isometic.Point3D;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author rayyee
	 */
	
	public class IsoObject implements ITreeObject
	{
		
		/**
		 * 物体尺寸
		 */
		protected var _size:Number;
		/**
		 * 排序偏移量
		 */
		protected var _sortOffset:Point;
		/**
		 * 三维坐标
		 */
		protected var _position:Point3D;
		
		protected var _source:BitmapData;
		
		protected var _bounds:Rectangle;
		
		private var _screenPos:Point;
		
		public var altered:Boolean;
		
		public function IsoObject(value:Number = 20) 
		{
			_size = value;
			_bounds = new Rectangle();
			_position = new Point3D();
			_sortOffset = new Point();
			updateScreenPosition();
		}
		
		protected function updateScreenPosition():void
		{
			altered = true;
			_screenPos = IsoTransform.isoToScreen(_position);
			_bounds.x = _screenPos.x;
			_bounds.y = _screenPos.y;
		}
		
		public function get x():Number
		{
			return _position.x;
		}
		
		public function set x(value:Number):void
		{
			_position.x = value;
			//_iGridX = _position.x / (_size / 2);
			updateScreenPosition();
		}
		
		public function get y():Number
		{
			return _position.y;
		}
		
		public function set y(value:Number):void
		{
			_position.y = value;
			updateScreenPosition();
		}
		
		public function get z():Number
		{
			return _position.z;
		}
		
		public function set z(value:Number):void
		{
			_position.z = value;
			//_iGridZ = _position.z / (_size / 2);
			updateScreenPosition();
		}
		
		public function get position():Point3D
		{
			return _position;
		}
		
		public function set position(value:Point3D):void
		{
			_position = value;
			updateScreenPosition();
		}
		
		public function get depth():Number
		{
			return (_position.x + _sortOffset.x + _position.z + _sortOffset.y) * .886 - _position.y * .707;
		}
		
		public function get source():BitmapData 
		{
			return _source;
		}
		
		public function set source(value:BitmapData):void 
		{
			_source = value;
			altered = true;
			_bounds = new Rectangle(_screenPos.x, _screenPos.y, value.width, value.height);
		}
		
		public function get screenPos():Point 
		{
			return _screenPos;
		}
		
		
		
		public function toString():String
		{
			return "[IsoObject (x:" + _position.x + ", y: " + _position.y + ", z: " + _position.z + ") ]";
		}
		
	}

}