package cn.rayyee.sd.core 
{
	import cn.rayyee.sd.camera.Camera3D;
	import cn.rayyee.sd.color.RGB;
	import cn.rayyee.sd.color.UV;
	import cn.rayyee.sd.data.bone.Skeleton;
	import cn.rayyee.sd.gemo.Triangle;
	import cn.rayyee.sd.math.Vector3;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author rayyee
	 */
	public class Mesh extends ObjectContainer3D
	{
		//texture
		public var texture:Texture;
		
		public var skeleton:Skeleton;
		
		//Buffer
		public var vertexBuffer:VertexBuffer3D;
		public var colorBuffer:VertexBuffer3D;
		public var normBuffer:VertexBuffer3D;
		public var uvBuffer:VertexBuffer3D;
        public var indexBuffer:IndexBuffer3D;
		
		//脏处理
        protected var _dirty:Boolean = true;
		
		//RawData
        public var verts:Vector.<Vector3>;
        public var norms:Vector.<Vector3>;
		public var uvs:Vector.<UV>;
        public var colors:Vector.<RGB>;
        public var tris:Vector.<Triangle>;
		public var indecies:Vector.<uint>;
		
		public function Mesh() 
		{
			this.verts = new Vector.<Vector3>();
            this.norms = new Vector.<Vector3>();
			this.uvs = new Vector.<UV>();
            this.colors = new Vector.<RGB>();
            this.tris = new Vector.<Triangle>();
			this.indecies = new Vector.<uint>();
			this.skeleton = new Skeleton();
		}
		
		/**
		 * 添加三角形
		 * 索引
		 * @param	ind1
		 * @param	ind2
		 * @param	ind3
		 * @param	len		是否指定顶点数量
		 */
		public function addTri(ind1:uint, ind2:uint, ind3:uint, len:int = 0):void			
		{
            //var len:uint = verts.length;
			len ||= verts.length;
            if (ind1 >= len) trace("!ERROR: Mesh.addTri(ind1) is out of range.");
            if (ind2 >= len) trace("!ERROR: Mesh.addTri(ind2) is out of range.");
            if (ind3 >= len) trace("!ERROR: Mesh.addTri(ind3) is out of range.");
            tris.push(new Triangle(ind1, ind2, ind3));
            _dirty = true;
        }
		
		/**
		 * 添加UV
		 * @param	u
		 * @param	v
		 */
		public function addUV(u:Number, v:Number):void
		{
			uvs.push(new UV(u, v));
		}
		
		/**
		 * 添加顶点
		 * @param	v
		 */
        public function addVert(v:Vector3):void
		{
            verts.push(v);
            norms.push(new Vector3());
            colors.push(new RGB(1, 1, 1));
        }
		
		/**
		 * 创建贴图
		 * @param	context
		 * @param	bmd
		 */
		public function createTexture(context:Context3D,bmd:BitmapData):void
		{
			texture = context.createTexture(bmd.width, bmd.height, Context3DTextureFormat.BGRA, false);
			texture.uploadFromBitmapData(bmd);
		}
		
		/**
		 * 每个面的法线
		 */
		public function calcFaceNorms():void
		{
            var tri:Triangle;
            var v1:Vector3;
            var v2:Vector3;
            var v3:Vector3;
            for each (tri in this.tris) {
                v1 = verts[tri.inds[0]];
                v2 = verts[tri.inds[1]];
                v3 = verts[tri.inds[2]];
                tri.norm.x = (((v3.y - v1.y) * (v2.z - v1.z)) - ((v2.y - v1.y) * (v3.z - v1.z)));
                tri.norm.y = (((v3.z - v1.z) * (v2.x - v1.x)) - ((v2.z - v1.z) * (v3.x - v1.x)));
                tri.norm.z = (((v3.x - v1.x) * (v2.y - v1.y)) - ((v2.x - v1.x) * (v3.y - v1.y)));
                tri.norm.inorm();
            }
        }
		
		/**
		 * 每个顶点的法线
		 * 是顶点经过的所有面的法线之和
		 * 先通过calcFaceNorms计算面法线，再用calcVertNorms计算顶点法线
		 */
		public function calcVertNorms():void
		{
            var n:Vector3;
            var tri:Triangle;
            var i:uint;
            for each (n in this.norms) n.zero();
            for each (tri in this.tris) {
                for each (i in tri.inds) this.norms[i].iaddv(tri.norm);
            }
            for each (n in this.norms) n.inorm();
        }
		
		/**
		 * 物体是否发生过改变
		 */
        public function get dirty():Boolean
		{
            return _dirty;
        }
		
		public function set dirty(value:Boolean):void 
		{
			_dirty = value;
		}
		
		/**
		 * 绘制mesh
		 */
		override public function draw(context:Context3D, camera:Camera3D):void
		{
			if (_childs.length)
			{
				var _m:Object3D;
				for each (_m in _childs) {
					_m.draw(context,camera);
				}
			}
			//else
			//{
				drawTriangles(context,camera);
			//}
		}
		
		private function drawTriangles(context:Context3D,camera:Camera3D):void 
		{
			mat.append(camera.viewProjection);
			if (dirty) updateBuffers(context);
			var normMatrix:Matrix3D = new Matrix3D();
			if (rot.x != 0) normMatrix.appendRotation(rot.x, new Vector3D(1, 0, 0));
			if (rot.y != 0) normMatrix.appendRotation(rot.y, new Vector3D(0, 1, 0));
			if (rot.z != 0) normMatrix.appendRotation(rot.z, new Vector3D(0, 0, 1));
			context.setVertexBufferAt(0, vertexBuffer, 0, "float3");
			context.setVertexBufferAt(1, normBuffer, 0, "float3");
			context.setVertexBufferAt(2, uvBuffer, 0, "float2");
			context.setVertexBufferAt(3, colorBuffer, 0, "float3");
			context.setTextureAt(0, texture);
			context.setProgramConstantsFromMatrix("vertex", 0, mat, true);
			context.setProgramConstantsFromMatrix("vertex", 4, normMatrix, true);
			context.drawTriangles(indexBuffer, 0, tris.length);
		}
		
		/**
		 * 更新缓冲区
		 * @param	context
		 */
		public function updateBuffers(context:Context3D):void
		{
            var tri:Triangle;
            var v:Vector3;
            var c:RGB;
			var u:UV;
            var n:Vector3;
            var vb:Vector.<Number> = new Vector.<Number>();//vertex
            var cb:Vector.<Number> = new Vector.<Number>();//color
            var nb:Vector.<Number> = new Vector.<Number>();//norm
			var ub:Vector.<Number> = new Vector.<Number>();//uv
            var len:uint = verts.length;
			//if (len <= 0) return;
            var i:uint;
            while (i < len) {
                v = verts[i];
                c = colors[i];
                n = norms[i];
				u = uvs[i];
                //vb.push(v.x, v.y, v.z, c.r, c.g, c.b, n.x, n.y, n.z);
                vb.push(v.x, v.y, v.z);
                cb.push(c.r, c.g, c.b);
                nb.push(n.x, n.y, n.z);
				ub.push(u.u, u.v);
                i++;
            }
            vertexBuffer = context.createVertexBuffer(len, 3);
            vertexBuffer.uploadFromVector(vb, 0, len);
			
			//colorBuffer = context.createVertexBuffer(len, 3);
			//colorBuffer.uploadFromVector(cb, 0, len);
			
			normBuffer = context.createVertexBuffer(norms.length, 3);
			normBuffer.uploadFromVector(nb, 0, norms.length);
			
			uvBuffer = context.createVertexBuffer(uvs.length, 2);
			uvBuffer.uploadFromVector(ub, 0, uvs.length);
			
            indecies = new Vector.<uint>();
            for each (tri in tris) {
                indecies.push(tri.inds[0], tri.inds[1], tri.inds[2]);
            }
			//trace(indecies.length,"len",vb.length);
            indexBuffer = context.createIndexBuffer(indecies.length);
            indexBuffer.uploadFromVector(indecies, 0, indecies.length);
            _dirty = false;
        }
		
	}

}