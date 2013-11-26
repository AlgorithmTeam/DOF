package cn.rayyee.sd.managers 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	/**
	 * ...
	 * @author rayyee
	 */
	public class TextureManager 
	{
		private var _textures:Vector.<Texture>;
		
		private var _context3D:Context3D;
		
		public function TextureManager(_ctx:Context3D,_tnum:int=1) 
		{
			this._context3D = _ctx;
			_textures = new Vector.<Texture>();
		}
		
		public function addTexture(bmd:BitmapData):void
		{
			var _texture:Texture = _context3D.createTexture(bmd.width, bmd.height, Context3DTextureFormat.BGRA, false);
			_texture.uploadFromBitmapData(bmd);
			
			_textures.push(_texture);
			//trace(_textures[0],_texture,bmd,bmd.width, bmd.height);
		}
		
		public function getTexture(_index:int):Texture
		{
			return _textures[_index];
		}
		
	}

}