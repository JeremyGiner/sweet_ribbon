package sweet.ribbon;
import haxe.ds.IntMap;
import haxe.ds.StringMap;
import sweet.ribbon.decoder.*;
import sweet.ribbon.encoder.*;
import Type.ValueType;
import sweet.functor.validator.IValidator;
import sweet.functor.validator.Equal;
import sweet.functor.validator.*;
import sweet.ribbon.RibbonEncoder.ParentReference;


typedef CodexBaseType = {
	index :Int,
	encoderValidator :IValidator<Dynamic>,
	decoder :ISubDecoderBaseType<Dynamic>,
	encoder :ISubEncoderBaseType<Dynamic>,
}
typedef Codex = {
	index :Int,
	encoderValidator :IValidator<Dynamic>,
	decoder :ISubDecoder,
	encoder :ISubEncoder<Dynamic>,
}

//TODO: handle field priority?

class RibbonStrategy {
	var _bSfafeMode = true; //TODO : ignore non-matching field on class
	
	var _mCodex :IntMap<Codex>;
	var _mCodexBaseType :IntMap<CodexBaseType>;
	
	var _aPriorityQueue :Array<Codex>;
	var _aPriorityQueueBaseType :Array<CodexBaseType>;
	
//_____________________________________________________________________________
//	 Constructor
	
	public function new( 
		oMappingInfoProvider :IMappingInfoProvider = null,
		aCodexBaseType :Array<CodexBaseType> = null,
		aCodex :Array<Codex> = null
	) {
		_mCodex = new IntMap<Codex>();
		_mCodexBaseType = new IntMap<CodexBaseType>();

		if ( oMappingInfoProvider == null )
			oMappingInfoProvider = new MappingInfoProvider();
		
		aCodexBaseType = (aCodexBaseType == null ) ? getDefaultCodexBaseTypeAr() : aCodexBaseType;
		aCodex = (aCodex == null ) ? getDefaultCodexAr( oMappingInfoProvider ) : aCodex;
		
		for ( oCodex in aCodexBaseType ) _addCodexBaseType( oCodex );
		_aPriorityQueueBaseType = Lambda.array(_mCodexBaseType);
		_aPriorityQueueBaseType.sort(function(a :CodexBaseType,b :CodexBaseType) {
			if ( a.index == b.index )
				return 0;
			return a.index > b.index ? 1 : -1;//TODO: use priority if available
		});
		
		for( oCodex in aCodex ) _addCodex( oCodex );
		_aPriorityQueue = Lambda.array(_mCodex);
		_aPriorityQueue.sort(function(a :Codex, b :Codex) {
			if ( a.index == b.index )
				return 0;
			return a.index > b.index ? 1 : -1;//TODO: use priority if available
		});
		
	}
	
//_____________________________________________________________________________
//	 Accessor
	
	public function getCodexIndex( o :Dynamic, aParent :List<ParentReference> ) :Null<Int> {
		
		for ( oCodex in _aPriorityQueueBaseType )
			if( oCodex.encoderValidator.apply(o) )
				return oCodex.index;
		for ( oCodex in _aPriorityQueue ) {
			if( oCodex.encoderValidator.apply(o) )
				return oCodex.index;
		}
		return null;
	}
	
	public function getEncoder( i :Int ) :ISubEncoder<Dynamic> {
		var oCodex = _getCodex( i );
		return oCodex == null ? null : oCodex.encoder;
	}
	
	public function getDecoder( i :Int ) :ISubDecoder {
		var oCodex = _getCodex( i );
		return oCodex == null ? null : oCodex.decoder;
	}
	public function getEncoderAtomic( i :Int ) :ISubEncoderBaseType<Dynamic> {
		var oCodex = _getCodexBaseType( i );
		return oCodex == null ? null : oCodex.encoder;
	}
	public function getDecoderAtomic( i :Int ) :ISubDecoderBaseType<Dynamic> {
		var oCodex = _getCodexBaseType( i );
		return oCodex == null ? null : oCodex.decoder;
	}
	
	static public function getDefaultCodexBaseTypeAr() :Array<CodexBaseType> {
		return  [
			{
				index: 0,
				encoderValidator: new Equal( null ), 
				encoder: new DatalessEncoder(),
				decoder: new DatalessDecoder(),
			},
			{
				index: 1,
				encoderValidator: new IsTypeOf( ValueType.TBool ), 
				encoder: new BoolEncoder(),
				decoder: new BoolDecoder(),
			},
			{
				index: 2,
				encoderValidator: new IsTypeOf( ValueType.TInt ), 
				encoder: new IntEncoder(),
				decoder: new IntDecoder(),
			},
			{
				index: 3,
				encoderValidator: new IsTypeOf( ValueType.TFloat ), 
				encoder: new FloatEncoder(),
				decoder: new FloatDecoder(),
			},
			{
				index: 4,
				encoderValidator: new StdIs( String ), 
				encoder: new StringEncoder(),
				decoder: new StringDecoder(),
			},
			{
				index: 5,
				encoderValidator: new StdIs( Reference ), 
				encoder: new ReferenceEncoder(),
				decoder: new ReferenceDecoder(),
			},
		];
	}
	
	static public function getDefaultCodexAr( oMappingInfoProvider :IMappingInfoProvider ) :Array<Codex> {
		return [
			{
				index: 6,
				encoderValidator: new StdIs(Array), 
				encoder: new ArrayEncoder(),
				decoder: new ArrayDecoder(),
			},
			{
				index: 7,
				encoderValidator: new StdIs(IntMap), //TODO : merge all Map of basic type ? 
				encoder: new IntMapEncoder(),
				decoder: new IntMapDecoder(),
			},
			{
				index: 8,
				encoderValidator: new StdIs(StringMap), 
				encoder: new StringMapEncoder(),
				decoder: new StringMapDecoder(),
			},
			{
				index: 9,
				encoderValidator: new IsObject(), 
				encoder: new InstanceEncoder( oMappingInfoProvider ),
				decoder: new InstanceDecoder(),
			},
		];
	}
	
//_____________________________________________________________________________
//	Sub-routine
	
	

	public function _addCodex( oCodex :Codex ) {
		if (
			_mCodex.exists( oCodex.index ) 
			|| _mCodexBaseType.exists( oCodex.index ) 
		)
			throw 'Trying to replace codex #' + oCodex.index;
		_mCodex.set( oCodex.index, oCodex );
	}
	public function _addCodexBaseType( oCodex :CodexBaseType ) {
		if (
			_mCodex.exists( oCodex.index ) 
			|| _mCodexBaseType.exists( oCodex.index ) 
		)
			throw 'Trying to replace codex #' + oCodex.index;
		_mCodexBaseType.set( oCodex.index, oCodex );
	}

	public function _getCodexBaseType( i :Int ) :CodexBaseType {
		return _mCodexBaseType.get(i);
	}

	public function _getCodex( i :Int ) :Codex {
		return _mCodex.get(i);
	}
}