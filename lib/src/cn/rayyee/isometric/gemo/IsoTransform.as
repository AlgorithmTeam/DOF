package cn.rayyee.isometric.gemo 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author rayyee
	 */
	public class IsoTransform 
	{
		
		/**
		 * y纵深值
		 */
		public static const Y_CORRECT:Number = Math.cos( -Math.PI / 6) * Math.SQRT2;
		
		/**
		 * 三维转二维
		 * @param    pos   三维点对象
		 */
		public static function isoToScreen(pos:Point3D):Point
		{
			var screenX:Number = pos.x - pos.z;
			var screenY:Number = pos.y * Y_CORRECT + (pos.x + pos.z) * .5;
			return new Point(screenX, screenY);
		}
		
		/**
		 * 二维转三维
		 * @param    pos   二维点对象
		 */
		public static function screenToIso(point:Point):Point3D
		{
			var xpos:Number = point.y + point.x / 2;
			var ypos:Number = 0;
			var zpos:Number = point.y - point.x / 2;
			return new Point3D(xpos, ypos, zpos);
		}
		
	}

}