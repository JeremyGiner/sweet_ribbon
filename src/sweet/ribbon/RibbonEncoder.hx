package sweet.ribbon;
import sweet.ribbon.encoder.ISubEncoder;
import sweet.ribbon.encoder.ISubEncoderBaseType;
import sweet.ribbon.encoder.IntEncoder;
import sweet.ribbon.encoder.StringEncoder;
import sweet.functor.validator.Equal;
import haxe.ds.ObjectMap;
import haxe.io.Bytes;
import sweet.functor.validator.IValidator;
import sweet.ribbon.RibbonStrategy;
import sweet.ribbon.tool.BytesWriter;
import sweet.ribbon.tool.BytesTool;

/**
 * ...
 * @author GINER Jeremy
 */
class RibbonEncoder {

	var _oStrategy :RibbonStrategy;
	
	var _oStringEncoder :StringEncoder;
	var _oIntEncoder :IntEncoder;
	
	static var _oDEPTHSTOP = new DEPTHSTOP();
	
//_____________________________________________________________________________
//	Constructor
	
	public function new( oStrategy :RibbonStrategy = null ) {
		_oStrategy = oStrategy == null ? new RibbonStrategy() : oStrategy;
		_oStringEncoder = new StringEncoder();// TODO : use singleton or something
		_oIntEncoder = new IntEncoder();// TODO : use singleton or something
	}
	
//_____________________________________________________________________________
//	Process
	
	public function encode( o :Dynamic ) :Bytes {
		
		var aMappingInfo = new List<MappingInfo>();
		var aBytes = new List<Bytes>();
		
		var oIterator = new Iterator( o, _oStrategy );
		for ( o in oIterator ) {
			var iCodexIndex = oIterator.getCodexIndex();
			
			//trace('Type :' + iCodexIndex);
			// Encode type
			var oBytes = Bytes.alloc( 1 );
			oBytes.set( 0, iCodexIndex );
			aBytes.add( oBytes );
			
			//_________________________
			// Case : Object encoding
			var oEncoder = oIterator.getEncoder();
			var oData = null;
			
			if ( oEncoder != null ) {
				
				// Encode class desc
				//TODO: handle case class desc already exist
				var iClassDescIndex :Null<Int> = null;
				var oClassDesc = oEncoder.getMappingInfo( o );
				if ( oClassDesc != null ) {
					iClassDescIndex = aMappingInfo.length;
					aMappingInfo.push( oClassDesc );
				}
				
				// Encode data
				oData = oEncoder.encode( o, iClassDescIndex );
				if( oData != null )
					aBytes.add( oData );
				
				continue;
			}
			
			//_________________________
			// Case : Atomic encoding
			var oEncoderAtomic = _oStrategy.getEncoderAtomic( iCodexIndex );
			if( oEncoderAtomic != null ) {
				
				// Encode data
				var oData = oEncoderAtomic.encode( o );
				if( oData != null )
					aBytes.add( oData );
				continue;
			}
			
			throw 'Codex index #'+iCodexIndex+' returned by the strategy is not associated to any codex';
		}
		
		// Encode class desc
		for ( oMappingInfo in aMappingInfo ) {
			//TODO : write in reverse
			aBytes.push( _encodeClassDesc( oMappingInfo ) );
		}
		aBytes.push( _oIntEncoder.encode( aMappingInfo.length ) );
		
		// Merge all bytes
		return BytesTool.joinList( aBytes );
	}
	
//_____________________________________________________________________________
//	Sub-routine
	
	function _encodeClassDesc( oMappingInfo :MappingInfo ) {
		
		var aBytes  = new List<Bytes>();
		
		var sClassName = oMappingInfo.getClassName();
		
		aBytes.add( _oStringEncoder.encode( sClassName ) );
		aBytes.add( _oIntEncoder.encode( oMappingInfo.getFieldNameAr().length) );
		for ( sField in oMappingInfo.getFieldNameAr() ) 
			aBytes.add( _oStringEncoder.encode( sField ) );
		
		return BytesTool.joinList( aBytes );
	}
	
