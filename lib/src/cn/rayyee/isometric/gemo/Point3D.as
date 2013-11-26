package cn.rayyee.isometric.gemo 
{
	/**
	 * ...
	 * @author rayyee
	 */
	public class Point3D 
	{
		/**
		 * 三点变量
		 */
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		/**
		 * 构造函数
		 * @param	x
		 * @param	y
		 * @param	z
		 */
		public function Point3D(x:Number = 0, y:Number = 0, z:Number = 0) 
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
	}

}