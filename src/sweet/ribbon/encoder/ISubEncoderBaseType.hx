package sweet.ribbon.encoder;
import haxe.io.Bytes;

/**
 * Interface for a sub-encoder of a basic object.
 * A basic object is considered as object which does not need to be divided 
 * into smaller object.
 * Also does not handle multiple reference, the object will be clone if 
 * it appear multiple time during a single encoding
 * 
 * @author GINER Jeremy
 */
interface ISubEncoderBaseType<C> {
	/**
	 * @param  Object
	 * @return Encoded object into Bytes or null
	 */
	public function encode( o :C ) :Bytes;
}