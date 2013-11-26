package cn.rayyee.sd.shader 
{
	import cn.rayyee.sd.shader.agal.IAGAL;
	import cn.rayyee.sd.shader.agal.ThreeLightFragment;
	import cn.rayyee.sd.shader.agal.ThreeLightVertex;
	import flash.display3D.Context3DProgramType;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author rayyee
	 */
	public class FactoryShader
	{
		
		public function FactoryShader() 
		{
			
		}
		
		/**
		 * 创建着色器
		 * @param	sMode		顶点着色器或碎片着色器
		 * @param	sName		着色器名字
		 * @param	luaMode		着色器语言
		 * @return
		 */
		public static function createShader(sMode:String, sName:String, luaMode:String = "agal"):ByteArray		
		{
			if (luaMode == "agal")
			{
				var _agal:AGALMiniAssembler = new AGALMiniAssembler();
				var _shaderCode:String;
				var _agalCode:IAGAL;
				if (sMode == Context3DProgramType.VERTEX)
				{
					switch(sName)
					{
						case ShaderConst.LIGHT_VERTEX:
							_agalCode = new ThreeLightVertex();
							_shaderCode = _agalCode.getShaderCode();
							break;
						default :
							trace("FactoryShader::sName无效，使用默认顶点着色器.");
							_shaderCode = "m44 op, va0, vc0\n" + // pos to clipspace					
										  "mov v0, va1" // copy uv
							break;
					}
				}
				else if (sMode == Context3DProgramType.FRAGMENT)
				{
					switch(sName)
					{
						case ShaderConst.LIGHT_FRAGMENT:
							_agalCode = new ThreeLightFragment();
							_shaderCode = _agalCode.getShaderCode();
							break;
						default :
							trace("FactoryShader::sName无效，使用默认碎片着色器.");
							_shaderCode = "tex ft1, v0, fs0 <2d,linear,nomip>\n" +
										  "mov oc, ft1";
							break;
					}
				}
				else trace("FactoryShader::sMode无效.");
				_agal.assemble(sMode, _shaderCode);
				return _agal.agalcode;
			}
			else if (luaMode == "pixelbender3d")
			{
				if (sMode == Context3DProgramType.VERTEX)
				{
					return null;
				}
				else if (sMode == Context3DProgramType.FRAGMENT)
				{
					return null;
				}
			}
			
			return null;
		}
		
		
	}

}