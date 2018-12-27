package sweet.ribbon;
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
	
	static var aBasicTypeId = {
		'null': -1,
		'Bool': -2,
		'Int16': -3,
		'Int': -4,
		'Int64': -5,
		'Array': -6,
		'String': -7,
	}
	
	var _oStringEncoder :StringEncoder;
	var _oIntEncoder :IntEncoder;
	
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
		
		var aObjectQueue = new List<Dynamic>();
		var mObjectIndex = new ObjectMap<Dynamic,Int>();
		var iObjectIndex = 0;
		
		aObjectQueue.push( o );
		
		while (	!aObjectQueue.isEmpty() ) {
			
			var o = aObjectQueue.pop();
			
			// Case : recurence -> use reference
			if ( Reflect.isObject( o ) )
			if ( mObjectIndex.exists( o ) )
				o = new Reference( mObjectIndex.get( o ) );
			else
				mObjectIndex.set( o, iObjectIndex++ );
			
			// Get TypeId
			var iType = _oStrategy.getCodexIndex( o );
			if ( iType == null )
				throw 'No sub-encoder/decoder, for a given object'; //TODO: improve message
			
			// Encode type
			var oBytes = Bytes.alloc( 1 );
			oBytes.set( 0, iType );
			aBytes.add( oBytes );
			
			//_________________________
			// Case : Object encoding
			var oEncoder = _oStrategy.getEncoder( iType );
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
				
				// Queue children
				var aChild = oEncoder.getChildAr( o );
				if( aChild != null )
				for( o in aChild )
					aObjectQueue.push( o );
				
				continue;
			}
			
			//_________________________
			// Case : Atomic encoding
			var oEncoderAtomic = _oStrategy.getEncoderAtomic( iType );
			if( oEncoderAtomic != null ) {
			
				// Assume oEncoderAtomic != null
				
				// Encode data
				var oData = oEncoderAtomic.encode( o );
				if( oData != null )
					aBytes.add( oData );
				continue;
			}
			
			throw 'could not find encoder'; //TODO : improve message
			
			
		} //End of stack iteration
		
		
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
		
		// Case : Annonymous structure
		if ( sClassName == null )
			throw 'Not implemented yet'; //TODO
		
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