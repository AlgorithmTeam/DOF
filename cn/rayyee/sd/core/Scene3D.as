package cn.rayyee.sd.core
{
	import cn.rayyee.sd.camera.Camera3D;
	import cn.rayyee.sd.color.RGB;
	import cn.rayyee.sd.math.Vector3;
	import cn.rayyee.sd.shader.FactoryShader;
	import cn.rayyee.sd.shader.ShaderConst;
	import cn.rayyee.sd.utils.KeyboardState;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author rayyee
	 */
	public class Scene3D
	{
		[Embed(source="../../../../Katarina_Referee_TX_CM.dds.png")]
		protected const TextureBitmap:Class;
		private var context:Context3D;
		private var program:Program3D;
		private var camera:Camera3D;
		private var modelTexture:Texture;
		public var BGC:RGB;
		public var meshes:Vector.<Mesh>;
		
		public function Scene3D()
		{
			this.camera = new Camera3D();
			this.BGC = new RGB(1, 1, 1);
			this.meshes = new Vector.<Mesh>();
			super();
		}
		
		public function addMesh(mesh:Mesh):void
		{
			//texture
			var bitmap:Bitmap = new TextureBitmap();
			var bmd:BitmapData = new BitmapData(512, 512);
			bmd.copyPixels(bitmap.bitmapData, bmd.rect, new Point());
			meshes.push(mesh);
			
			mesh.createTexture(context, bmd);
			//var count:int = mesh.numChildren;
			//if (count > 0)
			//{
				//var i:int;
				//
				//for (i = 0; i < count; i += 1)
				//{
					//Mesh(mesh.getChildByIndex(i)).createTexture(context, bmd);
				//}
			//}
		}
		
		public function createContext(ev:Event = null):void
		{
			var s3d:Stage3D = (ev.target as Stage3D);
			this.context = s3d.context3D;
			if (this.context == null)
				return;
			context.enableErrorChecking = true;
			context.configureBackBuffer(0x0500, 720, 2, true);
			//context.setCulling(Context3DTriangleFace.BACK);
			createLight();
			createProgram();
			//createTexture();
		}
		
		private function createTexture():void
		{
			var bitmap:Bitmap = new TextureBitmap();
			modelTexture = context.createTexture(bitmap.bitmapData.width, bitmap.bitmapData.height, Context3DTextureFormat.BGRA, false);
			modelTexture.uploadFromBitmapData(bitmap.bitmapData);
		}
		
		public function createLight():void
		{
			context.setProgramConstantsFromVector("fragment", 0, Vector.<Number>([camera.zFar / 1, camera.zFar / 1, camera.zFar / 1, 1]));
			context.setProgramConstantsFromVector("fragment", 1, Vector.<Number>([0, 0, -1, 1]));
			context.setProgramConstantsFromVector("fragment", 2, Vector.<Number>([-1, -1, -1, 1]));
			
			/* First we'll set up lighting constants for the fragment shader */
			//context.setProgramConstantsFromVector("fragment", 0, Vector.<Number>([0, 0, 0, 0])); //fc0, for clamping negative values to zero
			//context.setProgramConstantsFromVector("fragment", 1, Vector.<Number>([0.25, 0.25, 0.25, 0])); //fc1, ambient lighting (1/4 of full intensity)
			
			//key light
			//context.setProgramConstantsFromVector("fragment", 2, Vector.<Number>([0.37, 0.56, 0.74, 1])); //fc2, INVERSE light direction
			//context.setProgramConstantsFromVector("fragment", 3, Vector.<Number>([0.9, 0.9, 0.9, 1])); //fc3, light color & intensity
			
			//fill light
			//context.setProgramConstantsFromVector("fragment", 4, Vector.<Number>([-0.82, 0.41, 0.41, 1])); //fc4, INVERSE light direction
			//context.setProgramConstantsFromVector("fragment", 5, Vector.<Number>([0.6, 0.5, 0.4, 1])); //fc5, light color & intensity
			
			//backlight
			//context.setProgramConstantsFromVector("fragment", 6, Vector.<Number>([0, -0.1, -1, 1])); //fc6, INVERSE light direction
			//context.setProgramConstantsFromVector("fragment", 7, Vector.<Number>([0.2, 0.25, 0.3, 1])); //fc7, light color & intensity
		}
		
		public function createProgram():void
		{
			program ||= context.createProgram();
			var _vertexCode:ByteArray = FactoryShader.createShader(Context3DProgramType.VERTEX, ShaderConst.LIGHT_VERTEX);
			var _fragmentCode:ByteArray = FactoryShader.createShader(Context3DProgramType.FRAGMENT, ShaderConst.LIGHT_FRAGMENT);
			program.upload(_vertexCode, _fragmentCode);
		}
		
		public function update():void
		{
			if (!context)
				return;
			var mesh:Mesh;
			var rmat:Matrix3D;
			var r:Vector3;
			context.clear(BGC.r, BGC.g, BGC.b);
			context.setProgram(program);
			//camera.rot.x = 10;
			//camera.pos.y = -10;
			//camera.pos.z++;
			if (KeyboardState.LEFT_CLICK)
				camera.pos.x += 5;
			if (KeyboardState.RIGHT_CLICK)
				camera.pos.x -= 5;
			if (KeyboardState.UP_CLICK)
				camera.pos.y += 5;
			if (KeyboardState.DOWN_CLICK)
				camera.pos.y -= 5;
			if (KeyboardState.X_CLICK)
				camera.rot.x++;
			if (KeyboardState.Z_CLICK)
				camera.rot.x--;
			//trace(camera.rot.x, "camera.x", camera.pos);
			for each (mesh in meshes)
			{
				mesh.rot.y = (mesh.rot.y + 2);
				//mesh.rot.x = (mesh.rot.x + 0.5);
				mesh.updateMatrix();
				mesh.draw(context, camera);
				/**------------------------------------------------------
				   //mesh.mat.append(this.view);
				   mesh.mat.append(camera.viewProjection);
				   if (mesh.dirty) mesh.updateBuffers(this.context);
				   rmat = new Matrix3D();
				   r = mesh.rot;
				   if (r.x != 0) rmat.appendRotation(r.x, new Vector3D(1, 0, 0));
				   if (r.y != 0) rmat.appendRotation(r.y, new Vector3D(0, 1, 0));
				   if (r.z != 0) rmat.appendRotation(r.z, new Vector3D(0, 0, 1));
				
				   context.setVertexBufferAt(0, mesh.vertexBuffer, 0, "float3");
				   //context.setVertexBufferAt(1, mesh.colorBuffer, 0, "float3");
				   //context.setVertexBufferAt(2, mesh.normBuffer, 0, "float3");
				   context.setVertexBufferAt(1, mesh.normBuffer, 0, "float3");
				   context.setVertexBufferAt(2, mesh.uvBuffer, 0, "float2");
				
				   context.setTextureAt(0, mesh.texture);
				
				   context.setProgramConstantsFromMatrix("vertex", 0, mesh.mat, true);
				   context.setProgramConstantsFromMatrix("vertex", 4, rmat, true);
				   context.drawTriangles(mesh.indexBuffer, 0, mesh.tris.length);
				 ----------------------------------------------------------**/
			}
			context.present();
		}
	
	}

}