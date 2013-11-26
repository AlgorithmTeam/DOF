package cn.rayyee.sd.math 
{
	/**
	 * ...
	 * @author rayyee
	 */
	final public class Vector3 
	{
		
		public var x:Number = 0;
        public var y:Number = 0;
        public var z:Number = 0;
        private var ang:Number = 0;
		
		public function Vector3(X:Number=0, Y:Number=0, Z:Number=0) 
		{
			this.x = X;
            this.y = Y;
            this.z = Z;
		}
		
		public function abs():void
		{
			x = x < 0? -x:x;
			y = y < 0? -y:y;
			z = z < 0? -z:z;
        }
		
        public function add(X:Number, Y:Number, Z:Number):Vector3
		{
            return new Vector3((x + X), (y + Y), (z + Z));
        }
		
        public function addv(v:Vector3):Vector3
		{
            return new Vector3((x + v.x), (y + v.y), (z + v.z));
        }

        public function iadd(X:Number, Y:Number, Z:Number = 0):void
		{
            x = (x + X);
            y = (y + Y);
            z = (z + Z);
        }
		
        public function iaddv(v:Vector3):void
		{
            x = (x + v.x);
            y = (y + v.y);
            z = (z + v.z);
        }
		
        public function angleXY():Number
		{
            ang = (Math.atan2(y, x) * 180) / Math.PI;
            if (ang < 0) ang = (ang + 360);
            return ang;
        }
		
        public function angleYZ():Number
		{
            ang = (Math.atan2(z, y) * 180) / Math.PI;
            if (ang < 0) ang = (ang + 360);
            return ang;
        }
		
        public function angleZX():Number
		{
            ang = (Math.atan2(x, z) * 180) / Math.PI;
            if (ang < 0) ang = (ang + 360);
            return ang;
        }
		
        public function cap(dist:Number):void
		{
            if ((dist * dist) < rawmag()){
                inorm();
                imult(dist);
            };
        }
		
        public function copy():Vector3
		{
            return new Vector3(x, y, z);
        }
		
        public function distance(v:Vector3):Number
		{
            return subv(v).mag();
        }
		
        public function dot(v:Vector3):Number
		{
            return (x * v.x) + (y * v.y) + (z * v.z);
        }
		
        public function equals(X:Number, Y:Number, Z:Number):Boolean
		{
            if (x != X) return false;
            if (y != Y) return false;
            if (z != Z) return false;
            return true;
        }
		
        public function equalsv(v:Vector3):Boolean
		{
            if (x != v.x) return false;
            if (y != v.y) return false; 
            if (z != v.z) return false; 
            return true;
        }
		
        public function mag():Number
		{
            return Math.sqrt((x * x) + (y * y) + (z * z));
        }
		
        public function mult(s:Number):Vector3{
            return new Vector3((x * s), (y * s), (z * s));
        }
		
        public function multv(v:Vector3):Vector3
		{
            return new Vector3((x * v.x), (y * v.y), (z * v.z));
        }
		
        public function imult(s:Number):void
		{
            x = (x * s);
            y = (y * s);
            z = (z * s);
        }
		
        public function imultv(v:Vector3):void
		{
            x = (x * v.x);
            y = (y * v.y);
            z = (z * v.z);
        }
		
        public function norm():Vector3
		{
            var m:Number = Math.sqrt((x * x) + (y * y) + (z * z));
            if (m == 0) return new Vector3();
            return new Vector3((x / m), (y / m), (z / m));
        }
		
        public function inorm():void
		{
            var m:Number = Math.sqrt((x * x) + (y * y) + (z * z));
            if (m == 0) return;
            x = (x / m);
            y = (y / m);
            z = (z / m);
        }
		
        public function output():void
		{
            trace("Vector3(" + x + ", " + y + ", " + z + ")");
        }
		
        public function rawmag():Number
		{
            return (x * x) + (y * y) + (z * z);
        }
		
        public function irescale(mag:Number):void
		{
            var m:Number = Math.sqrt((x * x) + (y * y) + (z * z));
            if (m == 0) return;
            x = (x / m);
            y = (y / m);
            z = (z / m);
            x = (x * mag);
            y = (y * mag);
            z = (z * mag);
        }
		
        public function set(X:Number, Y:Number, Z:Number):void
		{
            x = X;
            y = Y;
            z = Z;
        }
		
        public function setv(v:Vector3):void
		{
            x = v.x;
            y = v.y;
            z = v.z;
        }
		
        public function sub(X:Number, Y:Number, Z:Number):Vector3
		{
            return new Vector3((x - X), (y - Y), (z - Z));
        }
		
        public function subv(v:Vector3):Vector3
		{
            return new Vector3((x - v.x), (y - v.y), (z - v.z));
        }
		
        public function isub(X:Number, Y:Number, Z:Number):void
		{
            x = (x - X);
            y = (y - Y);
            z = (z - Z);
        }
		
        public function isubv(v:Vector3):void
		{
            x = (x - v.x);
            y = (y - v.y);
            z = (z - v.z);
        }
		
        public function toString():String
		{
            return "Vector3(" + (Math.round(x * 100) / 100) + ", " + (Math.round(y * 100) / 100) + ", " + (Math.round(z * 100) / 100) + ")";
        }
		
        public function zero():void
		{
            x = y = z = 0;
        }
		
	}

}