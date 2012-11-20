package cn.rayyee.sd.primitives 
{
	import cn.rayyee.sd.core.Mesh;
	import cn.rayyee.sd.math.Vector3;
	
	/**
	 * ...
	 * @author rayyee
	 */
	public class Plane extends Mesh 
	{
		
		public function Plane() 
		{
			addVert(new Vector3( -0.5, 0, 0));
			addVert(new Vector3(0.5, 0, 0));
			addVert(new Vector3( -0.5, 0, 0.5));
			addVert(new Vector3(0.5, 0, 0.5));
			addTri(0, 1, 2);
			addTri(1, 3, 2);
			
			addUV(0,0);
			addUV(0,1);
			addUV(1,0);
			addUV(1,1);
			
			calcFaceNorms();
            calcVertNorms();
		}
		
	}

}