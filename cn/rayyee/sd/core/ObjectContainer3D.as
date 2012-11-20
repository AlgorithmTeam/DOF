package cn.rayyee.sd.core 
{
	/**
	 * ...
	 * @author rayyee
	 */
	public class ObjectContainer3D extends Object3D 
	{
		
		protected var _childs:Vector.<Object3D>;
		
		public function ObjectContainer3D() 
		{
			_childs = new Vector.<Object3D>;
		}
		
		override public function updateMatrix():void
		{
			super.updateMatrix();
			var _obj:Object3D;
			for each(_obj in _childs)
			{
				//trace("???");
				_obj.updateMatrix();
				_obj.mat.append(mat);
			}
		}
		
		public function get numChildren():int
		{
			return _childs.length;
		}
		
		public function addChild(_obj:Object3D):void
		{
			_childs.push(_obj);
		}
		
		public function removeChildAt(_index:int):void
		{
			_childs.splice(_index, 1);
		}
		
		public function removeChild(_obj:Object3D):void
		{
			removeChildAt(_childs.indexOf(_obj));
		}
		
		public function getChildByIndex(_index:int):Object3D
		{
			return _childs[_index];
		}
		
	}

}