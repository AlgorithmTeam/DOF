package cn.rayyee.utils
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.XMLNode;
	
	//import mx.utils.StringUtil;
	
	/**
	 * ...查找面板
	 * @author rayyee
	 */
	public class SearchPanel
	{
		private var _xmlData:XMLList;
		private var _iLevel:int;
		private var _iPop:int;
		private var _bNewUser:Boolean;
		private var _checkTask:Function;
		private var _checkBuild:Function;
		
		public function SearchPanel()
		{
		
		}
		
		/**
		 * 获取一个面板结构
		 * @param	_url
		 * @param	_level
		 * @param	_pop
		 * @param	_newuser
		 * @param	_callBack	解析完以后回调，面板结构作为参数传入callback
		 */
		public function getPanel(_url:String, _level:int, _pop:int, _newuser:Boolean, _callBack:Function, _ct:Function, _cb:Function):void
		{
			this._iLevel = _level;
			this._iPop = _pop;
			this._bNewUser = _newuser;
			this._checkTask = _ct;
			this._checkBuild = _cb;
			if (!_xmlData)
				loadXML(_url, _callBack);
			else
				_callBack.call(null, parserPanelData(_xmlData));
		}
		
		private function loadXML(_url:String, _callBack:Function):void
		{
			var _urlLoader:URLLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, function(e:Event):void
				{
					_xmlData = XMLList(_urlLoader.data).item;
					//trace("0.23">"0.12");
					//_xmlData = _xmlData.(@pid >= 1 && @must == 0);
					//trace(_xmlData);
					_callBack.call(null, parserPanelData(_xmlData));
				});
			_urlLoader.load(new URLRequest(_url));
		}
		
		private function parserPanelData(_data:XMLList):PanelStructure
		{
			//判断等级和人口限制
			//判断起始和结束时间
			//判断是否新手
			var _date:Date = new Date();
			var _mouth:Number = _date.getMonth() + 1;
			var _day:Number = _date.getDate();
			var _iNew:int = _bNewUser ? 1 : 0;
			_data = _data.(@level <= _iLevel && @elevel >= _iLevel && @pop <= _iPop && @btimeM <= _mouth && @etimeM >= _mouth && @btimeD <= _day && @etimeD >= _day && @newuser == _iNew);
			if (_data.length() < 1)
				return null;
			//判断是不是必弹的
			var _musts:XMLList = _data.(@must == 1);
			_data = _musts.length() > 0 ? sortXMLList(_musts, "prob") : sortXMLList(_data, "prob");
			var i:int, _adds:Array, _tasks:Array;
			for (i = 0; i < _data.length(); i += 1)
			{
				_adds = String(_data[i].@additional).split(",");
				_tasks = String(_data[i].@taskid).split(",");
				if (!_checkTask.call(null, _tasks))
				{
					if (_adds.length > 0)
					{
						if (!_checkBuild.call(null, _adds))
						{
							delete _data[i];
							i--;
						}
					}
					else
					{
						delete _data[i];
						i--;
					}
				}
			}
			if (_data.length() < 1)
				return null;
			var _panelStructure:PanelStructure = new PanelStructure(_data[i-1].@id, [_data[i-1].@btimeM, _data[i-1].@btimeD], [_data[i-1].@etimeM, _data[i-1].@etimeD], _data[i-1].@type, _data[i-1].@level, _data[i-1].@pop, _data[i-1].@porb, _tasks, _data[i-1].@must, _data[i-1].@newuser, _adds);
			return _panelStructure;
			//var _str:String = "1988.6.12";
			//trace(StringUtil.restrict(_str, "0-9"));
		}
		
		private function sortXMLList(list:XMLList, fieldName:String):XMLList
		{
			var arr:Array = new Array();
			var ch:XML;
			for each (ch in list)
				arr.push(ch);
			var resultArr:Array = arr.sortOn(fieldName);
			var result:XMLList = new XMLList();
			for (var i:int = 0; i < resultArr.length; i++)
				result += resultArr[i];
			return result;
		}
	
	}

}