package sweet.ribbon.encoder;
import sweet.ribbon.encoder.ISubEncoderBaseType;
import haxe.io.Bytes;

/**
 * ...
 * @author GINER Jeremy
 */
class IntEncoder implements ISubEncoderBaseType<Int> {
	public function new() { }
	public function encode( i :Int ) {
		var o = Bytes.alloc(4);
		o.setInt32( 0, i );
		return o;
	}
}