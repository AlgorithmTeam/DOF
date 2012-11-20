package dofold.shader 
{
	import flash.utils.ByteArray;
	/**
	 * AS3 code for AGAL Shader
	 * @author rayyee
	 */
	public class AGALCode 
	{
		private var _agalAssembler:AGALMiniAssembler;
		private var _codes:Vector.<String>;
		public function AGALCode(_agal:AGALMiniAssembler) 
		{
			this._agalAssembler = _agal;
			_codes = new Vector.<String>;
		}
		
		public function add(_code:String):void
		{
			_codes.push(_code);
		}
		
		public function get codes():String 
		{
			return _codes.join("\n");;
		}
		
		public function assemble(mode:String):ByteArray
		{
			return _agalAssembler.assemble(mode, codes);
		}
		
		public function dispose():void
		{
			_codes = new Vector.<String>;
		}
		
	}

}