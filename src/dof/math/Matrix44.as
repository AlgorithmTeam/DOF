package dof.math 
{
	/**
	 * ...
	 * @author rayyee
	 */
	public class Matrix44 
	{
		
		public function Matrix44() 
		{
			
		}
		
		/**
		 * 矩阵乘法
		 * 原数据
		 * @param	m1
		 * @param	m2
		 * @return
		 */
		public static function multiplyMM(m1:Vector.<Number>,m2:Vector.<Number>):Vector.<Number>
		{
			return Vector.<Number>([
				m1[0] * m2[0] + m1[0] * m2[4] + m1[0] * m2[8] + m1[0] * m2[12], 
					m1[1] * m2[0] + m1[1] * m2[4] + m1[1] * m2[8] + m1[1] * m2[12], 
					m1[2] * m2[0] + m1[2] * m2[4] + m1[2] * m2[8] + m1[2] * m2[12], 
					m1[3] * m2[0] + m1[3] * m2[4] + m1[3] * m2[8] + m1[3] * m2[12],
				m1[4] * m2[1] + m1[4] * m2[5] + m1[4] * m2[9] + m1[4] * m2[13], 
					m1[5] * m2[1] + m1[5] * m2[5] + m1[5] * m2[9] + m1[5] * m2[13], 
					m1[6] * m2[1] + m1[6] * m2[5] + m1[6] * m2[9] + m1[6] * m2[13], 
					m1[7] * m2[1] + m1[7] * m2[5] + m1[7] * m2[9] + m1[7] * m2[13],
				m1[8] * m2[2] + m1[8] * m2[6] + m1[8] * m2[10] + m1[8] * m2[14], 
					m1[9] * m2[2] + m1[9] * m2[6] + m1[9] * m2[10] + m1[9] * m2[14], 
					m1[10] * m2[2] + m1[10] * m2[6] + m1[10] * m2[10] + m1[10] * m2[14], 
					m1[11] * m2[2] + m1[11] * m2[6] + m1[11] * m2[10] + m1[11] * m2[14],
				m1[12] * m2[3] + m1[12] * m2[7] + m1[12] * m2[11] + m1[12] * m2[15], 
					m1[13] * m2[3] + m1[13] * m2[7] + m1[13] * m2[11] + m1[13] * m2[15],
					m1[14] * m2[3] + m1[14] * m2[7] + m1[14] * m2[11] + m1[14] * m2[15],
					m1[15] * m2[3] + m1[15] * m2[7] + m1[15] * m2[11] + m1[15] * m2[15]
			]);
		}
		
		/**
		 * 矩阵乘矢量
		 * Ax=b
		 * @param	m
		 * @param	v
		 * @return
		 */
		public static function multiplyMV(m:Vector.<Number>, v:Vector.<Number>):Vector.<Number>
		{
			return Vector.<Number>([
				m[0] * v[0] + m[1] * v[1] + m[2] * v[2] + m[3] * v[3],
				m[4] * v[0] + m[5] * v[1] + m[6] * v[2] + m[7] * v[3],
				m[8] * v[0] + m[9] * v[1] + m[10] * v[2] + m[11] * v[3],
				m[12] * v[0] + m[13] * v[1] + m[14] * v[2] + m[15] * v[3]
			]);
		}
		
	}

}