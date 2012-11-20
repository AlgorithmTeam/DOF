package dof.space.primitive
{
	import flash.geom.Matrix3D;
	
	/**
	 * ...
	 * @author rayyee
	 */
	public class Geometry implements IPrimitive
	{
		protected var _vertices:Vector.<Number>
		protected var _indices:Vector.<uint>;
		protected var _model:Matrix3D;
		
		public function Geometry()
		{
			_vertices = new Vector.<Number>;
			_indices = new Vector.<uint>;
		}
		
		public function get vertices():Vector.<Number>
		{
			return _vertices;
		}
		
		public function get indices():Vector.<uint>
		{
			return _indices;
		}
		
		public function get model():Matrix3D
		{
			return _model ||= new Matrix3D;
		}
	
	}

}