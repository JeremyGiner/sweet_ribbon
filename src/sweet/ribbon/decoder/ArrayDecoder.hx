package sweet.ribbon.decoder;
import sweet.ribbon.tool.BytesReader;
import sweet.ribbon.decoder.ISubDecoder;
import sweet.ribbon.mapper.ArrayMapper;
import sweet.ribbon.MappingInfo;

/**
 * ...
 * @author GINER Jeremy
 */
class ArrayDecoder implements ISubDecoder {
	
	public function new() {}
	
	public function decode( 
		oReader :BytesReader, 
		aMapping :Array<MappingInfo> 
	) {
		var iSize = oReader.readInt32();
		return new ArrayMapper( iSize );
	}
}