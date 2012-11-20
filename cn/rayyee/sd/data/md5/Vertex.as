package cn.rayyee.sd.data.md5
{
	import cn.rayyee.sd.color.UV;
	
	/**
	 * MD5顶点数据
	 * 最终顶点需要按照骨骼权重计算
	 * @author rayyee
	 */
	
	public class Vertex
	{
		//顶点索引
		public var index:int;
		//UV值
		public var uv:UV;
		//起始权重索引
		public var startWeight:int;
		//从起始开始的权重数
		public var countWeight:int;
		
		public function Vertex()
		{
		
		}
	
	}

}