package cn.rayyee.math2
{
	
	/**
	 * ...
	 * @author rayyee
	 */
	public class Vector2
	{
		
		public var x:Number;
		
		public var y:Number;
		
		public function Vector2(x_:Number = 0, y_:Number = 0)
		{
			this.x = x_;
			this.y = y_;
		}
		
		public function setXY(x_:Number = 0, y_:Number = 0):void
		{
			x = x_;
			y = y_;
		}
		
		public function setV(v:Vector2):void
		{
			x = v.x;
			y = v.y;
		}
		
		public function zero():void
		{
			x = y = 0;
		}
		
		public function negative():void
		{
			x = -x;
			y = -y;
		}
		
		public function copy():Vector2
		{
			return new Vector2(x, y);
		}
		
		public function add(v:Vector2):void
		{
			x += v.x;
			y += v.y;
		}
		
		public function subtract(v:Vector2):void
		{
			x -= v.x;
			y -= v.y;
		}
		
		public function multiply(a:Number):void
		{
			x *= a;
			y *= a;
		}
		
		public function multiplyM(m:Matrix22):void
		{
			var tX:Number = x; //改变y的时候需要旧的x
			x = m.col1.x * tX + m.col2.x * y;
			y = m.col1.y * tX + m.col2.y * y;
		}
		
		/**
		 * Sets / gets the length or magnitude of this vector. Changing the length will change the x and y but not the angle of this vector.
		 */
		public function set length(value:Number):void
		{
			var a:Number = angle;
			x = Math.cos(a) * value;
			y = Math.sin(a) * value;
		}
		public function get length():Number
		{
			return Math.sqrt(lengthSQ);
		}
		
		/**
		 * Gets the length of this vector, squared.
		 */
		public function get lengthSQ():Number
		{
			return x * x + y * y;
		}
		
		/**
		 * Gets / sets the angle of this vector. Changing the angle changes the x and y but retains the same length.
		 */
		public function set angle(value:Number):void
		{
			var len:Number = length;
			x = Math.cos(value) * len;
			y = Math.sin(value) * len;
		}
		public function get angle():Number
		{
			return Math.atan2(y, x);
		}
		
		public function floor():void
		{
			x = x >> 0;
			y = y >> 0;
		}
		
		public function round():void
		{
			x = Math.round(x);
			y = Math.round(y);
		}
		
		public function Normalize():Number
		{
			var length:Number = Math.sqrt(x * x + y * y);
			if (length < Number.MIN_VALUE)
			{
				return 0.0;
			}
			var invLength:Number = 1.0 / length;
			x *= invLength;
			y *= invLength;
			
			return length;
		}
		
		public function toString():String
		{
			return "[Vector2 (x:" + x + ", y:" + y + ")]";
		}
	
	}

}