package cn.rayyee.sd.shader.agal 
{
	/**
	 * ...
	 * @author rayyee
	 */
	public class ThreeLightFragment implements IAGAL
	{
		
		public function ThreeLightFragment() 
		{
			
		}
		
		public function getShaderCode():String
		{
			return "tex ft2, v2, fs0<2d,clamp,linear> \n" +			
					"mov oc , ft2 ";
			//return "dp3 ft0, fc1, v2 \n" +
					//"mul ft1, fc2, ft0 \n" + 
					//"mul ft0, ft1, v1 \n" + 
					//"mul ft2, fc0, v0.z \n" + 
					//"add oc, ft2, ft0";
			//return "nrm ft0.xyz, v1 \n" +       //normalize the fragment normal (v1)
					//"mov ft0.w, fc0.w \n"+      //set the w component to 0
					//"tex ft2, v2, fs0 <2d,clamp,linear> \n"+  //sample texture (fs0) using uv coordinates (v2)
					 //
					//"dp3 ft1, fc2, ft0 \n"+     //dot the transformed normal (ft0) with key light direction (fc2)
					//"max ft1, ft1, fc0 \n"+     //clamp any negative values to 0
					//"mul ft1, ft2, ft1 \n"+     //multiply original fragment color (ft2) by key light amount (ft1)
					//"mul ft3, ft1, fc3 \n"+     //multiply new fragment color (ft1) by key light color (fc3)
					 //
					//"dp3 ft1, fc4, ft0 \n"+     //dot the transformed normal (ft0) with fill light direction (fc4)
					//"max ft1, ft1, fc0 \n"+     //clamp any negative values to 0
					//"mul ft1, ft2, ft1 \n"+     //multiply original fragment color (ft2) by fill light amount (ft1)
					//"mul ft4, ft1, fc5 \n"+     //multiply new fragment color (ft1) by fill light color (fc5)
					 //
					//"dp3 ft1, fc6, ft0 \n"+     //dot the transformed normal (ft0) with back light direction (fc6)
					//"max ft1, ft1, fc0 \n"+     //clamp any negative values to 0
					//"mul ft1, ft2, ft1 \n"+     //multiply original fragment color (ft2) by back light amount (ft1)
					//"mul ft5, ft1, fc7 \n"+     //multiply new fragment color (ft1) by back light color (fc7)
					 //
					//"add ft1, ft3, ft4 \n"+     //add together first two light results (ft3, ft4)
					//"add ft1, ft5, ft1 \n"+     //add on third light result (ft5)
											 //
					//"mul ft2, ft2, fc1 \n"+     //multiply original fragment color (ft2) by ambient light intensity and color (fc1)
					//"add oc, ft2, ft1"          //add ambient light result (ft2) to combined three-light result (ft1) and output
		}
		
	}

}