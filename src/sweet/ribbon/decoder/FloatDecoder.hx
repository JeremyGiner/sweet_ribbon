package sweet.ribbon.decoder;
import sweet.ribbon.tool.BytesReader;
import sweet.ribbon.decoder.ISubDecoderBaseType;

/**
 * ...
 * @author GINER Jeremy
 */
class FloatDecoder implements ISubDecoderBaseType<Float> {
	public function new() {}
	public function decode( oReader :BytesReader ) {
		return oReader.readFloat(); 
	}
}