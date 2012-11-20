// ================================================================================
//
//	ADOBE SYSTEMS INCORPORATED
//	Copyright 2010 Adobe Systems Incorporated
//	All Rights Reserved.
//
//	NOTICE: Adobe permits you to use, modify, and distribute this file
//	in accordance with the terms of the license agreement accompanying it.
//
// ================================================================================
package dof.shader
{
	// ===========================================================================
	//	Imports
	// ---------------------------------------------------------------------------
	//import flash.display3D.*;
	import flash.utils.*;
	
	// ===========================================================================
	//	Class
	// ---------------------------------------------------------------------------
	public class AGALMiniAssembler
	{
		// ======================================================================
		//	Properties
		// ----------------------------------------------------------------------
		// AGAL bytes and error buffer 
		private var _agalcode:ByteArray							= null;
		private var _error:String								= "";
		
		private var debugEnabled:Boolean						= false;
		
		private static var initialized:Boolean					= false;
		
		// ======================================================================
		//	Getters
		// ----------------------------------------------------------------------
		public function get error():String						{ return _error; }
		public function get agalcode():ByteArray				{ return _agalcode; }
		
		// ======================================================================
		//	Constructor
		// ----------------------------------------------------------------------
		public function AGALMiniAssembler( debugging:Boolean = false ):void
		{
			debugEnabled = debugging;
			if ( !initialized )
				init();
		}
		// ======================================================================
		//	Methods
		// ----------------------------------------------------------------------
		public function assemble( mode:String, source:String, verbose:Boolean = false ):ByteArray
		{
			var start:uint = getTimer();
			
			_agalcode = new ByteArray();			
			_error = "";
			
			var isFrag:Boolean = false;
			
			if ( mode == FRAGMENT )
				isFrag = true
			else if ( mode != VERTEX )
				_error = 'ERROR: mode needs to be "' + FRAGMENT + '" or "' + VERTEX + '" but is "' + mode + '".';
			
			agalcode.endian = Endian.LITTLE_ENDIAN;
			agalcode.writeByte( 0xa0 );				// tag version
			agalcode.writeUnsignedInt( 0x1 );		// AGAL version, big endian, bit pattern will be 0x01000000
			agalcode.writeByte( 0xa1 );				// tag program id
			agalcode.writeByte( isFrag ? 1 : 0 );	// vertex or fragment
			
			var lines:Array = source.replace( /[\f\n\r\v]+/g, "\n" ).split( "\n" );
			var nest:int = 0;
			var nops:int = 0;
			var i:int;
			var lng:int = lines.length;
			
			for ( i = 0; i < lng && _error == ""; i++ )
			{
				var line:String = new String( lines[i] );
				
				// remove comments
				var startcomment:int = line.search( "//" );
				if ( startcomment != -1 )
					line = line.slice( 0, startcomment );
				
				// grab options
				var optsi:int = line.search( /<.*>/g );
				var opts:Array;
				if ( optsi != -1 )
				{
					opts = line.slice( optsi ).match( /([\w\.\-\+]+)/gi );
					line = line.slice( 0, optsi );
				}
				
				// find opcode
				var opCode:Array = line.match( /^\w{3}/ig );
				var opFound:OpCode = OPMAP[ opCode[0] ];
				
				// if debug is enabled, output the opcodes
				if ( debugEnabled )
					trace( opFound );
				
				if ( opFound == null )
				{
					if ( line.length >= 3 )
						trace( "warning: bad line "+i+": "+lines[i] );
					continue;
				}
				
				line = line.slice( line.search( opFound.name ) + opFound.name.length );
				
				// nesting check
				if ( opFound.flags & OP_DEC_NEST )
				{
					nest--;
					if ( nest < 0 )
					{
						_error = "error: conditional closes without open.";
						break;
					}
				}
				if ( opFound.flags & OP_INC_NEST )
				{
					nest++;
					if ( nest > MAX_NESTING )
					{
						_error = "error: nesting to deep, maximum allowed is "+MAX_NESTING+".";
						break;
					}
				}
				if ( ( opFound.flags & OP_FRAG_ONLY ) && !isFrag )
				{
					_error = "error: opcode is only allowed in fragment programs.";
					break;
				}
				if ( verbose )
					trace( "emit opcode=" + opFound );
				
				agalcode.writeUnsignedInt( opFound.emitCode );
				nops++;
				
				if ( nops > MAX_OPCODES )
				{
					_error = "error: too many opcodes. maximum is "+MAX_OPCODES+".";
					break;
				}
				
				// get operands, use regexp
				var regs:Array = line.match( /vc\[([vof][actps]?)(\d*)?(\.[xyzw](\+\d{1,3})?)?\](\.[xyzw]{1,4})?|([vof][actps]?)(\d*)?(\.[xyzw]{1,4})?/gi );
				if ( regs.length != opFound.numRegister )
				{
					_error = "error: wrong number of operands. found "+regs.length+" but expected "+opFound.numRegister+".";
					break;
				}
				
				var badreg:Boolean	= false;
				var pad:uint		= 64 + 64 + 32;
				var regLength:uint	= regs.length;
				
				for ( var j:int = 0; j < regLength; j++ )
				{
					var isRelative:Boolean = false;
					var relreg:Array = regs[ j ].match( /\[.*\]/ig );
					if ( relreg.length > 0 )
					{
						regs[ j ] = regs[ j ].replace( relreg[ 0 ], "0" );
						
						if ( verbose )
							trace( "IS REL" );
						isRelative = true;
					}
					
					var res:Array = regs[j].match( /^\b[A-Za-z]{1,2}/ig );
					var regFound:Register = REGMAP[ res[ 0 ] ];
					
					// if debug is enabled, output the registers
					if ( debugEnabled )
						trace( regFound );
					
					if ( regFound == null )
					{
						_error = "error: could not parse operand "+j+" ("+regs[j]+").";
						badreg = true;
						break;
					}
					
					if ( isFrag )
					{
						if ( !( regFound.flags & REG_FRAG ) )
						{
							_error = "error: register operand "+j+" ("+regs[j]+") only allowed in vertex programs.";
							badreg = true;
							break;
						}
						if ( isRelative )
						{
							_error = "error: register operand "+j+" ("+regs[j]+") relative adressing not allowed in fragment programs.";
							badreg = true;
							break;
						}			
					}
					else
					{
						if ( !( regFound.flags & REG_VERT ) )
						{
							_error = "error: register operand "+j+" ("+regs[j]+") only allowed in fragment programs.";
							badreg = true;
							break;
						}
					}
					
					regs[j] = regs[j].slice( regs[j].search( regFound.name ) + regFound.name.length );
					//trace( "REGNUM: " +regs[j] );
					var idxmatch:Array = isRelative ? relreg[0].match( /\d+/ ) : regs[j].match( /\d+/ );
					var regidx:uint = 0;
					
					if ( idxmatch )
						regidx = uint( idxmatch[0] );
					
					if ( regFound.range < regidx )
					{
						_error = "error: register operand "+j+" ("+regs[j]+") index exceeds limit of "+(regFound.range+1)+".";
						badreg = true;
						break;
					}
					
					var regmask:uint		= 0;
					var maskmatch:Array		= regs[j].match( /(\.[xyzw]{1,4})/ );
					var isDest:Boolean		= ( j == 0 && !( opFound.flags & OP_NO_DEST ) );
					var isSampler:Boolean	= ( j == 2 && ( opFound.flags & OP_SPECIAL_TEX ) );
					var reltype:uint		= 0;
					var relsel:uint			= 0;
					var reloffset:int		= 0;
					
					if ( isDest && isRelative )
					{
						_error = "error: relative can not be destination";	
						badreg = true; 
						break;								
					}
					
					if ( maskmatch )
					{
						regmask = 0;
						var cv:uint; 
						var maskLength:uint = maskmatch[0].length;
						for ( var k:int = 1; k < maskLength; k++ )
						{
							cv = maskmatch[0].charCodeAt(k) - "x".charCodeAt(0);
							if ( cv > 2 )
								cv = 3;
							if ( isDest )
								regmask |= 1 << cv;
							else
								regmask |= cv << ( ( k - 1 ) << 1 );
						}
						if ( !isDest )
							for ( ; k <= 4; k++ )
								regmask |= cv << ( ( k - 1 ) << 1 ) // repeat last								
					}
					else
					{
						regmask = isDest ? 0xf : 0xe4; // id swizzle or mask						
					}
					
					if ( isRelative )
					{
						var relname:Array = relreg[0].match( /[A-Za-z]{1,2}/ig );						
						var regFoundRel:Register = REGMAP[ relname[0]];						
						if ( regFoundRel == null )
						{ 
							_error = "error: bad index register"; 
							badreg = true; 
							break;
						}
						reltype = regFoundRel.emitCode;
						var selmatch:Array = relreg[0].match( /(\.[xyzw]{1,1})/ );						
						if ( selmatch.length==0 )
						{
							_error = "error: bad index register select"; 
							badreg = true; 
							break;						
						}
						relsel = selmatch[0].charCodeAt(1) - "x".charCodeAt(0);
						if ( relsel > 2 )
							relsel = 3; 
						var relofs:Array = relreg[0].match( /\+\d{1,3}/ig );
						if ( relofs.length > 0 ) 
							reloffset = relofs[0]; 						
						if ( reloffset < 0 || reloffset > 255 )
						{
							_error = "error: index offset "+reloffset+" out of bounds. [0..255]"; 
							badreg = true; 
							break;							
						}
						if ( verbose )
							trace( "RELATIVE: type="+reltype+"=="+relname[0]+" sel="+relsel+"=="+selmatch[0]+" idx="+regidx+" offset="+reloffset ); 
					}
					
					if ( verbose )
						trace( "  emit argcode="+regFound+"["+regidx+"]["+regmask+"]" );
					if ( isDest )
					{												
						agalcode.writeShort( regidx );
						agalcode.writeByte( regmask );
						agalcode.writeByte( regFound.emitCode );
						pad -= 32; 
					} else
					{
						if ( isSampler )
						{
							if ( verbose )
								trace( "  emit sampler" );
							var samplerbits:uint = 5; // type 5 
							var optsLength:uint = opts.length;
							var bias:Number = 0; 
							for ( k = 0; k<optsLength; k++ )
							{
								if ( verbose )
									trace( "    opt: "+opts[k] );
								var optfound:Sampler = SAMPLEMAP [opts[k]];
								if ( optfound == null )
								{
									// todo check that it's a number...
									//trace( "Warning, unknown sampler option: "+opts[k] );
									bias = Number(opts[k]); 
									if ( verbose )
										trace( "    bias: " + bias );																	
								}
								else
								{
									if ( optfound.flag != SAMPLER_SPECIAL_SHIFT )
										samplerbits &= ~( 0xf << optfound.flag );										
									samplerbits |= uint( optfound.mask ) << uint( optfound.flag );
								}
							}
							agalcode.writeShort( regidx );
							agalcode.writeByte(int(bias*8.0));
							agalcode.writeByte(0);							
							agalcode.writeUnsignedInt( samplerbits );
							
							if ( verbose )
								trace( "    bits: " + ( samplerbits - 5 ) );
							pad -= 64;
						}
						else
						{
							if ( j == 0 )
							{
								agalcode.writeUnsignedInt( 0 );
								pad -= 32;
							}
							agalcode.writeShort( regidx );
							agalcode.writeByte( reloffset );
							agalcode.writeByte( regmask );
							agalcode.writeByte( regFound.emitCode );
							agalcode.writeByte( reltype );
							agalcode.writeShort( isRelative ? ( relsel | ( 1 << 15 ) ) : 0 );
							
							pad -= 64;
						}
					}
				}
				
				// pad unused regs
				for ( j = 0; j < pad; j += 8 ) 
					agalcode.writeByte( 0 );
				
				if ( badreg )
					break;
			}
			
			if ( _error != "" )
			{
				_error += "\n  at line " + i + " " + lines[i];
				agalcode.length = 0;
				trace( _error );
			}
			
			// trace the bytecode bytes if debugging is enabled
			if ( debugEnabled )
			{
				var dbgLine:String = "generated bytecode:";
				var agalLength:uint = agalcode.length;
				for ( var index:uint = 0; index < agalLength; index++ )
				{
					if ( !( index % 16 ) )
						dbgLine += "\n";
					if ( !( index % 4 ) )
						dbgLine += " ";
					
					var byteStr:String = agalcode[ index ].toString( 16 );
					if ( byteStr.length < 2 )
						byteStr = "0" + byteStr;
					
					dbgLine += byteStr;
				}
				trace( dbgLine );
			}
			
			if ( verbose )
				trace( "AGALMiniAssembler.assemble time: " + ( ( getTimer() - start ) / 1000 ) + "s" );
			
			return agalcode;
		}
		
		static private function init():void
		{
			initialized = true;
			
			// Fill the dictionaries with opcodes and registers
			OPMAP[ MOV ] = new OpCode( MOV, 2, 0x00, 0 );
			OPMAP[ ADD ] = new OpCode( ADD, 3, 0x01, 0 );
			OPMAP[ SUB ] = new OpCode( SUB, 3, 0x02, 0 );
			OPMAP[ MUL ] = new OpCode( MUL, 3, 0x03, 0 );
			OPMAP[ DIV ] = new OpCode( DIV, 3, 0x04, 0 );
			OPMAP[ RCP ] = new OpCode( RCP, 2, 0x05, 0 );					
			OPMAP[ MIN ] = new OpCode( MIN, 3, 0x06, 0 );
			OPMAP[ MAX ] = new OpCode( MAX, 3, 0x07, 0 );
			OPMAP[ FRC ] = new OpCode( FRC, 2, 0x08, 0 );			
			OPMAP[ SQT ] = new OpCode( SQT, 2, 0x09, 0 );
			OPMAP[ RSQ ] = new OpCode( RSQ, 2, 0x0a, 0 );
			OPMAP[ POW ] = new OpCode( POW, 3, 0x0b, 0 );
			OPMAP[ LOG ] = new OpCode( LOG, 2, 0x0c, 0 );
			OPMAP[ EXP ] = new OpCode( EXP, 2, 0x0d, 0 );
			OPMAP[ NRM ] = new OpCode( NRM, 2, 0x0e, 0 );
			OPMAP[ SIN ] = new OpCode( SIN, 2, 0x0f, 0 );
			OPMAP[ COS ] = new OpCode( COS, 2, 0x10, 0 );
			OPMAP[ CRS ] = new OpCode( CRS, 3, 0x11, 0 );
			OPMAP[ DP3 ] = new OpCode( DP3, 3, 0x12, 0 );
			OPMAP[ DP4 ] = new OpCode( DP4, 3, 0x13, 0 );					
			OPMAP[ ABS ] = new OpCode( ABS, 2, 0x14, 0 );
			OPMAP[ NEG ] = new OpCode( NEG, 2, 0x15, 0 );
			OPMAP[ SAT ] = new OpCode( SAT, 2, 0x16, 0 );
			OPMAP[ M33 ] = new OpCode( M33, 3, 0x17, OP_SPECIAL_MATRIX );
			OPMAP[ M44 ] = new OpCode( M44, 3, 0x18, OP_SPECIAL_MATRIX );
			OPMAP[ M34 ] = new OpCode( M34, 3, 0x19, OP_SPECIAL_MATRIX );			
			OPMAP[ IFZ ] = new OpCode( IFZ, 1, 0x1a, OP_NO_DEST | OP_INC_NEST | OP_SCALAR );
			OPMAP[ INZ ] = new OpCode( INZ, 1, 0x1b, OP_NO_DEST | OP_INC_NEST | OP_SCALAR );
			OPMAP[ IFE ] = new OpCode( IFE, 2, 0x1c, OP_NO_DEST | OP_INC_NEST | OP_SCALAR );
			OPMAP[ INE ] = new OpCode( INE, 2, 0x1d, OP_NO_DEST | OP_INC_NEST | OP_SCALAR );
			OPMAP[ IFG ] = new OpCode( IFG, 2, 0x1e, OP_NO_DEST | OP_INC_NEST | OP_SCALAR );
			OPMAP[ IFL ] = new OpCode( IFL, 2, 0x1f, OP_NO_DEST | OP_INC_NEST | OP_SCALAR );
			OPMAP[ IEG ] = new OpCode( IEG, 2, 0x20, OP_NO_DEST | OP_INC_NEST | OP_SCALAR );
			OPMAP[ IEL ] = new OpCode( IEL, 2, 0x21, OP_NO_DEST | OP_INC_NEST | OP_SCALAR );
			OPMAP[ ELS ] = new OpCode( ELS, 0, 0x22, OP_NO_DEST | OP_INC_NEST | OP_DEC_NEST );
			OPMAP[ EIF ] = new OpCode( EIF, 0, 0x23, OP_NO_DEST | OP_DEC_NEST );
			OPMAP[ REP ] = new OpCode( REP, 1, 0x24, OP_NO_DEST | OP_INC_NEST | OP_SCALAR );
			OPMAP[ ERP ] = new OpCode( ERP, 0, 0x25, OP_NO_DEST | OP_DEC_NEST );
			OPMAP[ BRK ] = new OpCode( BRK, 0, 0x26, OP_NO_DEST );
			OPMAP[ KIL ] = new OpCode( KIL, 1, 0x27, OP_NO_DEST | OP_FRAG_ONLY );
			OPMAP[ TEX ] = new OpCode( TEX, 3, 0x28, OP_FRAG_ONLY | OP_SPECIAL_TEX );
			OPMAP[ SGE ] = new OpCode( SGE, 3, 0x29, 0 );
			OPMAP[ SLT ] = new OpCode( SLT, 3, 0x2a, 0 );
			OPMAP[ SGN ] = new OpCode( SGN, 2, 0x2b, 0 );
			
			REGMAP[ VA ]	= new Register( VA,	"vertex attribute",		0x0,	7,		REG_VERT | REG_READ );
			REGMAP[ VC ]	= new Register( VC,	"vertex constant",		0x1,	127,	REG_VERT | REG_READ );
			REGMAP[ VT ]	= new Register( VT,	"vertex temporary",		0x2,	7,		REG_VERT | REG_WRITE | REG_READ );
			REGMAP[ OP ]	= new Register( OP,	"vertex output",		0x3,	0,		REG_VERT | REG_WRITE );
			REGMAP[ V ]		= new Register( V,	"varying",				0x4,	7,		REG_VERT | REG_FRAG | REG_READ | REG_WRITE );
			REGMAP[ FC ]	= new Register( FC,	"fragment constant",	0x1,	27,		REG_FRAG | REG_READ );
			REGMAP[ FT ]	= new Register( FT,	"fragment temporary",	0x2,	7,		REG_FRAG | REG_WRITE | REG_READ );
			REGMAP[ FS ]	= new Register( FS,	"texture sampler",		0x5,	7,		REG_FRAG | REG_READ );
			REGMAP[ OC ]	= new Register( OC,	"fragment output",		0x3,	0,		REG_FRAG | REG_WRITE );
			
			SAMPLEMAP[ D2 ]			= new Sampler( D2,			SAMPLER_DIM_SHIFT,		0 );
			SAMPLEMAP[ D3 ]			= new Sampler( D3,			SAMPLER_DIM_SHIFT,		2 );
			SAMPLEMAP[ CUBE ]		= new Sampler( CUBE,		SAMPLER_DIM_SHIFT,		1 );
			SAMPLEMAP[ MIPNEAREST ]	= new Sampler( MIPNEAREST,	SAMPLER_MIPMAP_SHIFT,	1 );
			SAMPLEMAP[ MIPLINEAR ]	= new Sampler( MIPLINEAR,	SAMPLER_MIPMAP_SHIFT,	2 );
			SAMPLEMAP[ MIPNONE ]	= new Sampler( MIPNONE,		SAMPLER_MIPMAP_SHIFT,	0 );
			SAMPLEMAP[ NOMIP ]		= new Sampler( NOMIP,		SAMPLER_MIPMAP_SHIFT,	0 );
			SAMPLEMAP[ NEAREST ]	= new Sampler( NEAREST,		SAMPLER_FILTER_SHIFT,	0 );
			SAMPLEMAP[ LINEAR ]		= new Sampler( LINEAR,		SAMPLER_FILTER_SHIFT,	1 );
			SAMPLEMAP[ CENTROID ]	= new Sampler( CENTROID,	SAMPLER_SPECIAL_SHIFT,	1 << 0 );
			SAMPLEMAP[ SINGLE ]		= new Sampler( SINGLE,		SAMPLER_SPECIAL_SHIFT,	1 << 1 );
			SAMPLEMAP[ DEPTH ]		= new Sampler( DEPTH,		SAMPLER_SPECIAL_SHIFT,	1 << 2 );
			SAMPLEMAP[ REPEAT ]		= new Sampler( REPEAT,		SAMPLER_REPEAT_SHIFT,	1 );
			SAMPLEMAP[ WRAP ]		= new Sampler( WRAP,		SAMPLER_REPEAT_SHIFT,	1 );
			SAMPLEMAP[ CLAMP ]		= new Sampler( CLAMP,		SAMPLER_REPEAT_SHIFT,	0 );
		}
		
		// ======================================================================
		//	Constants
		// ----------------------------------------------------------------------
		private static const OPMAP:Dictionary					= new Dictionary();
		private static const REGMAP:Dictionary					= new Dictionary();
		private static const SAMPLEMAP:Dictionary				= new Dictionary();
		
		private static const MAX_NESTING:int					= 4;
		private static const MAX_OPCODES:int					= 256;
		
		private static const FRAGMENT:String					= "fragment";
		private static const VERTEX:String						= "vertex";
		
		// masks and shifts
		private static const SAMPLER_DIM_SHIFT:uint				= 12;
		private static const SAMPLER_SPECIAL_SHIFT:uint			= 16;
		private static const SAMPLER_REPEAT_SHIFT:uint			= 20;
		private static const SAMPLER_MIPMAP_SHIFT:uint			= 24;
		private static const SAMPLER_FILTER_SHIFT:uint			= 28;
		
		// regmap flags
		private static const REG_WRITE:uint						= 0x1;
		private static const REG_READ:uint						= 0x2;
		private static const REG_FRAG:uint						= 0x20;
		private static const REG_VERT:uint						= 0x40;
		
		// opmap flags
		private static const OP_SCALAR:uint						= 0x1;
		private static const OP_INC_NEST:uint					= 0x2;
		private static const OP_DEC_NEST:uint					= 0x4;
		private static const OP_SPECIAL_TEX:uint				= 0x8;
		private static const OP_SPECIAL_MATRIX:uint				= 0x10;
		private static const OP_FRAG_ONLY:uint					= 0x20;
		private static const OP_VERT_ONLY:uint					= 0x40;
		private static const OP_NO_DEST:uint					= 0x80;
		
		// opcodes操作码========================================================================================================
		//<opcode> <destination> <source 1> <source 2 or sampler>
		//<操作码>  <目标>  <来源1>  <来源2或样例>
		private static const MOV:String	= "mov";	//分量移动	move data from source1 to destination [把来源1移到目标内] 
		private static const ADD:String	= "add";	//分量加法	destination = source1 + source2
		private static const SUB:String	= "sub";	//分量减法	destination = source1 – source2
		private static const MUL:String	= "mul";	//分量乘法	destination = source1 * source2
		private static const DIV:String	= "div";	//分量除法	destination = source1 / source2
		private static const RCP:String	= "rcp";	//分量倒数	destination = 1/source1
		private static const MIN:String	= "min";	//分量最小值		destination = minimum(source1,source2)
		private static const MAX:String	= "max";	//分量最大值		destination = maximum(source1,source2)
		private static const FRC:String	= "frc";	//分量取小数[求小数部分]		destination = source1 - (float)floor(source1)
		private static const SQT:String	= "sqt";	//分量平方根		destination = sqrt(source1)
		private static const RSQ:String	= "rsq";	//分量平方根倒数		destination = 1/sqrt(source1)
		private static const POW:String	= "pow";	//分量次幂[source1的source2次幂]		destination = pow(source1,source2)
		private static const LOG:String	= "log";	//分量对数	destination = log_2(source1)
		private static const EXP:String	= "exp";	//分量指数	destination = 2^source1
		private static const NRM:String	= "nrm";	//分量单位向量[归一化]	destination = normalize(source1)
		private static const SIN:String	= "sin";	//分量正弦	destination = sin(source1)
		private static const COS:String	= "cos";	//分量余弦	destination = cos(source1)
		private static const CRS:String	= "crs";	//叉积	destination.x = source1.y * source2.z - source1.z * source2.y
															//destination.y = source1.z * source2.x - source1.x * source2.z
															//destination.z = source1.x * source2.y - source1.y * source2.x
		private static const DP3:String	= "dp3";	//三维点积	destination = source1.x*source2.x + source1.y*source2.y + source1.z*source2.z
		private static const DP4:String	= "dp4";	//四维点积	destination = source1.x*source2.x + source1.y*source2.y + source1.z*source2.z + source1.w*source2.w
		private static const ABS:String	= "abs";	//分量绝对值		destination = abs(source1)
		private static const NEG:String	= "neg";	//分量负值	destination = -source1
		private static const SAT:String	= "sat";	//分量饱和值	destination = maximum(minimum(source1,1),0)
		private static const M33:String	= "m33";	//3*3矩阵相乘	destination.x = (source1.x * source2[0].x) + (source1.y * source2[0].y) + (source1.z * source2[0].z)
																	//destination.y = (source1.x * source2[1].x) + (source1.y * source2[1].y) + (source1.z * source2[1].z)
																	//destination.z = (source1.x * source2[2].x) + (source1.y * source2[2].y) + (source1.z * source2[2].z)
		private static const M44:String	= "m44";	//4*4矩阵相乘	destination.x = (source1.x * source2[0].x) + (source1.y * source2[0].y) + (source1.z * source2[0].z) + (source1.w * source2[0].w)
																	//destination.y = (source1.x * source2[1].x) + (source1.y * source2[1].y) + (source1.z * source2[1].z) + (source1.w * source2[1].w)
																	//destination.z = (source1.x * source2[2].x) + (source1.y * source2[2].y) + (source1.z * source2[2].z) + (source1.w * source2[2].w)
																	//destination.w = (source1.x * source2[3].x) + (source1.y * source2[3].y) + (source1.z * source2[3].z) + (source1.w * source2[3].w)
		private static const M34:String	= "m34";	//3*4矩阵相乘	//destination.x = (source1.x * source2[0].x) + (source1.y * source2[0].y) + (source1.z * source2[0].z) + (source1.w * source2[0].w)
																	//destination.y = (source1.x * source2[1].x) + (source1.y * source2[1].y) + (source1.z * source2[1].z) + (source1.w * source2[1].w)
																	//destination.z = (source1.x * source2[2].x) + (source1.y * source2[2].y) + (source1.z * source2[2].z) + (source1.w * source2[2].w)
		private static const IFZ:String	= "ifz";	//尚未支持此功能
		private static const INZ:String	= "inz";	//尚未支持此功能
		private static const IFE:String	= "ife";	//尚未支持此功能
		private static const INE:String	= "ine";	//尚未支持此功能
		private static const IFG:String	= "ifg";	//尚未支持此功能
		private static const IFL:String	= "ifl";	//尚未支持此功能
		private static const IEG:String	= "ieg";	//尚未支持此功能
		private static const IEL:String	= "iel";	//尚未支持此功能
		private static const ELS:String	= "els";	//尚未支持此功能
		private static const EIF:String	= "eif";	//尚未支持此功能
		private static const REP:String	= "rep";	//尚未支持此功能
		private static const ERP:String	= "erp";	//尚未支持此功能
		private static const BRK:String	= "brk";	//尚未支持此功能
		private static const KIL:String	= "kil";	//如果单标量小于零组件的来源是，碎片被丢弃，而不是绘制到帧缓冲区。目标寄存器必须全部为0。(fragment shader only)
		private static const TEX:String	= "tex";	//贴图纹理操作码		destination = 从纹理source2加载到坐标source1上。在这source2必须是采样格式。 (fragment shader only)
		private static const SGE:String	= "sge";	//判断source1是否大于等于source2		destination = source1 >= source2 ? 1 : 0, 分量
		private static const SLT:String	= "slt";	//判断source1是否小于source2		destination = source1 < source2 ? 1 : 0, 分量
		private static const SGN:String	= "sgn";	//尚未支持此功能
		// opcodes==============================================================================================================
		
		// registers寄存器===========================================================================================================
		//属性寄存器[从着色器中访问该属性寄存器的语法：va<n>，其中<n>是属性寄存器的索引号]	
		//Context3D::setVertexBufferAt(index:int, buffer:VertexBuffer3D, bufferOffset:int = 0, format:String = "float4")[index==n]
		private static const VA:String	= "va";			
		//常量寄存器[从着色器中访问这些寄存器的语法：vc<n>，用于顶点着色器，fc<n>，用于像素着色器，其中<n>是常量寄存器的索引号]	
		//Context3D::setProgramConstants(programType:String, firstRegister:int, matrix:Matrix3D, transposedMatrix:Boolean = false)[可设置多个常量，顺序既是索引n]
		//注意:FromMatrix占用4行[如vc0-3]，FromVector占用1行[如vc0]，有128个常量寄存器用于顶点着色器和28常量寄存器用于像素着色器
		private static const VC:String	= "vc";			
		private static const FC:String	= "fc";
		//临时寄存器[访问它们的语法：vt<n>（点）和 ft<n> （像素），其中<n>是寄存器的序号]
		private static const VT:String	= "vt";
		private static const FT:String	= "ft";
		//输出寄存器[存储顶点和像素着色器的计算输出，对于顶点着色器是一个顶点剪辑空间的位置，对于像素着色器是该像素的颜色]
		private static const OP:String	= "op";
		private static const OC:String	= "oc";
		//变量寄存器[访问这些寄存器的语法：v<n>，其中<n>是寄存器序号,用来从顶点着色器向像素着色器传递数据]
		private static const V:String	= "v";
		//纹理采样寄存器[语法是：fs<n> <flags>，其中<n>是采样序号，<flags>是一个或多个用于指定应如何取样的集合,即下面的samplers,用逗号分开]	
		//Context3D::setTextureAt(sampler:int, texture:TextureBase)[sampler==n]
		private static const FS:String	= "fs";
		// registers=================================================================================================================
		
		// samplers样例===========================================================================
		//纹理维度
		private static const D2:String							= "2d";
		private static const D3:String							= "3d";
		private static const CUBE:String						= "cube";
		//多重材质映射
		private static const MIPNEAREST:String					= "mipnearest";
		private static const MIPLINEAR:String					= "miplinear";
		private static const MIPNONE:String						= "mipnone";
		private static const NOMIP:String						= "nomip";
		//纹理滤镜
		private static const NEAREST:String						= "nearest";
		private static const LINEAR:String						= "linear";
		
		private static const CENTROID:String					= "centroid";
		private static const SINGLE:String						= "single";
		private static const DEPTH:String						= "depth";
		//重复纹理
		private static const REPEAT:String						= "repeat";
		private static const WRAP:String						= "wrap";
		private static const CLAMP:String						= "clamp";
		// samplers===========================================================================
	}
}

