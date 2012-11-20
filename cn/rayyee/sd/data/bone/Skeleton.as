package cn.rayyee.sd.data.bone 
{
	import cn.rayyee.sd.data.md5.Vertex;
	import cn.rayyee.sd.data.md5.Weight;
	import cn.rayyee.sd.gemo.Joint;
	/**
	 * ...
	 * @author rayyee
	 */
	public class Skeleton 
	{
		//骨节
		public var joints:Vector.<Joint>;
		//权重
		public var weights:Vector.<Weight>;
		//顶点
		public var vertexs:Vector.<Vertex>;
		
		public function Skeleton() 
		{
			this.joints = new Vector.<Joint>;
			this.weights = new Vector.<Weight>;
			this.vertexs = new Vector.<Vertex>;
		}
		
	}

}