package sweet.ribbon;
import haxe.ds.StringMap;
import sweet.ribbon.decoder.*;
import sweet.ribbon.encoder.*;
import Type.ValueType;
import sweet.functor.validator.IValidator;
import sweet.functor.validator.Equal;
import sweet.functor.validator.*;
import sweet.ribbon.RibbonEncoder.ParentReference;



typedef CodexAtomic = {
	encoderValidator :IValidator<Dynamic>,
	decoder :ISubDecoderBaseType<Dynamic>,
	encoder :ISubEncoderBaseType<Dynamic>,
}
typedef Codex = {
	encoderValidator :IValidator<Dynamic>,
	decoder :ISubDecoder,
	encoder :ISubEncoder<Dynamic>,
}

//TODO: handle field priority?

class RibbonStrategy {
	var _bSfafeMode = true; //TODO : ignore non-matching field on class
	
	var _aCodex :Array<Codex>;
	var _aCodexAtomic :Array<CodexAtomic>;
	
//_____________________________________________________________________________
//	 Constructor
	
	public function new( oMappingInfoProvider :IMappingInfoProvider = null ) {
		
		if ( oMappingInfoProvider == null )
			oMappingInfoProvider = new MappingInfoProvider();
		
		_aCodexAtomic = [
			{ // index : 0
				encoderValidator: new Equal( null ), 
				encoder: new DatalessEncoder(),
				decoder: new DatalessDecoder(),
			},
			{ // index : 1
				encoderValidator: new IsTypeOf( ValueType.TBool ), 
				encoder: new BoolEncoder(),
				decoder: new BoolDecoder(),
			},
			{ // index : 2
				encoderValidator: new IsTypeOf( ValueType.TInt ), 
				encoder: new IntEncoder(),
				decoder: new IntDecoder(),
			},
			{ // index : 3
				encoderValidator: new StdIs( String ), 
				encoder: new StringEncoder(),
				decoder: new StringDecoder(),
			},
			{ // index : 4
				encoderValidator: new StdIs( Reference ), 
				encoder: new ReferenceEncoder(),
				decoder: new ReferenceDecoder(),
			},
		];
		
		_aCodex = [
			{ // index : 5
				encoderValidator: new StdIs(Array), 
				encoder: new ArrayEncoder(),
				decoder: new ArrayDecoder(),
			},
			{ // index : 6
				encoderValidator: new StdIs(StringMap), 
				encoder: new StringMapEncoder(),
				decoder: new StringMapDecoder(),
			},
			{ // index : 7
				encoderValidator: new IsObject(), 
				encoder: new InstanceEncoder( oMappingInfoProvider ),
				decoder: new InstanceDecoder(),
			},
		];
		
		
	}
	
//_____________________________________________________________________________
//	 Accessor
	
	public function getCodexIndex( o :Dynamic, aParent :List<ParentReference> ) :Null<Int> {
		
		// TODO : map result faster
		
		for ( i in 0..._aCodexAtomic.length )
			if( _aCodexAtomic[i].encoderValidator.apply(o) )
				return i;
		for ( i in 0..._aCodex.length )
			if( _aCodex[i].encoderValidator.apply(o) )
				return i + _aCodexAtomic.length;
		return null;
	}
	
	public function getEncoder( i :Int ) {
		var oCodex = _getCodex( i );
		return oCodex == null ? null : oCodex.encoder;
	}
	
	public function getDecoder( i :Int ) {
		var oCodex = _getCodex( i );
		return oCodex == null ? null : oCodex.decoder;
	}
	public function getEncoderAtomic( i :Int ) {
		var oCodex = _getCodexAtomic( i );
		return oCodex == null ? null : oCodex.encoder;
	}
	public function getDecoderAtomic( i :Int ) {
		var oCodex = _getCodexAtomic( i );
		return oCodex == null ? null : oCodex.decoder;
	}
	

	
//_____________________________________________________________________________
//	Sub-routine
	
	public function _getCodexAtomic( i :Int ) :CodexAtomic {
		if ( i < 0 || i >= _aCodexAtomic.length )
			return null;
		return _aCodexAtomic[i];
	}

	public function _getCodex( i :Int ) :Codex {
		i -= _aCodexAtomic.length;
		if ( i < 0 || i >= _aCodex.length )
			return null;
		return _aCodex[i];
	}
}