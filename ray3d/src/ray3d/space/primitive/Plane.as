package ray3d.space.primitive
{
	
	/**
	 * ...
	 * @author rayyee
	 */
	public class Plane extends Geometry
	{
		private var _width:int;
		private var _height:int;
		private var _vertices:Vector.<Number>
		private var _indices:Vector.<uint>;
		
		public function Plane(_w:int = 10, _h:int = 10)
		{
			this._width = _w;
			this._height = _h;
			init();
		}
		
		private function init():void
		{
			_vertices.push( -0.5, 0.5, 0, 1, 1, 0,
							0.5, 0.5, 0, 1, 1, 1,
							-0.5, -0.5, 0, 1, 0, 0, 
							0.5, -0.5, 0, 1, 1, 1);
			_indices.push(0, 1, 2, 1, 3, 2);
		}
	
	}

}