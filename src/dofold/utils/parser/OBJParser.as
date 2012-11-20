package dofold.utils.parser
{
	import flash.utils.ByteArray;
	
	import dofold.space.primitive.Geometry;

	public class OBJParser extends Geometry
	{
		// 3DSMAX的旧版本中使用了无效的顶点顺序：
		private var _vertex_data_is_zxy:Boolean = false;
		
		// 镜像UV贴图坐标
		// opengl默认的纹理坐标，s不变，t变为1.0 - t
		private var _mirror_uv:Boolean = false;
		
		// OBJ文件不包含顶点颜色
		// 但是许多着色器将需要此数据
		// 如果为false，缓冲区是用纯白色填充
		private var _random_vertex_colors:Boolean = true;
		
		// OBJ文件数据的常量
		private const LINE_FEED:String = String.fromCharCode(10);
		private const SPACE:String = String.fromCharCode(32);
		private const SLASH:String = "/";
		private const VERTEX:String = "v";
		private const NORMAL:String = "vn";
		private const UVWORLD:String = "vt";
		private const INDEX_DATA:String = "f";
		
		// 在解析OBJ文件时使用的临时变量
		private var _scale:Number;
		private var _faceIndex:uint;
		private var _vertices:Vector.<Number>;
		private var _normals:Vector.<Number>;
		private var _uvs:Vector.<Number>;
		private var _cachedRawNormalsBuffer:Vector.<Number>;
		
		public function OBJParser(objfile:Class, scale:Number = 1, data_is_zxy:Boolean = false, texture_flip:Boolean = false)
		{
			_vertex_data_is_zxy = data_is_zxy;
			_mirror_uv = texture_flip;
			
			_scale = scale;
			
			// 将数据转换为String
			var definition:String = readClass(objfile);
			
			// Init raw data containers.
			_vertices = new Vector.<Number>();
			_normals = new Vector.<Number>();
			_uvs = new Vector.<Number>();
			
			// 解析行数，并解析每一行
			var lines:Array = definition.split(LINE_FEED);
			var loop:uint = lines.length;
			for(var i:uint = 0; i < loop; ++i)
				parseLine(lines[i]);
			trace(loop,"loop");
		}
		
		private function readClass(f:Class):String
		{
			var bytes:ByteArray = new f();
			return bytes.readUTFBytes(bytes.bytesAvailable);
		}
		
		private function parseLine(line:String):void
		{
			// 分割成一行字
			var words:Array = line.split(SPACE);
			
			// 准备该行的数据.
			if (words.length > 0)
				var data:Array = words.slice(1);
			else
				return;
			
			// 通过检测第一个字符，把其余的内容交给合适的解析器
			var firstWord:String = words[0];
			if (firstWord == VERTEX)
				parseVertex(data);
			else if (firstWord == NORMAL)
				parseNormal(data);
			else if (firstWord == UVWORLD)
				parseUV(data);
			else if (firstWord == INDEX_DATA)
				parseIndex(data);
		}
		
		private function parseVertex(data:Array):void
		{
			if ((data[0] == '') || (data[0] == ' ')) 
				data = data.slice(1); // delete blanks
			if (_vertex_data_is_zxy)
			{
				//if (!_vertices.length) trace('zxy parseVertex: ' + data[1] + ',' + data[2] + ',' + data[0]);
				_vertices.push(new Vector3(Number(data[1]) * _scale, Number(data[2]) * _scale, Number(data[0]) * _scale));
				_vertices.push(Number(data[1])*_scale);
				_vertices.push(Number(data[2])*_scale);
				_vertices.push(Number(data[0])*_scale);
			}
			else // normal operation: x,y,z
			{
				if (!_vertices.length) trace('parseVertex: ' + data);
				var loop:uint = data.length;
				if (loop > 3) loop = 3;
				//verts.push(new Vector3(Number(data[0]), Number(data[1]), Number(data[2])));
				for (var i:uint = 0; i < loop; ++i)
				{
					var element:String = data[i];
					_vertices.push(Number(element) * _scale);
				}
			}
			//colors.push(new RGB(1,1,1));
		}
		
		private function parseNormal(data:Array):void
		{
			if ((data[0] == '') || (data[0] == ' ')) 
				data = data.slice(1); // delete blanks
			if (!_normals.length) trace('parseNormal:' + data);
			var loop:uint = data.length;
			if (loop > 3) loop = 3;
			//var _vec3:Vector3 = new Vector3(Number(data[0]), Number(data[1]), Number(data[2]));
			for (var i:uint = 0; i < loop; ++i)
			{
				var element:String = data[i];
				if (element != null) // handle 3dsmax extra spaces
					_normals.push(Number(element));
			}
			//norms.push(_vec3);
		}
		
		private function parseUV(data:Array):void
		{
			if ((data[0] == '') || (data[0] == ' ')) 
				data = data.slice(1); // delete blanks
			if (data.length != 2) 
				trace('parseUV:' + data, data.length);
			//var loop:uint = data.length;
			//if (loop > 2) loop = 2;
			_uvs.push(Number(data[0]), Number(data[1]));
			//for (var i:uint = 0; i < loop; ++i)
			//{
			//var element:String = data[i];
			//_uvs.push(Number(element));
			//}
		}
		
		private function parseIndex(data:Array):void
		{
			if (!tris.length) trace('parseIndex:' + data);
			var triplet:String;
			var subdata:Array;
			var vertexIndex:int;
			var uvIndex:int;
			var normalIndex:int;
			var index:uint;
			
			var i:uint;
			var loop:uint = data.length;
			var starthere:uint = 0;
			while ((data[starthere] == '') || (data[starthere] == ' ')) starthere++; // 忽略空白
			
			loop = starthere + 3;
			// 遍历每个元素
			// vertexIndex/uvIndex/normalIndex
			for (i = starthere; i < loop; ++i)
			{
				triplet 	= data[i]; 
				subdata 	= triplet.split(SLASH);
				vertexIndex = int(subdata[0]) - 1;
				uvIndex     = int(subdata[1]) - 1;
				normalIndex = int(subdata[2]) - 1;
				
				// sanity check
				if (vertexIndex < 0) 	vertexIndex = 0;
				if (uvIndex < 0) 		uvIndex = 0;
				if (normalIndex < 0) 	normalIndex = 0;
				
				//分析模型的原始数据，转换到Mesh的原始数据内
				// Vertex (x,y,z)
				index = 3 * vertexIndex;
				verts.push(new Vector3(_vertices[index + 0], _vertices[index + 1], _vertices[index + 2]));
				// Color (vertex r,g,b,a)
				//if (_random_vertex_colors)
				//_rawColorsBuffer.push(Math.random(), 
				//Math.random(), Math.random(), 1);
				//else
				//_rawColorsBuffer.push(1, 1, 1, 1); // pure white
				colors.push(new RGB(1, 1, 1));
				
				// Normals (nx,ny,nz) - *if* included in the file
				if (_normals.length)
				{
					index = 3 * normalIndex;
					norms.push(new Vector3(_normals[index + 0], _normals[index + 1], _normals[index + 2]));
					//_rawNormalsBuffer.push(_normals[index + 0], 
					//_normals[index + 1], _normals[index + 2]);
				}
				
				// Texture coordinates (u,v)
				index = 2 * uvIndex;
				
				if (_mirror_uv)
					uvs.push(new UV(_uvs[index + 0], 1 - _uvs[index + 1]));
				else
					uvs.push(new UV(1 - _uvs[index + 0], 1 - _uvs[index + 1]));
			}
			
			//if (tris.length > 17684) return;
			// Create index buffer - 一个三角形一次
			tris.push(new Triangle(_faceIndex + 0, _faceIndex + 1, _faceIndex + 2));
			_dirty = true;
			_faceIndex += 3;
		}
	}
}