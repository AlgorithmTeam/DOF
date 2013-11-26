package cn.rayyee.sd.parser 
{
	import cn.rayyee.sd.color.UV;
	import cn.rayyee.sd.core.Mesh;
	import cn.rayyee.sd.data.md5.Vertex;
	import cn.rayyee.sd.data.md5.Weight;
	import cn.rayyee.sd.gemo.Joint;
	import cn.rayyee.sd.gemo.Quaternion;
	import cn.rayyee.sd.math.Vector3;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	/**
	 * MD5解析
	 * 绑定骨骼的顶点 计算公式
	 * finalPos = (weight[0].pos * weight[0].bias) + ... + (weight[N].pos * weight[N].bias)
	 * @author rayyee
	 */
	public class Md5MeshParser extends Mesh
	{		
		private const NUMVERTS:String = "numverts";
		private const NUMTRIS:String = "numtris";
		private const NUMWEIGHTS:String = "numweights";
		
		private var _numverts:int;
		private var _numtris:int;
		private var _numweights:int;
		
		private var _meshs:Vector.<Mesh>;
		
		public function Md5MeshParser(file:Class) 
		{			
			
			var fileCode:String = readClass(file);
			var codes:Vector.<String> = Vector.<String>(fileCode.split("\n"));
			var i:int, count:int = codes.length;
			var di:int, lBraces:Boolean = false, braces:Vector.<Vector.<String>> = new Vector.<Vector.<String>>, temp:int = 0;
			for (i = 0; i < count; i += 1)
			{
				di = codes[i].indexOf("//");
				if (di == 0) continue;
				if (di != -1) codes[i] = codes[i].substr(0, di);
				if (codes[i].indexOf("{") != -1)				
				{
					braces.push(new Vector.<String>);
					lBraces = true;
					continue;
				}
				if (lBraces)
				{
					if (codes[i].indexOf("}") != -1)
					{
						lBraces = false;
						temp++;
						continue;
					}
					if (codes[i].indexOf("	") != -1)
					{
						//trace(codes[i]);
						braces[temp].push(codes[i]);
					}
				}
			}
			
			//trace(js);
			var _joints:Vector.<Joint> = parserJoint(braces[0]);
			count = braces.length;
			_meshs = new Vector.<Mesh>(count - 1, true);
			for (i = 1; i < count; i += 1)
			{
				_meshs[i - 1] = parserMesh(braces[i]);
				_meshs[i - 1].skeleton.joints = _joints;
				addChild(_meshs[i - 1]);
			}
			var _mesh:Mesh;
			for (i = 1; i < count; i += 1)
			{
				_mesh = _meshs[i - 1];
				//最终的顶点计算
				//根据权重指定的骨节方向信息，旋转此权重的位置 rotatePoint
				//每个能影响当前顶点的权重[计算结果]累加 countWeight
				var j:int,k:int,rv:Vector3D,_finalPos:Vector3,tempJoint:Joint,tempWeight:Weight;
				for (k = 0; k < _mesh.skeleton.vertexs.length;k+=1 )
				{
					_finalPos = new Vector3();
					for (j = 0; j < _mesh.skeleton.vertexs[k].countWeight; j += 1)
					{
						tempWeight = _mesh.skeleton.weights[j + _mesh.skeleton.vertexs[k].startWeight];
						tempJoint = _mesh.skeleton.joints[tempWeight.jointIndex];
						rv = tempJoint.orientation.rotatePoint(tempWeight.pos);
						_finalPos.x += (tempJoint.translation.x + rv.x) * tempWeight.bias;
						_finalPos.y += (tempJoint.translation.y + rv.y) * tempWeight.bias;
						_finalPos.z += (tempJoint.translation.z + rv.z) * tempWeight.bias; 
					}
					//trace("______");
					_mesh.addVert(_finalPos);
				}
				trace("..............__",i);
				trace(_mesh.verts.length,"?????",count);
				//法线计算
				_mesh.calcFaceNorms();
				_mesh.calcVertNorms();
			}
			trace("quanbu....");
		}
		
		private function parserMesh(ms:Vector.<String>):Mesh
		{
			var _mesh:Mesh = new Mesh();
			var i:int,temp:String,mcodes:Vector.<String>, count:int = ms.length;
			for (i = 0; i < count; i += 1)
			{
				temp = ms[i].indexOf(NUMVERTS) != -1?NUMVERTS:ms[i].indexOf(NUMTRIS) != -1?NUMTRIS:ms[i].indexOf(NUMWEIGHTS) != -1?NUMWEIGHTS:temp;
				switch(temp)
				{
					case NUMVERTS:
						if (ms[i].indexOf(NUMVERTS) != -1) _numverts = ms[i].split(" ")[1];
						else
						{
							mcodes = Vector.<String>(ms[i].split(" "));	
							if (mcodes[0].indexOf("vert") != -1)
							{
								//trace(mcodes);
								var _v:Vertex = new Vertex();
								_v.index = int(mcodes[1]);
								//_v.uv = new UV(Number(mcodes[3]), Number(mcodes[4]));
								_v.startWeight = int(mcodes[6]);
								_v.countWeight = int(mcodes[7]);
								_mesh.skeleton.vertexs.push(_v);
								_mesh.addUV(Number(mcodes[3]), Number(mcodes[4]));
							}
						}
						break;
					case NUMTRIS:
						if (ms[i].indexOf(NUMTRIS) != -1) 
						{
							//_numverts = ms[i].split(" ")[1];
						}
						else
						{
							mcodes = Vector.<String>(ms[i].split(" "));	
							if (mcodes[0].indexOf("tri") != -1)
							{
								//trace(mcodes[2],mcodes[3],mcodes[4]);
								_mesh.addTri(uint(mcodes[2]), uint(mcodes[3]), uint(mcodes[4]), _numverts);
							}
						}
						break;
					case NUMWEIGHTS:
						if (ms[i].indexOf(NUMWEIGHTS) != -1) 
						{
							//_numverts = ms[i].split(" ")[1];
						}
						else
						{
							mcodes = Vector.<String>(ms[i].split(" "));	
							if (mcodes[0].indexOf("weight") != -1)
							{
								//trace(mcodes,"??");
								var _w:Weight = new Weight();
								_w.index = int(mcodes[1]);
								_w.jointIndex = int(mcodes[2]);
								_w.bias = Number(mcodes[3]);
								_w.pos = new Vector3D(Number(mcodes[5]),Number(mcodes[6]),Number(mcodes[7]));
								_mesh.skeleton.weights.push(_w);
							}
						}
						break;
				}
			}
			return _mesh;
		}
		
		/**
		 * 解析骨节
		 * @param	js
		 */
		private function parserJoint(js:Vector.<String>):Vector.<Joint>
		{
			var _joints:Vector.<Joint> = new Vector.<Joint>;
			var i:int, _joint:Joint, jcodes:Vector.<String>,j2:Vector.<String>, count:int = js.length;
			for (i = 0; i < count; i += 1)
			{
				jcodes = Vector.<String>(js[i].split(" "));
				j2 = Vector.<String>(jcodes[0].split("	"));
				_joint = new Joint(j2[1], int(j2[2]), 
									new Vector3D(Number(jcodes[2]), Number(jcodes[3]), Number(jcodes[4])),
									new Quaternion(Number(jcodes[7]), Number(jcodes[8]), Number(jcodes[9])));
				_joints.push(_joint);
				//trace(jcodes);
			}
			return _joints;
		}
		
		private function readClass(f:Class):String
		{
			var bytes:ByteArray = new f();
			return bytes.readUTFBytes(bytes.bytesAvailable);
		}
		
	}

}