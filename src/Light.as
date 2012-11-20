package
{
    import com.adobe.utils.AGALMiniAssembler;
    import com.adobe.utils.PerspectiveMatrix3D;
	import dof.space.primitive.Teapot;
    //import com.adobe.viewsource.ViewSource;
    
    import flash.display.Sprite;
    import flash.display.Stage3D;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DRenderMode;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.Program3D;
    import flash.display3D.VertexBuffer3D;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.geom.Matrix3D;
    import flash.geom.Vector3D;
    
    public class Light extends Sprite
    {
        private var context3D:Context3D;
        private var program:Program3D;
        /**
         * 光照颜色 
         */
        private var color:Vector.<Number>=Vector.<Number>([0,1,0,1]);
        /**
         * 光照向量（光照的方向） 
         */
        private var lightDirection:Vector.<Number>=Vector.<Number>([0.57735,-0.57735,-0.57735,1]);
        private var projectMatrix:PerspectiveMatrix3D=new PerspectiveMatrix3D();
        private var fov:Number=45*Math.PI/180;
        private var near:Number=0.1;
        private var far:Number=1024;
        
        private var vertexBuffer:VertexBuffer3D;
        private var indexBuffer:IndexBuffer3D;
        
        /**
         * 法线矩阵 
         */
        private var normalMatrix:Matrix3D=new Matrix3D();
        /**
         * 世界空间变换矩阵 
         */
        private var worldMatrix:Matrix3D=new Matrix3D();
        /**
         * 最终变换矩阵
         */
        private var finalMatrix:Matrix3D=new Matrix3D();
		private var teapotData:Teapot;
        
        public function Light()
        {
            //ViewSource.addMenuItem(this, "srcview/index.html");
            addEventListener(Event.ADDED_TO_STAGE,onAdded);
        }
        private function onAdded(pEvent:Event):void{
            removeEventListener(Event.ADDED_TO_STAGE,onAdded);
            initStage3D();
        }
        private function initStage3D():void
        {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            
            stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreate);
            stage.stage3Ds[0].requestContext3D();
        }
        
        private function onContext3DCreate(event:Event):void
        {
            var t : Stage3D = event.target as Stage3D;
            context3D=t.context3D;
            
            //context3D.setCulling("back");
            //context3D.enableErrorChecking = true;
            context3D.configureBackBuffer(640,480,4,true);
            
            initProgram();
            initScene();
            
            addEventListener(Event.ENTER_FRAME,enterFrameHandler);
        }
        private function initProgram():void
        {
            var avColorLight:AGALMiniAssembler = new AGALMiniAssembler();
            avColorLight.assemble(Context3DProgramType.VERTEX,
                "m44 op, va0, vc0 \n" +  // 对点的位置(va0) 做到屏幕的投影变换
                "m44 vt0, va1, vc4 \n" +    // 对法线做变换
                "nrm vt0.xyz, vt0.xyz \n"+    // 对结果进行归一化
                "dp3 vt0.w, vt0.xyz, vc8.xyz \n"+    //变换过的法线和光线向量进行点乘
                "sat vt1, vt0.w \n"+    // 去除结果中小于0的部分  此时vt1.w的值为光照强度
                "mov v0, vt1 \n"    // 输出到Fragment Shader
            );
            var afColorLight:AGALMiniAssembler = new AGALMiniAssembler();
            afColorLight.assemble(Context3DProgramType.FRAGMENT,
                "mov ft0, fc0 \n"+    // 把颜色保存到临时变量
                "mul ft0, ft0, v0.w \n"+    // 乘以光照系数
                "mov oc, ft0 \n"    // 输出
            );
            
            program=context3D.createProgram();
            program.upload(avColorLight.agalcode, afColorLight.agalcode);
            
            
        }
        private function initScene():void
        {
            //初始化投影矩阵，设置观察点
            projectMatrix.perspectiveFieldOfViewRH(fov,640/480,near,far);
            projectMatrix.prependTranslation(0,-10,-50);
            //初始化顶点缓冲数据
			teapotData = new Teapot();
            vertexBuffer=context3D.createVertexBuffer(teapotData.vertices.length/6,6);
            vertexBuffer.uploadFromVector(teapotData.vertices, 0, teapotData.vertices.length/6);
            //初始化顶点的排列索引缓冲
            indexBuffer = context3D.createIndexBuffer( teapotData.indices.length );
            indexBuffer.uploadFromVector(teapotData.indices, 0, teapotData.indices.length );
        }
        private function enterFrameHandler(pEvent:Event):void
        {
            context3D.clear(0,0,0);
            //旋转世界空间变换矩阵，产生物体旋转的效果
            worldMatrix.prependRotation(2,Vector3D.Y_AXIS);
            //投影矩阵乘世界空间变换矩阵，为最终变换矩阵（到屏幕坐标）
            finalMatrix.copyFrom(projectMatrix);
            finalMatrix.prepend(worldMatrix);
            
            //以下三行代码效果：去除世界空间变换矩阵的缩放转换后，为法线矩阵
            normalMatrix.copyFrom(worldMatrix);
            normalMatrix.transpose();
            normalMatrix.invert();
            
            context3D.setProgram(program);
            
            context3D.setVertexBufferAt( 0, vertexBuffer,  0, Context3DVertexBufferFormat.FLOAT_3 );
            context3D.setVertexBufferAt( 1, vertexBuffer,  3, Context3DVertexBufferFormat.FLOAT_3 );
            //传入顶点着色器常量
            context3D.setProgramConstantsFromMatrix( Context3DProgramType.VERTEX,  0, finalMatrix, true );
            context3D.setProgramConstantsFromMatrix( Context3DProgramType.VERTEX,  4, normalMatrix, true );
            context3D.setProgramConstantsFromVector( Context3DProgramType.VERTEX,  8, lightDirection);
            //传入片段着色器常量
            context3D.setProgramConstantsFromVector( Context3DProgramType.FRAGMENT,  0, color );
            
            context3D.drawTriangles( indexBuffer, 0, teapotData.indices.length/3 );
            
            context3D.present();
        }
    }
}