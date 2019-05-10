package sweet.ribbon.encoder;
import sweet.ribbon.encoder.ISubEncoderBaseType;
import haxe.io.Bytes;


/**
 * ...
 * @author GINER Jeremy
 */
class ReferenceEncoder implements ISubEncoderBaseType<Reference> {
	public function new() {}
	public function encode( oReference :Reference ) {
		var o = Bytes.alloc(4);
		o.setInt32( 0, oReference.getId() );
		return o;
	}
}