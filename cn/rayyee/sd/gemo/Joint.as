package cn.rayyee.sd.gemo 
{
	import flash.geom.Vector3D;
	/**
	 * ...骨节
	 * @author rayyee
	 */
	final public class Joint 
	{
		/**
		 * 骨节名称
		 */
		private var _name:String;
		
		/**
		 * 当前节点的父节点下标
		 */
		private var _parentIndex:int;
		
		/**
		 * 偏移信息
		 */
		private var _translation:Vector3D;
		
		/**
		 * 方向信息
		 */
		private var _orientation:Quaternion;
		
		public function Joint(_n:String, _idx:int, _t:Vector3D, _o:Quaternion) 
		{
			this._name = _n;
			this._parentIndex = _idx;
			this._translation = _t;
			this._orientation = _o;
		}
		
		public function get orientation():Quaternion 
		{
			return _orientation;
		}
		
		public function set orientation(value:Quaternion):void 
		{
			_orientation = value;
		}
		
		public function get translation():Vector3D 
		{
			return _translation;
		}
		
		public function set translation(value:Vector3D):void 
		{
			_translation = value;
		}
		
		public function get parentIndex():int 
		{
			return _parentIndex;
		}
		
	}

}