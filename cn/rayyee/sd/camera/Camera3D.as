package cn.rayyee.sd.camera 
{
	import cn.rayyee.sd.camera.lenses.PerspectiveMatrix3D;
	import cn.rayyee.sd.core.Object3D;
	import cn.rayyee.sd.utils.Stage3DConfig;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	/**
	 * Camera transform matrices
	 * - World: The transformation from object space into world space
	 * - View: The transformation from world space into camera space
	 * - Projection: The transformation from camera space into homogeneous clip space
	 * - WorldViewProjection = World*View*Projection || MVP
	 * @version	 alpha
	 * @author  rayyee
	 */
	public class Camera3D extends Object3D
	{
		//The transform from world space into camera space
		//private var _viewTransform:Matrix3D;//Object3D.mat
		//The transform from camera space into homogeneous clip space
		private var _projectionTransform:PerspectiveMatrix3D;
		//_viewProjection=_viewTransform*_projectionTransform
		private var _viewProjection:Matrix3D;
		
		/**
		 * perspective Cut space`s Parameter
		 */
		private var _fieldOfView:Number;
		private var _zNear:Number;
		private var _zFar:Number;
		
		public function Camera3D() 
		{
			_projectionTransform = new PerspectiveMatrix3D();
			_zNear = 1;
			_zFar = 10000;
			_fieldOfView = 100*Math.PI/45;
			//_projectionTransform.perspectiveFieldOfViewRH(_fieldOfView, Stage3DConfig.RATIO, zNear, zFar);
			_viewProjection = new Matrix3D();
			
			//ortho
			_projectionTransform.orthoRH(200, 200, zNear, zFar);
		}
		
		/**
		 * ViewProjection matrices
		 */
		public function get viewProjection():Matrix3D 
		{
			updateMatrix();
			_viewProjection.identity();
			_viewProjection.append(mat);//view
			_viewProjection.append(_projectionTransform);//projection
			return _viewProjection;
		}
		
		/**
		 * 锥形视野范围的角度
		 */
		public function get fieldOfView():Number 
		{
			return _fieldOfView;
		}
		
		/**
		 * z近点
		 */
		public function get zNear():Number 
		{
			return _zNear;
		}
		
		/**
		 * z远点
		 */
		public function get zFar():Number 
		{
			return _zFar;
		}
		
	}

}