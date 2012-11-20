package dof.space.primitive
{
	import flash.geom.Matrix3D;
	
	/**
	 * ...
	 * @author rayyee
	 */
	public interface IPrimitive
	{
		function get vertices():Vector.<Number>;
		function get indices():Vector.<uint>;
		function get model():Matrix3D;
	}

}