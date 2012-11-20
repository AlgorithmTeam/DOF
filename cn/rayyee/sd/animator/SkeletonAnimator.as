package cn.rayyee.sd.animator 
{
	import cn.rayyee.sd.core.Mesh;
	import cn.rayyee.sd.data.md5.BaseFrame;
	import cn.rayyee.sd.data.md5.Frame;
	import cn.rayyee.sd.data.md5.Hierarchy;
	import cn.rayyee.sd.data.md5.Vertex;
	import cn.rayyee.sd.data.md5.Weight;
	import cn.rayyee.sd.gemo.Joint;
	import cn.rayyee.sd.gemo.Quaternion;
	import cn.rayyee.sd.math.Vector3;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author rayyee
	 */
	public class SkeletonAnimator extends BaseAnimator 
	{
		private var _playTimer:Timer;
		private var _meshs:Vector.<Mesh>;
		private var _joints:Vector.<Joint>;
		private var _baseFrames:Vector.<BaseFrame>;
		private var _hierarchys:Vector.<Hierarchy>;
		private var _frames:Vector.<Frame>;
		private var _weights:Vector.<Weight>;
		private var _vertexs:Vector.<Vertex>;
		
		public function SkeletonAnimator(m:Vector.<Mesh>, f:Vector.<Frame>, bf:Vector.<BaseFrame>, hi:Vector.<Hierarchy>) 
		{
			this._baseFrames = bf;
			this._hierarchys = hi;
			//this._joints = j;
			this._meshs = m;
			this._frames = f;
			//this._weights = w;
			//this._vertexs = v;
			
			initTimer();
		}
		
		private function initTimer():void 
		{
			_playTimer = new Timer(30);
			_playTimer.addEventListener(TimerEvent.TIMER, onRender);
		}
		
		private function onRender(e:TimerEvent):void 
		{
			if (_currentFrame >= _totalFrames) _currentFrame = 0;//循环
			_currentFrame++;
			updateJoints();
			updateVertexs();
			//_mesh.dirty = true;
		}
		
		private function updateVertexs():void 
		{
			//最终的顶点计算
			//根据权重指定的骨节方向信息，旋转此权重的位置 rotatePoint
			//每个能影响当前顶点的权重[计算结果]累加 countWeight
			var i:int, j:int,rv:Vector3D,_finalPos:Vector3,tempJoint:Joint,tempWeight:Weight;
			for (i = 0; i < _vertexs.length;i+=1 )
			{
				_finalPos = new Vector3();
				for (j = 0; j < _vertexs[i].countWeight; j += 1)
				{
					tempWeight = _weights[j + _vertexs[i].startWeight];
					tempJoint = _joints[tempWeight.jointIndex];
					rv = tempJoint.orientation.rotatePoint(tempWeight.pos);
					_finalPos.x += (tempJoint.translation.x + rv.x) * tempWeight.bias;
					_finalPos.y += (tempJoint.translation.y + rv.y) * tempWeight.bias;
					_finalPos.z += (tempJoint.translation.z + rv.z) * tempWeight.bias;
				}
				//_mesh.verts[i] = _finalPos;
				//addVert(_finalPos);
			}
			//trace(_mesh.verts.length, "??????", _mesh.skeleton.joints.length);
			//法线计算
			//_mesh.calcFaceNorms();
			//_mesh.calcVertNorms();
			
			//trace("update vertexs");
		}
		
		private function updateJoints():void
		{
			var i:int, j:int, count: int = _joints.length;
			var animatedPos:Vector3D, animatedOrient:Quaternion, rpos:Vector3D = new Vector3D;
			for (i = 0; i < count; i += 1)
			{
				animatedPos = _baseFrames[i].pos;
				animatedOrient = _baseFrames[i].orient;
				j = 0;
				//tx
				if (_hierarchys[i].flags & 1)
				{
					animatedPos.x = _frames[_currentFrame].datas[_hierarchys[i].startIndex + j];
					j++;
				}
				//ty
				if (_hierarchys[i].flags & 2)
				{
					animatedPos.y = _frames[_currentFrame].datas[_hierarchys[i].startIndex + j];
					j++;
				}
				//tz
				if (_hierarchys[i].flags & 4)
				{
					animatedPos.z = _frames[_currentFrame].datas[_hierarchys[i].startIndex + j];
					j++;
				}
				//qx
				if (_hierarchys[i].flags & 8)
				{
					animatedOrient.x = _frames[_currentFrame].datas[_hierarchys[i].startIndex + j];
					j++;
				}
				//qy
				if (_hierarchys[i].flags & 16)
				{
					animatedOrient.y = _frames[_currentFrame].datas[_hierarchys[i].startIndex + j];
					j++;
				}
				//qx
				if (_hierarchys[i].flags & 32)
				{
					animatedOrient.z = _frames[_currentFrame].datas[_hierarchys[i].startIndex + j];
					j++;
				}
				
				//根joint
				if (_joints[i].parentIndex < 0)
				{
					_joints[i].translation = animatedPos;
					_joints[i].orientation = animatedOrient;
				}
				//子joint
				else
				{
					rpos = _joints[_joints[i].parentIndex].orientation.rotatePoint(animatedPos, rpos);
					_joints[i].translation = rpos.add(_joints[_joints[i].parentIndex].translation);
					_joints[i].orientation.multiply(_joints[_joints[i].parentIndex].orientation , animatedOrient);
					_joints[i].orientation.normalize();
				}
				
			}
		}
		
		override public function play():void 
		{
			_currentFrame = 0;
			_playTimer.reset();
			_playTimer.start();
		}
		
		override public function stop():void 
		{
			_playTimer.stop();
		}
		
	}

}