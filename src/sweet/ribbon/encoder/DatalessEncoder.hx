package sweet.ribbon.encoder;
import sweet.ribbon.encoder.ISubEncoderBaseType;

/**
 * Encode null value
 * @author GINER Jeremy
 */
class DatalessEncoder implements ISubEncoderBaseType<Dynamic> {
	public function new() { }
	public function encode( o :Dynamic ) {
		return null;
	}
}