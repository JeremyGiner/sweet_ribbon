package sweet.ribbon.encoder;
import sweet.ribbon.encoder.ISubEncoderBaseType;
import haxe.io.Bytes;

/**
 * ...
 * @author GINER Jeremy
 */
class FloatEncoder implements ISubEncoderBaseType<Float> {
	public function new() { }
	public function encode( f :Float ) {
		var o = Bytes.alloc(8);
		o.setFloat( 0, f );
		return o;
	}
}