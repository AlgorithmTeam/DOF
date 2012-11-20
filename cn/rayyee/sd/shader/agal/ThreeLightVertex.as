package cn.rayyee.sd.shader.agal 
{
	/**
	 * ...
	 * @author rayyee
	 */
	public class ThreeLightVertex implements IAGAL 
	{
		
		public function ThreeLightVertex() 
		{
			
		}
		
		public function getShaderCode():String
		{
			return  "m44 vt0, va0, vc0 \n"+     //transform vertex x,y,z
					"mov op, vt0 \n"+           //output vertex x,y,z
					"m44 v1, va1, vc4 \n"+      //transform vertex normal, send to fragment shader
					"mov v2, va2"              //move vertex u,v to fragment shader
		}
		
		
	}

}