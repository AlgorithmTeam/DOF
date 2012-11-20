package cn.rayyee.gemo 
{
	import flash.geom.Point;
	/**
	 * ...贝塞尔
	 * @author rayyee
	 */
	public class Bezier
	{
		/**
		 * 二次贝塞尔曲线方程
		 * P(t)=(1-t)2P0+2t(1-t)P1+t2P2,0<=t<=1.
		 * @param	start		P0
		 * @param	control		P1
		 * @param	anchor		P2
		 * @param	t			t
		 * @return
		 */
		public static function getValue(start:Point, control:Point, anchor:Point, t:Number):Point 
		{
			var m:Number = 1 - t;
			var x:Number = m * m * start.x + 2 * t * m * control.x + t * t * anchor.x;
			var y:Number = m * m * start.y + 2 * t * m * control.y + t * t * anchor.y;
			return new Point(x, y);
		}
		
		public static function getControlPoint(start:Point, middle:Point, end:Point):Point 
		{
			var x:Number = (4 * middle.x - start.x - end.x) * 0.5;
			var y:Number = (4 * middle.y - start.y - end.y) * 0.5;
			return new Point (x, y);
		}
		
		public static function getLength(start:Point, control:Point, anchor:Point, t:Number):Number
		{
			_initIntegration(start, control, anchor);
			return _calculateLength(t);
		}
		
		public static function getTForX(start:Point, control:Point, anchor:Point, x:Number):Array 
		{
			var ax:Number = start.x - 2 * control.x + anchor.x;
			var bx:Number = 2 * (control.x - start.x);
			var cx:Number = start.x - x;
			var answer:Array = _quadraticFormula(ax, bx, cx);
			var i:int = answer.length;
			while (i--) {
				var t:Number = answer[i];
				if (t < 0 || t > 1) answer.splice(i, 1);
			}
			return answer;
		}
		
		public static function getTForY(start:Point, control:Point, anchor:Point, y:Number):Array
		{
			var ay:Number = start.y - 2 * control.y + anchor.y;
			var by:Number = 2 * (control.y - start.y);
			var cy:Number = start.y - y;
			var answer:Array = _quadraticFormula(ay, by, cy);
			var i:int = answer.length;
			while (i--) {
				var t:Number = answer[i];
				if (t < 0 || t > 1) answer.splice(i, 1);
			}
			return answer;
		}
		
		public static function getTForLength(start:Point, control:Point, anchor:Point, length:Number):Number
		{
			_initIntegration(start, control, anchor);
			var totalLength:Number = _calculateLength(1);
			var t:Number = length / totalLength;
			if (t <= 0 || t >= 1) {
				return t <= 0 ? 0 : 1;
			}
			var temp:Number = _calculateLength(t);
			var d:Number = length - temp;
			while (Math.abs(d) > 0.01) {
				t += d / totalLength;
				temp = _calculateLength(t);
				d = length - temp;
			}
			return t;
		}
		
		public static function getTForClosestPoint(start:Point, control:Point, anchor:Point, point:Point):Number
		{
			var ax:Number = start.x - 2 * control.x + anchor.x;
			var bx:Number = control.x - start.x;
			var cx:Number = start.x;
			var ay:Number = start.y - 2 * control.y + anchor.y;
			var by:Number = control.y - start.y;
			var cy:Number = start.y;
			var a:Number = - (ax * ax + ay * ay);
			var b:Number = - 3 * (ax * bx + ay * by);
			var c:Number = ax * (point.x - cx) - 2 * bx * bx + ay * (point.y - cy) - 2 * by * by;
			var d:Number = bx * (point.x - cx) + by * (point.y - cy);
			var answer:Array = _cubicFormula(a, b, c, d);
			var minimum:Number = Number.MAX_VALUE;
			var length:int = answer.length;
			var t:Number;
			for (var i:int = 0; i < length; i++) {
				if (answer[i] < 0) answer[i] = 0;
				else if (answer[i] > 1) answer[i] = 1;
				var distance:Number = Point.distance(point, getValue(start, control, anchor, answer[i]));
				if (distance < minimum) {
					t = answer[i];
					minimum = distance;
				}
			}
			return t;
		}
		
		public static function getTForIntersectionOfLine(start:Point, control:Point, anchor:Point, a:Number, b:Number, c:Number):Array
		{
			var aa:Number = a * (start.x - 2 * control.x + anchor.x) + b * (start.y - 2 * control.y + anchor.y);
			var bb:Number = 2 * a * (control.x - start.x) + 2 * b * (control.y - start.y);
			var cc:Number = a * start.x + b * start.y + c;
			var answer:Array = _quadraticFormula(aa, bb, cc);
			var i:int = answer.length;
			while (i--) {
				var t:Number = answer[i];
				if (t < 0 || t > 1) answer.splice(i, 1);
			}
			return answer;
		}
		
		private static var _ax:Number;
		private static var _ay:Number;
		private static var _bx:Number;
		private static var _by:Number;
		private static var _A:Number;
		private static var _B:Number;
		private static var _C:Number;
		
		private static function _initIntegration(start:Point, control:Point, anchor:Point):void 
		{
			_ax = start.x - 2 * control.x + anchor.x;
			_ay = start.y - 2 * control.y + anchor.y;
			_bx = control.x - start.x;
			_by = control.y - start.y;
			_A = _ax * _ax + _ay * _ay;
			_B = _ax * _bx + _ay * _by;
			_C = _bx * _bx + _by * _by;
			if (_A != 0) {
				_B = _B / _A;
				_C = _C / _A - _B * _B;
				_A = Math.sqrt(_A);
			}
		}
		
		private static function _integrate(t:Number):Number 
		{
			var m:Number = _B + t;
			var n:Number = Math.sqrt(m * m + _C);
			if (_C <= 0) return _A * m * n;
			return _A * (m * n + _C * Math.log(m + n));
		}
		
		private static function _calculateLength(t:Number):Number 
		{
			if (_A == 0) return Math.sqrt(4 * _C) * t;
			return _integrate(t) - _integrate(0);
		}
		
		/**
		 * 二次方程
		 * @param	a
		 * @param	b
		 * @param	c
		 * @return
		 */
		private static function _quadraticFormula(a:Number, b:Number, c:Number):Array
		{
			var answer:Array = [];
			if (a == 0) {
				if (b != 0) answer.push(- c / b);
			} else {
				var D:Number = b * b - 4 * a * c;
				if (D > 0) {
					D = Math.sqrt(D);
					answer.push((- b - D) / (2 * a), (- b + D) / (2 * a));
				} else if (D == 0) {
					answer.push(- b / (2 * a));
				}
			}
			return answer;
		}
		
		/**
		 * 三次方程
		 * @param	a
		 * @param	b
		 * @param	c
		 * @param	d
		 * @return
		 */
		private static function _cubicFormula(a:Number, b:Number, c:Number, d:Number):Array 
		{
			if (a == 0) {
				return _quadraticFormula(b, c, d);
			}
			var answer:Array = [];
			var q:Number = (3 * a * c - b * b) / (9 * a * a);
			var r:Number = (9 * a * b * c - 27 * a * a * d - 2 * b * b * b) / (54 * a * a * a);
			if (q == 0) {
				answer.push((r < 0 ? -1 : 1) * Math.pow(Math.abs(r), 1 / 3) - b / (3 * a));
			} else {
				var D:Number = q * q * q + r * r;
				if (D > 0) {
					D = Math.sqrt(D);
					var s:Number = r + D;
					s = (s < 0 ? -1 : 1) * Math.pow(Math.abs(s), 1 / 3);
					var t:Number = r - D;
					t = (t < 0 ? -1 : 1) * Math.pow(Math.abs(t), 1 / 3);
					answer.push(s + t - b / (3 * a));
				} else {
					var u:Number = Math.sqrt(-q);
					var theta:Number = Math.acos(r / Math.sqrt(-Math.pow(q, 3)));
					answer.push(2 * u * Math.cos(theta / 3) - b / (3 * a));
					answer.push(2 * u * Math.cos((theta + 2 * Math.PI) / 3) - b / (3 * a));
					answer.push(2 * u * Math.cos((theta + 4 * Math.PI) / 3) - b / (3 * a));
				}
			}
			return answer;
		}
		
	}

}