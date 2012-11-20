package ray3d.space.camera 
{
	import flash.geom.Matrix3D;
	/**
	 * ...
	 * @author rayyee
	 */
	public class CameraBasic
	{
		private var _projection:Matrix3D;
		private var _view:Matrix3D;
		private var _zFar:Number;
		private var _zNear:Number;
		
		public function CameraBasic(zn:Number,zf:Number) 
		{
			this._zFar = zf;
			this._zNear = zn;
			this._view = new Matrix3D;
			this._projection = new Matrix3D;
		}
		
		/**
		 * 透视投影[左手系]
		 * 根据投影面视野角度确定范围
		 * OpenGL算法
		 * @param	fieldOfViewY	在Y轴上的视野范围
		 * @param	aspectRatio		宽高比
		 */
		public function perspectiveFieldOfViewLH(fieldOfViewY:Number, aspectRatio:Number):void
		{
			var yScale:Number = 1.0/Math.tan(fieldOfViewY/2.0);
			var xScale:Number = yScale / aspectRatio; 
			_projection.copyRawDataFrom(Vector.<Number>([
				xScale, 0.0, 0.0, 0.0,
				0.0, yScale, 0.0, 0.0,
				0.0, 0.0, _zFar/(_zFar-_zNear), 1.0,
				0.0, 0.0, (_zNear*_zFar)/(_zNear-_zFar), 0.0
			]));
		}
		public function perspectiveFieldOfViewRH(fieldOfViewY:Number, aspectRatio:Number):void {
			var yScale:Number = 1.0/Math.tan(fieldOfViewY/2.0);
			var xScale:Number = yScale / aspectRatio; 
			_projection.copyRawDataFrom(Vector.<Number>([
				xScale, 0.0, 0.0, 0.0,
				0.0, yScale, 0.0, 0.0,
				0.0, 0.0, _zFar/(_zNear-_zFar), -1.0,
				0.0, 0.0, (_zNear*_zFar)/(_zNear-_zFar), 0.0
			]));
		}
		
		public function get vp():Matrix3D
		{
			var _vp:Matrix3D = new Matrix3D();
			_vp.append(_view);
			_vp.append(_projection);
			return _vp;
		}
		
		public function get projection():Matrix3D 
		{
			return _projection;
		}
		
		public function get view():Matrix3D 
		{
			return _view;
		}
		
	}

}