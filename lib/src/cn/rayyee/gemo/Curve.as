package cn.rayyee.gemo 
{
	import flash.geom.Point;
	/**
	 * ...曲线
	 * @author rayyee
	 */
	public class Curve 
	{
		
		public var start:Point;
		public var end:Point;
		public var control:Point;
		
		public function Curve(S:Point, C:Point, E:Point) 
		{
			this.start = S;
			this.end = E;
			this.control = C;
		}
		
		/**
		 * 二次贝塞尔曲线方程
		 * P(t)=(1-t)2P0+2t(1-t)P1+t2P2,0<=t<=1.
		 * start:P0
		 * control:P1
		 * end:P2
		 * @param	t
		 * @return
		 */
		public function getPoint(t : Number) : Point 
		{
			var point:Point = new Point();
			const f : Number = 1 - t;
			point.x = start.x * f * f + control.x * 2 * t * f + end.x * t * t;
			point.y = start.y * f * f + control.y * 2 * t * f + end.y * t * t;
			return point;
		}
		
	}

}