// ================================================================================
//	Helper Classes
// --------------------------------------------------------------------------------
{
	// ===========================================================================
	//	Class
	// ---------------------------------------------------------------------------
	class OpCode
	{		
		// ======================================================================
		//	Properties
		// ----------------------------------------------------------------------
		private var _emitCode:uint;
		private var _flags:uint;
		private var _name:String;
		private var _numRegister:uint;
		
		// ======================================================================
		//	Getters
		// ----------------------------------------------------------------------
		public function get emitCode():uint		{ return _emitCode; }
		public function get flags():uint		{ return _flags; }
		public function get name():String		{ return _name; }
		public function get numRegister():uint	{ return _numRegister; }
		
		// ======================================================================
		//	Constructor
		// ----------------------------------------------------------------------
		public function OpCode( name:String, numRegister:uint, emitCode:uint, flags:uint)
		{
			_name = name;
			_numRegister = numRegister;
			_emitCode = emitCode;
			_flags = flags;
		}		
		
		// ======================================================================
		//	Methods
		// ----------------------------------------------------------------------
		public function toString():String
		{
			return "[OpCode name=\""+_name+"\", numRegister="+_numRegister+", emitCode="+_emitCode+", flags="+_flags+"]";
		}
	}
	
	// ===========================================================================
	//	Class
	// ---------------------------------------------------------------------------
	class Register
	{
		// ======================================================================
		//	Properties
		// ----------------------------------------------------------------------
		private var _emitCode:uint;
		private var _name:String;
		private var _longName:String;
		private var _flags:uint;
		private var _range:uint;
		
		// ======================================================================
		//	Getters
		// ----------------------------------------------------------------------
		public function get emitCode():uint		{ return _emitCode; }
		public function get longName():String	{ return _longName; }
		public function get name():String		{ return _name; }
		public function get flags():uint		{ return _flags; }
		public function get range():uint		{ return _range; }
		
		// ======================================================================
		//	Constructor
		// ----------------------------------------------------------------------
		public function Register( name:String, longName:String, emitCode:uint, range:uint, flags:uint)
		{
			_name = name;
			_longName = longName;
			_emitCode = emitCode;
			_range = range;
			_flags = flags;
		}
		
		// ======================================================================
		//	Methods
		// ----------------------------------------------------------------------
		public function toString():String
		{
			return "[Register name=\""+_name+"\", longName=\""+_longName+"\", emitCode="+_emitCode+", range="+_range+", flags="+ _flags+"]";
		}
	}
	
	// ===========================================================================
	//	Class
	// ---------------------------------------------------------------------------
	class Sampler
	{
		// ======================================================================
		//	Properties
		// ----------------------------------------------------------------------
		private var _flag:uint;
		private var _mask:uint;
		private var _name:String;
		
		// ======================================================================
		//	Getters
		// ----------------------------------------------------------------------
		public function get flag():uint		{ return _flag; }
		public function get mask():uint		{ return _mask; }
		public function get name():String	{ return _name; }
		
		// ======================================================================
		//	Constructor
		// ----------------------------------------------------------------------
		public function Sampler( name:String, flag:uint, mask:uint )
		{
			_name = name;
			_flag = flag;
			_mask = mask;
		}
		
		// ======================================================================
		//	Methods
		// ----------------------------------------------------------------------
		public function toString():String
		{
			return "[Sampler name=\""+_name+"\", flag=\""+_flag+"\", mask="+mask+"]";
		}
	}
	}