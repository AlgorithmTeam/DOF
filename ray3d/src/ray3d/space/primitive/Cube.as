package ray3d.space.primitive
{
	
	/**
	 * ...
	 * @author rayyee
	 */
	public class Cube extends Geometry
	{
		public function Cube(cubeSide:Number)
		{
			var a:Number = cubeSide / 2.0;
			_vertices.push(-a, -a, -a, 0, 0, 0, -a, a, -a, 0, 1, 0, a, a, -a, 1, 1, 0, a, -a, -a, 1, 0, 0, -a, -a, a, 0, 0, 1, -a, a, a, 0, 1, 1, a, a, a, 1, 1, 1, a, -a, a, 1, 0, 1);
			_indices.push(0, 1, 3, 3, 1, 2, 3, 2, 7, 7, 2, 6, 1, 5, 2, 2, 5, 6, 7, 5, 4, 7, 6, 5, 4, 5, 1, 4, 1, 0, 0, 7, 4, 0, 3, 7);
		}
	
	}

}