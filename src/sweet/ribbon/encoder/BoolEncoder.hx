package sweet.ribbon.encoder;
import haxe.io.Bytes;
import sweet.ribbon.encoder.ISubEncoderBaseType;

/**
 * Encode bool into a Bytes ( length 1 )
 * @author GINER Jeremy
 */
class BoolEncoder implements ISubEncoderBaseType<Bool> {
	public function new() {	}
	public function encode( b :Bool ) {
		var o = Bytes.alloc(1);
		o.set(0, b ? 1 : 0 );
		return o;
	}
}