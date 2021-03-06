package dofold.space.scene
{
	import dofold.space.primitive.api.IPrimitive;
	
	/**
	 * ...
	 * @author rayyee
	 */
	public class Scene
	{
		private var _childs:Vector.<IPrimitive>
		
		public function Scene()
		{
			_childs = new Vector.<IPrimitive>;
		}
		
		public function addChild(_child:IPrimitive):void
		{
			_childs.push(_child);
		}
		
		public function get childs():Vector.<IPrimitive> 
		{
			return _childs;
		}
	
	}

}