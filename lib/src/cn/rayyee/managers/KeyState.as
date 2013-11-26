package cn.rayyee.managers 
{
	import flash.events.KeyboardEvent;
	/**
	 * ...
	 * @author rayyee
	 */
	public class KeyState 
	{
		
		public var left:Boolean = false;
		public var up:Boolean = false;
		public var right:Boolean = false;
		public var down:Boolean = false;
		public var a:Boolean = false;
		public var b:Boolean = false;
		public var c:Boolean = false;
		public var d:Boolean = false;
		public var p:Boolean = false;
		public var f:Boolean = false;
		public var esc:Boolean = false;
		//
		//押したフレームのみtrue
		public var leftP:Boolean = false;
		public var upP:Boolean = false;
		public var rightP:Boolean = false;
		public var downP:Boolean = false;
		public var aP:Boolean = false;
		public var bP:Boolean = false;
		public var cP:Boolean = false;
		public var dP:Boolean = false;
		public var pP:Boolean = false;
		public var fP:Boolean = false;
		public var escP:Boolean = false;
		//
		public var controlType:uint = 0;
		public var keyChecked:Boolean = false;
		//
		private var aCode:uint = 90;
		private var bCode:uint = 88;
		private var cCode:uint = 67;
		private var dCode:uint = 86;
		private var pCode:uint = 80;
		private var fCode:uint = 70;
		//
		public function onKeyDown(myEvt:KeyboardEvent):void 
		{
			keyChecked = false;
			//trace("[ "+myEvt+" ]キーが押されました")
			switch (myEvt.keyCode) {
				case 37://←
				case 100://テンキー4
				case 65://A
					if (left == false) {
						leftP = true;
					}
					left = true;
					break;
				case 38://↑
				case 104://テンキー8
				case 87://W
					if (up == false) {
						upP = true;
					}
					up = true;
					break;
				case 39://→
				case 102://テンキー6
				case 68://D
					if (right == false) {
						rightP = true;
					}
					right = true;
					break;
				case 40://↓
				case 98://テンキー2
				case 83://S
					if (down == false) {
						downP = true;
					}
					down = true;
					break;
				case aCode://Z
				case 32://SPACE
					if (a == false) {
						aP = true;
					}
					a = true;
					break;
				case bCode://X
					if (b == false) {
						bP = true;
					}
					b = true;
					break;
				case cCode://C
					if (c == false) {
						cP = true;
					}
					c = true;
					break;
				case dCode://V
					if (d == false) {
						dP = true;
					}
					d = true;
					break;
				case pCode://P
					if (p == false) {
						pP = true;
					}
					p = true;
					break;
				case fCode://F
					if (f == false) {
						fP = true;
					}
					f = true;
					break;
				case 27://ESC
					if (esc == false) {
						escP = true;
					}
					esc = true;
					break;
				default :
					break;
			}
		}
		
		public function onKeyUp(myEvt:KeyboardEvent):void 
		{
			keyChecked = false;
			switch (myEvt.keyCode) {
				case 37://←
				case 100://テンキー4
				case 65://A
					left = false;
					break;
				case 38://↑
				case 104://テンキー8
				case 87://W
					up = false;
					break;
				case 39://→
				case 102://テンキー6
				case 68://D
					right = false;
					break;
				case 40://↓
				case 98://テンキー2
				case 83://S
					down = false;
					break;
				case aCode://Z
				case 32://SPACE
					a = false;
					break;
				case bCode://X
					b = false;
					break;
				case cCode://C
					c = false;
					break;
				case dCode://V
					d = false;
					break;
				case pCode://P
					p = false;
					break;
				case fCode://F
					f = false;
					break;
				case 27://ESC
					esc = false;
					break;
				default :
					break;
			}
		}
		
		public function keyCheck():void 
		{
			if (keyChecked == false)
			{
				keyChecked = true;
				leftP = false;
				upP = false;
				rightP = false;
				downP= false;
				aP = false;
				bP = false;
				cP = false;
				dP = false;
				pP = false;
				fP = false;
				escP = false;
			}
		}
		
	}

}