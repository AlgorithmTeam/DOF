package cn.rayyee.math2 
{
	/**
	 * 矩阵_alpha
	 * @author rayyee
	 */
	public class Matrix22
	{
		public var col1:Vector2 = new Vector2();
		public var col2:Vector2 = new Vector2();
		
		public function Matrix22(angle:Number=0, c1:Vector2=null, c2:Vector2=null) 
		{
			if (c1 != null && c2 != null)
			{
				col1 = c1;
				col2 = c2;
			}
			else
			{
				var c:Number = Math.cos(angle);
				var s:Number = Math.sin(angle);
				col1.x = c; col2.x = -s;
				col1.y = s; col2.y = c;
			}
		}
		
		/**
		 * 旋转
		 * @param	angle	弧度
		 */
		public function rotate(angle:Number):void
		{
			var c:Number = Math.cos(angle);
			var s:Number = Math.sin(angle);
			col1.x = c; col2.x = -s;
			col1.y = s; col2.y = c;
		}
		
		public function copy():Matrix22
		{
			return new Matrix22(0, col1, col2);
		}
		
		public function add(m:Matrix22):void
		{
			col1.x += m.col1.x;
			col1.y += m.col1.y;
			col2.x += m.col2.x;
			col2.y += m.col2.y;
		}
		
		public function identity() : void
		{
			col1.x = 1.0; col2.x = 0.0;
			col1.y = 0.0; col2.y = 1.0;
		}
		
		public function zero() : void
		{
			col1.x = 0.0; col2.x = 0.0;
			col1.y = 0.0; col2.y = 0.0;
		}
		
		public function getAngle() :Number
		{
			return Math.atan2(col1.y, col1.x);
		}
		
		public function invert(out:Matrix22):Matrix22
		{
			var a:Number = col1.x; 
			var b:Number = col2.x; 
			var c:Number = col1.y; 
			var d:Number = col2.y;
			var det:Number = a * d - b * c;
			det = 1.0 / det;
			out.col1.x =  det * d;	out.col2.x = -det * b;
			out.col1.y = -det * c;	out.col2.y =  det * a;
			return out;
		}
		
		// Solve A * x = b
		public function solve(out:Vector2, bX:Number, bY:Number):Vector2
		{
			//float32 a11 = col1.x, a12 = col2.x, a21 = col1.y, a22 = col2.y;
			var a11:Number = col1.x, a12:Number = col2.x, a21:Number = col1.y, a22:Number = col2.y;
			//float32 det = a11 * a22 - a12 * a21;
			var det:Number = a11 * a22 - a12 * a21;
			det = 1.0 / det;
			out.x = det * (a22 * bX - a12 * bY);
			out.y = det * (a11 * bY - a21 * bX);
			
			return out;
		}
		
	}

}