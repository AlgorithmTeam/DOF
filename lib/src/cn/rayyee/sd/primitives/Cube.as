package cn.rayyee.sd.primitives 
{
	import cn.rayyee.sd.core.Mesh;
	import cn.rayyee.sd.math.Vector3;
	/**
	 * ...
	 * @author rayyee
	 */
	public class Cube extends Mesh
	{
		
		public function Cube(width:Number = 1, height:Number = 1, depth:Number = 1)
		{
			addVert(new Vector3(-0.5, -0.5, -0.5));//0
            addVert(new Vector3(0.5, -0.5, -0.5));//1
            addVert(new Vector3(0.5, 0.5, -0.5));//2
            addTri(0, 1, 2);
            addVert(new Vector3(-0.5, 0.5, -0.5));//3
            addTri(0, 2, 3);
            addVert(new Vector3(-0.5, 0.5, 0.5));//4
            addTri(0, 3, 4);
            addVert(new Vector3(-0.5, -0.5, 0.5));//5
            addTri(0, 4, 5);
            addVert(new Vector3(0.5, 0.5, 0.5));//6
            addTri(5, 4, 6);
            addVert(new Vector3(0.5, -0.5, 0.5));//7
            addTri(5, 6, 7);
            addTri(7, 6, 2);
            addTri(7, 2, 1);
            addTri(0, 5, 1);
            addTri(1, 5, 7);
            addTri(2, 4, 3);
            addTri(4, 2, 6);
			
			addUV(1, 0);
			addUV(0, 0);
			addUV(0, 1);
			addUV(1, 1);
			
			addUV(1, 0);
			addUV(1, 1);
			addUV(0, 1);
			addUV(0, 0);
			
            calcFaceNorms();
            calcVertNorms();
			
			//addVert(new Vector3(-0.5, -0.5, -0.5));
            //addVert(new Vector3(0.5, -0.5, -0.5));
            //addVert(new Vector3(0.5, 0.5, -0.5));
            //addVert(new Vector3(-0.5, 0.5, -0.5));
            //addTri(0, 1, 2);
            //addTri(0, 2, 3);
            //addVert(new Vector3(-0.5, -0.5, -0.5));
            //addVert(new Vector3(-0.5, 0.5, -0.5));
            //addVert(new Vector3(-0.5, 0.5, 0.5));
            //addVert(new Vector3(-0.5, -0.5, 0.5));
            //addTri(4, 5, 6);
            //addTri(4, 6, 7);
            //addVert(new Vector3(0.5, 0.5, 0.5));
            //addVert(new Vector3(0.5, -0.5, 0.5));
            //addVert(new Vector3(-0.5, -0.5, 0.5));
            //addVert(new Vector3(-0.5, 0.5, 0.5));
            //addTri(8, 9, 10);
            //addTri(8, 10, 11);
            //addVert(new Vector3(0.5, -0.5, -0.5));
            //addVert(new Vector3(0.5, -0.5, 0.5));
            //addVert(new Vector3(0.5, 0.5, 0.5));
            //addVert(new Vector3(0.5, 0.5, -0.5));
            //addTri(12, 13, 14);
            //addTri(12, 14, 15);
            //addVert(new Vector3(-0.5, -0.5, -0.5));
            //addVert(new Vector3(-0.5, -0.5, 0.5));
            //addVert(new Vector3(0.5, -0.5, -0.5));
            //addVert(new Vector3(0.5, -0.5, 0.5));
            //addTri(16, 17, 18);
            //addTri(18, 17, 19);
            //addVert(new Vector3(-0.5, 0.5, -0.5));
            //addVert(new Vector3(0.5, 0.5, -0.5));
            //addVert(new Vector3(-0.5, 0.5, 0.5));
            //addVert(new Vector3(0.5, 0.5, 0.5));
            //addTri(20, 21, 22);
            //addTri(22, 21, 23);
            //calcFaceNorms();
            //calcVertNorms();
		}
		
	}

}