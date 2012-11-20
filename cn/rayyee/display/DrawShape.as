package cn.rayyee.display 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * ...画一些简单的图形
	 * @author rayyee
	 */
	public class DrawShape extends Sprite 
	{
		
		public function DrawShape() 
		{
			//静态工具类，无需实例化
		}
		
		/**
		 * 画一个圆形
		 * 通常当作一个球
		 * @param	_radius
		 * @param	_color
		 * @return
		 */
		public static function createCircle(_radius:Number,_color:uint=0xff):Shape
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill(_color, 1);
			shape.graphics.drawCircle(0, 0, _radius);
			shape.graphics.endFill();
			
			return shape;
		}
		
		/**
		 * 画一个矩形
		 * @param	_x
		 * @param	_y
		 * @param	_width
		 * @param	_height
		 * @param	_color
		 * @return
		 */
		public static function createRect(_x:Number,_y:Number,_width:Number,_height:Number,_color:uint=0xff):Shape
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill(_color);
			shape.graphics.drawRect(_x, _y, _width, _height);
			shape.graphics.endFill();
			
			return shape;
		}
		
	}

}