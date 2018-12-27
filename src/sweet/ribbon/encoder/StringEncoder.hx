package sweet.ribbon.encoder;
import sweet.ribbon.encoder.ISubEncoderBaseType;
import haxe.io.Bytes;

/**
 * ...
 * @author GINER Jeremy
 */
class StringEncoder implements ISubEncoderBaseType<String> {
	public function new() { }
	public function encode( s :String ) {
		var o = Bytes.alloc( s.length + 4 );
		o.setInt32( 0, s.length );
		for( i in 0...s.length )
			o.set( 4 + i, s.charCodeAt(i) );
		return o;
	}
}