	function _getKey( oMappingInfo :MappingInfo ) {
		return oMappingInfo.getClassName() 
			+ ':' 
			+ oMappingInfo.getFieldNameAr().join('.')
		;
	}
}
/**
 * iterate throught an object using the encoders of a strategy
 * - circular/multiple reference are replace by a Reference object
 * TODO: simplify ?
 */
class Iterator {
	
	var _aObjectQueue :List<Dynamic>;
	var _aParentStack :List<ParentReference>;
	var _mObjectIndex :ObjectMap<Dynamic,Int>;
	var _oStrategy :RibbonStrategy;
	
	var _iType :Null<Int>;
	var _oEncoder :ISubEncoder<Dynamic>;
	var _oEncoderSimple :ISubEncoderBaseType<Dynamic>; // TODO
	var _iDepthStopCount :Int;
	var _iObjectIndex :Int;
	
	static var _oDEPTHSTOP = new DEPTHSTOP();
	
	public function new( o :Dynamic, oStrategy :RibbonStrategy ) {
		
		_aObjectQueue = new List<Dynamic>();
		_aParentStack = new List<ParentReference>();
		_mObjectIndex = new ObjectMap<Dynamic,Int>();
		
		_iDepthStopCount = 0;
		_oStrategy = oStrategy;
		_aObjectQueue.push( o );
		_iType = null;
		_oEncoder = null;
		_iObjectIndex = 0;
	}
	
	public function hasNext() {
		return _aObjectQueue.length - _iDepthStopCount != 0;
	}
	public function next() {
		var o = _aObjectQueue.pop();
		
		// Increment current child index
		if ( _aParentStack.first() != null )
			_aParentStack.first().childIndex++;
		
		// Case depth stop
		while ( o == _oDEPTHSTOP ) {
			_aParentStack.pop();
			_iDepthStopCount--;
			o = _aObjectQueue.pop();
		}
		
		
		// Get TypeId and encoder
		_iType = _oStrategy.getCodexIndex( o, _aParentStack );
		if ( _iType == null )
			throw 'No sub-encoder/decoder, for a given object'; //TODO: improve message
		_oEncoder = _oStrategy.getEncoder( _iType );
		
		// Case : recurence -> use reference
		if ( _oEncoder != null )
		if ( _mObjectIndex.exists( o ) ) {
			
			// Turn into reference
			o = new Reference( _mObjectIndex.get( o ) ); 
			// Get reference type and encoder
			_iType = _oStrategy.getCodexIndex( o, _aParentStack );
			if ( _iType == null )
				throw 'No sub-encoder/decoder, for a given object'; //TODO: improve message
			_oEncoder = null;// assume _oStrategy.getEncoder( _iType ) return null
			
		} else {
			// Add to ObjectIndex
			_mObjectIndex.set( o, (_iObjectIndex++) );
		}
		
		//_________________________
		// Case : is a structure with possible children
		
		if ( _oEncoder != null ) {
			
			// Queue children
			var aChild = _oEncoder.getChildAr( o );
			if ( aChild != null && aChild.length > 0 ) {
				_aParentStack.push( {parent: o, childIndex: -1} );
				_aObjectQueue.push( _oDEPTHSTOP );
				_iDepthStopCount++;
				for( o in aChild )
					_aObjectQueue.push( o );
			}
		}
		
		return o;
	}
	
	public function getParentStack() {
		return _aParentStack;
	}
	public function getCodexIndex() {
		return _iType; 
	}
	public function getEncoder() {
		return _oEncoder;
	}
}

/**
 * Token class used by iterator as delimiter in order to update his parent stack
 * TODO : use enum instead
 */
private class DEPTHSTOP {
	public function new() {}
}

typedef ParentReference = {
	var parent :Dynamic;
	var childIndex :Int;
};
/*


encode Ribbon format
[4] count of class type
	[4] class full name size
	[X] class full name
	[4] field count
		[4] field name size
		[X] field name 

[1] type ( 0 : null, 1 : bool .... x : index of class, y : end instance, z : ref to  )
	? type array
		[4] array size
		match following X data as a value
	? type string
		[1] string size X
		[X] string data
	? type map
	? type class instance 
		[1] class index ( see above )
		match next data with field
	? type ref to
		[4] index of object in the sequence
	? else
		[X] data
*/