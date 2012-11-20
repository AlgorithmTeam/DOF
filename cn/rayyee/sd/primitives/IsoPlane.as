package cn.rayyee.sd.primitives 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author rayyee
	 */
	public class IsoPlane 
	{
		//顶点
		private var _vertices:Vector.<Number>;
		
		//转换矩阵
		private var _transform:Matrix3D;
		
		private var _context3D:Context3D;
		
		private var _texture:Texture;
		
		public function IsoPlane(_ctx:Context3D) 
		{
			this._context3D = _ctx;
			
			_vertices = Vector.<Number>([
				-10, -10, 5, 0, 0, // x, y, z, u, v
				-10,  10, 5, 0, 1,
				 10,  10, 5, 1, 1,
				 10, -10, 5, 1, 0]);
				 
			_transform = new Matrix3D();
			_transform.appendTranslation(0, 0, 5);
			_transform.appendRotation(45, Vector3D.Z_AXIS);
			_transform.appendScale(1, .5, 1);
		}
		
		public function get vertices():Vector.<Number> 
		{
			return _vertices;
		}
		
		public function get transform():Matrix3D 
		{
			return _transform;
		}
		
		/**
		 * 设置贴图
		 */
		//public function setMaterial(bmd:BitmapData):void
		//{
			//_texture = _context3D.createTexture(bmd.width, bmd.height, Context3DTextureFormat.BGRA, false);
			//_texture.uploadFromBitmapData(bmd);
		//}
		
	}

}