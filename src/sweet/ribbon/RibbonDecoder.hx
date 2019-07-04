package sweet.ribbon;
import haxe.io.Bytes;
import sweet.ribbon.RibbonStrategy;
import sweet.ribbon.tool.BytesReader;
import sweet.ribbon.mapper.IMapper;
import sweet.ribbon.MappingInfo;

/**
 * ...
 * @author GINER Jeremy
 */
class RibbonDecoder {
	
	var _oStrategy :RibbonStrategy;
	
	public function new( oStrategy :RibbonStrategy = null ) {
		_oStrategy = oStrategy != null ?
			oStrategy :
			new RibbonStrategy()
		;
	}
	
	public function decode( oInput :Bytes ) {
		
		var oReader = new BytesReader( oInput );
		
		//_____________________________
		// Read class and fields
		// Get class description
		
		// ? TODO : use Strategy instead
		var aClassDesc = new Array<MappingInfo>();
		var iClassCount = oReader.readInt32();
		for ( i in 0...iClassCount ) {
			var iLength = oReader.readInt32();
			var sClassName = oReader.readString( iLength );
			
			// Get field array
			var aField = new Array<String>(); 
			var iFieldCount = oReader.readInt32();
			
			for ( j in 0...iFieldCount ) {
				var iLength = oReader.readInt32();
				var sFieldName = oReader.readString( iLength ); 
				
				aField.push( sFieldName );
			}
			
			// Create class description
			aClassDesc.push( new MappingInfo( sClassName, aField ) );
		}
		
		//_____________________________
		// Read sequence
		
		
		var aDepthStack = new List<IMapper<Dynamic>>();
		var aObject = new Array<Dynamic>(); // Keep track of object index
		while ( 
			aDepthStack.length == 0 
			|| !aDepthStack.first().isFilled() 
		) {
			
			// Get Type
			var iType = oReader.read();
			
			// Get Data
			var oData :Dynamic = null;
			
			// Case : using object decoder
			var oSubDecoder = _oStrategy.getDecoder( iType );
			var oDecoderAtomic = _oStrategy.getDecoderAtomic( iType );
			if ( oSubDecoder != null ) {
				
				// Decode
				var oMapper = oSubDecoder.decode( oReader, aClassDesc );
				oData = oMapper.getObject();
				
				// Case : object have child -> Push depth
				if( !oMapper.isFilled() ) {
					aDepthStack.push( oMapper );
					aObject.push( oMapper.getObject() ); 
					continue;
				}
				
				// Register object index
				aObject.push( oMapper.getObject() ); 
				
				//continue;
			
			// Case : using atomic decoder
			} else if( oDecoderAtomic != null ) {
				if ( oDecoderAtomic == null )
					throw 'Cannot find subdecoder #' + iType;
				
				// Decode
				oData = oDecoderAtomic.decode( oReader );
				
				// Case : reference
				if ( Std.is( oData, Reference ) ) {
					if ( oData.getId() < 0 || aObject.length <= oData.getId() )
						throw 'invalid reference id [' + oData.getId() + ']';
					oData = aObject[ oData.getId() ];
				}
				
				// Case : atomic data alone in ribbon
				if ( aDepthStack.length == 0 )
					return oData;
				
			} else 
				throw 'decoder not found for id #' + iType;
			
			// Attach child to parent
			var oParent = aDepthStack.first();
			if ( oParent == null )
				continue;
			oParent.addChild( oData );
			
			// Pop depth on mapper filled
			while ( aDepthStack.first().isFilled() ) {
				
				var oMapperChild = aDepthStack.pop();
				if ( aDepthStack.length == 0 ) {
					// Case : 
					if ( oReader.getBytes().length != oReader.getPosition() )
						throw 'Main mapper is over yet '+((oReader.getBytes().length-1)-oReader.getPosition())+' byte(s) are left unread';
					return oMapperChild.getObject();
				}
				aDepthStack.first().addChild( oMapperChild.getObject() );
			}
			
			
		}
		return aDepthStack.last().getObject();
	}
}
