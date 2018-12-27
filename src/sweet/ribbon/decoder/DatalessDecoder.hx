package sweet.ribbon.decoder;
import sweet.ribbon.tool.BytesReader;
import sweet.ribbon.decoder.ISubDecoderBaseType;

/**
 * Decode null value
 * @author GINER Jeremy
 */
class DatalessDecoder implements ISubDecoderBaseType<Dynamic> {
	public function new() {}
	public function decode( oReader :BytesReader ) {
		return null;
	}
}