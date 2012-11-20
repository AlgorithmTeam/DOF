package cn.rayyee.utils
{
	
	/**
	 * ...
	 * @author rayyee
	 */
	public class ColorUtil
	{
		
		public function ColorUtil()
		{
			
		}
		
		public static function extractBit24(bit24:uint):Vector.<uint>
		{
			var red:uint   = bit24 >> 16;
			var green:uint = bit24 >> 8 & 0xFF;
			var blue:uint  = bit24 & 0xFF;
			return Vector.<uint>([red, green, blue]);
		}
		
		public static function extractBit32(bit32:uint):Vector.<uint>
		{
			var alpha:uint = bit32 >> 24;
			var red:uint   = bit32 >> 16 & 0xFF;
			var green:uint = bit32 >> 8 & 0xFF;
			var blue:uint  = bit32 & 0xFF;
			return Vector.<uint>([alpha, red, green, blue]);
		}
	
	}

}