package sweet.ribbon.decoder;
import sweet.ribbon.tool.BytesReader;
import sweet.ribbon.decoder.ISubDecoderBaseType;

/**
 * Decode boolean from a byte
 * @author GINER Jeremy
 */
class BoolDecoder implements ISubDecoderBaseType<Bool> {
	public function new() {}
	public function decode( oReader :BytesReader ) :Bool {
		return oReader.read() == 0 ? false : true; 
	}
}