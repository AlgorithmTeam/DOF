package cn.rayyee.sd.utils 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author rayyee
	 */
	public class ByteArrayUtil 
	{
		
		public function ByteArrayUtil() 
		{
			
		}
		
		public static function readStringByClass(f:Class):String
		{
			var bytes:ByteArray = new f();
			return bytes.readUTFBytes(bytes.bytesAvailable);
		}
		
	}

}