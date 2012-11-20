package cn.rayyee.sd.parser 
{
	import cn.rayyee.sd.data.md5.BaseFrame;
	import cn.rayyee.sd.data.md5.Bound;
	import cn.rayyee.sd.data.md5.Frame;
	import cn.rayyee.sd.data.md5.Hierarchy;
	import cn.rayyee.sd.gemo.Quaternion;
	import cn.rayyee.sd.utils.ByteArrayUtil;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	/**
	 * MD5骨骼动画
	 * @author rayyee
	 */
	public class Md5AnimParser
	{
		//总帧数
		private var numFrames:int;
		//骨节数
		private var numJoints:int;
		//基础帧
		private var _baseFrames:Vector.<BaseFrame>;
		//帧信息
		private var _frames:Vector.<Frame>;
		//边界信息，碰撞检测有用
		private var _bounds:Vector.<Bound>;
		//层次信息
		private var _hierarchys:Vector.<Hierarchy>;
		
		public function Md5AnimParser(file:Class) 
		{
			_hierarchys = new Vector.<Hierarchy>;
			_bounds = new Vector.<Bound>;
			_baseFrames = new Vector.<BaseFrame>;
			_frames = new Vector.<Frame>;
			
			var fileCode:String = ByteArrayUtil.readStringByClass(file);
			var codes:Vector.<String> = Vector.<String>(fileCode.split("\n"));
			var i:int, count:int = codes.length;
			var di:int, lBraces:Boolean, temp:int, braces:Vector.<Vector.<String>> = new Vector.<Vector.<String>>;
			for (i = 0; i < count; i += 1)
			{
				di = codes[i].indexOf("//");
				if (di == 0) continue;
				if (di != -1) codes[i] = codes[i].substr(0, di);
				if (codes[i].indexOf("{")!=-1)
				{
					braces.push(new Vector.<String>);
					lBraces = true;
					continue;
				}
				if (lBraces)
				{
					if (codes[i].indexOf("}") != -1) 
					{
						temp++;
						lBraces = false;
						continue;
					}
					if (codes[i].indexOf("	") != -1) braces[temp].push(codes[i]);
				}
			}
			
			parserHierarchy(braces[0]);
			parserBaseFrame(braces[2]);
			count = braces.length;
			for (i = 3; i < count; i += 1)
			{
				parserFrame(braces[i], i - 3);
			}
		}
		
		private function parserBaseFrame(code:Vector.<String>):void
		{
			var i:int,cs:Vector.<String>,bf:BaseFrame, count:int = code.length;
			for (i = 0; i < count; i += 1)
			{
				cs = Vector.<String>(code[i].split(" "));
				bf = new BaseFrame();
				bf.pos = new Vector3D(Number(cs[1]), Number(cs[2]), Number(cs[3]));
				bf.orient = new Quaternion(Number(cs[6]), Number(cs[7]), Number(cs[8]));
				_baseFrames.push(bf);
			}
		}
		
		private function parserFrame(code:Vector.<String>,_index:int):void
		{
			var i:int, fm:Frame = new Frame(), count:int = code.length;
			fm.index = _index;
			for (i = 0; i < count; i += 1)
			{
				fm.datas.push(Number(code[i]));
			}
			_frames.push(fm);
		}
		
		private function parserHierarchy(code:Vector.<String>):void
		{
			var i:int, hi:Hierarchy,cs0:Vector.<String>, cs:Vector.<String>, count:int = code.length;
			for (i = 0; i < count; i += 1)
			{
				cs = Vector.<String>(code[i].split(" "));
				cs0 = Vector.<String>(cs[0].split("	"));
				hi = new Hierarchy();
				hi.name = cs0[1];
				hi.parentIndex = int(cs0[2]);
				hi.flags = int(cs[1]);
				hi.startIndex = int(cs[2]);
				_hierarchys.push(hi);
			}
		}
		
		public function get frames():Vector.<Frame> 
		{
			return _frames;
		}
		
		public function get baseFrames():Vector.<BaseFrame> 
		{
			return _baseFrames;
		}
		
		public function get hierarchys():Vector.<Hierarchy> 
		{
			return _hierarchys;
		}
		
	}

}