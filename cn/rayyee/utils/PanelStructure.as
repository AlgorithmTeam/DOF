package cn.rayyee.utils 
{
	/**
	 * ...
	 * @author rayyee
	 */
	public class PanelStructure 
	{
		/**
		 * 面板id
		 */
		private var _iPID:int;
		
		/**
		 * 开始时间
		 */
		private var _aBeginTime:Array;
		
		/**
		 * 结束时间
		 */
		private var _aEndTime:Array;
		
		/**
		 * 类型
		 */
		private var _iType:int;
		
		/**
		 * 级别限制
		 */
		private var _iLevelLimit:int;
		
		/**
		 * 人口限制
		 */
		private var _iPopulationLimit:int;
		
		/**
		 * 弹出几率
		 */
		private var _nProbability:Number;
		
		/**
		 * 任务id
		 */
		private var _aTaskID:Array;
		
		/**
		 * 是否必弹
		 */
		private var _bMustPlay:Boolean;
		
		/**
		 * 是否新手弹
		 */
		private var _bNewUser:Boolean;
		
		/**
		 * 额外内容，如建筑id
		 */
		private var _aAdditional:Array;
		
		public function PanelStructure(_pid:int, _btime:Array, _etime:Array, _type:int, _level:int, _pop:int, 
										_probability:int, _taskid:Array, _mustpaly:Boolean, _newuser:Boolean, _additional:Array)
		{
			this._iPID = _pid;
			this._aBeginTime = _btime;
			this._aEndTime = _etime;
			this._iType = _type;
			this._iLevelLimit = _level;
			this._iPopulationLimit = _pop;
			this._nProbability = _probability;
			this._aTaskID = _taskid;
			this._bMustPlay = _mustpaly;
			this._bNewUser = _newuser;
			this._aAdditional = _additional;
		}
		
		public function get iPID():int 
		{
			return _iPID;
		}
		
		public function get aBeginTime():Array 
		{
			return _aBeginTime;
		}
		
		public function get aEndTime():Array 
		{
			return _aEndTime;
		}
		
		public function get iType():int 
		{
			return _iType;
		}
		
		public function get iLevelLimit():int 
		{
			return _iLevelLimit;
		}
		
		public function get iPopulationLimit():int 
		{
			return _iPopulationLimit;
		}
		
		public function get nProbability():Number 
		{
			return _nProbability;
		}
		
		public function get aTaskID():Array 
		{
			return _aTaskID;
		}
		
		public function get bMustPlay():Boolean 
		{
			return _bMustPlay;
		}
		
		public function get bNewUser():Boolean 
		{
			return _bNewUser;
		}
		
		public function get aAdditional():Array 
		{
			return _aAdditional;
		}
		
	}

}