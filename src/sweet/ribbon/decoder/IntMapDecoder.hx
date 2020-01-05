package sweet.ribbon.decoder;
import sweet.ribbon.tool.BytesReader;
import sweet.ribbon.decoder.ISubDecoder;
import sweet.ribbon.mapper.IntMapMapper;
import sweet.ribbon.MappingInfo;

/**
 * ...
 * @author GINER Jeremy
 */
class IntMapDecoder implements ISubDecoder {
	
	public function new() {}
	
	public function decode( 
		oReader :BytesReader, 
		aMapping :Array<MappingInfo> 
	) {
		var iClassIndex = oReader.readInt32();
		
		if ( iClassIndex < 0 || iClassIndex >= aMapping.length )
			throw 'Invalid class index : [' + iClassIndex + ']';
		
		var oClassDesc = aMapping[ iClassIndex ];
		return new IntMapMapper( oClassDesc );
	}
}