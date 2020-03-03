package sweet.ribbon.decoder;
import sweet.ribbon.tool.BytesReader;
import sweet.ribbon.decoder.ISubDecoder;
import sweet.ribbon.mapper.StructureMapper;
import sweet.ribbon.MappingInfo;

/**
 * ...
 * @author GINER Jeremy
 */
class StructureDecoder implements ISubDecoder {
	
	public function new() {}
	
	public function decode( 
		oReader :BytesReader, 
		aMapping :Array<MappingInfo> 
	) {
		var iClassIndex = oReader.readInt32();
		
		if ( iClassIndex < 0 || iClassIndex >= aMapping.length )
			throw 'Invalid class index : [' + iClassIndex + ']';
		
		var oClassDesc = aMapping[ iClassIndex ];
		return new StructureMapper( oClassDesc );
	}
}