package cn.rayyee.sd.gemo 
{
	import cn.rayyee.sd.math.Vector3;
	/**
	 * ...
	 * @author rayyee
	 */
	final public class Triangle 
	{
		public var inds:Vector.<uint>;
        public var norm:Vector3;
		public function Triangle(ind1:uint, ind2:uint, ind3:uint) 
		{
			this.inds = new Vector.<uint>(3, true);
            this.norm = new Vector3();
            this.inds[0] = ind1;
            this.inds[1] = ind2;
            this.inds[2] = ind3;
		}
		
	}

}