package cn.rayyee.giso.display
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix3D;
	
	/**
	 * ...
	 * @author rayyee
	 */
	public class GpuSprite
	{
		private var _transform:Matrix3D;
		private var _width:Number;
		private var _height:Number;
		private var _vertexBuffer3D:VertexBuffer3D;
		private var _uvBuffer3D:VertexBuffer3D;
		private var _indexBuffer3D:IndexBuffer3D;
		
		public function GpuSprite()
		{
			this._transform = new Matrix3D();
			this._width = 120;
			this._height = 80;
			var _scaleX:Number = .32;
			//this._transform.appendScale(_scaleX, _width / _height * _scaleX, 1);
			this._transform.appendScale(_scaleX, 760 / 650 * _scaleX, 1);
			this._transform.appendTranslation(-1, 80/600, 0);
		}
		
		public function init(context3D:Context3D):void
		{
			var _vertexsRowData:Vector.<Number> = Vector.<Number>([0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0, 1.0]);
			var _uvsRowData:Vector.<Number> = Vector.<Number>([0.0, 120/128, 120/128, 120/128, 0.0, 0.0, 120/128, 0.0]);
			var _indicesRowData:Vector.<uint> = Vector.<uint>([0, 2, 1, 1, 2, 3]);
			
			_vertexBuffer3D = context3D.createVertexBuffer(4, 2);
			_vertexBuffer3D.uploadFromVector(_vertexsRowData, 0, 4);
			_uvBuffer3D = context3D.createVertexBuffer(4, 2);
			_uvBuffer3D.uploadFromVector(_uvsRowData, 0, 4);
			_indexBuffer3D = context3D.createIndexBuffer(6);
			_indexBuffer3D.uploadFromVector(_indicesRowData, 0, 6);
			
			initBuffers(context3D);
		}
		
		public function createTexture(context3D:Context3D,bmd:BitmapData):void
		{
			var _texture:Texture = context3D.createTexture(bmd.width, bmd.height, Context3DTextureFormat.BGRA, false);
			_texture.uploadFromBitmapData(bmd);
			context3D.setTextureAt(0, _texture);
		}
		
		private function initBuffers(context3D:Context3D):void
		{
			context3D.setVertexBufferAt(0, _vertexBuffer3D, 0, "float2");
			context3D.setVertexBufferAt(1, _uvBuffer3D, 0, "float2");
		}
		
		public function render(context3D:Context3D):void
		{
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _transform, true);
			context3D.drawTriangles(_indexBuffer3D, 0, 2);
		}
	
	}

}