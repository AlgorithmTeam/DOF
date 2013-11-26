package cn.rayyee.sd.core 
{
	import cn.rayyee.sd.camera.Camera3D;
	import cn.rayyee.sd.math.Vector3;
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author rayyee
	 */
	public class Object3D 
	{
		//World Matrix :The transformation from object space into world space
        public var mat:Matrix3D;
		
		//transform
        public var pos:Vector3;
        public var sca:Vector3;
        public var rot:Vector3;
		
		public function Object3D() 
		{
			this.mat = new Matrix3D();
            this.pos = new Vector3();
            this.sca = new Vector3(1, 1, 1);
            this.rot = new Vector3();
		}
		
		public function draw(context:Context3D,camera:Camera3D):void
		{
			
		}
		
		/**
		 * 矩阵变换
		 */
        public function updateMatrix():void
		{
            mat.identity();
            mat.appendScale(sca.x, sca.y, sca.z);
            if (rot.x != 0) mat.appendRotation(rot.x, new Vector3D(1, 0, 0));
            if (rot.y != 0) mat.appendRotation(rot.y, new Vector3D(0, 1, 0));
            if (rot.z != 0) mat.appendRotation(rot.z, new Vector3D(0, 0, 1));
            mat.appendTranslation(pos.x, pos.y, pos.z);
        }
		
	}

}